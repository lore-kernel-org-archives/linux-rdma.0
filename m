From: Lloyd Brown <lloyd_brown-pC3/9zQCMHo@public.gmane.org>
Subject: [PATCH 1/2] Update ibcheckerrors to accept thresholds file
Date: Thu, 20 Jan 2011 15:42:41 -0700
Message-ID: <1295563362-24695-2-git-send-email-lloyd_brown@byu.edu>
References: <1295563362-24695-1-git-send-email-lloyd_brown@byu.edu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295563362-24695-1-git-send-email-lloyd_brown-8Bzd4dk9+oo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lloyd Brown <lloyd_brown-pC3/9zQCMHo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds the "-T" option, borrowed from ibcheckerrs
 to allow the user to pass in a thresholds file, overriding the
 defaults.  In reality, all it's doing is passing this along to
 the ibcheckerrs call.

Signed-off-by: Lloyd Brown <lloyd_brown-8Bzd4dk9+oo@public.gmane.org>
---
 infiniband-diags/scripts/ibcheckerrors.in |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/infiniband-diags/scripts/ibcheckerrors.in b/infiniband-diags/scripts/ibcheckerrors.in
index a45bd63..1e8b1a1 100644
--- a/infiniband-diags/scripts/ibcheckerrors.in
+++ b/infiniband-diags/scripts/ibcheckerrors.in
@@ -3,7 +3,7 @@
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
 function usage() {
-	echo Usage: `basename $0` "[-h] [-b] [-v] [-N | -nocolor]"\
+	echo Usage: `basename $0` "[-h] [-b] [-v] [-N | -nocolor] [-T <threshold_file>]"\
 	    "[<topology-file> | -C ca_name -P ca_port -t(imeout) timeout_ms]"
 	exit -1
 }
@@ -23,6 +23,8 @@ ntype=""
 nodeguid=""
 topofile=""
 ca_info=""
+thresholdfile=""
+thresholdopt=""
 
 while [ "$1" ]; do
 	case $1 in
@@ -53,6 +55,15 @@ while [ "$1" ]; do
 		ca_info="$ca_info $1 $2"
 		shift
 		;;
+	-T)
+		if ! [ -r $2 ]; then
+			echo "Can't use threshold file '$2'"
+			usage
+		fi
+		thresholdopt="-T"
+		thresholdfile="$2"
+		shift
+		;;
 	-*)
 		usage
 		;;
@@ -85,7 +96,7 @@ function check_node(lid, port)
 		print "\n# " ntype ": nodeguid 0x" nodeguid " failed"
 		return 1;
 	}
-	if (system("'$IBPATH'/ibcheckerrs '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port))
+	if (system("'$IBPATH'/ibcheckerrs '"$ca_info"' '$gflags' '$thresholdopt' '$thresholdfile' '$verbose' '$brief' " lid " " port))
 		return 2;
 	return 0;
 }
@@ -115,7 +126,7 @@ function check_node(lid, port)
 			if (check_node(lid, port) == 2)
 				pcnterr++;
 		} else if (err &&
-			   system("'$IBPATH'/ibcheckerrs '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port))
+			   system("'$IBPATH'/ibcheckerrs '"$ca_info"' '$gflags' '$thresholdopt' '$thresholdfile' '$verbose' '$brief' " lid " " port))
 			pcnterr++;
 }
 
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
