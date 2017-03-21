From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 19/20] IB/rdmavt, IB/qib,
 IB/hfi1: Make percpu refcount optional for user MRs
Date: Mon, 20 Mar 2017 17:26:32 -0700
Message-ID: <20170321002631.28538.2121.stgit@scvm10.sc.intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321001900.28538.38175.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In some cases, the cost of user memory deregistration is more
important than the data path benefit of percpu reference counts.

Add a (default off) module parameter to disarm percpu for user memory
regions.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/verbs.c    |    7 +++++++
 drivers/infiniband/hw/qib/qib_verbs.c |    7 +++++++
 drivers/infiniband/sw/rdmavt/mr.c     |    6 +++++-
 include/rdma/rdma_vt.h                |    1 +
 4 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 5e7e577..552b26d 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -68,6 +68,12 @@
 MODULE_PARM_DESC(lkey_table_size,
 		 "LKEY table size in bits (2^n, 1 <= n <= 23)");
 
+static unsigned int hfi1_no_user_mr_percpu;
+module_param_named(no_user_mr_percpu, hfi1_no_user_mr_percpu, uint,
+		   S_IRUGO);
+MODULE_PARM_DESC(no_user_mr_percpu,
+		 "Avoid percpu refcount for user MRs (default 0)");
+
 static unsigned int hfi1_max_pds = 0xFFFF;
 module_param_named(max_pds, hfi1_max_pds, uint, S_IRUGO);
 MODULE_PARM_DESC(max_pds,
@@ -1841,6 +1847,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	/* misc settings */
 	dd->verbs_dev.rdi.flags = 0; /* Let rdmavt handle it all */
 	dd->verbs_dev.rdi.dparms.lkey_table_size = hfi1_lkey_table_size;
+	dd->verbs_dev.rdi.dparms.no_user_mr_percpu = hfi1_no_user_mr_percpu;
 	dd->verbs_dev.rdi.dparms.nports = dd->num_pports;
 	dd->verbs_dev.rdi.dparms.npkeys = hfi1_get_npkeys(dd);
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index e120efe..6c718cd 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -56,6 +56,12 @@
 MODULE_PARM_DESC(lkey_table_size,
 		 "LKEY table size in bits (2^n, 1 <= n <= 23)");
 
+static unsigned int qib_no_user_mr_percpu;
+module_param_named(no_user_mr_percpu, qib_no_user_mr_percpu, uint,
+		   S_IRUGO);
+MODULE_PARM_DESC(no_user_mr_percpu,
+		 "Avoid percpu refcount for user MRs (default 0)");
+
 static unsigned int ib_qib_max_pds = 0xFFFF;
 module_param_named(max_pds, ib_qib_max_pds, uint, S_IRUGO);
 MODULE_PARM_DESC(max_pds,
@@ -1606,6 +1612,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.dparms.max_rdma_atomic = QIB_MAX_RDMA_ATOMIC;
 	dd->verbs_dev.rdi.driver_f.get_guid_be = qib_get_guid_be;
 	dd->verbs_dev.rdi.dparms.lkey_table_size = qib_lkey_table_size;
+	dd->verbs_dev.rdi.dparms.no_user_mr_percpu = qib_no_user_mr_percpu;
 	dd->verbs_dev.rdi.dparms.qp_table_size = ib_qib_qp_table_size;
 	dd->verbs_dev.rdi.dparms.qpn_start = 1;
 	dd->verbs_dev.rdi.dparms.qpn_res_start = QIB_KD_QP;
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 7c86955..bbcc31f 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -280,6 +280,7 @@ static void rvt_free_lkey(struct rvt_mregion *mr)
 	struct rvt_mr *mr;
 	int rval = -ENOMEM;
 	int m;
+	struct rvt_dev_info *dev = ib_to_rvt(pd->device);
 
 	/* Allocate struct plus pointers to first level page tables. */
 	m = (count + RVT_SEGSZ - 1) / RVT_SEGSZ;
@@ -287,7 +288,10 @@ static void rvt_free_lkey(struct rvt_mregion *mr)
 	if (!mr)
 		goto bail;
 
-	rval = rvt_init_mregion(&mr->mr, pd, count, 0);
+	rval = rvt_init_mregion(&mr->mr, pd, count,
+				ibpd_to_rvtpd(pd)->user &&
+				dev->dparms.no_user_mr_percpu ?
+					PERCPU_REF_INIT_ATOMIC : 0);
 	if (rval)
 		goto bail;
 	/*
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 8fc1ca7..d60a41e 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -142,6 +142,7 @@ struct rvt_driver_params {
 	 * For instance special module parameters. Goes here.
 	 */
 	unsigned int lkey_table_size;
+	unsigned int no_user_mr_percpu;
 	unsigned int qp_table_size;
 	int qpn_start;
 	int qpn_inc;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
