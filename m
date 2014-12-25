From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/6] RDMA/ocrdma: populate GID table as per RoCE-v2 spec
Date: Thu, 25 Dec 2014 06:29:23 +0530
Message-ID: <3a2ec7eb-b220-4a8f-b419-1af93187d769@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Somnath kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

As per the RoCE-v2 specification this patch introduces
following changes:

1. Ecah port consumes 2 gid table entries. first entry will be
   of RoCE-v1 type and second entry will be of RoCE-v2 type.
   GID entry of v1 type is used for non-routable traffic, while
   GID entry of v2 type is used for routable traffic.

2. In case IPv6 address is assigned another 2 entries are
   consumed as per point 1.

3. A new hook from IB stack to query GID type is implemented.

4. A flag to report RoCE-v2 capability in port-capability-mask.
5. A new driver hook to report Port Type is added.

Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |    3 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  115 +++++++++++++++++++--------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   12 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   23 +++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |    2 +
 6 files changed, 123 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 4dcec05..fbaee9d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -99,6 +99,7 @@ struct ocrdma_dev_attr {
 	u8 local_ca_ack_delay;
 	u8 ird;
 	u8 num_ird_pages;
+	u8 roce_flags;
 };
 
 struct ocrdma_dma_mem {
@@ -231,7 +232,8 @@ struct ocrdma_dev {
 	u16 base_eqid;
 	u16 max_eq;
 
-	union ib_gid *sgid_tbl;
+	struct ib_gid_entry *sgid_tbl;
+	u32 gid_tblsz;
 	/* provided synchronization to sgid table for
 	 * updating gid entries triggered by notifier.
 	 */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 6e58f39..473c615 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1112,6 +1112,9 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->local_ca_ack_delay = (rsp->max_pd_ca_ack_delay &
 				    OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_SHIFT;
+	attr->roce_flags = (rsp->max_pd_ca_ack_delay &
+				OCRDMA_MBX_QUERY_CFG_L3_TYPE_MASK) >>
+				OCRDMA_MBX_QUERY_CFG_L3_TYPE_SHIFT;
 	attr->max_mw = rsp->max_mw;
 	attr->max_mr = rsp->max_mr;
 	attr->max_mr_size = ((u64)rsp->max_mr_size_hi << 32) |
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 3dd5ba7..34e9c1d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -51,8 +51,6 @@ static LIST_HEAD(ocrdma_dev_list);
 static DEFINE_SPINLOCK(ocrdma_devlist_lock);
 static DEFINE_IDR(ocrdma_dev_id);
 
-static union ib_gid ocrdma_zero_sgid;
-
 void ocrdma_get_guid(struct ocrdma_dev *dev, u8 *guid)
 {
 	u8 mac_addr[6];
@@ -68,25 +66,22 @@ void ocrdma_get_guid(struct ocrdma_dev *dev, u8 *guid)
 	guid[7] = mac_addr[5];
 }
 
-static bool ocrdma_add_sgid(struct ocrdma_dev *dev, union ib_gid *new_sgid)
+static bool ocrdma_add_sgid(struct ocrdma_dev *dev,
+			    struct ib_gid_entry *new_gid_entry)
 {
 	int i;
 	unsigned long flags;
 
-	memset(&ocrdma_zero_sgid, 0, sizeof(union ib_gid));
-
-
 	spin_lock_irqsave(&dev->sgid_lock, flags);
-	for (i = 0; i < OCRDMA_MAX_SGID; i++) {
-		if (!memcmp(&dev->sgid_tbl[i], &ocrdma_zero_sgid,
-			    sizeof(union ib_gid))) {
+	for (i = 0; i < dev->gid_tblsz; i++) {
+		if (is_zero_gid_value(&dev->sgid_tbl[i].gid)) {
 			/* found free entry */
-			memcpy(&dev->sgid_tbl[i], new_sgid,
+			memcpy(&dev->sgid_tbl[i].gid, &new_gid_entry->gid,
 			       sizeof(union ib_gid));
+			dev->sgid_tbl[i].gid_type = new_gid_entry->gid_type;
 			spin_unlock_irqrestore(&dev->sgid_lock, flags);
 			return true;
-		} else if (!memcmp(&dev->sgid_tbl[i], new_sgid,
-				   sizeof(union ib_gid))) {
+		} else if (gid_entry_equal(&dev->sgid_tbl[i], new_gid_entry)) {
 			/* entry already present, no addition is required. */
 			spin_unlock_irqrestore(&dev->sgid_lock, flags);
 			return false;
@@ -96,19 +91,21 @@ static bool ocrdma_add_sgid(struct ocrdma_dev *dev, union ib_gid *new_sgid)
 	return false;
 }
 
-static bool ocrdma_del_sgid(struct ocrdma_dev *dev, union ib_gid *sgid)
+static bool ocrdma_del_sgid(struct ocrdma_dev *dev,
+			    struct ib_gid_entry *gid_entry)
 {
 	int found = false;
 	int i;
 	unsigned long flags;
 
-
 	spin_lock_irqsave(&dev->sgid_lock, flags);
 	/* first is default sgid, which cannot be deleted. */
-	for (i = 1; i < OCRDMA_MAX_SGID; i++) {
-		if (!memcmp(&dev->sgid_tbl[i], sgid, sizeof(union ib_gid))) {
+	for (i = 1; i < dev->gid_tblsz; i++) {
+		if (gid_entry_equal(&dev->sgid_tbl[i], gid_entry)) {
 			/* found matching entry */
-			memset(&dev->sgid_tbl[i], 0, sizeof(union ib_gid));
+			memset(&dev->sgid_tbl[i].gid, 0,
+			       sizeof(dev->sgid_tbl[i].gid));
+			dev->sgid_tbl[i].gid_type = 0;
 			found = true;
 			break;
 		}
@@ -118,7 +115,7 @@ static bool ocrdma_del_sgid(struct ocrdma_dev *dev, union ib_gid *sgid)
 }
 
 static int ocrdma_addr_event(unsigned long event, struct net_device *netdev,
-			     union ib_gid *gid)
+			     struct ib_gid_entry *gid_entry)
 {
 	struct ib_event gid_event;
 	struct ocrdma_dev *dev;
@@ -142,13 +139,25 @@ static int ocrdma_addr_event(unsigned long event, struct net_device *netdev,
 	if (!found)
 		return NOTIFY_DONE;
 
+	if (gid_entry->gid_type == GID_TYPE_RoCE_V2 &&
+	    /* is IPv4 type */
+	    ipv6_addr_v4mapped((struct in6_addr *)&gid_entry->gid) &&
+	    !(dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV4))
+		return NOTIFY_DONE;
+
+	if (gid_entry->gid_type == GID_TYPE_RoCE_V2 &&
+	    /* is IPv6 type */
+	    !ipv6_addr_v4mapped((struct in6_addr *)&gid_entry->gid) &&
+	    !(dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV6))
+		return NOTIFY_DONE;
+
 	mutex_lock(&dev->dev_lock);
 	switch (event) {
 	case NETDEV_UP:
-		updated = ocrdma_add_sgid(dev, gid);
+		updated = ocrdma_add_sgid(dev, gid_entry);
 		break;
 	case NETDEV_DOWN:
-		updated = ocrdma_del_sgid(dev, gid);
+		updated = ocrdma_del_sgid(dev, gid_entry);
 		break;
 	default:
 		break;
@@ -168,11 +177,15 @@ static int ocrdma_inetaddr_event(struct notifier_block *notifier,
 				  unsigned long event, void *ptr)
 {
 	struct in_ifaddr *ifa = ptr;
-	union ib_gid gid;
+	struct ib_gid_entry gid_entry;
 	struct net_device *netdev = ifa->ifa_dev->dev;
 
-	ipv6_addr_set_v4mapped(ifa->ifa_address, (struct in6_addr *)&gid);
-	return ocrdma_addr_event(event, netdev, &gid);
+	ipv6_addr_set_v4mapped(ifa->ifa_address,
+			       (struct in6_addr *)&gid_entry.gid);
+	gid_entry.gid_type = GID_TYPE_V1;
+	ocrdma_addr_event(event, netdev, &gid_entry);
+	gid_entry.gid_type = GID_TYPE_RoCE_V2;
+	return ocrdma_addr_event(event, netdev, &gid_entry);
 }
 
 static struct notifier_block ocrdma_inetaddr_notifier = {
@@ -185,9 +198,15 @@ static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 				  unsigned long event, void *ptr)
 {
 	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
-	union  ib_gid *gid = (union ib_gid *)&ifa->addr;
+	struct  ib_gid_entry gid_entry;
+	union  ib_gid *gid = &gid_entry.gid;
 	struct net_device *netdev = ifa->idev->dev;
-	return ocrdma_addr_event(event, netdev, gid);
+
+	gid = (union ib_gid *)&ifa->addr;
+	gid_entry.gid_type = GID_TYPE_V1;
+	ocrdma_addr_event(event, netdev, &gid_entry);
+	gid_entry.gid_type = GID_TYPE_RoCE_V2;
+	return ocrdma_addr_event(event, netdev, &gid_entry);
 }
 
 static struct notifier_block ocrdma_inet6addr_notifier = {
@@ -196,6 +215,16 @@ static struct notifier_block ocrdma_inet6addr_notifier = {
 
 #endif /* IPV6 and VLAN */
 
+static enum ib_port_type ocrdma_get_port_type(struct ib_device *device,
+					      u8 port_num)
+{
+	struct ocrdma_dev *dev = get_ocrdma_dev(device);
+
+	return (dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV4 ||
+		dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV6) ?
+		IB_PORT_TYPE_RoCEV2 : IB_PORT_TYPE_V1;
+}
+
 static enum rdma_link_layer ocrdma_link_layer(struct ib_device *device,
 					      u8 port_num)
 {
@@ -246,7 +275,9 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	dev->ibdev.query_port = ocrdma_query_port;
 	dev->ibdev.modify_port = ocrdma_modify_port;
 	dev->ibdev.query_gid = ocrdma_query_gid;
+	dev->ibdev.query_gid_type = ocrdma_query_gid_type;
 	dev->ibdev.get_link_layer = ocrdma_link_layer;
+	dev->ibdev.get_port_type = ocrdma_get_port_type;
 	dev->ibdev.alloc_pd = ocrdma_alloc_pd;
 	dev->ibdev.dealloc_pd = ocrdma_dealloc_pd;
 
@@ -306,11 +337,19 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 
 static int ocrdma_alloc_resources(struct ocrdma_dev *dev)
 {
+	int tblsz = OCRDMA_MAX_SGID;
+
+	if (dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV4 ||
+	    dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV6)
+		tblsz *= 2;
+
 	mutex_init(&dev->dev_lock);
-	dev->sgid_tbl = kzalloc(sizeof(union ib_gid) *
-				OCRDMA_MAX_SGID, GFP_KERNEL);
+	dev->sgid_tbl = kzalloc(sizeof(struct ib_gid_entry) *
+				tblsz, GFP_KERNEL);
 	if (!dev->sgid_tbl)
 		goto alloc_err;
+	dev->gid_tblsz = tblsz;
+
 	spin_lock_init(&dev->sgid_lock);
 
 	dev->cq_tbl = kzalloc(sizeof(struct ocrdma_cq *) *
@@ -393,23 +432,30 @@ static void ocrdma_remove_sysfiles(struct ocrdma_dev *dev)
 static void ocrdma_add_default_sgid(struct ocrdma_dev *dev)
 {
 	/* GID Index 0 - Invariant manufacturer-assigned EUI-64 */
-	union ib_gid *sgid = &dev->sgid_tbl[0];
+	struct ib_gid_entry *sgid_entry = &dev->sgid_tbl[0];
+	union ib_gid *sgid = &sgid_entry->gid;
 
 	sgid->global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
 	ocrdma_get_guid(dev, &sgid->raw[8]);
+	sgid_entry->gid_type = GID_TYPE_V1;
 }
 
 static void ocrdma_init_ipv4_gids(struct ocrdma_dev *dev,
 				  struct net_device *net)
 {
+	struct ib_gid_entry gid_entry;
 	struct in_device *in_dev;
-	union ib_gid gid;
+
 	in_dev = in_dev_get(net);
 	if (in_dev) {
 		for_ifa(in_dev) {
 			ipv6_addr_set_v4mapped(ifa->ifa_address,
-					       (struct in6_addr *)&gid);
-			ocrdma_add_sgid(dev, &gid);
+					       (struct in6_addr *)
+					       &gid_entry.gid);
+			gid_entry.gid_type = GID_TYPE_V1;
+			ocrdma_add_sgid(dev, &gid_entry);
+			gid_entry.gid_type = GID_TYPE_RoCE_V2;
+			ocrdma_add_sgid(dev, &gid_entry);
 		}
 		endfor_ifa(in_dev);
 		in_dev_put(in_dev);
@@ -420,6 +466,7 @@ static void ocrdma_init_ipv6_gids(struct ocrdma_dev *dev,
 				  struct net_device *net)
 {
 #if IS_ENABLED(CONFIG_IPV6)
+	struct ib_gid_entry gid_entry;
 	struct inet6_dev *in6_dev;
 	union ib_gid  *pgid;
 	struct inet6_ifaddr *ifp;
@@ -428,7 +475,11 @@ static void ocrdma_init_ipv6_gids(struct ocrdma_dev *dev,
 		read_lock_bh(&in6_dev->lock);
 		list_for_each_entry(ifp, &in6_dev->addr_list, if_list) {
 			pgid = (union ib_gid *)&ifp->addr;
-			ocrdma_add_sgid(dev, pgid);
+			gid_entry.gid = *pgid;
+			gid_entry.gid_type = GID_TYPE_V1;
+			ocrdma_add_sgid(dev, &gid_entry);
+			gid_entry.gid_type = GID_TYPE_RoCE_V2;
+			ocrdma_add_sgid(dev, &gid_entry);
 		}
 		read_unlock_bh(&in6_dev->lock);
 		in6_dev_put(in6_dev);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 243c87c..d75f0cd 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -125,6 +125,12 @@ enum {
 	OCRDMA_DB_RQ_SHIFT		= 24
 };
 
+enum {
+	OCRDMA_L3_TYPE_IB_GRH   = 0x00,
+	OCRDMA_L3_TYPE_IPV4     = 0x01,
+	OCRDMA_L3_TYPE_IPV6     = 0x02
+};
+
 #define OCRDMA_DB_CQ_RING_ID_MASK       0x3FF	/* bits 0 - 9 */
 #define OCRDMA_DB_CQ_RING_ID_EXT_MASK  0x0C00	/* bits 10-11 of qid at 12-11 */
 /* qid #2 msbits at 12-11 */
@@ -488,7 +494,9 @@ enum {
 	OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_SHIFT		= 8,
 	OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_MASK		= 0xFF <<
 				OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_SHIFT,
-
+	OCRDMA_MBX_QUERY_CFG_L3_TYPE_SHIFT		 = 0,
+	OCRDMA_MBX_QUERY_CFG_L3_TYPE_MASK		= 0xFF <<
+				OCRDMA_MBX_QUERY_CFG_L3_TYPE_SHIFT,
 	OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_SHIFT		= 0,
 	OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_MASK		= 0xFFFF,
 	OCRDMA_MBX_QUERY_CFG_MAX_WRITE_SGE_SHIFT	= 16,
@@ -1049,6 +1057,8 @@ enum {
 	OCRDMA_QP_PARAMS_STATE_MASK		= BIT(5) | BIT(6) | BIT(7),
 	OCRDMA_QP_PARAMS_FLAGS_SQD_ASYNC	= BIT(8),
 	OCRDMA_QP_PARAMS_FLAGS_INB_ATEN		= BIT(9),
+	OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_SHIFT	= 11,
+	OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_MASK	= BIT(11) | BIT(12) | BIT(13),
 	OCRDMA_QP_PARAMS_MAX_SGE_RECV_SHIFT	= 16,
 	OCRDMA_QP_PARAMS_MAX_SGE_RECV_MASK	= 0xFFFF <<
 					OCRDMA_QP_PARAMS_MAX_SGE_RECV_SHIFT,
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 5732a63..c6298f1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -53,7 +53,7 @@ int ocrdma_query_gid(struct ib_device *ibdev, u8 port,
 
 	dev = get_ocrdma_dev(ibdev);
 	memset(sgid, 0, sizeof(*sgid));
-	if (index > OCRDMA_MAX_SGID)
+	if (index > dev->gid_tblsz)
 		return -EINVAL;
 
 	memcpy(sgid, &dev->sgid_tbl[index], sizeof(*sgid));
@@ -61,6 +61,21 @@ int ocrdma_query_gid(struct ib_device *ibdev, u8 port,
 	return 0;
 }
 
+int ocrdma_query_gid_type(struct ib_device *ibdev, u8 port,
+			  int index, u8 *gid_type)
+{
+	struct ocrdma_dev *dev;
+
+	dev = get_ocrdma_dev(ibdev);
+	if (index > dev->gid_tblsz)
+		return -EINVAL;
+
+	if (gid_type)
+		*gid_type = dev->sgid_tbl[index].gid_type;
+
+	return 0;
+}
+
 int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 {
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibdev);
@@ -176,7 +191,11 @@ int ocrdma_query_port(struct ib_device *ibdev,
 	    IB_PORT_CM_SUP |
 	    IB_PORT_REINIT_SUP |
 	    IB_PORT_DEVICE_MGMT_SUP | IB_PORT_VENDOR_CLASS_SUP | IB_PORT_IP_BASED_GIDS;
-	props->gid_tbl_len = OCRDMA_MAX_SGID;
+	if (dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV4 ||
+	    dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV6)
+		props->port_cap_flags |= IB_PORT_RoCEV2_BASED_GIDS;
+
+	props->gid_tbl_len = dev->gid_tblsz;
 	props->pkey_tbl_len = 1;
 	props->bad_pkey_cntr = 0;
 	props->qkey_viol_cntr = 0;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index b8f7853..ee90d30 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -38,6 +38,8 @@ int ocrdma_arm_cq(struct ib_cq *, enum ib_cq_notify_flags flags);
 
 int ocrdma_query_device(struct ib_device *, struct ib_device_attr *props);
 int ocrdma_query_port(struct ib_device *, u8 port, struct ib_port_attr *props);
+int ocrdma_query_gid_type(struct ib_device *, u8 port,
+			  int index, u8 *gid_type);
 int ocrdma_modify_port(struct ib_device *, u8 port, int mask,
 		       struct ib_port_modify *props);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
