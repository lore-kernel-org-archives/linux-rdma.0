From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 1/6] [ofa_kernel] Add 3.0_sles11sp2 in get_backport_dir.sh
Date: Mon, 2 Apr 2012 00:03:23 -0500
Message-ID: <20120402050320.GA19791@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add 3.0_sles11sp2 in get_backport_dir.sh
These patches were created for SLES11SP2 kernel version 3.0.26-0.5

TODO: Fix ehca,qlgc_vnic, qib

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 ofed_scripts/get_backport_dir.sh |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/ofed_scripts/get_backport_dir.sh b/ofed_scripts/get_backport_dir.sh
index a30a2a8..97f3a81 100755
--- a/ofed_scripts/get_backport_dir.sh
+++ b/ofed_scripts/get_backport_dir.sh
@@ -213,8 +213,16 @@ get_backport_dir()
         2.6.39*)
                 echo 2.6.39
         ;;
-        3.0* | 2.6.40*)
-                echo 3.0
+	2.6.40*)
+		echo 3.0
+	;;
+        3.0*)
+		minor=$(echo $KVERSION | cut -d "." -f 3 | cut -d "-" -f 1)
+		if [ $minor -gt 25 ]; then
+			echo 3.0_sles11sp2
+		else
+			echo 3.0
+		fi
         ;;
         3.1*)
                 echo 3.1
-- 
1.7.7


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
