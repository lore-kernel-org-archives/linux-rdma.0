From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 16/19 V4] mlx4_en: querying link state
Date: Thu, 10 Jun 2010 22:07:32 +0300
Message-ID: <4C1137F4.60605@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In multifunction device, a certain function can initialize its port after some
other function already done that. In that case link event would not be generated.
Need to query the port to retrieve the port state.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/en_netdev.c |   10 ++++++++++
 drivers/net/mlx4/en_port.c   |   32 ++++++++++++++++++++++++++++++++
 drivers/net/mlx4/en_port.h   |   13 +++++++++++++
 drivers/net/mlx4/mlx4_en.h   |    8 ++++++++
 4 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/en_netdev.c b/drivers/net/mlx4/en_netdev.c
index 5ebe135..d171945 100644
--- a/drivers/net/mlx4/en_netdev.c
+++ b/drivers/net/mlx4/en_netdev.c
@@ -219,6 +219,16 @@ static void mlx4_en_do_set_multicast(struct work_struct *work)
 		goto out;
 	}
 
+	if (!netif_carrier_ok(dev)) {
+		if (!mlx4_en_QUERY_PORT(mdev, priv->port)) {
+			if (priv->port_state.link_state) {
+				priv->last_link_state = MLX4_DEV_EVENT_PORT_UP;
+				netif_carrier_on(dev);
+				en_dbg(LINK, priv, "Link Up\n");
+			}
+		}
+	}
+
 	/*
 	 * Promsicuous mode: disable all filters
 	 */
diff --git a/drivers/net/mlx4/en_port.c b/drivers/net/mlx4/en_port.c
index 2863a30..84cc32d 100644
--- a/drivers/net/mlx4/en_port.c
+++ b/drivers/net/mlx4/en_port.c
@@ -40,6 +40,38 @@
 #include "en_port.h"
 #include "mlx4_en.h"
 
+int mlx4_en_QUERY_PORT(struct mlx4_en_dev *mdev, u8 port)
+{
+	struct mlx4_en_query_port_context *qport_context;
+	struct mlx4_en_priv *priv = netdev_priv(mdev->pndev[port]);
+	struct mlx4_en_port_state *state = &priv->port_state;
+	struct mlx4_cmd_mailbox *mailbox;
+	int err;
+
+	mailbox = mlx4_alloc_cmd_mailbox(mdev->dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	memset(mailbox->buf, 0, sizeof(*qport_context));
+	err = mlx4_cmd_box(mdev->dev, 0, mailbox->dma, port, 0,
+			   MLX4_CMD_QUERY_PORT, MLX4_CMD_TIME_CLASS_B);
+	if (err)
+		goto out;
+	qport_context = mailbox->buf;
+
+	/* This command is always accessed from Ethtool context
+	 * already synchronized, no need in locking */
+	state->link_state = !!(qport_context->link_up & MLX4_EN_LINK_UP_MASK);
+	if ((qport_context->link_speed & MLX4_EN_SPEED_MASK) ==
+	    MLX4_EN_1G_SPEED)
+		state->link_speed = 1000;
+	else
+		state->link_speed = 10000;
+	state->transciver = qport_context->transceiver;
+
+out:
+	mlx4_free_cmd_mailbox(mdev->dev, mailbox);
+	return err;
+}
 
 int mlx4_en_DUMP_ETH_STATS(struct mlx4_en_dev *mdev, u8 port, u8 reset)
 {
diff --git a/drivers/net/mlx4/en_port.h b/drivers/net/mlx4/en_port.h
index 40918ab..ecbab85 100644
--- a/drivers/net/mlx4/en_port.h
+++ b/drivers/net/mlx4/en_port.h
@@ -41,6 +41,19 @@ enum {
 	MLX4_MCAST_ENABLE       = 2,
 };
 
+struct mlx4_en_query_port_context {
+	u8 link_up;
+#define MLX4_EN_LINK_UP_MASK	0x80
+	u8 reserved;
+	__be16 mtu;
+	u8 reserved2;
+	u8 link_speed;
+#define MLX4_EN_SPEED_MASK	0x3
+#define MLX4_EN_1G_SPEED	0x2
+	u16 reserved3[5];
+	__be64 mac;
+	u8 transceiver;
+};
 
 struct mlx4_en_stat_out_mbox {
 	/* Received frames with a length of 64 octets */
diff --git a/drivers/net/mlx4/mlx4_en.h b/drivers/net/mlx4/mlx4_en.h
index 2204ec3..e0ce6c5 100644
--- a/drivers/net/mlx4/mlx4_en.h
+++ b/drivers/net/mlx4/mlx4_en.h
@@ -389,6 +389,12 @@ struct mlx4_en_rss_context {
 	__be32 rss_key[10];
 };
 
+struct mlx4_en_port_state {
+	int link_state;
+	int link_speed;
+	int transciver;
+};
+
 struct mlx4_en_pkt_stats {
 	unsigned long broadcast;
 	unsigned long rx_prio[8];
@@ -437,6 +443,7 @@ struct mlx4_en_priv {
 	struct vlan_group *vlgrp;
 	struct net_device_stats stats;
 	struct net_device_stats ret_stats;
+	struct mlx4_en_port_state port_state;
 	spinlock_t stats_lock;
 
 	unsigned long last_moder_packets;
@@ -562,6 +569,7 @@ int mlx4_SET_PORT_qpn_calc(struct mlx4_dev *dev, u8 port, u32 base_qpn,
 			   u8 promisc);
 
 int mlx4_en_DUMP_ETH_STATS(struct mlx4_en_dev *mdev, u8 port, u8 reset);
+int mlx4_en_QUERY_PORT(struct mlx4_en_dev *mdev, u8 port);
 
 /*
  * Globals
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
