From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/37] IB/rdmavt: Macroize override checks during driver
 registration
Date: Mon, 07 Dec 2015 15:43:19 -0500
Message-ID: <20151207204318.8144.29135.stgit@phlsvslse11.ph.intel.com>
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

Add a macro to cut down on writing the same lines over and over again for
what will be a large number of functions that will be supported.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index fc977b3..aaf10e7 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -70,29 +70,25 @@ static void rvt_cleanup(void)
 }
 module_exit(rvt_cleanup);
 
+/*
+ * Check driver override. If driver passes a value use it, otherwise we use our
+ * own value.
+ */
+#define CDR(rdi, x) \
+	rdi->ibdev.x = rdi->ibdev.x ? : rvt_ ##x
+
 int rvt_register_device(struct rvt_dev_info *rdi)
 {
 	if (!rdi)
 		return -EINVAL;
 
-	/*
-	 * Drivers have the option to override anything in the ibdev that they
-	 * want to specifically handle. VT needs to check for things it supports
-	 * and if the driver wants to handle that functionality let it. We may
-	 * come up with a better mechanism that simplifies the code at some
-	 * point.
-	 */
-
 	/* DMA Operations */
 	rdi->ibdev.dma_ops =
 		rdi->ibdev.dma_ops ? : &rvt_default_dma_mapping_ops;
 
 	/* Protection Domain */
-	rdi->ibdev.alloc_pd =
-		rdi->ibdev.alloc_pd ? : rvt_alloc_pd;
-	rdi->ibdev.dealloc_pd =
-		rdi->ibdev.dealloc_pd ? : rvt_dealloc_pd;
-
+	CDR(rdi, alloc_pd);
+	CDR(rdi, dealloc_pd);
 	spin_lock_init(&rdi->n_pds_lock);
 	rdi->n_pds_allocated = 0;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
