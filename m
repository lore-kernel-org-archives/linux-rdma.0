From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V5 12/12] RDMA/ocrdma: Changes in driver to incorporate the moving of GID Table mgmt to IB/Core.
Date: Mon,  8 Jun 2015 17:12:15 +0300
Message-ID: <1433772735-22416-13-git-send-email-matanb@mellanox.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433772735-22416-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

1.Check and set port capability flags to indicate RoCEV2 support.
2.Change query_gid hook to return value from IB/Core GID Mgmt APIs.
3.Get rid of all the netdev notifier chain subscription code as well as
maintenance of SGID Table in memory.
4.Implement get_netdev hook in driver.

Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  10 ++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   3 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 233 +---------------------------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |  13 ++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  31 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |   4 +
 6 files changed, 62 insertions(+), 232 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index c9780d9..ea6484c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -99,6 +99,7 @@ struct ocrdma_dev_attr {
 	u8 local_ca_ack_delay;
 	u8 ird;
 	u8 num_ird_pages;
+	u8 roce_flags;
 };
 
 struct ocrdma_dma_mem {
@@ -574,4 +575,13 @@ static inline u8 ocrdma_is_enabled_and_synced(u32 state)
 		(state & OCRDMA_STATE_FLAG_SYNC);
 }
 
+static inline bool ocrdma_is_rocev2_supported(struct ocrdma_dev *dev)
+{
+	return (dev->attr.roce_flags & (OCRDMA_L3_TYPE_IPV4 <<
+					OCRDMA_ROUDP_FLAGS_SHIFT) ||
+		dev->attr.roce_flags & (OCRDMA_L3_TYPE_IPV6 <<
+					OCRDMA_ROUDP_FLAGS_SHIFT)) ?
+								true : false;
+}
+
 #endif
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 0c9e959..42116a5 100644
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
index f552898..0d3e915 100644
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
@@ -67,135 +65,6 @@ void ocrdma_get_guid(struct ocrdma_dev *dev, u8 *guid)
 	guid[6] = mac_addr[4];
 	guid[7] = mac_addr[5];
 }
-
-static bool ocrdma_add_sgid(struct ocrdma_dev *dev, union ib_gid *new_sgid)
-{
-	int i;
-	unsigned long flags;
-
-	memset(&ocrdma_zero_sgid, 0, sizeof(union ib_gid));
-
-
-	spin_lock_irqsave(&dev->sgid_lock, flags);
-	for (i = 0; i < OCRDMA_MAX_SGID; i++) {
-		if (!memcmp(&dev->sgid_tbl[i], &ocrdma_zero_sgid,
-			    sizeof(union ib_gid))) {
-			/* found free entry */
-			memcpy(&dev->sgid_tbl[i], new_sgid,
-			       sizeof(union ib_gid));
-			spin_unlock_irqrestore(&dev->sgid_lock, flags);
-			return true;
-		} else if (!memcmp(&dev->sgid_tbl[i], new_sgid,
-				   sizeof(union ib_gid))) {
-			/* entry already present, no addition is required. */
-			spin_unlock_irqrestore(&dev->sgid_lock, flags);
-			return false;
-		}
-	}
-	spin_unlock_irqrestore(&dev->sgid_lock, flags);
-	return false;
-}
-
-static bool ocrdma_del_sgid(struct ocrdma_dev *dev, union ib_gid *sgid)
-{
-	int found = false;
-	int i;
-	unsigned long flags;
-
-
-	spin_lock_irqsave(&dev->sgid_lock, flags);
-	/* first is default sgid, which cannot be deleted. */
-	for (i = 1; i < OCRDMA_MAX_SGID; i++) {
-		if (!memcmp(&dev->sgid_tbl[i], sgid, sizeof(union ib_gid))) {
-			/* found matching entry */
-			memset(&dev->sgid_tbl[i], 0, sizeof(union ib_gid));
-			found = true;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&dev->sgid_lock, flags);
-	return found;
-}
-
-static int ocrdma_addr_event(unsigned long event, struct net_device *netdev,
-			     union ib_gid *gid)
-{
-	struct ib_event gid_event;
-	struct ocrdma_dev *dev;
-	bool found = false;
-	bool updated = false;
-	bool is_vlan = false;
-
-	is_vlan = netdev->priv_flags & IFF_802_1Q_VLAN;
-	if (is_vlan)
-		netdev = rdma_vlan_dev_real_dev(netdev);
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(dev, &ocrdma_dev_list, entry) {
-		if (dev->nic_info.netdev == netdev) {
-			found = true;
-			break;
-		}
-	}
-	rcu_read_unlock();
-
-	if (!found)
-		return NOTIFY_DONE;
-
-	mutex_lock(&dev->dev_lock);
-	switch (event) {
-	case NETDEV_UP:
-		updated = ocrdma_add_sgid(dev, gid);
-		break;
-	case NETDEV_DOWN:
-		updated = ocrdma_del_sgid(dev, gid);
-		break;
-	default:
-		break;
-	}
-	if (updated) {
-		/* GID table updated, notify the consumers about it */
-		gid_event.device = &dev->ibdev;
-		gid_event.element.port_num = 1;
-		gid_event.event = IB_EVENT_GID_CHANGE;
-		ib_dispatch_event(&gid_event);
-	}
-	mutex_unlock(&dev->dev_lock);
-	return NOTIFY_OK;
-}
-
-static int ocrdma_inetaddr_event(struct notifier_block *notifier,
-				  unsigned long event, void *ptr)
-{
-	struct in_ifaddr *ifa = ptr;
-	union ib_gid gid;
-	struct net_device *netdev = ifa->ifa_dev->dev;
-
-	ipv6_addr_set_v4mapped(ifa->ifa_address, (struct in6_addr *)&gid);
-	return ocrdma_addr_event(event, netdev, &gid);
-}
-
-static struct notifier_block ocrdma_inetaddr_notifier = {
-	.notifier_call = ocrdma_inetaddr_event
-};
-
-#if IS_ENABLED(CONFIG_IPV6)
-
-static int ocrdma_inet6addr_event(struct notifier_block *notifier,
-				  unsigned long event, void *ptr)
-{
-	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
-	union  ib_gid *gid = (union ib_gid *)&ifa->addr;
-	struct net_device *netdev = ifa->idev->dev;
-	return ocrdma_addr_event(event, netdev, gid);
-}
-
-static struct notifier_block ocrdma_inet6addr_notifier = {
-	.notifier_call = ocrdma_inet6addr_event
-};
-
-#endif /* IPV6 and VLAN */
-
 static enum rdma_link_layer ocrdma_link_layer(struct ib_device *device,
 					      u8 port_num)
 {
@@ -263,6 +132,8 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	dev->ibdev.query_port = ocrdma_query_port;
 	dev->ibdev.modify_port = ocrdma_modify_port;
 	dev->ibdev.query_gid = ocrdma_query_gid;
+	dev->ibdev.get_netdev = ocrdma_get_netdev;
+	dev->ibdev.modify_gid = ocrdma_modify_gid;
 	dev->ibdev.get_link_layer = ocrdma_link_layer;
 	dev->ibdev.alloc_pd = ocrdma_alloc_pd;
 	dev->ibdev.dealloc_pd = ocrdma_dealloc_pd;
@@ -325,12 +196,6 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 static int ocrdma_alloc_resources(struct ocrdma_dev *dev)
 {
 	mutex_init(&dev->dev_lock);
-	dev->sgid_tbl = kzalloc(sizeof(union ib_gid) *
-				OCRDMA_MAX_SGID, GFP_KERNEL);
-	if (!dev->sgid_tbl)
-		goto alloc_err;
-	spin_lock_init(&dev->sgid_lock);
-
 	dev->cq_tbl = kzalloc(sizeof(struct ocrdma_cq *) *
 			      OCRDMA_MAX_CQ, GFP_KERNEL);
 	if (!dev->cq_tbl)
@@ -362,7 +227,6 @@ static void ocrdma_free_resources(struct ocrdma_dev *dev)
 	kfree(dev->stag_arr);
 	kfree(dev->qp_tbl);
 	kfree(dev->cq_tbl);
-	kfree(dev->sgid_tbl);
 }
 
 /* OCRDMA sysfs interface */
@@ -408,68 +272,6 @@ static void ocrdma_remove_sysfiles(struct ocrdma_dev *dev)
 		device_remove_file(&dev->ibdev.dev, ocrdma_attributes[i]);
 }
 
-static void ocrdma_add_default_sgid(struct ocrdma_dev *dev)
-{
-	/* GID Index 0 - Invariant manufacturer-assigned EUI-64 */
-	union ib_gid *sgid = &dev->sgid_tbl[0];
-
-	sgid->global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
-	ocrdma_get_guid(dev, &sgid->raw[8]);
-}
-
-static void ocrdma_init_ipv4_gids(struct ocrdma_dev *dev,
-				  struct net_device *net)
-{
-	struct in_device *in_dev;
-	union ib_gid gid;
-	in_dev = in_dev_get(net);
-	if (in_dev) {
-		for_ifa(in_dev) {
-			ipv6_addr_set_v4mapped(ifa->ifa_address,
-					       (struct in6_addr *)&gid);
-			ocrdma_add_sgid(dev, &gid);
-		}
-		endfor_ifa(in_dev);
-		in_dev_put(in_dev);
-	}
-}
-
-static void ocrdma_init_ipv6_gids(struct ocrdma_dev *dev,
-				  struct net_device *net)
-{
-#if IS_ENABLED(CONFIG_IPV6)
-	struct inet6_dev *in6_dev;
-	union ib_gid  *pgid;
-	struct inet6_ifaddr *ifp;
-	in6_dev = in6_dev_get(net);
-	if (in6_dev) {
-		read_lock_bh(&in6_dev->lock);
-		list_for_each_entry(ifp, &in6_dev->addr_list, if_list) {
-			pgid = (union ib_gid *)&ifp->addr;
-			ocrdma_add_sgid(dev, pgid);
-		}
-		read_unlock_bh(&in6_dev->lock);
-		in6_dev_put(in6_dev);
-	}
-#endif
-}
-
-static void ocrdma_init_gid_table(struct ocrdma_dev *dev)
-{
-	struct  net_device *net_dev;
-
-	for_each_netdev(&init_net, net_dev) {
-		struct net_device *real_dev = rdma_vlan_dev_real_dev(net_dev) ?
-				rdma_vlan_dev_real_dev(net_dev) : net_dev;
-
-		if (real_dev == dev->nic_info.netdev) {
-			ocrdma_add_default_sgid(dev);
-			ocrdma_init_ipv4_gids(dev, net_dev);
-			ocrdma_init_ipv6_gids(dev, net_dev);
-		}
-	}
-}
-
 static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 {
 	int status = 0, i;
@@ -498,7 +300,6 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 		goto alloc_err;
 
 	ocrdma_init_service_level(dev);
-	ocrdma_init_gid_table(dev);
 	status = ocrdma_register_device(dev);
 	if (status)
 		goto alloc_err;
@@ -645,34 +446,12 @@ static struct ocrdma_driver ocrdma_drv = {
 	.be_abi_version		= OCRDMA_BE_ROCE_ABI_VERSION,
 };
 
-static void ocrdma_unregister_inet6addr_notifier(void)
-{
-#if IS_ENABLED(CONFIG_IPV6)
-	unregister_inet6addr_notifier(&ocrdma_inet6addr_notifier);
-#endif
-}
-
-static void ocrdma_unregister_inetaddr_notifier(void)
-{
-	unregister_inetaddr_notifier(&ocrdma_inetaddr_notifier);
-}
-
 static int __init ocrdma_init_module(void)
 {
 	int status;
 
 	ocrdma_init_debugfs();
 
-	status = register_inetaddr_notifier(&ocrdma_inetaddr_notifier);
-	if (status)
-		return status;
-
-#if IS_ENABLED(CONFIG_IPV6)
-	status = register_inet6addr_notifier(&ocrdma_inet6addr_notifier);
-	if (status)
-		goto err_notifier6;
-#endif
-
 	status = be_roce_register_driver(&ocrdma_drv);
 	if (status)
 		goto err_be_reg;
@@ -680,19 +459,13 @@ static int __init ocrdma_init_module(void)
 	return 0;
 
 err_be_reg:
-#if IS_ENABLED(CONFIG_IPV6)
-	ocrdma_unregister_inet6addr_notifier();
-err_notifier6:
-#endif
-	ocrdma_unregister_inetaddr_notifier();
+
 	return status;
 }
 
 static void __exit ocrdma_exit_module(void)
 {
 	be_roce_unregister_driver(&ocrdma_drv);
-	ocrdma_unregister_inet6addr_notifier();
-	ocrdma_unregister_inetaddr_notifier();
 	ocrdma_rem_debugfs();
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 243c87c..6b74eb9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -125,6 +125,14 @@ enum {
 	OCRDMA_DB_RQ_SHIFT		= 24
 };
 
+enum {
+	OCRDMA_L3_TYPE_IB_GRH   = 0x00,
+	OCRDMA_L3_TYPE_IPV4     = 0x01,
+	OCRDMA_L3_TYPE_IPV6     = 0x02
+};
+
+#define OCRDMA_ROUDP_FLAGS_SHIFT	0x03
+
 #define OCRDMA_DB_CQ_RING_ID_MASK       0x3FF	/* bits 0 - 9 */
 #define OCRDMA_DB_CQ_RING_ID_EXT_MASK  0x0C00	/* bits 10-11 of qid at 12-11 */
 /* qid #2 msbits at 12-11 */
@@ -488,6 +496,9 @@ enum {
 	OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_SHIFT		= 8,
 	OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_MASK		= 0xFF <<
 				OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_SHIFT,
+	OCRDMA_MBX_QUERY_CFG_L3_TYPE_SHIFT		 = 0,
+	OCRDMA_MBX_QUERY_CFG_L3_TYPE_MASK		= 0xFF <<
+				OCRDMA_MBX_QUERY_CFG_L3_TYPE_SHIFT,
 
 	OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_SHIFT		= 0,
 	OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_MASK		= 0xFFFF,
@@ -1049,6 +1060,8 @@ enum {
 	OCRDMA_QP_PARAMS_STATE_MASK		= BIT(5) | BIT(6) | BIT(7),
 	OCRDMA_QP_PARAMS_FLAGS_SQD_ASYNC	= BIT(8),
 	OCRDMA_QP_PARAMS_FLAGS_INB_ATEN		= BIT(9),
+	OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_SHIFT	= 11,
+	OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_MASK	= BIT(11) | BIT(12) | BIT(13),
 	OCRDMA_QP_PARAMS_MAX_SGE_RECV_SHIFT	= 16,
 	OCRDMA_QP_PARAMS_MAX_SGE_RECV_MASK	= 0xFFFF <<
 					OCRDMA_QP_PARAMS_MAX_SGE_RECV_SHIFT,
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index cf1f515..f1c4290 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -31,6 +31,7 @@
 #include <rdma/iw_cm.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib_cache.h>
 
 #include "ocrdma.h"
 #include "ocrdma_hw.h"
@@ -49,6 +50,7 @@ int ocrdma_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
 int ocrdma_query_gid(struct ib_device *ibdev, u8 port,
 		     int index, union ib_gid *sgid)
 {
+	int ret;
 	struct ocrdma_dev *dev;
 
 	dev = get_ocrdma_dev(ibdev);
@@ -56,7 +58,22 @@ int ocrdma_query_gid(struct ib_device *ibdev, u8 port,
 	if (index >= OCRDMA_MAX_SGID)
 		return -EINVAL;
 
-	memcpy(sgid, &dev->sgid_tbl[index], sizeof(*sgid));
+	ret = ib_get_cached_gid(ibdev, port, index, sgid);
+	if (ret == -EAGAIN) {
+		memcpy(sgid, &zgid, sizeof(*sgid));
+		return 0;
+	}
+
+	return ret;
+}
+
+int ocrdma_modify_gid(struct ib_device *ibdev, u8 port_num, unsigned int index,
+		      const union ib_gid *gid, const struct ib_gid_attr *attr,
+		      void **context)
+{
+	struct ocrdma_dev *dev;
+
+	dev = get_ocrdma_dev(ibdev);
 
 	return 0;
 }
@@ -106,6 +123,15 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 	return 0;
 }
 
+struct net_device *ocrdma_get_netdev(struct ib_device *ibdev, u8 port_num)
+{
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibdev);
+
+	if (dev)
+		return dev->nic_info.netdev;
+
+	return NULL;
+}
 static inline void get_link_speed_and_width(struct ocrdma_dev *dev,
 					    u8 *ib_speed, u8 *ib_width)
 {
@@ -175,7 +201,8 @@ int ocrdma_query_port(struct ib_device *ibdev,
 	props->port_cap_flags =
 	    IB_PORT_CM_SUP |
 	    IB_PORT_REINIT_SUP |
-	    IB_PORT_DEVICE_MGMT_SUP | IB_PORT_VENDOR_CLASS_SUP | IB_PORT_IP_BASED_GIDS;
+	    IB_PORT_DEVICE_MGMT_SUP | IB_PORT_VENDOR_CLASS_SUP |
+	    IB_PORT_IP_BASED_GIDS | IB_PORT_ROCE;
 	props->gid_tbl_len = OCRDMA_MAX_SGID;
 	props->pkey_tbl_len = 1;
 	props->bad_pkey_cntr = 0;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index 3cdc81e..b24795c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -47,6 +47,10 @@ ocrdma_query_protocol(struct ib_device *device, u8 port_num);
 void ocrdma_get_guid(struct ocrdma_dev *, u8 *guid);
 int ocrdma_query_gid(struct ib_device *, u8 port,
 		     int index, union ib_gid *gid);
+struct net_device *ocrdma_get_netdev(struct ib_device *device, u8 port_num);
+int ocrdma_modify_gid(struct ib_device *ibdev, u8 port_num, unsigned int index,
+		      const union ib_gid *gid, const struct ib_gid_attr *attr,
+		      void **context);
 int ocrdma_query_pkey(struct ib_device *, u8 port, u16 index, u16 *pkey);
 
 struct ib_ucontext *ocrdma_alloc_ucontext(struct ib_device *,
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
