From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/12] IB/hfi1: Unify access to GUID entries
Date: Mon, 17 Oct 2016 04:19:30 -0700
Message-ID: <20161017111929.7934.31847.stgit@scvm10.sc.intel.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017103326.7934.21558.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch consolidates the node GUIDs and the port GUID handling
and unifies access to these items. The knowledge of hfi1 GUIDs'
design and their location are kept in accessors to centralize access.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c  |    4 ++--
 drivers/infiniband/hw/hfi1/hfi.h   |   19 +++++++++++++++++--
 drivers/infiniband/hw/hfi1/mad.c   |   19 ++++++++++---------
 drivers/infiniband/hw/hfi1/ruc.c   |   16 +++-------------
 drivers/infiniband/hw/hfi1/verbs.c |   15 +++++++--------
 drivers/infiniband/hw/hfi1/verbs.h |    3 ---
 6 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 7992152..a0f05d7 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9567,11 +9567,11 @@ int bringup_serdes(struct hfi1_pportdata *ppd)
 	if (HFI1_CAP_IS_KSET(EXTENDED_PSN))
 		add_rcvctrl(dd, RCV_CTRL_RCV_EXTENDED_PSN_ENABLE_SMASK);
 
-	guid = ppd->guid;
+	guid = ppd->guids[HFI1_PORT_GUID_INDEX];
 	if (!guid) {
 		if (dd->base_guid)
 			guid = dd->base_guid + ppd->port - 1;
-		ppd->guid = guid;
+		ppd->guids[HFI1_PORT_GUID_INDEX] = guid;
 	}
 
 	/* Set linkinit_reason on power up per OPA spec */
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 368e96c..87847cc 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -512,6 +512,9 @@ struct rvt_sge_state;
 #define HFI1_MIN_VLS_SUPPORTED 1
 #define HFI1_MAX_VLS_SUPPORTED 8
 
+#define HFI1_GUIDS_PER_PORT  5
+#define HFI1_PORT_GUID_INDEX 0
+
 static inline void incr_cntr64(u64 *cntr)
 {
 	if (*cntr < (u64)-1LL)
@@ -582,8 +585,9 @@ struct hfi1_pportdata {
 	u32 port_type;
 	struct qsfp_data qsfp_info;
 
-	/* GUID for this interface, in host order */
-	u64 guid;
+	/* GUIDs for this interface, in host order, guids[0] is a port guid */
+	u64 guids[HFI1_GUIDS_PER_PORT];
+
 	/* GUID for peer interface, in host order */
 	u64 neighbor_guid;
 
@@ -1637,6 +1641,17 @@ static inline u16 hfi1_get_pkey(struct hfi1_ibport *ibp, unsigned index)
 }
 
 /*
+ * Return the indexed GUID from the port GUIDs table.
+ */
+static inline __be64 get_sguid(struct hfi1_ibport *ibp, unsigned int index)
+{
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+
+	WARN_ON(index >= HFI1_GUIDS_PER_PORT);
+	return cpu_to_be64(ppd->guids[index]);
+}
+
+/*
  * Called by readers of cc_state only, must call under rcu_read_lock().
  */
 static inline struct cc_state *get_cc_state(struct hfi1_pportdata *ppd)
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 9487c9b..0ef62e6 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -336,20 +336,20 @@ static int __subn_get_opa_nodeinfo(struct opa_smp *smp, u32 am, u8 *data,
 	ni = (struct opa_node_info *)data;
 
 	/* GUID 0 is illegal */
-	if (am || pidx >= dd->num_pports || dd->pport[pidx].guid == 0) {
+	if (am || pidx >= dd->num_pports || ibdev->node_guid == 0 ||
+	    get_sguid(to_iport(ibdev, port), HFI1_PORT_GUID_INDEX) == 0) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)smp);
 	}
 
-	ni->port_guid = cpu_to_be64(dd->pport[pidx].guid);
+	ni->port_guid = get_sguid(to_iport(ibdev, port), HFI1_PORT_GUID_INDEX);
 	ni->base_version = OPA_MGMT_BASE_VERSION;
 	ni->class_version = OPA_SMI_CLASS_VERSION;
 	ni->node_type = 1;     /* channel adapter */
 	ni->num_ports = ibdev->phys_port_cnt;
 	/* This is already in network order */
 	ni->system_image_guid = ib_hfi1_sys_image_guid;
-	/* Use first-port GUID as node */
-	ni->node_guid = cpu_to_be64(dd->pport->guid);
+	ni->node_guid = ibdev->node_guid;
 	ni->partition_cap = cpu_to_be16(hfi1_get_npkeys(dd));
 	ni->device_id = cpu_to_be16(dd->pcidev->device);
 	ni->revision = cpu_to_be32(dd->minrev);
@@ -373,19 +373,20 @@ static int subn_get_nodeinfo(struct ib_smp *smp, struct ib_device *ibdev,
 
 	/* GUID 0 is illegal */
 	if (smp->attr_mod || pidx >= dd->num_pports ||
-	    dd->pport[pidx].guid == 0)
+	    ibdev->node_guid == 0 ||
+	    get_sguid(to_iport(ibdev, port), HFI1_PORT_GUID_INDEX) == 0) {
 		smp->status |= IB_SMP_INVALID_FIELD;
-	else
-		nip->port_guid = cpu_to_be64(dd->pport[pidx].guid);
+		return reply((struct ib_mad_hdr *)smp);
+	}
 
+	nip->port_guid = get_sguid(to_iport(ibdev, port), HFI1_PORT_GUID_INDEX);
 	nip->base_version = OPA_MGMT_BASE_VERSION;
 	nip->class_version = OPA_SMI_CLASS_VERSION;
 	nip->node_type = 1;     /* channel adapter */
 	nip->num_ports = ibdev->phys_port_cnt;
 	/* This is already in network order */
 	nip->sys_guid = ib_hfi1_sys_image_guid;
-	 /* Use first-port GUID as node */
-	nip->node_guid = cpu_to_be64(dd->pport->guid);
+	nip->node_guid = ibdev->node_guid;
 	nip->partition_cap = cpu_to_be16(hfi1_get_npkeys(dd));
 	nip->device_id = cpu_to_be16(dd->pcidev->device);
 	nip->revision = cpu_to_be32(dd->minrev);
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index a1576ae..5a70e91 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -239,16 +239,6 @@ bail:
 	return ret;
 }
 
-static __be64 get_sguid(struct hfi1_ibport *ibp, unsigned index)
-{
-	if (!index) {
-		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-
-		return cpu_to_be64(ppd->guid);
-	}
-	return ibp->guids[index - 1];
-}
-
 static int gid_ok(union ib_gid *gid, __be64 gid_prefix, __be64 id)
 {
 	return (gid->global.interface_id == id &&
@@ -699,9 +689,9 @@ u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
 	/* The SGID is 32-bit aligned. */
 	hdr->sgid.global.subnet_prefix = ibp->rvp.gid_prefix;
 	hdr->sgid.global.interface_id =
-		grh->sgid_index && grh->sgid_index < ARRAY_SIZE(ibp->guids) ?
-		ibp->guids[grh->sgid_index - 1] :
-			cpu_to_be64(ppd_from_ibp(ibp)->guid);
+		grh->sgid_index < HFI1_GUIDS_PER_PORT ?
+		get_sguid(ibp, grh->sgid_index) :
+		get_sguid(ibp, HFI1_PORT_GUID_INDEX);
 	hdr->dgid = grh->dgid;
 
 	/* GRH header size in 32-bit words. */
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 9c3c237..6d8e37f 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1485,15 +1485,11 @@ static int hfi1_get_guid_be(struct rvt_dev_info *rdi, struct rvt_ibport *rvp,
 			    int guid_index, __be64 *guid)
 {
 	struct hfi1_ibport *ibp = container_of(rvp, struct hfi1_ibport, rvp);
-	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 
-	if (guid_index == 0)
-		*guid = cpu_to_be64(ppd->guid);
-	else if (guid_index < HFI1_GUIDS_PER_PORT)
-		*guid = ibp->guids[guid_index - 1];
-	else
+	if (guid_index >= HFI1_GUIDS_PER_PORT)
 		return -EINVAL;
 
+	*guid = get_sguid(ibp, guid_index);
 	return 0;
 }
 
@@ -1622,6 +1618,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
 	struct ib_device *ibdev = &dev->rdi.ibdev;
 	struct hfi1_pportdata *ppd = dd->pport;
+	struct hfi1_ibport *ibp = &ppd->ibport_data;
 	unsigned i;
 	int ret;
 	size_t lcpysz = IB_DEVICE_NAME_MAX;
@@ -1642,17 +1639,19 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	if (ret)
 		goto err_verbs_txreq;
 
+	/* Use first-port GUID as node guid */
+	ibdev->node_guid = get_sguid(ibp, HFI1_PORT_GUID_INDEX);
+
 	/*
 	 * The system image GUID is supposed to be the same for all
 	 * HFIs in a single system but since there can be other
 	 * device types in the system, we can't be sure this is unique.
 	 */
 	if (!ib_hfi1_sys_image_guid)
-		ib_hfi1_sys_image_guid = cpu_to_be64(ppd->guid);
+		ib_hfi1_sys_image_guid = ibdev->node_guid;
 	lcpysz = strlcpy(ibdev->name, class_name(), lcpysz);
 	strlcpy(ibdev->name + lcpysz, "_%d", IB_DEVICE_NAME_MAX - lcpysz);
 	ibdev->owner = THIS_MODULE;
-	ibdev->node_guid = cpu_to_be64(ppd->guid);
 	ibdev->phys_port_cnt = dd->num_pports;
 	ibdev->dma_device = &dd->pcidev->dev;
 	ibdev->modify_device = modify_device;
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 7a8af39..e6b8930 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -73,7 +73,6 @@ struct hfi1_packet;
 #include "iowait.h"
 
 #define HFI1_MAX_RDMA_ATOMIC     16
-#define HFI1_GUIDS_PER_PORT	5
 
 /*
  * Increment this value if any changes that break userspace ABI
@@ -169,8 +168,6 @@ struct hfi1_ibport {
 	struct rvt_qp __rcu *qp[2];
 	struct rvt_ibport rvp;
 
-	__be64 guids[HFI1_GUIDS_PER_PORT	- 1];	/* writable GUIDs */
-
 	/* the first 16 entries are sl_to_vl for !OPA */
 	u8 sl_to_sc[32];
 	u8 sc_to_sl[32];

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
