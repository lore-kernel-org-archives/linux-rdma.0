From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] scripts: Add mkey support into ibhosts,
 ibswitches, and ibrouters
Date: Mon, 28 Nov 2016 16:47:52 -0500
Message-ID: <a4a95aaf-f7ff-2ab8-feec-8a206c070044@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/scripts/ibhosts.in b/scripts/ibhosts.in
index fda0541..c37260c 100644
--- a/scripts/ibhosts.in
+++ b/scripts/ibhosts.in
@@ -3,19 +3,32 @@
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
 usage() {
-	echo Usage: `basename $0` "[-h] [<topology-file> | -C ca_name" \
-	    "-P ca_port -t timeout_ms]"
+	echo Usage: `basename $0` "[-h] [<topology-file> | -y mkey" \
+	    "-C ca_name -P ca_port -t timeout_ms]"
 	exit -1
 }
 
 topofile=""
 ca_info=""
+mkey="0"
 
 while [ "$1" ]; do
 	case $1 in
 	-h | --help)
 		usage
 		;;
+	-y | --m_key)
+		case $2 in
+		-*)
+			usage
+			;;
+		esac
+		if [ x$2 = x ] ; then
+			usage
+		fi
+		shift
+		mkey="$1"
+		;;
 	-P | --Port | -C | --Ca | -t | --timeout)
 		case $2 in
 		-*)
@@ -44,7 +57,7 @@ done
 if [ "$topofile" ]; then
 	netcmd="cat $topofile"
 else
-	netcmd="$IBPATH/ibnetdiscover $ca_info"
+	netcmd="$IBPATH/ibnetdiscover -y $mkey $ca_info"
 fi
 
 text="`eval $netcmd`"
diff --git a/scripts/ibrouters.in b/scripts/ibrouters.in
index ae66ca4..b3e5a1d 100644
--- a/scripts/ibrouters.in
+++ b/scripts/ibrouters.in
@@ -3,19 +3,32 @@
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
 usage() {
-	echo Usage: `basename $0` "[-h] [<topology-file> | -C ca_name" \
-	    "-P ca_port -t timeout_ms]"
+	echo Usage: `basename $0` "[-h] [<topology-file> | -y mkey" \
+	    "-C ca_name -P ca_port -t timeout_ms]"
 	exit -1
 }
 
 topofile=""
 ca_info=""
+mkey="0"
 
 while [ "$1" ]; do
 	case $1 in
 	-h | --help)
 		usage
 		;;
+	-y | --m_key)
+		case $2 in
+		-*)
+			usage
+			;;
+		esac
+		if [ x$2 = x ] ; then
+			usage
+		fi
+		shift
+		mkey="$1"
+		;;
 	-P | --Port | -C | --Ca | -t | --timeout)
 		case $2 in
 		-*)
@@ -44,7 +57,7 @@ done
 if [ "$topofile" ]; then
 	netcmd="cat $topofile"
 else
-	netcmd="$IBPATH/ibnetdiscover $ca_info"
+	netcmd="$IBPATH/ibnetdiscover -y $mkey $ca_info"
 fi
 
 text="`eval $netcmd`"
diff --git a/scripts/ibswitches.in b/scripts/ibswitches.in
index 0f3aa91..743f1db 100644
--- a/scripts/ibswitches.in
+++ b/scripts/ibswitches.in
@@ -3,19 +3,32 @@
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
 usage() {
-	echo Usage: `basename $0` "[-h] [<topology-file> | -C ca_name" \
-	    "-P ca_port -t timeout_ms]"
+	echo Usage: `basename $0` "[-h] [<topology-file> | -y mkey" \
+	    "-C ca_name -P ca_port -t timeout_ms]"
 	exit -1
 }
 
 topofile=""
 ca_info=""
+mkey="0"
 
 while [ "$1" ]; do
 	case $1 in
 	-h | --help)
 		usage
 		;;
+	-y | --m_key)
+		case $2 in
+		-*)
+			usage
+			;;
+		esac
+		if [ x$2 = x ] ; then
+			usage
+		fi
+		shift
+		mkey="$1"
+		;;
 	-P | --Port | -C | --Ca | -t | --timeout)
 		case $2 in
 		-*)
@@ -44,7 +57,7 @@ done
 if [ "$topofile" ]; then
 	netcmd="cat $topofile"
 else
-	netcmd="$IBPATH/ibnetdiscover $ca_info"
+	netcmd="$IBPATH/ibnetdiscover -y $mkey $ca_info"
 fi
 
 text="`eval $netcmd`"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
