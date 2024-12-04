#!/bin/bash

ytdlpExtraOpts="--user-agent facebookexternalhit/1.1"
videoFormat="bv[height<=?1080]+ba/b"

CookiesCheck () {
    # Check for cookies file
    if [ -f /config/cookies.txt ]; then
        cookiesFile="/config/cookies.txt"
        echo "Cookies File Found!"
    else
        echo "Cookies File Not Found!"
        cookiesFile=""
    fi
}

NotifySonarrForImport () {
    sonarrProcessIt=$(curl -s "$ARR_URL/api/v3/command" --header "X-Api-Key:"${ARR_API_KEY} -H "Content-Type: application/json" --data "{\"name\":\"DownloadedEpisodesScan\", \"path\":\"$1\"}")
}

SonarrTaskStatusCheck () {
	alerted=no
	until false
	do
		taskCount=$(curl -s "$ARR_URL/api/v3/command?apikey=${ARR_API_KEY}" | jq -r '.[] | select(.status=="started") | .name' | grep -v "RescanFolders" | wc -l)
		if [ "$taskCount" -ge "1" ]; then
			if [ "$alerted" == "no" ]; then
				alerted=yes
				echo "STATUS :: SONARR BUSY :: Pausing/waiting for all active Sonarr tasks to end..."
			fi
			sleep 2
		else
			break
		fi
	done
}

YoutubeSeriesDownloaderProcess () {

	CookiesCheck
	
	sonarrSeriesList=$(curl -s --header "X-Api-Key:"${ARR_API_KEY} --request GET  "$ARR_URL/api/v3/series")
	sonarrSeriesIds=$(echo "${sonarrSeriesList}" | jq -r '.[] | select(.network=="YouTube") |.id')
	sonarrSeriesTotal=$(echo "${sonarrSeriesIds}" | wc -l)
	
	loopCount=0
	for id in $(echo $sonarrSeriesIds); do
	    loopCount=$(( $loopCount + 1 ))
	
	    seriesId=$id
	    seriesData=$(curl -s "$ARR_URL/api/v3/series/$seriesId?apikey=$ARR_API_KEY")
	    seriesTitle=$(echo "$seriesData" | jq -r .title)
	    seriesTitleDots=$(echo "$seriesTitle" | sed s/\ /./g)
	    seriesTvdbTitleSlug=$(echo "$seriesData" | jq -r .titleSlug)
	    seriesNetwork=$(echo "$seriesData" | jq -r .network)
	    seriesEpisodeData=$(curl -s "$ARR_URL/api/v3/episode?seriesId=$seriesId&apikey=$ARR_API_KEY")
	    seriesEpisodeTvdbIds=$(echo $seriesEpisodeData | jq -r ".[] | select(.monitored==true) | select(.hasFile==false) | .tvdbId")
	    seriesEpisodeTvdbIdsCount=$(echo "$seriesEpisodeTvdbIds" | wc -l)
	
	    currentLoopIteration=0
	    for episodeId in $(echo $seriesEpisodeTvdbIds); do
	        echo "seriesTitle: $seriesTitle" 
	        echo "seriesSlug: $seriesTvdbTitleSlug"
            # Custom hotfix for Todopoderosos
            if [[ "$seriesTitle" == "Todopoderosos" ]]; then
                seriesTvdbTitleSlug="337393-show"
            fi
	        currentLoopIteration=$(( $currentLoopIteration + 1 ))
	        seriesEpisdodeData=$(echo $seriesEpisodeData | jq -r ".[] | select(.tvdbId==$episodeId)")
	        episodeSeasonNumber=$(echo $seriesEpisdodeData | jq -r .seasonNumber)
	        episodeNumber=$(echo $seriesEpisdodeData | jq -r .episodeNumber)
	        tvdbPageData=$(curl -s "https://thetvdb.com/series/$seriesTvdbTitleSlug/episodes/$episodeId")
	        downloadUrl=$(echo "$tvdbPageData" | grep -i youtube.com  | grep -i watch | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*")
	        if [ -z $downloadUrl ]; then
	            network="$(echo "$tvdbPageData" | grep -i "/companies/youtube")"
	            if [ ! -z "$network" ]; then 
	                downloadUrl=$(echo "$tvdbPageData" | grep -iws "production code" -A 2 | sed 's/\ //g' | tail -n1)
	                if [ ! -z $downloadUrl ]; then
	                    downloadUrl="https://www.youtube.com/watch?v=$downloadUrl"
	                fi
	            fi
	        fi
	
	        if [ -z $downloadUrl ]; then
	            echo "$loopCount/$sonarrSeriesTotal :: $currentLoopIteration/$seriesEpisodeTvdbIdsCount :: $seriesTitle :: S${episodeSeasonNumber}E${episodeNumber} :: ERROR :: No Download URL found, skipping"
	            continue
	        fi
	        downloadLocation="/media/manual-downloads/yt-dlp"

	        fileName="$seriesTitleDots.S${episodeSeasonNumber}E${episodeNumber}.WEB-DL.mkv"
	        echo "$loopCount/$sonarrSeriesTotal :: $currentLoopIteration/$seriesEpisodeTvdbIdsCount :: $seriesTitle :: S${episodeSeasonNumber}E${episodeNumber} :: Downloading via yt-dlp ($videoFormat)..."
	        if [ ! -z "$cookiesFile" ]; then
	            yt-dlp -f "$videoFormat" --no-video-multistreams --cookies "$cookiesFile" -o "$downloadLocation/$fileName" --merge-output-format mkv --no-mtime --geo-bypass $ytdlpExtraOpts "$downloadUrl"
	        else
	            yt-dlp -f "$videoFormat" --no-video-multistreams -o "$downloadLocation/$fileName" --merge-output-format mkv --no-mtime --geo-bypass $ytdlpExtraOpts "$downloadUrl"
	        fi
	
	        if [ -f "$downloadLocation/$fileName" ]; then
	            NotifySonarrForImport "$downloadLocation/$fileName"
	            echo "$loopCount/$sonarrSeriesTotal :: $currentLoopIteration/$seriesEpisodeTvdbIdsCount :: $seriesTitle :: S${episodeSeasonNumber}E${episodeNumber} :: Notified Sonarr to import \"$fileName\"" 
	        fi
	        SonarrTaskStatusCheck
	    done
	done
}

YoutubeSeriesDownloaderProcess

exit 0
