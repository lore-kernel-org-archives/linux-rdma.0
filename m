From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 06/11] IB/mad: Ensure DR MADs are correctly specified when using OPA devices
Date: Fri, 23 Sep 2016 13:44:29 -0400
Message-ID: <1474652674-13110-7-git-send-email-ira.weiny@intel.com>
References: <1474652674-13110-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474652674-13110-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Pure DR MADs do not need OPA GIDs to be specified in the GRH since
they do not rely on LID information.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c | 100 +++++++++++++++++++++++++++++++++++++-----
 include/rdma/ib_addr.h        |  14 ++++++
 2 files changed, 102 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 2d49228f28b2..752bd91a1cc9 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <rdma/ib_cache.h>
+#include <rdma/ib_addr.h>
 
 #include "mad_priv.h"
 #include "mad_rmpp.h"
@@ -731,6 +732,76 @@ static size_t mad_priv_dma_size(const struct ib_mad_private *mp)
 	return sizeof(struct ib_grh) + mp->mad_size;
 }
 
+static int verify_mad_ah(struct ib_mad_agent_private *mad_agent_priv,
+			 struct ib_mad_send_wr_private *mad_send_wr)
+{
+	struct ib_device *ib_dev = mad_agent_priv->qp_info->port_priv->device;
+	u8 port = mad_agent_priv->qp_info->port_priv->port_num;
+	struct ib_smp *smp = mad_send_wr->send_buf.mad;
+	struct opa_smp *opa_smp = (struct opa_smp *)smp;
+	u32 opa_drslid = be32_to_cpu(opa_smp->route.dr.dr_slid);
+	u32 opa_drdlid = be32_to_cpu(opa_smp->route.dr.dr_dlid);
+
+	bool dr_slid_is_permissive = (OPA_LID_PERMISSIVE ==
+				 opa_smp->route.dr.dr_slid);
+	bool dr_dlid_is_permissive = (OPA_LID_PERMISSIVE ==
+				 opa_smp->route.dr.dr_dlid);
+	bool drslid_is_ib_ucast = !(opa_drslid & 0xFFFFC000);
+	bool drdlid_is_ib_ucast = !(opa_drdlid & 0xFFFFC000);
+	bool drslid_is_ext = !drslid_is_ib_ucast && !dr_slid_is_permissive;
+	bool drdlid_is_ext = !drdlid_is_ib_ucast && !dr_dlid_is_permissive;
+	bool grh_present = false;
+	struct ib_ah_attr attr;
+	union ib_gid sgid;
+	int ret = 0;
+
+	ret = ib_query_ah(mad_send_wr->send_buf.ah, &attr);
+	if (ret)
+		return ret;
+	grh_present = (attr.ah_flags & IB_AH_GRH);
+	if (grh_present) {
+		ret = ib_query_gid(ib_dev, port, attr.grh.sgid_index,
+				   &sgid, NULL);
+		if (ret)
+			return ret;
+	}
+
+	if (smp->class_version == OPA_SMP_CLASS_VERSION) {
+		/*
+		 * Conditions when GRH info should not be specified
+		 * 1. both dr_slid and dr_dlid are permissve (Pure DR)
+		 * 2. both dr_slid and dr_dlid are less than 0xc000.
+		 *
+		 * Conditions when GRH info should be specified
+		 * 1. dr_dlid is not permissive and above 0xbfff
+		 * OR
+		 * 2. dr_slid is not permissive and above 0xbfff
+		 */
+		if (grh_present) {
+			if ((dr_slid_is_permissive &&
+			     dr_dlid_is_permissive) ||
+			     (drslid_is_ib_ucast && drdlid_is_ib_ucast))
+				if (ib_is_opa_gid(&attr.grh.dgid) &&
+				    ib_is_opa_gid(&sgid))
+					return -EINVAL;
+			if (drslid_is_ext && !ib_is_opa_gid(&sgid))
+				return -EINVAL;
+			if (drdlid_is_ext &&
+			    !ib_is_opa_gid(&attr.grh.dgid))
+				return -EINVAL;
+		} else { /* There is no GRH */
+			if (drslid_is_ext || drdlid_is_ext)
+				return -EINVAL;
+		}
+	} else {
+		if (grh_present)
+			if (ib_is_opa_gid(&attr.grh.dgid) &&
+			    ib_is_opa_gid(&sgid))
+				return -EINVAL;
+	}
+	return 0;
+}
+
 /*
  * Return 0 if SMP is to be sent
  * Return 1 if SMP was consumed locally (whether or not solicited)
@@ -754,8 +825,12 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	size_t mad_size = port_mad_size(mad_agent_priv->qp_info->port_priv);
 	u16 out_mad_pkey_index = 0;
 	u16 drslid;
-	bool opa = rdma_cap_opa_mad(mad_agent_priv->qp_info->port_priv->device,
-				    mad_agent_priv->qp_info->port_priv->port_num);
+	bool opa_mad =
+		rdma_cap_opa_mad(mad_agent_priv->qp_info->port_priv->device,
+				 mad_agent_priv->qp_info->port_priv->port_num);
+	bool opa_ah =
+		rdma_cap_opa_ah(mad_agent_priv->qp_info->port_priv->device,
+				mad_agent_priv->qp_info->port_priv->port_num);
 
 	if (rdma_cap_ib_switch(device) &&
 	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
@@ -763,13 +838,21 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	else
 		port_num = mad_agent_priv->agent.port_num;
 
+	if (opa_mad && opa_ah) {
+		ret = verify_mad_ah(mad_agent_priv, mad_send_wr);
+		if (ret) {
+			dev_err(&device->dev,
+				"Error verifying MAD format\n");
+			goto out;
+		}
+	}
 	/*
 	 * Directed route handling starts if the initial LID routed part of
 	 * a request or the ending LID routed part of a response is empty.
 	 * If we are at the start of the LID routed part, don't update the
 	 * hop_ptr or hop_cnt.  See section 14.2.2, Vol 1 IB spec.
 	 */
-	if (opa && smp->class_version == OPA_SMP_CLASS_VERSION) {
+	if (opa_mad && smp->class_version == OPA_SMP_CLASS_VERSION) {
 		u32 opa_drslid;
 
 		if ((opa_get_smp_direction(opa_smp)
@@ -783,13 +866,6 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 			goto out;
 		}
 		opa_drslid = be32_to_cpu(opa_smp->route.dr.dr_slid);
-		if (opa_drslid != be32_to_cpu(OPA_LID_PERMISSIVE) &&
-		    opa_drslid & 0xffff0000) {
-			ret = -EINVAL;
-			dev_err(&device->dev, "OPA Invalid dr_slid 0x%x\n",
-			       opa_drslid);
-			goto out;
-		}
 		drslid = (u16)(opa_drslid & 0x0000ffff);
 
 		/* Check to post send on QP or process locally */
@@ -834,7 +910,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 		     send_wr->pkey_index,
 		     send_wr->port_num, &mad_wc);
 
-	if (opa && smp->base_version == OPA_MGMT_BASE_VERSION) {
+	if (opa_mad && smp->base_version == OPA_MGMT_BASE_VERSION) {
 		mad_wc.byte_len = mad_send_wr->send_buf.hdr_len
 					+ mad_send_wr->send_buf.data_len
 					+ sizeof(struct ib_grh);
@@ -891,7 +967,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	}
 
 	local->mad_send_wr = mad_send_wr;
-	if (opa) {
+	if (opa_mad) {
 		local->mad_send_wr->send_wr.pkey_index = out_mad_pkey_index;
 		local->return_wc_byte_len = mad_size;
 	}
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index e6293338dfb1..0d4fa0cdf0ab 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -333,4 +333,18 @@ static inline struct net_device *rdma_vlan_dev_real_dev(const struct net_device
 		vlan_dev_real_dev(dev) : NULL;
 }
 
+/**
+ * ib_is_opa_gid: Returns true if the top 24 bits of the gid
+ * contains the OPA_STL_OUI identifier. This identifies that
+ * the provided gid is a special purpose GID meant to carry
+ * extended LID information.
+ *
+ * @gid: The Global identifier
+ */
+static inline bool ib_is_opa_gid(union ib_gid *gid)
+{
+	return ((be64_to_cpu(gid->global.interface_id) >> 40) ==
+		OPA_STL_OUI);
+}
+
 #endif /* IB_ADDR_H */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
