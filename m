From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 13/28] bnxt_re: Support for PD, ucontext and mmap verbs
Date: Sun,  4 Dec 2016 22:38:17 -0800
Message-ID: <1480919912-1079-14-git-send-email-selvin.xavier@broadcom.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480919912-1079-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch includes the uverbs_abi.h file to enable user verbs.
Also adds support for the Protection Domain, User Context and mmap
verbs.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxtre/bnxt_qplib_res.c     |  28 +++
 drivers/infiniband/hw/bnxtre/bnxt_qplib_res.h     |   8 +-
 drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.h      |   4 +
 drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.c   | 219 +++++++++++++++++++++-
 drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.h   |  23 +++
 drivers/infiniband/hw/bnxtre/bnxt_re_main.c       |   7 +
 drivers/infiniband/hw/bnxtre/bnxt_re_uverbs_abi.h |  32 ++++
 7 files changed, 319 insertions(+), 2 deletions(-)
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_re_uverbs_abi.h

diff --git a/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.c b/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.c
index e65ec73..e4c50b7 100644
--- a/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.c
+++ b/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.c
@@ -504,6 +504,34 @@ static int bnxt_qplib_alloc_pkey_tbl(struct bnxt_qplib_res *res,
 	return 0;
 };
 
+/* PDs */
+int bnxt_qplib_alloc_pd(struct bnxt_qplib_pd_tbl *pdt, struct bnxt_qplib_pd *pd)
+{
+	u32 bit_num;
+
+	bit_num = find_first_bit(pdt->tbl, pdt->max);
+	if (bit_num == pdt->max)
+		return -ENOMEM;
+
+	/* Found unused PD */
+	clear_bit(bit_num, pdt->tbl);
+	pd->id = bit_num;
+	return 0;
+}
+
+int bnxt_qplib_dealloc_pd(struct bnxt_qplib_res *res,
+			  struct bnxt_qplib_pd_tbl *pdt,
+			  struct bnxt_qplib_pd *pd)
+{
+	if (test_and_set_bit(pd->id, pdt->tbl)) {
+		dev_warn(&res->pdev->dev, "Freeing an unused PD? pdn = %d",
+			 pd->id);
+		return -EINVAL;
+	}
+	pd->id = 0;
+	return 0;
+}
+
 static void bnxt_qplib_free_pd_tbl(struct bnxt_qplib_pd_tbl *pdt)
 {
 	kfree(pdt->tbl);
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.h b/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.h
index 192df9c..5c89c14 100644
--- a/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.h
+++ b/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.h
@@ -12,7 +12,7 @@
  */
 
 #ifndef __BNXT_QPLIB_RES_H__
-#define __BNXT_QPLIB_RES_H_
+#define __BNXT_QPLIB_RES_H__
 extern const struct bnxt_qplib_gid bnxt_qplib_gid_zero;
 
 #define PTR_CNT_PER_PG		(PAGE_SIZE / sizeof(void *))
@@ -160,6 +160,7 @@ struct bnxt_qplib_res {
 	struct bnxt_qplib_dpi_tbl	dpi_tbl;
 };
 
+struct bnxt_qplib_pd;
 struct bnxt_qplib_dev_attr;
 
 void bnxt_qplib_free_hwq(struct pci_dev *pdev, struct bnxt_qplib_hwq *hwq);
@@ -167,6 +168,11 @@ int bnxt_qplib_alloc_init_hwq(struct pci_dev *pdev, struct bnxt_qplib_hwq *hwq,
 			      struct scatterlist *sl, int nmap, u32 *elements,
 			      u32 elements_per_page, u32 aux, u32 pg_size,
 			      enum bnxt_qplib_hwq_type hwq_type);
+int bnxt_qplib_alloc_pd(struct bnxt_qplib_pd_tbl *pd_tbl,
+			struct bnxt_qplib_pd *pd);
+int bnxt_qplib_dealloc_pd(struct bnxt_qplib_res *res,
+			  struct bnxt_qplib_pd_tbl *pd_tbl,
+			  struct bnxt_qplib_pd *pd);
 int bnxt_qplib_alloc_dpi(struct bnxt_qplib_dpi_tbl *dpit,
 			 struct bnxt_qplib_dpi     *dpi,
 			 void                      *app);
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.h b/drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.h
index 3efdd96..2f8daba 100644
--- a/drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.h
+++ b/drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.h
@@ -44,6 +44,10 @@ struct bnxt_qplib_dev_attr {
 	u8				tqm_alloc_reqs[MAX_TQM_ALLOC_REQ];
 };
 
+struct bnxt_qplib_pd {
+	u32				id;
+};
+
 struct bnxt_qplib_gid {
 	u8				data[16];
 };
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.c b/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.c
index e69fb3f..e802745 100644
--- a/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.c
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.c
@@ -7,6 +7,223 @@
  * the Free Software Foundation.
  */
 
-/*
+ /*
  * Description: IB Verbs interpreter
  */
+
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/netdevice.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_umem.h>
+#include <rdma/ib_addr.h>
+#include <rdma/ib_mad.h>
+#include <rdma/ib_cache.h>
+
+#include "bnxt_ulp.h"
+
+#include "bnxt_re_hsi.h"
+#include "bnxt_qplib_res.h"
+#include "bnxt_qplib_sp.h"
+#include "bnxt_qplib_fp.h"
+#include "bnxt_qplib_rcfw.h"
+
+#include "bnxt_re.h"
+#include "bnxt_re_ib_verbs.h"
+#include "bnxt_re_uverbs_abi.h"
+
+/* Protection Domains */
+int bnxt_re_dealloc_pd(struct ib_pd *ib_pd)
+{
+	struct bnxt_re_pd *pd = to_bnxt_re(ib_pd, struct bnxt_re_pd, ib_pd);
+	struct bnxt_re_dev *rdev = pd->rdev;
+	int rc;
+
+	if (ib_pd->uobject && (u64)pd->dpi.dbr) {
+		struct ib_ucontext *ib_uctx = ib_pd->uobject->context;
+		struct bnxt_re_ucontext *ucntx;
+
+		/* Free DPI only if this is the first PD allocated by the
+		 * application and mark the context dpi as NULL
+		 */
+		ucntx = to_bnxt_re(ib_uctx, struct bnxt_re_ucontext, ib_uctx);
+
+		rc = bnxt_qplib_dealloc_dpi(&rdev->qplib_res,
+					    &rdev->qplib_res.dpi_tbl,
+					    &pd->dpi);
+		if (rc)
+			dev_err(rdev_to_dev(rdev), "Failed to deallocate HW DPI");
+			/* Don't fail, continue*/
+		ucntx->dpi = NULL;
+	}
+
+	rc = bnxt_qplib_dealloc_pd(&rdev->qplib_res,
+				   &rdev->qplib_res.pd_tbl,
+				   &pd->qplib_pd);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "Failed to deallocate HW PD");
+		return rc;
+	}
+
+	kfree(pd);
+	return 0;
+}
+
+struct ib_pd *bnxt_re_alloc_pd(struct ib_device *ibdev,
+			       struct ib_ucontext *ucontext,
+			       struct ib_udata *udata)
+{
+	struct bnxt_re_dev *rdev = to_bnxt_re_dev(ibdev, ibdev);
+	struct bnxt_re_ucontext *ucntx = to_bnxt_re(ucontext,
+						    struct bnxt_re_ucontext,
+						    ib_uctx);
+	struct bnxt_re_pd *pd;
+	int rc;
+
+	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd)
+		return ERR_PTR(-ENOMEM);
+
+	pd->rdev = rdev;
+	if (bnxt_qplib_alloc_pd(&rdev->qplib_res.pd_tbl, &pd->qplib_pd)) {
+		dev_err(rdev_to_dev(rdev), "Failed to allocate HW PD");
+		rc = -ENOMEM;
+		goto fail;
+	}
+
+	if (udata) {
+		struct bnxt_re_pd_resp resp;
+
+		if (!ucntx->dpi) {
+			/* Allocate DPI in alloc_pd to avoid failing of
+			 * ibv_devinfo and family of application when DPIs
+			 * are depleted.
+			 */
+			if (bnxt_qplib_alloc_dpi(&rdev->qplib_res.dpi_tbl,
+						 &pd->dpi, ucntx)) {
+				rc = -ENOMEM;
+				goto dbfail;
+			}
+			ucntx->dpi = &pd->dpi;
+		}
+
+		resp.pdid = pd->qplib_pd.id;
+		/* Still allow mapping this DBR to the new user PD. */
+		resp.dpi = ucntx->dpi->dpi;
+		resp.dbr = (u64)ucntx->dpi->umdbr;
+
+		rc = ib_copy_to_udata(udata, &resp, sizeof(resp));
+		if (rc) {
+			dev_err(rdev_to_dev(rdev),
+				"Failed to copy user response\n");
+			goto dbfail;
+		}
+	}
+
+	return &pd->ib_pd;
+dbfail:
+	(void)bnxt_qplib_dealloc_pd(&rdev->qplib_res, &rdev->qplib_res.pd_tbl,
+				    &pd->qplib_pd);
+fail:
+	kfree(pd);
+	return ERR_PTR(rc);
+}
+
+struct ib_ucontext *bnxt_re_alloc_ucontext(struct ib_device *ibdev,
+					   struct ib_udata *udata)
+{
+	struct bnxt_re_dev *rdev = to_bnxt_re_dev(ibdev, ibdev);
+	struct bnxt_re_uctx_resp resp;
+	struct bnxt_re_ucontext *uctx;
+	struct bnxt_qplib_dev_attr *dev_attr = &rdev->dev_attr;
+	int rc;
+
+	dev_dbg(rdev_to_dev(rdev), "ABI version requested %d",
+		ibdev->uverbs_abi_ver);
+
+	if (ibdev->uverbs_abi_ver != BNXT_RE_ABI_VERSION) {
+		dev_dbg(rdev_to_dev(rdev), " is different from the device %d ",
+			BNXT_RE_ABI_VERSION);
+		return ERR_PTR(-EPERM);
+	}
+
+	uctx = kzalloc(sizeof(*uctx), GFP_KERNEL);
+	if (!uctx)
+		return ERR_PTR(-ENOMEM);
+
+	uctx->rdev = rdev;
+
+	uctx->shpg = (void *)__get_free_page(GFP_KERNEL);
+	if (!uctx->shpg) {
+		rc = -ENOMEM;
+		goto fail;
+	}
+	spin_lock_init(&uctx->sh_lock);
+
+	resp.dev_id = rdev->en_dev->pdev->devfn; /*Temp, Use idr_alloc instead*/
+	resp.max_qp = rdev->qplib_ctx.qpc_count;
+	resp.pg_size = PAGE_SIZE;
+	resp.cqe_sz = sizeof(struct cq_base);
+	resp.max_cqd = dev_attr->max_cq_wqes;
+
+	rc = ib_copy_to_udata(udata, &resp, sizeof(resp));
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "Failed to copy user context");
+		rc = -EFAULT;
+		goto cfail;
+	}
+
+	return &uctx->ib_uctx;
+cfail:
+	free_page((u64)uctx->shpg);
+	uctx->shpg = NULL;
+fail:
+	kfree(uctx);
+	return ERR_PTR(rc);
+}
+
+int bnxt_re_dealloc_ucontext(struct ib_ucontext *ib_uctx)
+{
+	struct bnxt_re_ucontext *uctx = to_bnxt_re(ib_uctx,
+						   struct bnxt_re_ucontext,
+						   ib_uctx);
+	if (uctx->shpg)
+		free_page((u64)uctx->shpg);
+	kfree(uctx);
+	return 0;
+}
+
+/* Helper function to mmap the virtual memory from user app */
+int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
+{
+	struct bnxt_re_ucontext *uctx = to_bnxt_re(ib_uctx,
+						   struct bnxt_re_ucontext,
+						   ib_uctx);
+	struct bnxt_re_dev *rdev = uctx->rdev;
+	u64 pfn;
+
+	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+		return -EINVAL;
+
+	if (vma->vm_pgoff) {
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+		if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+				       PAGE_SIZE, vma->vm_page_prot)) {
+			dev_err(rdev_to_dev(rdev), "Failed to map DPI");
+			return -EAGAIN;
+		}
+	} else {
+		pfn = virt_to_phys(uctx->shpg) >> PAGE_SHIFT;
+		if (remap_pfn_range(vma, vma->vm_start,
+				    pfn, PAGE_SIZE, vma->vm_page_prot)) {
+			dev_err(rdev_to_dev(rdev),
+				"Failed to map shared page");
+			return -EAGAIN;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.h b/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.h
index 0651c30..325036d 100644
--- a/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.h
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.h
@@ -14,4 +14,27 @@
 #ifndef __BNXT_RE_IB_VERBS_H__
 #define __BNXT_RE_IB_VERBS_H__
 
+struct bnxt_re_pd {
+	struct bnxt_re_dev	*rdev;
+	struct ib_pd		ib_pd;
+	struct bnxt_qplib_pd	qplib_pd;
+	struct bnxt_qplib_dpi	dpi;
+};
+
+struct bnxt_re_ucontext {
+	struct bnxt_re_dev	*rdev;
+	struct ib_ucontext	ib_uctx;
+	struct bnxt_qplib_dpi	*dpi;
+	void			*shpg;
+	spinlock_t		sh_lock;	/* protect shpg */
+};
+
+struct ib_pd *bnxt_re_alloc_pd(struct ib_device *ibdev,
+			       struct ib_ucontext *context,
+			       struct ib_udata *udata);
+int bnxt_re_dealloc_pd(struct ib_pd *pd);
+struct ib_ucontext *bnxt_re_alloc_ucontext(struct ib_device *ibdev,
+					   struct ib_udata *udata);
+int bnxt_re_dealloc_ucontext(struct ib_ucontext *context);
+int bnxt_re_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 #endif /* __BNXT_RE_IB_VERBS_H__ */
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_main.c b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
index bf480d5..3cf5069 100644
--- a/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
@@ -34,6 +34,7 @@
 #include "bnxt_qplib_fp.h"
 #include "bnxt_qplib_rcfw.h"
 #include "bnxt_re.h"
+#include "bnxt_re_ib_verbs.h"
 #include "bnxt.h"
 static char version[] =
 		BNXT_RE_DESC " v" ROCE_DRV_MODULE_VERSION "\n";
@@ -418,6 +419,12 @@ static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
 
 	ibdev->num_comp_vectors	= 1;
 	ibdev->dma_device = &rdev->en_dev->pdev->dev;
+	ibdev->alloc_pd			= bnxt_re_alloc_pd;
+	ibdev->dealloc_pd		= bnxt_re_dealloc_pd;
+	ibdev->alloc_ucontext		= bnxt_re_alloc_ucontext;
+	ibdev->dealloc_ucontext		= bnxt_re_dealloc_ucontext;
+	ibdev->mmap			= bnxt_re_mmap;
+
 	return ib_register_device(ibdev, NULL);
 }
 
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_uverbs_abi.h b/drivers/infiniband/hw/bnxtre/bnxt_re_uverbs_abi.h
new file mode 100644
index 0000000..77a898c
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re_uverbs_abi.h
@@ -0,0 +1,32 @@
+/* Broadcom NetXtreme-C/E RoCE driver.
+ *
+ * Copyright (c) 2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+/*
+ * Description: Uverbs ABI header file
+ */
+
+#ifndef __BNXT_RE_UVERBS_ABI_H__
+#define __BNXT_RE_UVERBS_ABI_H__
+
+#define BNXT_RE_ABI_VERSION	1
+
+struct bnxt_re_uctx_resp {
+	__u32 dev_id;
+	__u32 max_qp;
+	__u32 pg_size;
+	__u32 cqe_sz;
+	__u32 max_cqd;
+} __packed;
+
+struct bnxt_re_pd_resp {
+	__u32 pdid;
+	__u32 dpi;
+	__u64 dbr;
+} __packed;
+
+#endif /* __BNXT_RE_UVERBS_ABI_H__*/
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
