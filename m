From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: move ibidsverify man page to main rpm
Date: Fri, 4 May 2012 10:41:00 -0700
Message-ID: <20120504104100.edce67ea.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


It was incorrectly put in the compat rpm.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index de027b6..f720e21 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -49,7 +49,8 @@ man_MANS = man/ibaddr.8 man/ibping.8 \
 		man/iblinkinfo.8 man/ibqueryerrors.8 man/ibfindnodesusing.8 \
 		man/ibrouters.8 man/check_lft_balance.8 man/ibcacheedit.8 \
 		man/infiniband-diags.8 \
-		man/ibstatus.8 man/ibccquery.8 man/ibccconfig.8
+		man/ibstatus.8 man/ibccquery.8 man/ibccconfig.8 \
+		man/ibidsverify.8
 
 # define this for the dist target
 compat_man_pages = man/ibdiscover.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
@@ -58,7 +59,7 @@ compat_man_pages = man/ibdiscover.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
 		man/ibcheckstate.8 man/ibcheckwidth.8 \
 		man/ibswportwatch.8 \
 		man/ibprintswitch.8 man/ibprintca.8 man/ibdatacounts.8 \
-		man/ibdatacounters.8 man/ibprintrt.8 man/ibidsverify.8 \
+		man/ibdatacounters.8 man/ibprintrt.8 \
 		man/ibclearcounters.8 man/ibclearerrors.8
 
 # but only actually install them if specified
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
