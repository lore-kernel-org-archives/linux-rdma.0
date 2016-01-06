From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/9] IB/qib: Use rdmavt pkey verbs function
Date: Wed, 06 Jan 2016 10:23:21 -0800
Message-ID: <20160106182320.5401.51690.stgit@scvm10.sc.intel.com>
References: <20160106181837.5401.67435.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106181837.5401.67435.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove qib query pkey function which is no longer needed as this is now
being done in rdmavt. The allocation and maintenance of the list still
resides in the driver.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_verbs.c |   33 +++++++++++++--------------------
 1 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 368b794..c923734 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1836,24 +1836,6 @@ unsigned qib_get_pkey(struct qib_ibport *ibp, unsigned index)
 	return ret;
 }
 
-static int qib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
-			  u16 *pkey)
-{
-	struct qib_devdata *dd = dd_from_ibdev(ibdev);
-	int ret;
-
-	if (index >= qib_get_npkeys(dd)) {
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	*pkey = qib_get_pkey(to_iport(ibdev, port), index);
-	ret = 0;
-
-bail:
-	return ret;
-}
-
 /**
  * qib_alloc_ucontext - allocate a ucontest
  * @ibdev: the infiniband device
@@ -1956,7 +1938,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	struct qib_ibdev *dev = &dd->verbs_dev;
 	struct ib_device *ibdev = &dev->rdi.ibdev;
 	struct qib_pportdata *ppd = dd->pport;
-	unsigned i;
+	unsigned i, ctxt;
 	int ret;
 
 	dev->qp_table_size = ib_qib_qp_table_size;
@@ -2068,7 +2050,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->modify_device = qib_modify_device;
 	ibdev->query_port = qib_query_port;
 	ibdev->modify_port = qib_modify_port;
-	ibdev->query_pkey = qib_query_pkey;
+	ibdev->query_pkey = NULL;
 	ibdev->query_gid = qib_query_gid;
 	ibdev->alloc_ucontext = qib_alloc_ucontext;
 	ibdev->dealloc_ucontext = qib_dealloc_ucontext;
@@ -2126,6 +2108,17 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.flags = (RVT_FLAG_QP_INIT_DRIVER |
 				   RVT_FLAG_CQ_INIT_DRIVER);
 	dd->verbs_dev.rdi.dparms.lkey_table_size = qib_lkey_table_size;
+	dd->verbs_dev.rdi.dparms.nports = dd->num_pports;
+	dd->verbs_dev.rdi.dparms.npkeys = qib_get_npkeys(dd);
+
+	ppd = dd->pport;
+	for (i = 0; i < dd->num_pports; i++, ppd++) {
+		ctxt = ppd->hw_pidx;
+		rvt_init_port(&dd->verbs_dev.rdi,
+			      &ppd->ibport_data.rvp,
+			      i,
+			      dd->rcd[ctxt]->pkeys);
+	}
 
 	ret = rvt_register_device(&dd->verbs_dev.rdi);
 	if (ret)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
