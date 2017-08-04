From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 21/27] IB/hfi1: Determine 9B/16B L2 header type
 based on Address handle
Date: Fri, 04 Aug 2017 13:54:16 -0700
Message-ID: <20170804205415.17853.77749.stgit@scvm10.sc.intel.com>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170804204842.17853.14858.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When address handle attributes are initialized, the LIDs are
transformed to be in the 32 bit LID space.
When constructing the header, hfi1 driver will look at the LID
to determine the packet header to be created.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c   |   21 ++++++--
 drivers/infiniband/core/uverbs_cmd.c |    3 +
 drivers/infiniband/hw/hfi1/hfi.h     |   92 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/qp.c      |   28 ++++++++++
 drivers/infiniband/hw/hfi1/verbs.c   |   12 ++++
 drivers/infiniband/hw/hfi1/verbs.h   |    1 
 include/rdma/ib_verbs.h              |   15 ++++++
 include/rdma/opa_addr.h              |    4 +
 8 files changed, 168 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 70fa4ca..61b0f45 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -50,6 +50,7 @@
 #include <uapi/rdma/ib_user_sa.h>
 #include <rdma/ib_marshall.h>
 #include <rdma/ib_addr.h>
+#include <rdma/opa_addr.h>
 #include "sa.h"
 #include "core_priv.h"
 
@@ -1241,6 +1242,11 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 	ah_attr->type = rdma_ah_find_type(device, port_num);
 
 	rdma_ah_set_dlid(ah_attr, be32_to_cpu(sa_path_get_dlid(rec)));
+
+	if ((ah_attr->type == RDMA_AH_ATTR_TYPE_OPA) &&
+	    (rdma_ah_get_dlid(ah_attr) == be16_to_cpu(IB_LID_PERMISSIVE)))
+		rdma_ah_set_make_grd(ah_attr, true);
+
 	rdma_ah_set_sl(ah_attr, rec->sl);
 	rdma_ah_set_path_bits(ah_attr, be32_to_cpu(sa_path_get_slid(rec)) &
 			      get_src_path_mask(device, port_num));
@@ -2290,12 +2296,15 @@ static void update_sm_ah(struct work_struct *work)
 	rdma_ah_set_sl(&ah_attr, port_attr.sm_sl);
 	rdma_ah_set_port_num(&ah_attr, port->port_num);
 	if (port_attr.grh_required) {
-		rdma_ah_set_ah_flags(&ah_attr, IB_AH_GRH);
-
-		rdma_ah_set_subnet_prefix(&ah_attr,
-					  cpu_to_be64(port_attr.subnet_prefix));
-		rdma_ah_set_interface_id(&ah_attr,
-					 cpu_to_be64(IB_SA_WELL_KNOWN_GUID));
+		if (ah_attr.type == RDMA_AH_ATTR_TYPE_OPA) {
+			rdma_ah_set_make_grd(&ah_attr, true);
+		} else {
+			rdma_ah_set_ah_flags(&ah_attr, IB_AH_GRH);
+			rdma_ah_set_subnet_prefix(&ah_attr,
+						  cpu_to_be64(port_attr.subnet_prefix));
+			rdma_ah_set_interface_id(&ah_attr,
+						 cpu_to_be64(IB_SA_WELL_KNOWN_GUID));
+		}
 	}
 
 	new_ah->ah = rdma_create_ah(port->agent->qp->pd, &ah_attr);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 670176b..3ce4563 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2000,6 +2000,7 @@ static int modify_qp(struct ib_uverbs_file *file,
 	rdma_ah_set_static_rate(&attr->ah_attr, cmd->base.dest.static_rate);
 	rdma_ah_set_port_num(&attr->ah_attr,
 			     cmd->base.dest.port_num);
+	rdma_ah_set_make_grd(&attr->ah_attr, false);
 
 	attr->alt_ah_attr.type = rdma_ah_find_type(qp->device,
 						   cmd->base.dest.port_num);
@@ -2023,6 +2024,7 @@ static int modify_qp(struct ib_uverbs_file *file,
 				cmd->base.alt_dest.static_rate);
 	rdma_ah_set_port_num(&attr->alt_ah_attr,
 			     cmd->base.alt_dest.port_num);
+	rdma_ah_set_make_grd(&attr->alt_ah_attr, false);
 
 	ret = ib_modify_qp_with_udata(qp, attr,
 				      modify_qp_mask(qp->qp_type,
@@ -2573,6 +2575,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	}
 
 	attr.type = rdma_ah_find_type(ib_dev, cmd.attr.port_num);
+	rdma_ah_set_make_grd(&attr, false);
 	rdma_ah_set_dlid(&attr, cmd.attr.dlid);
 	rdma_ah_set_sl(&attr, cmd.attr.sl);
 	rdma_ah_set_path_bits(&attr, cmd.attr.src_path_bits);
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index ee19660..cec9590 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -70,6 +70,7 @@
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
 #include <rdma/rdma_vt.h>
+#include <rdma/opa_addr.h>
 
 #include "chip_registers.h"
 #include "common.h"
@@ -353,6 +354,10 @@ struct hfi1_packet {
 	bool fecn;
 };
 
+/* Packet types */
+#define HFI1_PKT_TYPE_9B  0
+#define HFI1_PKT_TYPE_16B 1
+
 /*
  * OPA 16B Header
  */
@@ -2170,6 +2175,31 @@ static inline bool is_integrated(struct hfi1_devdata *dd)
 #define DD_DEV_ENTRY(dd)       __string(dev, dev_name(&(dd)->pcidev->dev))
 #define DD_DEV_ASSIGN(dd)      __assign_str(dev, dev_name(&(dd)->pcidev->dev))
 
+static inline void hfi1_update_ah_attr(struct ib_device *ibdev,
+				       struct rdma_ah_attr *attr)
+{
+	struct hfi1_pportdata *ppd;
+	struct hfi1_ibport *ibp;
+	u32 dlid = rdma_ah_get_dlid(attr);
+
+	/*
+	 * Kernel clients may not have setup GRH information
+	 * Set that here.
+	 */
+	ibp = to_iport(ibdev, rdma_ah_get_port_num(attr));
+	ppd = ppd_from_ibp(ibp);
+	if ((((dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
+	      (ppd->lid >= be16_to_cpu(IB_MULTICAST_LID_BASE))) &&
+	    (dlid != be32_to_cpu(OPA_LID_PERMISSIVE)) &&
+	    (dlid != be16_to_cpu(IB_LID_PERMISSIVE)) &&
+	    (!(rdma_ah_get_ah_flags(attr) & IB_AH_GRH))) ||
+	    (rdma_ah_get_make_grd(attr))) {
+		rdma_ah_set_ah_flags(attr, IB_AH_GRH);
+		rdma_ah_set_interface_id(attr, OPA_MAKE_ID(dlid));
+		rdma_ah_set_subnet_prefix(attr, ibp->rvp.gid_prefix);
+	}
+}
+
 /*
  * hfi1_check_mcast- Check if the given lid is
  * in the OPA multicast range.
@@ -2223,4 +2253,66 @@ static inline bool hfi1_is_16B_mcast(u32 lid)
 		opa_get_lid(opa_get_mcast_base(OPA_MCAST_NR), 16B)) &&
 		(lid != opa_get_lid(be32_to_cpu(OPA_LID_PERMISSIVE), 16B)));
 }
+
+static inline void hfi1_make_opa_lid(struct rdma_ah_attr *attr)
+{
+	const struct ib_global_route *grh = rdma_ah_read_grh(attr);
+	u32 dlid = rdma_ah_get_dlid(attr);
+
+	/* Modify ah_attr.dlid to be in the 32 bit LID space.
+	 * This is how the address will be laid out:
+	 * Assuming MCAST_NR to be 4,
+	 * 32 bit permissive LID = 0xFFFFFFFF
+	 * Multicast LID range = 0xFFFFFFFE to 0xF0000000
+	 * Unicast LID range = 0xEFFFFFFF to 1
+	 * Invalid LID = 0
+	 */
+	if (ib_is_opa_gid(&grh->dgid))
+		dlid = opa_get_lid_from_gid(&grh->dgid);
+	else if ((dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
+		 (dlid != be16_to_cpu(IB_LID_PERMISSIVE)) &&
+		 (dlid != be32_to_cpu(OPA_LID_PERMISSIVE)))
+		dlid = dlid - be16_to_cpu(IB_MULTICAST_LID_BASE) +
+			opa_get_mcast_base(OPA_MCAST_NR);
+	else if (dlid == be16_to_cpu(IB_LID_PERMISSIVE))
+		dlid = be32_to_cpu(OPA_LID_PERMISSIVE);
+
+	rdma_ah_set_dlid(attr, dlid);
+}
+
+static inline u8 hfi1_get_packet_type(u32 lid)
+{
+	/* 9B if lid > 0xF0000000 */
+	if (lid >= opa_get_mcast_base(OPA_MCAST_NR))
+		return HFI1_PKT_TYPE_9B;
+
+	/* 16B if lid > 0xC000 */
+	if (lid >= opa_get_lid(opa_get_mcast_base(OPA_MCAST_NR), 9B))
+		return HFI1_PKT_TYPE_16B;
+
+	return HFI1_PKT_TYPE_9B;
+}
+
+static inline bool hfi1_get_hdr_type(u32 lid, struct rdma_ah_attr *attr)
+{
+	/*
+	 * If there was an incoming 16B packet with permissive
+	 * LIDs, OPA GIDs would have been programmed when those
+	 * packets were received. A 16B packet will have to
+	 * be sent in response to that packet. Return a 16B
+	 * header type if that's the case.
+	 */
+	if (rdma_ah_get_dlid(attr) == be32_to_cpu(OPA_LID_PERMISSIVE))
+		return (ib_is_opa_gid(&rdma_ah_read_grh(attr)->dgid)) ?
+			HFI1_PKT_TYPE_16B : HFI1_PKT_TYPE_9B;
+
+	/*
+	 * Return a 16B header type if either the the destination
+	 * or source lid is extended.
+	 */
+	if (hfi1_get_packet_type(rdma_ah_get_dlid(attr)) == HFI1_PKT_TYPE_16B)
+		return HFI1_PKT_TYPE_16B;
+
+	return hfi1_get_packet_type(lid);
+}
 #endif                          /* _HFI1_KERNEL_H */
diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index b801d84..0fca6df 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -232,6 +232,31 @@ int hfi1_check_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 	return 0;
 }
 
+/*
+ * qp_set_16b - Set the hdr_type based on whether the slid or the
+ * dlid in the connection is extended. Only applicable for RC and UC
+ * QPs. UD QPs determine this on the fly from the ah in the wqe
+ */
+static inline void qp_set_16b(struct rvt_qp *qp)
+{
+	struct hfi1_pportdata *ppd;
+	struct hfi1_ibport *ibp;
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	/* Update ah_attr to account for extended LIDs */
+	hfi1_update_ah_attr(qp->ibqp.device, &qp->remote_ah_attr);
+
+	/* Create 32 bit LIDs */
+	hfi1_make_opa_lid(&qp->remote_ah_attr);
+
+	if (!(rdma_ah_get_ah_flags(&qp->remote_ah_attr) & IB_AH_GRH))
+		return;
+
+	ibp = to_iport(qp->ibqp.device, qp->port_num);
+	ppd = ppd_from_ibp(ibp);
+	priv->hdr_type = hfi1_get_hdr_type(ppd->lid, &qp->remote_ah_attr);
+}
+
 void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 		    int attr_mask, struct ib_udata *udata)
 {
@@ -242,6 +267,7 @@ void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 		priv->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
 		priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
 		priv->s_sendcontext = qp_to_send_context(qp, priv->s_sc);
+		qp_set_16b(qp);
 	}
 
 	if (attr_mask & IB_QP_PATH_MIG_STATE &&
@@ -251,6 +277,7 @@ void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 		priv->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
 		priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
 		priv->s_sendcontext = qp_to_send_context(qp, priv->s_sc);
+		qp_set_16b(qp);
 	}
 }
 
@@ -751,6 +778,7 @@ void hfi1_migrate_qp(struct rvt_qp *qp)
 	qp->s_flags |= RVT_S_AHG_CLEAR;
 	priv->s_sc = ah_to_sc(qp->ibqp.device, &qp->remote_ah_attr);
 	priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
+	qp_set_16b(qp);
 
 	ev.device = qp->ibqp.device;
 	ev.element.qp = &qp->ibqp;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index df4103d..62526f5 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1421,6 +1421,15 @@ static int query_port(struct rvt_dev_info *rdi, u8 port_num,
 	props->active_mtu = !valid_ib_mtu(ppd->ibmtu) ? props->max_mtu :
 		mtu_to_enum(ppd->ibmtu, IB_MTU_2048);
 
+	/*
+	 * sm_lid of 0xFFFF needs special handling so that it can
+	 * be differentiated from a permissve LID of 0xFFFF.
+	 * We set the grh_required flag here so the SA can program
+	 * the DGID in the address handle appropriately
+	 */
+	if (props->sm_lid == be16_to_cpu(IB_LID_PERMISSIVE))
+		props->grh_required = true;
+
 	return 0;
 }
 
@@ -1528,6 +1537,7 @@ static void hfi1_notify_new_ah(struct ib_device *ibdev,
 	struct hfi1_pportdata *ppd;
 	struct hfi1_devdata *dd;
 	u8 sc5;
+	struct rdma_ah_attr *attr = &ah->attr;
 
 	/*
 	 * Do not trust reading anything from rvt_ah at this point as it is not
@@ -1537,6 +1547,8 @@ static void hfi1_notify_new_ah(struct ib_device *ibdev,
 	ibp = to_iport(ibdev, rdma_ah_get_port_num(ah_attr));
 	ppd = ppd_from_ibp(ibp);
 	sc5 = ibp->sl_to_sc[rdma_ah_get_sl(&ah->attr)];
+	hfi1_update_ah_attr(ibdev, attr);
+	hfi1_make_opa_lid(attr);
 	dd = dd_from_ppd(ppd);
 	ah->vl = sc_to_vlt(dd, sc5);
 	if (ah->vl < num_vls || ah->vl == 15)
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 68577a0..d3dd0c0 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -147,6 +147,7 @@ struct hfi1_qp_priv {
 	u8 s_sc;		                  /* SC[0..4] for next packet */
 	struct iowait s_iowait;
 	struct rvt_qp *owner;
+	u8 hdr_type; /* 9B or 16B */
 };
 
 /*
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 3cb31e4..991783d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -862,6 +862,7 @@ struct roce_ah_attr {
 struct opa_ah_attr {
 	u32			dlid;
 	u8			src_path_bits;
+	bool			make_grd;
 };
 
 struct rdma_ah_attr {
@@ -3619,6 +3620,20 @@ static inline u8 rdma_ah_get_path_bits(const struct rdma_ah_attr *attr)
 	return 0;
 }
 
+static inline void rdma_ah_set_make_grd(struct rdma_ah_attr *attr,
+					bool make_grd)
+{
+	if (attr->type == RDMA_AH_ATTR_TYPE_OPA)
+		attr->opa.make_grd = make_grd;
+}
+
+static inline bool rdma_ah_get_make_grd(const struct rdma_ah_attr *attr)
+{
+	if (attr->type == RDMA_AH_ATTR_TYPE_OPA)
+		return attr->opa.make_grd;
+	return false;
+}
+
 static inline void rdma_ah_set_port_num(struct rdma_ah_attr *attr, u8 port_num)
 {
 	attr->port_num = port_num;
diff --git a/include/rdma/opa_addr.h b/include/rdma/opa_addr.h
index 8d3ad4e..9ae126f 100644
--- a/include/rdma/opa_addr.h
+++ b/include/rdma/opa_addr.h
@@ -71,7 +71,7 @@
  *
  * @gid: The Global identifier
  */
-static inline bool ib_is_opa_gid(union ib_gid *gid)
+static inline bool ib_is_opa_gid(const union ib_gid *gid)
 {
 	return ((be64_to_cpu(gid->global.interface_id) >> 40) ==
 		OPA_SPECIAL_OUI);
@@ -84,7 +84,7 @@ static inline bool ib_is_opa_gid(union ib_gid *gid)
  *
  * @gid: The Global identifier
  */
-static inline u32 opa_get_lid_from_gid(union ib_gid *gid)
+static inline u32 opa_get_lid_from_gid(const union ib_gid *gid)
 {
 	return be64_to_cpu(gid->global.interface_id) & 0xFFFFFFFF;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
