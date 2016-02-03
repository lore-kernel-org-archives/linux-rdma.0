From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 19/54] staging/rdma/hfi1: Fix SL->SC checks
Date: Wed, 03 Feb 2016 14:33:14 -0800
Message-ID: <20160203223311.5923.98930.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny@intel..com>

SLs which are mapped to SC15 are invalid and should fail the
operation.

For RC/UC QP types, verify the AH information at modify_qp time and
fail the modify_qp if the SL is invalid.

For other QP types check the SL during post_send via the new rdmavt
callback.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qp.c    |   20 ++++++++++++++++++++
 drivers/staging/rdma/hfi1/verbs.c |    1 +
 drivers/staging/rdma/hfi1/verbs.h |    2 ++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 52723c2..05a9619 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -185,6 +185,9 @@ int hfi1_check_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 
 	if (attr_mask & IB_QP_AV) {
 		sc = ah_to_sc(ibqp->device, &attr->ah_attr);
+		if (sc == 0xf)
+			return -EINVAL;
+
 		if (!qp_to_sdma_engine(qp, sc) &&
 		    dd->flags & HFI1_HAS_SEND_DMA)
 			return -EINVAL;
@@ -192,6 +195,9 @@ int hfi1_check_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 
 	if (attr_mask & IB_QP_ALT_PATH) {
 		sc = ah_to_sc(ibqp->device, &attr->alt_ah_attr);
+		if (sc == 0xf)
+			return -EINVAL;
+
 		if (!qp_to_sdma_engine(qp, sc) &&
 		    dd->flags & HFI1_HAS_SEND_DMA)
 			return -EINVAL;
@@ -220,6 +226,20 @@ void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 	}
 }
 
+int hfi1_check_send_wr(struct rvt_qp *qp, struct ib_send_wr *wr)
+{
+	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
+	struct rvt_ah *ah = ibah_to_rvtah(ud_wr(wr)->ah);
+
+	if (qp->ibqp.qp_type != IB_QPT_RC &&
+	    qp->ibqp.qp_type != IB_QPT_UC &&
+	    qp->ibqp.qp_type != IB_QPT_SMI &&
+	    ibp->sl_to_sc[ah->attr.sl] == 0xf) {
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /**
  * hfi1_compute_aeth - compute the AETH (syndrome + MSN)
  * @qp: the queue pair to compute the AETH for
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index a53d93a..6d541ca 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1561,6 +1561,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.mtu_to_path_mtu = mtu_to_path_mtu;
 	dd->verbs_dev.rdi.driver_f.check_modify_qp = hfi1_check_modify_qp;
 	dd->verbs_dev.rdi.driver_f.modify_qp = hfi1_modify_qp;
+	dd->verbs_dev.rdi.driver_f.check_send_wr = hfi1_check_send_wr;
 
 	/* completeion queue */
 	snprintf(dd->verbs_dev.rdi.dparms.cq_name,
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 79bcab6..1571ae3 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -439,6 +439,8 @@ int hfi1_check_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 		    int attr_mask, struct ib_udata *udata);
 
+int hfi1_check_send_wr(struct rvt_qp *qp, struct ib_send_wr *wr);
+
 int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
 		       int has_grh, struct rvt_qp *qp, u32 bth0);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
