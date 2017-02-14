From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/mlx4: Take source GID by index from HW GID table
Date: Tue, 14 Feb 2017 07:24:53 +0200
Message-ID: <20170214052453.16488-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Previously, we used the HW GID index in order to search the source GID
in the software GID cached table. In some cases, for example when
the MAC Address of the network interface is changed, the GID cached table
saves the old-IPv6-link-local GID at the end of the table.

When returning the old MAC address, the software GID cached table tries
to add the new IPv6-link-local GID, and when it identifies that the GID
already exists, the software GID cached does not add it. Thus a mismatch
occurs between the HW and the SW GID tables.

It resulted with sending traffic with the wrong source GID.

This commit fixes the issue by taking both from the HW table.

The problem can be reproduced with the following scenario:
Client:
    # ifconfig ens6 2.2.2.5
    # ifconfig ens6 inet6 add 2001:0db8:0:f101::5/64
    # ifconfig ens6 hw ether f4:52:14:61:a0:71
    # ifconfig ens6 inet6 del 2001:0db8:0:f101::5/64
    # ifconfig ens6 inet6 add 2001:0db8:0:f101::5/64
    # ucmatose -f ipv6 -b 2001:0db8:0:f101::5 -s 2001:0db8:0:f101::6 -p 20156
Server:
    # ucmatose -f ipv6 -b 2001:0db8:0:f101::6 -p 20156

Fixes: 4c3eb3ca1396 ('IB/mlx4: Add VLAN support for IBoE')
Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 56 +++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index c068add8838b..4f50b96fe605 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2424,11 +2424,31 @@ static u8 sl_to_vl(struct mlx4_ib_dev *dev, u8 sl, int port_num)
 	return vl;
 }

+static int fill_gid_by_hw_index(struct mlx4_ib_dev *ibdev, u8 port_num,
+				int index, union ib_gid *gid,
+				enum ib_gid_type *gid_type)
+{
+	struct mlx4_ib_iboe *iboe = &ibdev->iboe;
+	struct mlx4_port_gid_table *port_gid_table;
+	unsigned long flags;
+
+	port_gid_table = &iboe->gids[port_num - 1];
+	spin_lock_irqsave(&iboe->lock, flags);
+	memcpy(gid, &port_gid_table->gids[index].gid, sizeof(*gid));
+	*gid_type = port_gid_table->gids[index].gid_type;
+	spin_unlock_irqrestore(&iboe->lock, flags);
+	if (!memcmp(gid, &zgid, sizeof(*gid)))
+		return -ENOENT;
+
+	return 0;
+}
+
 #define MLX4_ROCEV2_QP1_SPORT 0xC000
 static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 			    void *wqe, unsigned *mlx_seg_len)
 {
 	struct ib_device *ib_dev = sqp->qp.ibqp.device;
+	struct mlx4_ib_dev *ibdev = to_mdev(ib_dev);
 	struct mlx4_wqe_mlx_seg *mlx = wqe;
 	struct mlx4_wqe_ctrl_seg *ctrl = wqe;
 	struct mlx4_wqe_inline_seg *inl = wqe + sizeof *mlx;
@@ -2454,8 +2474,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 	is_eth = rdma_port_get_link_layer(sqp->qp.ibqp.device, sqp->qp.port) == IB_LINK_LAYER_ETHERNET;
 	is_grh = mlx4_ib_ah_grh_present(ah);
 	if (is_eth) {
-		struct ib_gid_attr gid_attr;
-
+		enum ib_gid_type gid_type;
 		if (mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
 			/* When multi-function is enabled, the ib_core gid
 			 * indexes don't necessarily match the hw ones, so
@@ -2466,18 +2485,11 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 			if (err)
 				return err;
 		} else  {
-			err = ib_get_cached_gid(ib_dev,
-						be32_to_cpu(ah->av.ib.port_pd) >> 24,
-						ah->av.ib.gid_index, &sgid,
-						&gid_attr);
-			if (!err) {
-				if (gid_attr.ndev)
-					dev_put(gid_attr.ndev);
-				if (!memcmp(&sgid, &zgid, sizeof(sgid)))
-					err = -ENOENT;
-			}
+			err = fill_gid_by_hw_index(ibdev, sqp->qp.port,
+					    ah->av.ib.gid_index,
+					    &sgid, &gid_type);
 			if (!err) {
-				is_udp = gid_attr.gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP;
+				is_udp = gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP;
 				if (is_udp) {
 					if (ipv6_addr_v4mapped((struct in6_addr *)&sgid))
 						ip_version = 4;
@@ -2955,21 +2967,17 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,

 		if (sqp->roce_v2_gsi) {
 			struct mlx4_ib_ah *ah = to_mah(ud_wr(wr)->ah);
-			struct ib_gid_attr gid_attr;
+			enum ib_gid_type gid_type;
 			union ib_gid gid;

-			if (!ib_get_cached_gid(ibqp->device,
-					       be32_to_cpu(ah->av.ib.port_pd) >> 24,
-					       ah->av.ib.gid_index, &gid,
-					       &gid_attr)) {
-				if (gid_attr.ndev)
-					dev_put(gid_attr.ndev);
-				qp = (gid_attr.gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) ?
-					to_mqp(sqp->roce_v2_gsi) : qp;
-			} else {
+			if (!fill_gid_by_hw_index(mdev, sqp->qp.port,
+					   ah->av.ib.gid_index,
+					   &gid, &gid_type))
+				qp = (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) ?
+						to_mqp(sqp->roce_v2_gsi) : qp;
+			else
 				pr_err("Failed to get gid at index %d. RoCEv2 will not work properly\n",
 				       ah->av.ib.gid_index);
-			}
 		}
 	}

--
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
