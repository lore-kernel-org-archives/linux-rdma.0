From: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] IB/core,rdmavt,hfi1,opa-vnic: Send OPA cap_mask3 in trap
Date: Thu,  1 Jun 2017 17:04:02 -0700
Message-ID: <1496361842-58389-1-git-send-email-niranjana.vishwanathapura@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "Michael N. Henry" <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Provide the ability for IB clients to modify the OPA specific
capability mask and include this mask in the subsequent trap data.

Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael N. Henry <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c                |  7 ++-----
 drivers/infiniband/hw/hfi1/mad.h                |  2 +-
 drivers/infiniband/hw/hfi1/verbs.c              |  6 +++++-
 drivers/infiniband/sw/rdmavt/vt.c               |  9 +++++++--
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c | 27 ++++++++++++++++++++++++-
 include/rdma/ib_verbs.h                         |  3 ++-
 include/rdma/rdma_vt.h                          |  1 +
 7 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 5977673..70831ad 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -260,6 +260,7 @@ void hfi1_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num)
 	data.issuer_lid = cpu_to_be32(lid);
 	data.ntc_144.lid = data.issuer_lid;
 	data.ntc_144.new_cap_mask = cpu_to_be32(ibp->rvp.port_cap_flags);
+	data.ntc_144.cap_mask3 = cpu_to_be16(ibp->rvp.port_cap3_flags);
 
 	send_trap(ibp, &data, sizeof(data));
 }
@@ -704,11 +705,7 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	buffer_units |= (dd->vl15_init << 11) & OPA_PI_MASK_BUF_UNIT_VL15_INIT;
 	pi->buffer_units = cpu_to_be32(buffer_units);
 
-	pi->opa_cap_mask = cpu_to_be16(OPA_CAP_MASK3_IsSharedSpaceSupported |
-				       OPA_CAP_MASK3_IsEthOnFabricSupported);
-	/* Driver does not support mcast/collective configuration */
-	pi->opa_cap_mask &=
-		cpu_to_be16(~OPA_CAP_MASK3_IsAddrRangeConfigSupported);
+	pi->opa_cap_mask = cpu_to_be16(ibp->rvp.port_cap3_flags);
 	pi->collectivemask_multicastmask = ((HFI1_COLLECTIVE_NR & 0x7)
 					    << 3 | (HFI1_MCAST_NR & 0x7));
 
diff --git a/drivers/infiniband/hw/hfi1/mad.h b/drivers/infiniband/hw/hfi1/mad.h
index 5aa3fd1..a4e2506 100644
--- a/drivers/infiniband/hw/hfi1/mad.h
+++ b/drivers/infiniband/hw/hfi1/mad.h
@@ -115,7 +115,7 @@ struct opa_mad_notice_attr {
 			__be32	lid;		/* LID where change occurred */
 			__be32	new_cap_mask;	/* new capability mask */
 			__be16	reserved2;
-			__be16	cap_mask;
+			__be16	cap_mask3;
 			__be16	change_flags;	/* low 4 bits only */
 		} __packed ntc_144;
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 90e7b77..322c70f 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1551,9 +1551,13 @@ static void init_ibport(struct hfi1_pportdata *ppd)
 	/* Set the prefix to the default value (see ch. 4.1.1) */
 	ibp->rvp.gid_prefix = IB_DEFAULT_GID_PREFIX;
 	ibp->rvp.sm_lid = 0;
-	/* Below should only set bits defined in OPA PortInfo.CapabilityMask */
+	/*
+	 * Below should only set bits defined in OPA PortInfo.CapabilityMask
+	 * and PortInfo.CapabilityMask3
+	 */
 	ibp->rvp.port_cap_flags = IB_PORT_AUTO_MIGR_SUP |
 		IB_PORT_CAP_MASK_NOTICE_SUP;
+	ibp->rvp.port_cap3_flags = OPA_CAP_MASK3_IsSharedSpaceSupported;
 	ibp->rvp.pma_counter_select[0] = IB_PMA_PORT_XMIT_DATA;
 	ibp->rvp.pma_counter_select[1] = IB_PMA_PORT_RCV_DATA;
 	ibp->rvp.pma_counter_select[2] = IB_PMA_PORT_XMIT_PKTS;
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 0d7c6bb..64bdd44 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -202,8 +202,13 @@ static int rvt_modify_port(struct ib_device *ibdev, u8 port_num,
 		return -EINVAL;
 
 	rvp = rdi->ports[port_index];
-	rvp->port_cap_flags |= props->set_port_cap_mask;
-	rvp->port_cap_flags &= ~props->clr_port_cap_mask;
+	if (port_modify_mask & IB_PORT_OPA_MASK_CHG) {
+		rvp->port_cap3_flags |= props->set_port_cap_mask;
+		rvp->port_cap3_flags &= ~props->clr_port_cap_mask;
+	} else {
+		rvp->port_cap_flags |= props->set_port_cap_mask;
+		rvp->port_cap_flags &= ~props->clr_port_cap_mask;
+	}
 
 	if (props->set_port_cap_mask || props->clr_port_cap_mask)
 		rdi->driver_f.cap_mask_chg(rdi, port_num);
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index 875694f..32cdd7a 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -52,7 +52,9 @@
 
 #include <linux/module.h>
 #include <rdma/ib_addr.h>
-#include <rdma/ib_smi.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/opa_smi.h>
+#include <rdma/opa_port_info.h>
 
 #include "opa_vnic_internal.h"
 
@@ -980,6 +982,27 @@ static int vema_register(struct opa_vnic_ctrl_port *cport)
 }
 
 /**
+ * opa_vnic_ctrl_config_dev -- This function sends a trap to the EM
+ * by way of ib_modify_port to indicate support for ethernet on the
+ * fabric.
+ * @cport: pointer to control port
+ * @en: enable or disable ethernet on fabric support
+ */
+static void opa_vnic_ctrl_config_dev(struct opa_vnic_ctrl_port *cport, bool en)
+{
+	struct ib_port_modify pm = { 0 };
+	int i;
+
+	if (en)
+		pm.set_port_cap_mask = OPA_CAP_MASK3_IsEthOnFabricSupported;
+	else
+		pm.clr_port_cap_mask = OPA_CAP_MASK3_IsEthOnFabricSupported;
+
+	for (i = 1; i <= cport->num_ports; i++)
+		ib_modify_port(cport->ibdev, i, IB_PORT_OPA_MASK_CHG, &pm);
+}
+
+/**
  * opa_vnic_vema_add_one -- Handle new ib device
  * @device: ib device pointer
  *
@@ -1007,6 +1030,7 @@ static void opa_vnic_vema_add_one(struct ib_device *device)
 		c_info("VNIC client initialized\n");
 
 	ib_set_client_data(device, &opa_vnic_client, cport);
+	opa_vnic_ctrl_config_dev(cport, true);
 }
 
 /**
@@ -1025,6 +1049,7 @@ static void opa_vnic_vema_rem_one(struct ib_device *device,
 		return;
 
 	c_info("removing VNIC client\n");
+	opa_vnic_ctrl_config_dev(cport, false);
 	vema_unregister(cport);
 	kfree(cport);
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ba8314e..317bbad 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -577,7 +577,8 @@ struct ib_device_modify {
 enum ib_port_modify_flags {
 	IB_PORT_SHUTDOWN		= 1,
 	IB_PORT_INIT_TYPE		= (1<<2),
-	IB_PORT_RESET_QKEY_CNTR		= (1<<3)
+	IB_PORT_RESET_QKEY_CNTR		= (1<<3),
+	IB_PORT_OPA_MASK_CHG		= (1<<4)
 };
 
 struct ib_port_modify {
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 4878aaf..9e51302 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -75,6 +75,7 @@ struct rvt_ibport {
 	__be64 mkey;
 	u64 tid;
 	u32 port_cap_flags;
+	u16 port_cap3_flags;
 	u32 pma_sample_start;
 	u32 pma_sample_interval;
 	__be16 pma_counter_select[5];
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
