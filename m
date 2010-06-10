From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 13/19 V4] mlx4_core: Giving Mac addresses for slave
	functions.
Date: Thu, 10 Jun 2010 22:04:54 +0300
Message-ID: <4C113756.50307@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For physical slaves, Mac address is retreived from static configuration.
For virtual slaves get random Macs.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/fw.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/mlx4/fw.h |    6 ++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index e53a392..773de63 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -32,6 +32,7 @@
  * SOFTWARE.
  */
 
+#include <linux/etherdevice.h>
 #include <linux/mlx4/cmd.h>
 #include <linux/cache.h>
 
@@ -136,6 +137,45 @@ int mlx4_MOD_STAT_CFG(struct mlx4_dev *dev, struct mlx4_mod_stat_cfg *cfg)
 	return err;
 }
 
+int mlx4_QUERY_VEP_CFG(struct mlx4_dev *dev, u8 vep_num,
+		       struct mlx4_vep_cfg *cfg)
+{
+	int err;
+	u32 in_mod;
+	u64 output;
+
+#define QUERY_VEP_CFG_OPMOD		3
+
+#define QUERY_VEP_CFG_INMOD		(2 << 28)
+#define QUERY_VEP_CFG_INMOD_VEP_OFFSET	16
+
+#define QUERY_VEP_CFG_MAC_OFFSET	0x90
+#define QUERY_VEP_CFG_LINK_OFFSET	0xa0
+
+
+	in_mod = QUERY_VEP_CFG_INMOD | (vep_num << QUERY_VEP_CFG_INMOD_VEP_OFFSET);
+
+	err = mlx4_cmd_imm(dev, 0, &output, in_mod | QUERY_VEP_CFG_MAC_OFFSET,
+			   QUERY_VEP_CFG_OPMOD, MLX4_CMD_MOD_STAT_CFG,
+			   MLX4_CMD_TIME_CLASS_A);
+	if (err) {
+		mlx4_err(dev, "Failed to retrieve mac for function %d\n", vep_num);
+		return err;
+	}
+	cfg->mac = output & 0xffffffffffffULL;
+
+	err = mlx4_cmd_imm(dev, 0, &output, in_mod | QUERY_VEP_CFG_LINK_OFFSET,
+			   QUERY_VEP_CFG_OPMOD, MLX4_CMD_MOD_STAT_CFG,
+			   MLX4_CMD_TIME_CLASS_A);
+	if (err) {
+		mlx4_err(dev, "Failed to retrieve link for function %d\n", vep_num);
+		return err;
+	}
+	cfg->link = (output >> 32) & 1;
+
+	return 0;
+}
+
 int mlx4_QUERY_PORT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
 							  struct mlx4_cmd_mailbox *inbox,
 							  struct mlx4_cmd_mailbox *outbox)
@@ -148,10 +188,34 @@ int mlx4_QUERY_SLAVE_CAP_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vh
 						       struct mlx4_cmd_mailbox *inbox,
 						       struct mlx4_cmd_mailbox *outbox)
 {
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_mfunc_master_ctx *master = &priv->mfunc.master;
+	struct mlx4_slave_state *slave_st = &master->slave_state[slave];
 	struct mlx4_caps *caps = outbox->buf;
+	struct mlx4_vep_cfg cfg;
+	u8 pf_num = slave_st->pf_num;
+	u8 rand_mac[6];
+	int i, j, err = 0;
 
 	memcpy(caps, &dev->caps, sizeof *caps);
 
+	/* For physical functions Mac should be defined by fw */
+	if (pf_num == slave) {
+		err = mlx4_QUERY_VEP_CFG(dev, pf_num, &cfg);
+		if (err)
+			mlx4_warn(dev, "Failed to retreive mac address for vep %d\n", pf_num);
+		else
+			caps->def_mac[(pf_num & 1) + 1] = cfg.mac;
+	}
+	if (pf_num != slave || err) {
+		for (i = 1; i <= dev->caps.num_ports; ++i) {
+			random_ether_addr(rand_mac);
+			caps->def_mac[i] = 0;
+			for (j = 0; j < ETH_ALEN; j++)
+				caps->def_mac[i] |= ((u64)(rand_mac[1]) << 8 * j);
+		}
+	}
+
 	/* Ports are activated according to physical function number */
 	mlx4_set_port_mask(dev, caps, slave);
 
diff --git a/drivers/net/mlx4/fw.h b/drivers/net/mlx4/fw.h
index d5c17cf..f8d49d0 100644
--- a/drivers/net/mlx4/fw.h
+++ b/drivers/net/mlx4/fw.h
@@ -43,6 +43,11 @@ struct mlx4_mod_stat_cfg {
 	u8 log_pg_sz_m;
 };
 
+struct mlx4_vep_cfg {
+	u64 mac;
+	u8  link;
+};
+
 struct mlx4_dev_cap {
 	int max_srq_sz;
 	int max_qp_sz;
@@ -180,6 +185,7 @@ int mlx4_MAP_ICM_AUX(struct mlx4_dev *dev, struct mlx4_icm *icm);
 int mlx4_UNMAP_ICM_AUX(struct mlx4_dev *dev);
 int mlx4_NOP(struct mlx4_dev *dev);
 int mlx4_MOD_STAT_CFG(struct mlx4_dev *dev, struct mlx4_mod_stat_cfg *cfg);
+int mlx4_QUERY_VEP_CFG(struct mlx4_dev *dev, u8 vep_num, struct mlx4_vep_cfg *cfg);
 int mlx4_QUERY_FUNC(struct mlx4_dev *dev, int func, u8 *pf_num);
 
 #endif /* MLX4_FW_H */
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
