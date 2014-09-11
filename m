From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/5] IB/mlx4: Avoid accessing netdevice when building RoCE qp1 header
Date: Thu, 11 Sep 2014 14:11:17 +0300
Message-ID: <1410433880-12439-3-git-send-email-ogerlitz@mellanox.com>
References: <1410433880-12439-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410433880-12439-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

The source MAC is needed in RoCE when building the QP1 header.

Currently, this is obtained from the source net device. However, the net
device may not yet exist, or can be destroyed in parallel to this QP1 send
operation (e.g through the VPI port change flow) so accessing it may cause
a kernel crash.

To fix this, we maintain a source MAC cache per port for the net device in
struct mlx4_ib_roce.  This cached MAC is initialized to be the default MAC
address obtained during HCA initialization via QUERY_PORT. This cached MAC
is updated via the netdev event notifier handler.

Since the cached MAC is held in an atomic64 object, we do not need locking
when accessing it.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |    5 ++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    1 +
 drivers/infiniband/hw/mlx4/qp.c      |   38 +++++++++++++++++++--------------
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index ea30f9e..234c3fe 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1640,6 +1640,8 @@ static void mlx4_ib_update_qps(struct mlx4_ib_dev *ibdev,
 	new_smac = mlx4_mac_to_u64(dev->dev_addr);
 	read_unlock(&dev_base_lock);
 
+	atomic64_set(&ibdev->iboe.mac[port - 1], new_smac);
+
 	mutex_lock(&ibdev->qp1_proxy_lock[port - 1]);
 	qp = ibdev->qp1_proxy[port - 1];
 	if (qp) {
@@ -2187,6 +2189,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			goto err_steer_free_bitmap;
 	}
 
+	for (j = 1; j <= ibdev->dev->caps.num_ports; j++)
+		atomic64_set(&iboe->mac[j - 1], ibdev->dev->caps.def_mac[j]);
+
 	if (ib_register_device(&ibdev->ib_dev, NULL))
 		goto err_steer_free_bitmap;
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index e8cad39..6eb743f 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -451,6 +451,7 @@ struct mlx4_ib_iboe {
 	spinlock_t		lock;
 	struct net_device      *netdevs[MLX4_MAX_PORTS];
 	struct net_device      *masters[MLX4_MAX_PORTS];
+	atomic64_t		mac[MLX4_MAX_PORTS];
 	struct notifier_block 	nb;
 	struct notifier_block	nb_inet;
 	struct notifier_block	nb_inet6;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 6778045..25e0208 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1390,18 +1390,10 @@ static void update_mcg_macs(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
 static int handle_eth_ud_smac_index(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp, u8 *smac,
 				    struct mlx4_qp_context *context)
 {
-	struct net_device *ndev;
 	u64 u64_mac;
 	int smac_index;
 
-
-	ndev = dev->iboe.netdevs[qp->port - 1];
-	if (ndev) {
-		smac = ndev->dev_addr;
-		u64_mac = mlx4_mac_to_u64(smac);
-	} else {
-		u64_mac = dev->dev->caps.def_mac[qp->port];
-	}
+	u64_mac = atomic64_read(&dev->iboe.mac[qp->port - 1]);
 
 	context->pri_path.sched_queue = MLX4_IB_DEFAULT_SCHED_QUEUE | ((qp->port - 1) << 6);
 	if (!qp->pri.smac) {
@@ -2083,6 +2075,16 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 	return 0;
 }
 
+static void mlx4_u64_to_smac(u8 *dst_mac, u64 src_mac)
+{
+	int i;
+
+	for (i = ETH_ALEN; i; i--) {
+		dst_mac[i - 1] = src_mac & 0xff;
+		src_mac >>= 8;
+	}
+}
+
 static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 			    void *wqe, unsigned *mlx_seg_len)
 {
@@ -2197,7 +2199,6 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	}
 
 	if (is_eth) {
-		u8 *smac;
 		struct in6_addr in6;
 
 		u16 pcp = (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 29) << 13;
@@ -2210,12 +2211,17 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		memcpy(&ctrl->imm, ah->av.eth.mac + 2, 4);
 		memcpy(&in6, sgid.raw, sizeof(in6));
 
-		if (!mlx4_is_mfunc(to_mdev(ib_dev)->dev))
-			smac = to_mdev(sqp->qp.ibqp.device)->
-				iboe.netdevs[sqp->qp.port - 1]->dev_addr;
-		else	/* use the src mac of the tunnel */
-			smac = ah->av.eth.s_mac;
-		memcpy(sqp->ud_header.eth.smac_h, smac, 6);
+		if (!mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
+			u64 mac = atomic64_read(&to_mdev(ib_dev)->iboe.mac[sqp->qp.port - 1]);
+			u8 smac[ETH_ALEN];
+
+			mlx4_u64_to_smac(smac, mac);
+			memcpy(sqp->ud_header.eth.smac_h, smac, ETH_ALEN);
+		} else {
+			/* use the src mac of the tunnel */
+			memcpy(sqp->ud_header.eth.smac_h, ah->av.eth.s_mac, ETH_ALEN);
+		}
+
 		if (!memcmp(sqp->ud_header.eth.smac_h, sqp->ud_header.eth.dmac_h, 6))
 			mlx->flags |= cpu_to_be32(MLX4_WQE_CTRL_FORCE_LOOPBACK);
 		if (!is_vlan) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
