From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 25/36] IB/rdmavt: Add the start of capability flags
Date: Wed, 06 Jan 2016 10:03:07 -0800
Message-ID: <20160106180305.8747.31058.stgit@scvm10.sc.intel.com>
References: <20160106174638.8747.47197.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106174638.8747.47197.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
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
index 4b83770..b44ac17 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -56,6 +56,16 @@
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
@@ -429,6 +439,8 @@ struct rvt_dev_info {
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
