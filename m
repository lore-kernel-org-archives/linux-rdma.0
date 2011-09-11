From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband-diags/scripts/ibcheckport.in: ignore lid/sm lid
 checks on non zero port switches
Date: Sun, 11 Sep 2011 11:10:32 +0300
Message-ID: <20110911081032.GB2256@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 scripts/ibcheckport.in |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/scripts/ibcheckport.in b/scripts/ibcheckport.in
index a786e9f..9717288 100644
--- a/scripts/ibcheckport.in
+++ b/scripts/ibcheckport.in
@@ -88,10 +88,15 @@ else
 	fi
 fi
 
+is_switch=`$IBPATH/smpquery $ca_info nodeinfo $lid $portnum | awk -F '[.:]*' '/^NodeType/{ if ($2 == "Switch") {print 1}}'`
+
+if [ "$is_switch" -a "$portnum" == "0" ]; then
+	ignore_check=true
+fi
 
 text="`eval $IBPATH/smpquery $ca_info portinfo $lid $portnum`"
 rv=$?
-if echo "$text" | awk -v mono=$bw -F '[.:]*' '
+if echo "$text" | awk -v ignore_check=$ignore_check -v mono=$bw -F '[.:]*' '
 function blue(s)
 {
 	if (mono)
@@ -110,9 +115,9 @@ function blue(s)
 
 /^LinkWidthActive/{ if ($2 == "1X") warn = warn "#warn: Link configured as 1X  lid '$lid' port '$portnum'\n"}
 
-/^Lid/{ if ($2 == "0") warn = warn "#warn: Lid is not configured lid '$lid' port '$portnum'\n"}
+/^Lid/{ if (ignore_check == "0" && $2 == "0") warn = warn "#warn: Lid is not configured lid '$lid' port '$portnum'\n"}
 
-/^SMLid/{ if ($2 == "0") warn = warn "#warn: SM Lid is not configured\n"}
+/^SMLid/{ if (ignore_check == "0" && $2 == "0") warn = warn "#warn: SM Lid is not configured\n"}
 
 #/^LocalPort/	{ if ($2 != '$portnum') {err = err "#error: port " $2 " does not match query ('$portnum')\n"; exit -1}}
 
-- 
1.7.6


-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
