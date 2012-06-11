From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 10/29] net/mlx4_core: Implement mechanism for reserved qkeys
Date: Mon, 11 Jun 2012 13:45:51 +0300
Message-ID: <1339411570-4689-11-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The sriov special-qp tunneling mechanism uses proxy special-qp's
(instead of the real special qps) for MADs on guests.  These proxy qp's
send their packets to a "tunnel" qp owned by the master.  The master
then forwards the MAD (after any required paravirtualization) to the
real special QP, which sends out the MAD.

For security reasons (i.e., to prevent guests from sending MADs to tunnel QPs
belonging to other guests), each proxy-tunnel qp pair is assigned a unique,
reserved, qkey.  These qkeys are available only for proxy and tunnel qp's --
if the guest tries to use these qkeys with other qp's, it will fail.

This patch introduces a mechanism for reserving a block of 64K Qkeys for
proxy/tunneling use.

The patch introduces also two new fields into mlx4_dev:
base_sqpn and base_tunnel_sqpn.

In SRIOV mode, the qp numbers for the "real", proxy, and tunnel sqps
are added to the reserved-qp number area (so that they will not change).
There are 8 special QPs per port in the HCA, and each of them is assigned
both a proxy and a tunnel qp, for each VF and for the PF as well in SRIOV mode.

The qp numbers for these qp's are arranged as follows:
1. The Real SQP numbers (8)
2. The proxy sqp's (8 * (max number of VFs + max number of PFs)
3. The tunnel sqp's (8 * (max number of VFs + max number of PFs)

To support these QPs, two new fields are added to struct mlx4_dev:
base_sqp:  this is the QP number of the first of the real SQPs

base_tunnel_sqp:  this is the qp number of the first qp in the
                  tunnel sqp region. (On guests, this is the first
                  tunnel sqp of the 8 which are assigned to that guest).

In addition, in SRIOV mode, sqp_start is the number of the first proxy
sqp in the proxy sqp region.(On guests, this is the first proxy sqp
of the 8 which are assigned to that guest).

Note that in non-SRIOV mode, there are not proxies and no tunnels.
In this case, sqp_start is set to sqp_base -- which minimizes code
changes.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   17 +++++++++++++++++
 include/linux/mlx4/device.h               |   12 ++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 7ea68ce..ff7332f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -391,6 +391,23 @@ static int mlx4_how_many_lives_vf(struct mlx4_dev *dev)
 	return ret;
 }
 
+int mlx4_get_parav_qkey(struct mlx4_dev *dev, u32 qpn, u32 *qkey)
+{
+	u32 qk = MLX4_RESERVED_QKEY_BASE;
+	if (qpn >= dev->caps.base_tunnel_sqpn + 8 * MLX4_MFUNC_MAX ||
+	    qpn < dev->caps.sqp_start)
+		return -EINVAL;
+
+	if (qpn >= dev->caps.base_tunnel_sqpn)
+		/* tunnel qp */
+		qk += qpn - dev->caps.base_tunnel_sqpn;
+	else
+		qk += qpn - dev->caps.sqp_start;
+	*qkey = qk;
+	return 0;
+}
+EXPORT_SYMBOL(mlx4_get_parav_qkey);
+
 int mlx4_is_slave_active(struct mlx4_dev *dev, int slave)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 560b220..93239d7 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -56,6 +56,14 @@ enum {
 	MLX4_MAX_PORTS		= 2
 };
 
+/* base qkey for use in sriov tunnel-qp/proxy-qp communication.
+ * These qkeys must not be allowed for general use. This is a 64k range,
+ * and to test for violation, we use the mask (protect against future chg).
+ */
+#define MLX4_RESERVED_QKEY_BASE  (0xFFFF0000)
+#define MLX4_RESERVED_QKEY_MASK  (0xFFFF0000)
+
+
 enum {
 	MLX4_BOARD_ID_LEN = 64
 };
@@ -293,6 +301,8 @@ struct mlx4_caps {
 	int			max_qp_init_rdma;
 	int			max_qp_dest_rdma;
 	int			sqp_start;
+	u32			base_sqpn;
+	u32			base_tunnel_sqpn;
 	int			num_srqs;
 	int			max_srq_wqes;
 	int			max_srq_sge;
@@ -767,4 +777,6 @@ int mlx4_wol_write(struct mlx4_dev *dev, u64 config, int port);
 int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx);
 void mlx4_counter_free(struct mlx4_dev *dev, u32 idx);
 
+int mlx4_get_parav_qkey(struct mlx4_dev *dev, u32 qpn, u32 *qkey);
+
 #endif /* MLX4_DEVICE_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
