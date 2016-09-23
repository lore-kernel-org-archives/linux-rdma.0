From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 11/11] IB/rdmavt: Modify rvt_check_ah() to account for extended LIDs
Date: Fri, 23 Sep 2016 13:44:34 -0400
Message-ID: <1474652674-13110-12-git-send-email-ira.weiny@intel.com>
References: <1474652674-13110-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474652674-13110-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

rvt_check_ah() delegates lid verification to underlying
driver. Underlying driver uses different conditions to
check for dlid depending on whether the device supports
extended LIDs

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h      |  1 +
 drivers/infiniband/hw/hfi1/verbs.c    | 13 +++++++++++++
 drivers/infiniband/hw/qib/qib_verbs.c |  9 +++++++++
 drivers/infiniband/sw/rdmavt/ah.c     | 10 ----------
 drivers/infiniband/sw/rdmavt/qp.c     |  9 ++++++---
 5 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 57ebbec2840c..fe4aa7eacc5e 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -67,6 +67,7 @@
 #include <rdma/ib_hdrs.h>
 #include <linux/rhashtable.h>
 #include <rdma/rdma_vt.h>
+#include <rdma/ib_addr.h>
 
 #include "chip_registers.h"
 #include "common.h"
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 1f193340dac0..468faf0e2b10 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1510,7 +1510,20 @@ static int hfi1_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
 	struct hfi1_pportdata *ppd;
 	struct hfi1_devdata *dd;
 	u8 sc5;
+	u32 lid;
 
+	if ((ah_attr->ah_flags & IB_AH_GRH) &&
+	    ib_is_opa_gid(&ah_attr->grh.dgid)) {
+		lid = opa_get_lid_from_gid(&ah_attr->grh.dgid);
+		if (lid != OPA_LID_PERMISSIVE)
+			return -EINVAL;
+	} else {
+		lid = ah_attr->dlid;
+		if ((lid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
+		    (lid != be16_to_cpu(IB_LID_PERMISSIVE)) &&
+		    (!(ah_attr->ah_flags & IB_AH_GRH)))
+			return -EINVAL;
+	}
 	/* test the mapping for validity */
 	ibp = to_iport(ibdev, ah_attr->port_num);
 	ppd = ppd_from_ibp(ibp);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 876ebb442d38..ebb30fce030c 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1426,6 +1426,15 @@ int qib_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
 	if (ah_attr->sl > 15)
 		return -EINVAL;
 
+	if (ah_attr->dlid == 0)
+		return -EINVAL;
+	if (ah_attr->dlid >=
+		be16_to_cpu(IB_MULTICAST_LID_BASE) &&
+	    ah_attr->dlid !=
+		be16_to_cpu(IB_LID_PERMISSIVE) &&
+	    !(ah_attr->ah_flags & IB_AH_GRH))
+		return -EINVAL;
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/sw/rdmavt/ah.c b/drivers/infiniband/sw/rdmavt/ah.c
index 16c446142c2a..9521294a28f1 100644
--- a/drivers/infiniband/sw/rdmavt/ah.c
+++ b/drivers/infiniband/sw/rdmavt/ah.c
@@ -65,8 +65,6 @@ int rvt_check_ah(struct ib_device *ibdev,
 	int err;
 	struct ib_port_attr port_attr;
 	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
-	enum rdma_link_layer link = rdma_port_get_link_layer(ibdev,
-							     ah_attr->port_num);
 
 	err = ib_query_port(ibdev, ah_attr->port_num, &port_attr);
 	if (err)
@@ -80,14 +78,6 @@ int rvt_check_ah(struct ib_device *ibdev,
 	if ((ah_attr->ah_flags & IB_AH_GRH) &&
 	    ah_attr->grh.sgid_index >= port_attr.gid_tbl_len)
 		return -EINVAL;
-	if (link != IB_LINK_LAYER_ETHERNET) {
-		if (ah_attr->dlid == 0)
-			return -EINVAL;
-		if (ah_attr->dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE) &&
-		    ah_attr->dlid != be16_to_cpu(IB_LID_PERMISSIVE) &&
-		    !(ah_attr->ah_flags & IB_AH_GRH))
-			return -EINVAL;
-	}
 	if (rdi->driver_f.check_ah)
 		return rdi->driver_f.check_ah(ibdev, ah_attr);
 	return 0;
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 7fe0d7e3ba46..d41c7f7748da 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1035,6 +1035,7 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	int mig = 0;
 	int pmtu = 0; /* for gcc warning only */
 	enum rdma_link_layer link;
+	int opa_ah;
 
 	link = rdma_port_get_link_layer(ibqp->device, qp->port_num);
 
@@ -1045,6 +1046,7 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	cur_state = attr_mask & IB_QP_CUR_STATE ?
 		attr->cur_qp_state : qp->state;
 	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
+	opa_ah = rdma_cap_opa_ah(ibqp->device, qp->port_num);
 
 	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type,
 				attr_mask, link))
@@ -1055,15 +1057,16 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		goto inval;
 
 	if (attr_mask & IB_QP_AV) {
-		if (attr->ah_attr.dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
+		if (!opa_ah && (attr->ah_attr.dlid >=
+				be16_to_cpu(IB_MULTICAST_LID_BASE)))
 			goto inval;
 		if (rvt_check_ah(qp->ibqp.device, &attr->ah_attr))
 			goto inval;
 	}
 
 	if (attr_mask & IB_QP_ALT_PATH) {
-		if (attr->alt_ah_attr.dlid >=
-		    be16_to_cpu(IB_MULTICAST_LID_BASE))
+		if (!opa_ah && (attr->alt_ah_attr.dlid >=
+			be16_to_cpu(IB_MULTICAST_LID_BASE)))
 			goto inval;
 		if (rvt_check_ah(qp->ibqp.device, &attr->alt_ah_attr))
 			goto inval;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
