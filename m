From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 9/9 v2] opensm/scripts/sldd.sh: Update to support guid2mkey/neighbors
Date: Wed,  1 Aug 2012 07:52:35 -0700
Message-ID: <1343832755-26753-9-git-send-email-foraker1@llnl.gov>
References: <1343832537.26423.8.camel@auk75.llnl.gov>
 <1343832755-26753-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343832755-26753-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, alexne-LTKPlh9/A5tDPfheJLI6IQ@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Essentially a straightforward parameterization of all of the
functions, with a for loop wrapped around the main body, so
that the script can support sync'ing multiple files.

This allows us to add the new guid2mkey and neighbors cache
files to the default file list.

Semantics for the CACHE_FILE environment parameter have changed
slightly; instead of specifying a path to the guid2lid file,
it specifies a colon-separated list of paths to be synchronized,
which replaces the default list in its entirety.

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 scripts/sldd.sh.in |  143 ++++++++++++++++++++++++++++------------------------
 1 file changed, 78 insertions(+), 65 deletions(-)

diff --git a/scripts/sldd.sh.in b/scripts/sldd.sh.in
index f7635fe..9b0e282 100755
--- a/scripts/sldd.sh.in
+++ b/scripts/sldd.sh.in
@@ -49,9 +49,9 @@ fi
 
 SLDD_DEBUG=${SLDD_DEBUG:-0}
 
-CACHE_FILE=${CACHE_FILE:-/var/cache/opensm/guid2lid}
-CACHE_DIR=$(dirname ${CACHE_FILE})
-tmp_cache=${CACHE_FILE}.tmp
+CACHE_FILE=${CACHE_FILE:-/var/cache/opensm/guid2lid:/var/cache/opensm/guid2mkey:/var/cache/opensm/neighbors}
+declare -a arr_CACHE_FILES
+arr_CACHE_FILES=(`echo $CACHE_FILE| sed 's/:/\n/g' | sort | uniq`)
 
 PING='ping -w 1 -c 1'
 
@@ -104,8 +104,8 @@ is_local()
 
 update_remote_cache()
 {
-	/bin/rm -f ${CACHE_FILE}.upd
-	/bin/cp -a ${CACHE_FILE} ${CACHE_FILE}.upd
+	/bin/rm -f "$1.upd"
+	/bin/cp -a "$1" "$1.upd"
 
 	[ $SLDD_DEBUG -eq 1 ] &&
 	echo "Updating remote cache file"
@@ -118,17 +118,18 @@ update_remote_cache()
 		fi
 
 		if is_alive $host; then
-			stat=$($RSH $host "/bin/mkdir -p ${CACHE_DIR} > /dev/null 2>&1; /bin/rm -f ${CACHE_FILE}.${local_host} > /dev/null 2>&1; echo \$?" | tr -d '[:space:]')
+			cache_dir=$(dirname "$1")
+			stat=$($RSH $host "/bin/mkdir -p ${cache_dir} > /dev/null 2>&1; /bin/rm -f "$1.${local_host}" > /dev/null 2>&1; echo \$?" | tr -d '[:space:]')
 			if [ "X${stat}" == "X0" ]; then
 				[ $SLDD_DEBUG -eq 1 ] &&
 				echo "Updating $host"
-				logger -i "SLDD: updating $host with ${CACHE_FILE}"
-				$RCP ${CACHE_FILE}.upd ${host}:${CACHE_FILE}.${local_host}
-				/bin/cp ${CACHE_FILE}.upd ${CACHE_FILE}.${host}
+				logger -i "SLDD: updating $host with $1"
+				$RCP "$1.upd" "${host}:$1.${local_host}"
+				/bin/cp "$1.upd" "$1.${host}"
 			else
 				[ $SLDD_DEBUG -eq 1 ] &&
 				echo "$RSH to $host failed."
-				logger -i "SLDD: Failed to update $host with ${CACHE_FILE}. $RSH without password should be enabled"
+				logger -i "SLDD: Failed to update $host with $1. $RSH without password should be enabled"
 				exit 5
 			fi
 		else
@@ -142,21 +143,21 @@ update_remote_cache()
 get_latest_remote_cache()
 {
 	# Find most updated remote cache file (the suffix should be like ip address: *.*.*.*)
-	echo -n "$(/bin/ls -1t ${CACHE_FILE}.*.* 2> /dev/null | head -1)"
+	echo -n "$(/bin/ls -1t $1.*.* 2> /dev/null | head -1)"
 }
 
 get_largest_remote_cache()
 {
 	# Find largest (size) remote cache file (the suffix should be like ip address: *.*.*.*)
-	echo -n "$(/bin/ls -1S ${CACHE_FILE}.*.* 2> /dev/null | head -1)"
+	echo -n "$(/bin/ls -1S $1.*.* 2> /dev/null | head -1)"
 }
 
 swap_cache_files()
 {
-	/bin/rm -f ${CACHE_FILE}.old
-	/bin/mv ${CACHE_FILE} ${CACHE_FILE}.old
-	/bin/cp ${largest_remote_cache} ${CACHE_FILE}
-	touch ${CACHE_FILE}.tmp
+	/bin/rm -f "$1.old"
+	/bin/mv "$1" "$1.old"
+	/bin/cp "$2" "$1"
+	touch "$1.tmp"
 }
 
 # Find local host in the osm hosts list
@@ -170,74 +171,86 @@ done
 
 # Get cache file info
 declare -i new_size=0
-declare -i last_size=0
+declare -ai arr_last_size
+for i in  ${!arr_CACHE_FILES[@]}
+do
+	arr_last_size[$i]=0
+done
 declare -i largest_remote_cache_size=0
 
-if [ -e ${CACHE_FILE} ]; then
-	last_size=$(du -b ${CACHE_FILE} | awk '{print$1}' | tr -d '[:space:]')
-else
-	touch ${CACHE_FILE} ${CACHE_FILE}.tmp
-fi
+for i in ${!arr_CACHE_FILES[@]}
+do
+	cache_file=${arr_CACHE_FILES[$i]}
+	if [ -e ${cache_file} ]; then
+		arr_last_size[$i]=$(du -b ${cache_file} | awk '{print$1}' | tr -d '[:space:]')
+	else
+		touch ${cache_file} ${cache_file}.tmp
+	fi
 
-# if [ ${last_size} -gt 0 ]; then
-# 	# First time update
-# 	update_remote_cache
-# fi
+#	if [ ${arr_last_size[$i]} -gt 0 ]; then
+#		# First time update
+#		update_remote_cache ${cache_file}
+#	fi
+done
 
 while true
 do
-	if [ -s "${CACHE_FILE}" ]; then
-		new_size=$(du -b ${CACHE_FILE} | awk '{print$1}' | tr -d '[:space:]')
-		# Check if local cache file grew from its last version or the time stamp changed
-		if [ ${new_size} -gt ${last_size} ]
-		   [ "$(/bin/ls -1t ${CACHE_FILE} ${CACHE_FILE}.tmp 2> /dev/null | head -1)"  != "${CACHE_FILE}.tmp" ]; then
-			largest_remote_cache=$(get_largest_remote_cache)
+	for i in ${!arr_CACHE_FILES[@]}
+	do
+		cache_file=${arr_CACHE_FILES[$i]}
+		if [ -s "${cache_file}" ]; then
+			new_size=$(du -b ${cache_file} | awk '{print$1}' | tr -d '[:space:]')
+			# Check if local cache file grew from its last version or the time stamp changed
+			if [ ${new_size} -gt ${arr_last_size[$i]} ]
+			   [ "$(/bin/ls -1t ${cache_file} ${cache_file}.tmp 2> /dev/null | head -1)"  != "${cache_file}.tmp" ]; then
+				largest_remote_cache=$(get_largest_remote_cache ${cache_file})
+				if [[ -n "${largest_remote_cache}" && -s "${largest_remote_cache}" ]]; then
+					largest_remote_cache_size=$(du -b ${largest_remote_cache} 2> /dev/null | awk '{print$1}' | tr -d '[:space:]')
+				else
+					largest_remote_cache_size=0
+				fi
+
+				# Check if local cache file larger than remote chache file
+				if [ ${new_size} -gt ${largest_remote_cache_size} ]; then
+					[ $SLDD_DEBUG -eq 1 ] &&
+					echo "Local cache file larger then remote. Update remote cache files"
+					arr_last_size[$i]=${new_size}
+					update_remote_cache ${cache_file}
+					continue
+				fi
+			fi
+
+			largest_remote_cache=$(get_largest_remote_cache ${cache_file})
 			if [[ -n "${largest_remote_cache}" && -s "${largest_remote_cache}" ]]; then
 				largest_remote_cache_size=$(du -b ${largest_remote_cache} 2> /dev/null | awk '{print$1}' | tr -d '[:space:]')
 			else
 				largest_remote_cache_size=0
 			fi
 
-			# Check if local cache file larger than remote chache file
-			if [ ${new_size} -gt ${largest_remote_cache_size} ]; then
+			# Update local cache file from remote
+			if [ ${largest_remote_cache_size} -gt ${new_size} ]; then
 				[ $SLDD_DEBUG -eq 1 ] &&
-				echo "Local cache file larger then remote. Update remote cache files"
-				last_size=${new_size}
-				update_remote_cache
-				continue
+				echo "Local cache file shorter then remote. Use ${largest_remote_cache}"
+				logger -i "SLDD: updating local cache file with ${largest_remote_cache}"
+				swap_cache_files ${cache_file} ${largest_remote_cache}
+				arr_last_size[$i]=${largest_remote_cache_size}
 			fi
-		fi
 
-		largest_remote_cache=$(get_largest_remote_cache)
-		if [[ -n "${largest_remote_cache}" && -s "${largest_remote_cache}" ]]; then
-			largest_remote_cache_size=$(du -b ${largest_remote_cache} 2> /dev/null | awk '{print$1}' | tr -d '[:space:]')
-		else
-			largest_remote_cache_size=0
-		fi
-
-		# Update local cache file from remote
-		if [ ${largest_remote_cache_size} -gt ${new_size} ]; then
+		else # The local cache file is empty
 			[ $SLDD_DEBUG -eq 1 ] &&
-			echo "Local cache file shorter then remote. Use ${largest_remote_cache}"
-			logger -i "SLDD: updating local cache file with ${largest_remote_cache}"
-			swap_cache_files
-			last_size=${largest_remote_cache_size}
-		fi
+			echo "${cache_file} is empty"
 
-	else # The local cache file is empty
-		[ $SLDD_DEBUG -eq 1 ] &&
-		echo "${CACHE_FILE} is empty"
+			largest_remote_cache=$(get_largest_remote_cache ${cache_file})
+			if [[ -n "${largest_remote_cache}" && -s "${largest_remote_cache}" ]]; then
+				# Copy it to the current cache
+				[ $SLDD_DEBUG -eq 1 ] &&
+				echo "Local cache file is empty. Use ${largest_remote_cache}"
+				logger -i "SLDD: updating local cache file with ${largest_remote_cache}"
+				swap_cache_files ${cache_file} ${largest_remote_cache}
+			fi
 
-		largest_remote_cache=$(get_largest_remote_cache)
-		if [[ -n "${largest_remote_cache}" && -s "${largest_remote_cache}" ]]; then
-			# Copy it to the current cache
-			[ $SLDD_DEBUG -eq 1 ] &&
-			echo "Local cache file is empty. Use ${largest_remote_cache}"
-			logger -i "SLDD: updating local cache file with ${largest_remote_cache}"
-			swap_cache_files
 		fi
-
-	fi
+	done
 
 	[ $SLDD_DEBUG -eq 1 ] &&
 	echo "Sleeping ${RESCAN_TIME} seconds."
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
