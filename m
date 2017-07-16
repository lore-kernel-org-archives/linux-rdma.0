From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 2/2] IB/core: Add generic function to extract IB speed from netdev
Date: Sun, 16 Jul 2017 22:31:25 +0300
Message-ID: <20170716193125.7560-3-yuval.shaia@oracle.com>
References: <20170716193125.7560-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170716193125.7560-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Logic of retrieving netdev speed from net_device and translating it to
IB speed is implemented in rxe, in usnic and in bnxt drivers.

Define new function which merges all.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c              | 55 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/bnxt_re/ib_verbs.c     | 49 ++-----------------------
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 31 +++-------------
 drivers/infiniband/sw/rxe/rxe_verbs.c        | 53 +++------------------------
 include/rdma/ib_verbs.h                      |  1 +
 5 files changed, 71 insertions(+), 118 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 8ece2aae033d..1f72bfe9129a 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2124,3 +2124,58 @@ void ib_drain_qp(struct ib_qp *qp)
 		ib_drain_rq(qp);
 }
 EXPORT_SYMBOL(ib_drain_qp);
+
+int ib_get_eth_speed(struct ib_device *dev, u8 port_num, u8 *speed, u8 *width)
+{
+	int rc;
+	u32 netdev_speed;
+	struct net_device *netdev;
+	struct ethtool_link_ksettings lksettings;
+
+	if (rdma_port_get_link_layer(dev, port_num) != IB_LINK_LAYER_ETHERNET)
+		return -EINVAL;
+
+	if (!dev->get_netdev)
+		return -EOPNOTSUPP;
+
+	netdev = dev->get_netdev(dev, port_num);
+	if (!netdev)
+		return -ENODEV;
+
+	rtnl_lock();
+	rc = __ethtool_get_link_ksettings(netdev, &lksettings);
+	rtnl_unlock();
+
+	dev_put(netdev);
+
+	if (!rc) {
+		netdev_speed = lksettings.base.speed;
+	} else {
+		netdev_speed = SPEED_1000;
+		pr_warn("%s speed is unknown, defaulting to %d\n", netdev->name,
+			netdev_speed);
+	}
+
+	if (netdev_speed <= SPEED_1000) {
+		*width = IB_WIDTH_1X;
+		*speed = IB_SPEED_SDR;
+	} else if (netdev_speed <= SPEED_10000) {
+		*width = IB_WIDTH_1X;
+		*speed = IB_SPEED_FDR10;
+	} else if (netdev_speed <= SPEED_20000) {
+		*width = IB_WIDTH_4X;
+		*speed = IB_SPEED_DDR;
+	} else if (netdev_speed <= SPEED_25000) {
+		*width = IB_WIDTH_1X;
+		*speed = IB_SPEED_EDR;
+	} else if (netdev_speed <= SPEED_40000) {
+		*width = IB_WIDTH_4X;
+		*speed = IB_SPEED_FDR10;
+	} else {
+		*width = IB_WIDTH_4X;
+		*speed = IB_SPEED_EDR;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ib_get_eth_speed);
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index e1211c822894..6a9cee00d2f8 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -223,50 +223,6 @@ int bnxt_re_modify_device(struct ib_device *ibdev,
 	return 0;
 }
 
-static void __to_ib_speed_width(struct net_device *netdev, u8 *speed, u8 *width)
-{
-	struct ethtool_link_ksettings lksettings;
-	u32 espeed;
-
-	if (netdev->ethtool_ops && netdev->ethtool_ops->get_link_ksettings) {
-		memset(&lksettings, 0, sizeof(lksettings));
-		rtnl_lock();
-		netdev->ethtool_ops->get_link_ksettings(netdev, &lksettings);
-		rtnl_unlock();
-		espeed = lksettings.base.speed;
-	} else {
-		espeed = SPEED_UNKNOWN;
-	}
-	switch (espeed) {
-	case SPEED_1000:
-		*speed = IB_SPEED_SDR;
-		*width = IB_WIDTH_1X;
-		break;
-	case SPEED_10000:
-		*speed = IB_SPEED_QDR;
-		*width = IB_WIDTH_1X;
-		break;
-	case SPEED_20000:
-		*speed = IB_SPEED_DDR;
-		*width = IB_WIDTH_4X;
-		break;
-	case SPEED_25000:
-		*speed = IB_SPEED_EDR;
-		*width = IB_WIDTH_1X;
-		break;
-	case SPEED_40000:
-		*speed = IB_SPEED_QDR;
-		*width = IB_WIDTH_4X;
-		break;
-	case SPEED_50000:
-		break;
-	default:
-		*speed = IB_SPEED_SDR;
-		*width = IB_WIDTH_1X;
-		break;
-	}
-}
-
 /* Port */
 int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
 		       struct ib_port_attr *port_attr)
@@ -308,8 +264,9 @@ int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
 	 * IB stack to avoid race in the NETDEV_UNREG path
 	 */
 	if (test_bit(BNXT_RE_FLAG_IBDEV_REGISTERED, &rdev->flags))
-		__to_ib_speed_width(rdev->netdev, &port_attr->active_speed,
-				    &port_attr->active_width);
+		if (!ib_get_eth_speed(ibdev, port_num, &port_attr->active_speed,
+				      &port_attr->active_width))
+			return -EINVAL;
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index f9dc1e80c3b7..e5f57dd49980 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -226,27 +226,6 @@ static void qp_grp_destroy(struct usnic_ib_qp_grp *qp_grp)
 	spin_unlock(&vf->lock);
 }
 
-static void eth_speed_to_ib_speed(int speed, u8 *active_speed,
-					u8 *active_width)
-{
-	if (speed <= 10000) {
-		*active_width = IB_WIDTH_1X;
-		*active_speed = IB_SPEED_FDR10;
-	} else if (speed <= 20000) {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_DDR;
-	} else if (speed <= 30000) {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_QDR;
-	} else if (speed <= 40000) {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_FDR10;
-	} else {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_EDR;
-	}
-}
-
 static int create_qp_validate_user_data(struct usnic_ib_create_qp_cmd cmd)
 {
 	if (cmd.spec.trans_type <= USNIC_TRANSPORT_UNKNOWN ||
@@ -326,12 +305,16 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 				struct ib_port_attr *props)
 {
 	struct usnic_ib_dev *us_ibdev = to_usdev(ibdev);
-	struct ethtool_link_ksettings cmd;
 
 	usnic_dbg("\n");
 
 	mutex_lock(&us_ibdev->usdev_lock);
-	__ethtool_get_link_ksettings(us_ibdev->netdev, &cmd);
+	if (!ib_get_eth_speed(ibdev, port, &props->active_speed,
+			      &props->active_width)) {
+		mutex_unlock(&us_ibdev->usdev_lock);
+		return -EINVAL;
+	}
+
 	/* props being zeroed by the caller, avoid zeroing it here */
 
 	props->lid = 0;
@@ -355,8 +338,6 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 	props->pkey_tbl_len = 1;
 	props->bad_pkey_cntr = 0;
 	props->qkey_viol_cntr = 0;
-	eth_speed_to_ib_speed(cmd.base.speed, &props->active_speed,
-			      &props->active_width);
 	props->max_mtu = IB_MTU_4096;
 	props->active_mtu = iboe_get_mtu(us_ibdev->ufdev->mtu);
 	/* Userspace will adjust for hdrs */
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 07511718d98d..c2358a66e4db 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -51,40 +51,16 @@ static int rxe_query_device(struct ib_device *dev,
 	return 0;
 }
 
-static void rxe_eth_speed_to_ib_speed(int speed, u8 *active_speed,
-				      u8 *active_width)
-{
-	if (speed <= 1000) {
-		*active_width = IB_WIDTH_1X;
-		*active_speed = IB_SPEED_SDR;
-	} else if (speed <= 10000) {
-		*active_width = IB_WIDTH_1X;
-		*active_speed = IB_SPEED_FDR10;
-	} else if (speed <= 20000) {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_DDR;
-	} else if (speed <= 30000) {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_QDR;
-	} else if (speed <= 40000) {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_FDR10;
-	} else {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_EDR;
-	}
-}
-
 static int rxe_query_port(struct ib_device *dev,
 			  u8 port_num, struct ib_port_attr *attr)
 {
 	struct rxe_dev *rxe = to_rdev(dev);
 	struct rxe_port *port;
-	u32 speed;
+	int rc = -EINVAL;
 
 	if (unlikely(port_num != 1)) {
 		pr_warn("invalid port_number %d\n", port_num);
-		goto err1;
+		goto out;
 	}
 
 	port = &rxe->port;
@@ -93,29 +69,12 @@ static int rxe_query_port(struct ib_device *dev,
 	*attr = port->attr;
 
 	mutex_lock(&rxe->usdev_lock);
-	if (rxe->ndev->ethtool_ops->get_link_ksettings) {
-		struct ethtool_link_ksettings ks;
-
-		rxe->ndev->ethtool_ops->get_link_ksettings(rxe->ndev, &ks);
-		speed = ks.base.speed;
-	} else if (rxe->ndev->ethtool_ops->get_settings) {
-		struct ethtool_cmd cmd;
-
-		rxe->ndev->ethtool_ops->get_settings(rxe->ndev, &cmd);
-		speed = cmd.speed;
-	} else {
-		pr_warn("%s speed is unknown, defaulting to 1000\n",
-			rxe->ndev->name);
-		speed = 1000;
-	}
-	rxe_eth_speed_to_ib_speed(speed, &attr->active_speed,
-				  &attr->active_width);
+	rc = ib_get_eth_speed(dev, port_num, &attr->active_speed,
+			      &attr->active_width);
 	mutex_unlock(&rxe->usdev_lock);
 
-	return 0;
-
-err1:
-	return -EINVAL;
+out:
+	return rc;
 }
 
 static int rxe_query_gid(struct ib_device *device,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 69cf21363530..bf049b6bf900 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3509,6 +3509,7 @@ void ib_drain_qp(struct ib_qp *qp);
 
 int ib_resolve_eth_dmac(struct ib_device *device,
 			struct rdma_ah_attr *ah_attr);
+int ib_get_eth_speed(struct ib_device *dev, u8 port_num, u8 *speed, u8 *width);
 
 static inline u8 *rdma_ah_retrieve_dmac(struct rdma_ah_attr *attr)
 {
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
