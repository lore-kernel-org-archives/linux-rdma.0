From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 25/37] IB/rdmavt: Add the start of capability flags
Date: Mon, 07 Dec 2015 15:44:48 -0500
Message-ID: <20151207204447.8144.91996.stgit@phlsvslse11.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Drivers will need a set of flags to dictate behavior to rdmavt. This patch
adds a placeholder and a spot for it to live, as well as a few flags
that will be used.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_vt.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 1dfbb37..aa76cc3 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -59,6 +59,16 @@
 #include "ib_verbs.h"
 
 /*
+ * For some of the IBTA objects there will likely be some
+ * initializations required. We need flags to determine whether it is OK
+ * for rdmavt to do this or not. This does not imply any functions of a
+ * partiuclar IBTA object are overridden.
+ */
+#define RVT_FLAG_MR_INIT_DRIVER BIT(1)
+#define RVT_FLAG_QP_INIT_DRIVER BIT(2)
+#define RVT_FLAG_CQ_INIT_DRIVER BIT(3)
+
+/*
  * For Memory Regions. This stuff should probably be moved into rdmavt/mr.h once
  * drivers no longer need access to the MR directly.
  */
@@ -435,6 +445,8 @@ struct rvt_dev_info {
 	/* Internal use */
 	int n_pds_allocated;
 	spinlock_t n_pds_lock; /* Protect pd allocated count */
+
+	int flags;
 };
 
 static inline struct rvt_pd *ibpd_to_rvtpd(struct ib_pd *ibpd)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
