From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Wed, 25 May 2011 15:10:52 +0300
Message-ID: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since there's a dependency between the port mtu to the maximal
number of VLs the port can support - act in a loop, going down
from the highest possible number of VLs to the lowest. Use the
firmware return status as an indication for the requested number
of VLs being impossible with that mtu.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---

Roland, this is an updated approach and posting for the patch posted
earlier by Vlad on which you've responded @
http://www.spinics.net/lists/linux-rdma/msg02136.html
I've attempted to address your comment and questions, let me know...

 drivers/net/mlx4/port.c |   36 ++++++++++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mlx4/port.c b/drivers/net/mlx4/port.c
index 8856659..872e8d3 100644
--- a/drivers/net/mlx4/port.c
+++ b/drivers/net/mlx4/port.c
@@ -43,6 +43,10 @@
 #define MLX4_VLAN_VALID		(1u << 31)
 #define MLX4_VLAN_MASK		0xfff

+static int mlx4_ib_set_4k_mtu;
+module_param_named(set_4k_mtu, mlx4_ib_set_4k_mtu, int, 0444);
+MODULE_PARM_DESC(set_4k_mtu, "attempt to set 4K MTU to IB ports");
+
 void mlx4_init_mac_table(struct mlx4_dev *dev, struct mlx4_mac_table *table)
 {
 	int i;
@@ -461,10 +465,20 @@ int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps)
 	return err;
 }

+/* bit locations for set port command with zero op modifier */
+enum {
+	MLX4_SET_PORT_VL_CAP	 = 4, /* bits 7:4 */
+	MLX4_SET_PORT_MTU_CAP	 = 12, /* bits 15:12 */
+	MLX4_CHANGE_PORT_VL_CAP	 = 21,
+	MLX4_CHANGE_PORT_MTU_CAP = 22,
+};
+
+#define IBTA_MTU_4096	5
+
 int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 {
 	struct mlx4_cmd_mailbox *mailbox;
-	int err;
+	int err, vl_cap;

 	if (dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
 		return 0;
@@ -474,10 +488,24 @@ int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 		return PTR_ERR(mailbox);

 	memset(mailbox->buf, 0, 256);
-
 	((__be32 *) mailbox->buf)[1] = dev->caps.ib_port_def_cap[port];
-	err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_SET_PORT,
-		       MLX4_CMD_TIME_CLASS_B);
+
+	if (mlx4_ib_set_4k_mtu)
+		for (vl_cap = 8; vl_cap >= 1; vl_cap >>= 1) {
+			((__be32 *) mailbox->buf)[0] = cpu_to_be32(
+				(1 << MLX4_CHANGE_PORT_MTU_CAP) |
+				(1 << MLX4_CHANGE_PORT_VL_CAP)	|
+				(IBTA_MTU_4096 << MLX4_SET_PORT_MTU_CAP) |
+				(vl_cap << MLX4_SET_PORT_VL_CAP));
+			err = mlx4_cmd(dev, mailbox->dma, port, 0,
+				MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B);
+			if (err != -ENOMEM)
+				break;
+		}
+	else {
+		err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_SET_PORT,
+			       MLX4_CMD_TIME_CLASS_B);
+	}

 	mlx4_free_cmd_mailbox(dev, mailbox);
 	return err;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
