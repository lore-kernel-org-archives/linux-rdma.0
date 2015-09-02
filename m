From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/2] IB/core: Remove unnecessary defines from ib_mad.h
Date: Wed,  2 Sep 2015 18:45:54 -0400
Message-ID: <1441233955-31743-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove the unused IB_NOTICE_REPRESS_* defines.

When the hfi1 driver was added these definitions were moved from the qib driver
to ib_mad.h.  They should have been removed instead.

Fixes: d4ab347005fb ("IB/core: Add core header changes needed for OPA")
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_mad.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index c206205bbf98..7f2cf855a0b6 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -157,18 +157,6 @@
 #define IB_NOTICE_TRAP_BAD_QKEY		cpu_to_be16(258)
 
 /*
- * Repress trap/notice flags
- */
-#define IB_NOTICE_REPRESS_LLI_THRESH	(1 << 0)
-#define IB_NOTICE_REPRESS_EBO_THRESH	(1 << 1)
-#define IB_NOTICE_REPRESS_FLOW_UPDATE	(1 << 2)
-#define IB_NOTICE_REPRESS_CAP_MASK_CHG	(1 << 3)
-#define IB_NOTICE_REPRESS_SYS_GUID_CHG	(1 << 4)
-#define IB_NOTICE_REPRESS_BAD_MKEY	(1 << 5)
-#define IB_NOTICE_REPRESS_BAD_PKEY	(1 << 6)
-#define IB_NOTICE_REPRESS_BAD_QKEY	(1 << 7)
-
-/*
  * Generic trap/notice other local changes flags (trap 144).
  */
 #define IB_NOTICE_TRAP_LSE_CHG		0x04	/* Link Speed Enable changed */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
