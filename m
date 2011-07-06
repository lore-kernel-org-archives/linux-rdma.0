From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: enable perfmgr build by default
Date: Wed, 6 Jul 2011 15:11:16 -0700
Message-ID: <20110706151116.79c187ea.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This should at least be compiled in by default.


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 config/osmvsel.m4 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/config/osmvsel.m4 b/config/osmvsel.m4
index c24930b..2c91f63 100644
--- a/config/osmvsel.m4
+++ b/config/osmvsel.m4
@@ -206,12 +206,12 @@ AC_DEFUN([OPENIB_OSM_PERF_MGR_SEL], [
 
 dnl enable the perf-mgr
 AC_ARG_ENABLE(perf-mgr,
-[  --enable-perf-mgr Enable the performance manager (default no)],
+[  --enable-perf-mgr Enable the performance manager (default yes)],
    [case $enableval in
      yes) perf_mgr=yes ;;
      no)  perf_mgr=no ;;
    esac],
-   perf_mgr=no)
+   perf_mgr=yes)
 AC_ARG_ENABLE(perf-mgr-profile,
 [  --enable-perf-mgr-profile Enable the performance manager profiling (default no)],
 	[case $enableval in
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
