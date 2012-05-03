From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: update ib[hosts|switches|routers] to
 standard options
Date: Thu, 3 May 2012 10:31:46 -0700
Message-ID: <20120503103146.c2f0f1e5.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 scripts/ibhosts.in    |    6 +++---
 scripts/ibrouters.in  |    6 +++---
 scripts/ibswitches.in |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/scripts/ibhosts.in b/scripts/ibhosts.in
index 08b2f83..20abdf3 100644
--- a/scripts/ibhosts.in
+++ b/scripts/ibhosts.in
@@ -4,7 +4,7 @@ IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
 function usage() {
 	echo Usage: `basename $0` "[-h] [<topology-file> | -C ca_name" \
-	    "-P ca_port -t(imeout) timeout_ms]"
+	    "-P ca_port -t timeout_ms]"
 	exit -1
 }
 
@@ -13,10 +13,10 @@ ca_info=""
 
 while [ "$1" ]; do
 	case $1 in
-	-h)
+	-h | --help)
 		usage
 		;;
-	-P | -C | -t | -timeout)
+	-P | --Port | -C | --Ca | -t | --timeout)
 		case $2 in
 		-*)
 			usage
diff --git a/scripts/ibrouters.in b/scripts/ibrouters.in
index 97769db..71f4c60 100644
--- a/scripts/ibrouters.in
+++ b/scripts/ibrouters.in
@@ -4,7 +4,7 @@ IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
 function usage() {
 	echo Usage: `basename $0` "[-h] [<topology-file> | -C ca_name" \
-	    "-P ca_port -t(imeout) timeout_ms]"
+	    "-P ca_port -t timeout_ms]"
 	exit -1
 }
 
@@ -13,10 +13,10 @@ ca_info=""
 
 while [ "$1" ]; do
 	case $1 in
-	-h)
+	-h | --help)
 		usage
 		;;
-	-P | -C | -t | -timeout)
+	-P | --Port | -C | --Ca | -t | --timeout)
 		case $2 in
 		-*)
 			usage
diff --git a/scripts/ibswitches.in b/scripts/ibswitches.in
index 2919a0a..2a1bcae 100644
--- a/scripts/ibswitches.in
+++ b/scripts/ibswitches.in
@@ -4,7 +4,7 @@ IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
 function usage() {
 	echo Usage: `basename $0` "[-h] [<topology-file> | -C ca_name" \
-	    "-P ca_port -t(imeout) timeout_ms]"
+	    "-P ca_port -t timeout_ms]"
 	exit -1
 }
 
@@ -13,10 +13,10 @@ ca_info=""
 
 while [ "$1" ]; do
 	case $1 in
-	-h)
+	-h | --help)
 		usage
 		;;
-	-P | -C | -t | -timeout)
+	-P | --Port | -C | --Ca | -t | --timeout)
 		case $2 in
 		-*)
 			usage
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
