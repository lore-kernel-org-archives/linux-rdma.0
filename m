From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH] ethernet: mlx4: Delete an error message for a failed memory
 allocation in five functions
Date: Mon, 1 Jan 2018 21:46:34 +0100
Message-ID: <30191db0-4d99-0349-b66a-c7354ef90d50@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-GB
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Mon, 1 Jan 2018 21:42:27 +0100

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_cq.c | 4 +---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 4 +---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 4 +---
 drivers/net/ethernet/mellanox/mlx4/main.c  | 4 +---
 drivers/net/ethernet/mellanox/mlx4/reset.c | 1 -
 5 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_cq.c b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
index 1e487acb4667..cf5e0d002b3f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
@@ -55,10 +55,8 @@ int mlx4_en_create_cq(struct mlx4_en_priv *priv,
 	cq = kzalloc_node(sizeof(*cq), GFP_KERNEL, node);
 	if (!cq) {
 		cq = kzalloc(sizeof(*cq), GFP_KERNEL);
-		if (!cq) {
-			en_err(priv, "Failed to allocate CQ structure\n");
+		if (!cq)
 			return -ENOMEM;
-		}
 	}
 
 	cq->size = entries;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 85e28efcda33..103abe1ad0cb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -272,10 +272,8 @@ int mlx4_en_create_rx_ring(struct mlx4_en_priv *priv,
 	ring = kzalloc_node(sizeof(*ring), GFP_KERNEL, node);
 	if (!ring) {
 		ring = kzalloc(sizeof(*ring), GFP_KERNEL);
-		if (!ring) {
-			en_err(priv, "Failed to allocate RX ring structure\n");
+		if (!ring)
 			return -ENOMEM;
-		}
 	}
 
 	ring->prod = 0;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 6b6853773848..a21d6ffaa244 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -58,10 +58,8 @@ int mlx4_en_create_tx_ring(struct mlx4_en_priv *priv,
 	ring = kzalloc_node(sizeof(*ring), GFP_KERNEL, node);
 	if (!ring) {
 		ring = kzalloc(sizeof(*ring), GFP_KERNEL);
-		if (!ring) {
-			en_err(priv, "Failed allocating TX ring\n");
+		if (!ring)
 			return -ENOMEM;
-		}
 	}
 
 	ring->size = size;
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 4d84cab77105..c793c5b0b0cf 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3177,10 +3177,8 @@ static u64 mlx4_enable_sriov(struct mlx4_dev *dev, struct pci_dev *pdev,
 	}
 
 	dev->dev_vfs = kzalloc(total_vfs * sizeof(*dev->dev_vfs), GFP_KERNEL);
-	if (NULL == dev->dev_vfs) {
-		mlx4_err(dev, "Failed to allocate memory for VFs\n");
+	if (!dev->dev_vfs)
 		goto disable_sriov;
-	}
 
 	if (!(dev->flags &  MLX4_FLAG_SRIOV)) {
 		if (total_vfs > fw_enabled_sriov_vfs) {
diff --git a/drivers/net/ethernet/mellanox/mlx4/reset.c b/drivers/net/ethernet/mellanox/mlx4/reset.c
index 0076d88587ca..74d77e56cc35 100644
--- a/drivers/net/ethernet/mellanox/mlx4/reset.c
+++ b/drivers/net/ethernet/mellanox/mlx4/reset.c
@@ -72,7 +72,6 @@ int mlx4_reset(struct mlx4_dev *dev)
 	hca_header = kmalloc(256, GFP_KERNEL);
 	if (!hca_header) {
 		err = -ENOMEM;
-		mlx4_err(dev, "Couldn't allocate memory to save HCA PCI header, aborting\n");
 		goto out;
 	}
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
