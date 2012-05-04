From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: move deprecated scripts to "compat" rpm
Date: Fri, 4 May 2012 09:35:14 -0700
Message-ID: <20120504093514.d3d61ca8.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



commit 7cdad904b8d846cf3958a779561ede8bc59b5d05 missed ibclearerrors and
ibclearcounters.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 6e519e1..de027b6 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -26,7 +26,7 @@ sbin_SCRIPTS = scripts/ibhosts \
 		scripts/ibfindnodesusing.pl scripts/ibidsverify.pl \
 		scripts/check_lft_balance.pl \
 		scripts/dump_lfts.sh scripts/dump_mfts.sh \
-		scripts/ibclearerrors scripts/ibclearcounters scripts/ibstatus
+		scripts/ibstatus
 
 if ENABLE_COMPAT_UTILS
 sbin_SCRIPTS += scripts/ibcheckerrs scripts/ibchecknet scripts/ibchecknode \
@@ -37,7 +37,7 @@ sbin_SCRIPTS += scripts/ibcheckerrs scripts/ibchecknet scripts/ibchecknode \
 		scripts/ibswportwatch.pl \
 		scripts/ibqueryerrors.pl scripts/iblinkinfo.pl \
 		scripts/ibprintca.pl scripts/ibprintswitch.pl scripts/ibprintrt.pl \
-		scripts/set_nodedesc.sh
+		scripts/set_nodedesc.sh scripts/ibclearerrors scripts/ibclearcounters
 endif
 
 man_MANS = man/ibaddr.8 man/ibping.8 \
@@ -48,7 +48,7 @@ man_MANS = man/ibaddr.8 man/ibping.8 \
 		man/dump_lfts.8 man/dump_mfts.8 man/ibsysstat.8 \
 		man/iblinkinfo.8 man/ibqueryerrors.8 man/ibfindnodesusing.8 \
 		man/ibrouters.8 man/check_lft_balance.8 man/ibcacheedit.8 \
-		man/infiniband-diags.8 man/ibclearcounters.8 man/ibclearerrors.8 \
+		man/infiniband-diags.8 \
 		man/ibstatus.8 man/ibccquery.8 man/ibccconfig.8
 
 # define this for the dist target
@@ -58,7 +58,8 @@ compat_man_pages = man/ibdiscover.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
 		man/ibcheckstate.8 man/ibcheckwidth.8 \
 		man/ibswportwatch.8 \
 		man/ibprintswitch.8 man/ibprintca.8 man/ibdatacounts.8 \
-		man/ibdatacounters.8 man/ibprintrt.8 man/ibidsverify.8
+		man/ibdatacounters.8 man/ibprintrt.8 man/ibidsverify.8 \
+		man/ibclearcounters.8 man/ibclearerrors.8
 
 # but only actually install them if specified
 if ENABLE_COMPAT_UTILS
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
