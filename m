From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-next 2/3] net/mlx4: Query performance and diagnostics counters
Date: Tue, 19 Jul 2016 20:54:57 +0300
Message-ID: <1468950898-9674-3-git-send-email-leon@kernel.org>
References: <1468950898-9674-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468950898-9674-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a function to query diagnostics counters from the firmware.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c | 36 +++++++++++++++++++++++++++++++++
 include/linux/mlx4/device.h             |  3 +++
 2 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 90a28ab..0a52560 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -2460,6 +2460,42 @@ int mlx4_NOP(struct mlx4_dev *dev)
 			MLX4_CMD_NATIVE);
 }
 
+int mlx4_query_diag_counters(struct mlx4_dev *dev, u8 op_modifier,
+			     const u32 offset[],
+			     u32 value[], size_t array_len, u8 port)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	u32 *outbox;
+	size_t i;
+	int ret;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	outbox = mailbox->buf;
+
+	ret = mlx4_cmd_box(dev, 0, mailbox->dma, port, op_modifier,
+			   MLX4_CMD_DIAG_RPRT, MLX4_CMD_TIME_CLASS_A,
+			   MLX4_CMD_NATIVE);
+	if (ret)
+		goto out;
+
+	for (i = 0; i < array_len; i++) {
+		if (offset[i] > MLX4_MAILBOX_SIZE) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		MLX4_GET(value[i], outbox, offset[i]);
+	}
+
+out:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return ret;
+}
+EXPORT_SYMBOL(mlx4_query_diag_counters);
+
 int mlx4_get_phys_port_id(struct mlx4_dev *dev)
 {
 	u8 port;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 7ff690b..d70cfbe 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1382,6 +1382,9 @@ void mlx4_fmr_unmap(struct mlx4_dev *dev, struct mlx4_fmr *fmr,
 int mlx4_fmr_free(struct mlx4_dev *dev, struct mlx4_fmr *fmr);
 int mlx4_SYNC_TPT(struct mlx4_dev *dev);
 int mlx4_test_interrupts(struct mlx4_dev *dev);
+int mlx4_query_diag_counters(struct mlx4_dev *dev, u8 op_modifier,
+			     const u32 offset[], u32 value[],
+			     size_t array_len, u8 port);
 u32 mlx4_get_eqs_per_port(struct mlx4_dev *dev, u8 port);
 bool mlx4_is_eq_vector_valid(struct mlx4_dev *dev, u8 port, int vector);
 struct cpu_rmap *mlx4_get_cpu_rmap(struct mlx4_dev *dev, int port);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
