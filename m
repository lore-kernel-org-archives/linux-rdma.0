From: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] ibsim: fix non-debug path in run_opensm.sh script
Date: Fri, 05 Aug 2011 17:29:47 -0600
Message-ID: <E1QpTpr-00026L-B8@rvml.edm.orcorp.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 scripts/run_opensm.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/run_opensm.sh b/scripts/run_opensm.sh
index a225d81..a299dc0 100755
--- a/scripts/run_opensm.sh
+++ b/scripts/run_opensm.sh
@@ -29,7 +29,7 @@ if [ -z "$debug" ] ; then
 	export SIM_HOST
 	export OSM_TMP_DIR
 	export OSM_CACHE_DIR
-	time LD_PRELOAD=${umad2sim} ${cmd} ${cmd_args}
+	LD_PRELOAD=${umad2sim} time ${cmd} ${cmd_args}
 	rc=$?
 	exit $rc
 else
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
