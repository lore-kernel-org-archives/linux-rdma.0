From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 02/12] IB/mlx4: Add gid_type to GID properties
Date: Thu, 14 Jan 2016 17:50:33 +0200
Message-ID: <b7c83bf56d947c4a816bbfec82b7a062dff78738.1452780850.git.monis@mellanox.com>
References: <cover.1452780849.git.monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IB core driver adds a property of type to struct ib_gid_attr.
The mlx4 driver should take that in consideration when modifying or
querying the hardware gid table.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    | 17 +++++++++++++----
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index a7916e3..22c9c1c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -215,7 +215,8 @@ static int mlx4_ib_add_gid(struct ib_device *device,
 	port_gid_table = &iboe->gids[port_num - 1];
 	spin_lock_bh(&iboe->lock);
 	for (i = 0; i < MLX4_MAX_PORT_GIDS; ++i) {
-		if (!memcmp(&port_gid_table->gids[i].gid, gid, sizeof(*gid))) {
+		if (!memcmp(&port_gid_table->gids[i].gid, gid, sizeof(*gid)) &&
+		    (port_gid_table->gids[i].gid_type == attr->gid_type))  {
 			found = i;
 			break;
 		}
@@ -233,6 +234,7 @@ static int mlx4_ib_add_gid(struct ib_device *device,
 			} else {
 				*context = port_gid_table->gids[free].ctx;
 				memcpy(&port_gid_table->gids[free].gid, gid, sizeof(*gid));
+				port_gid_table->gids[free].gid_type = attr->gid_type;
 				port_gid_table->gids[free].ctx->real_index = free;
 				port_gid_table->gids[free].ctx->refcount = 1;
 				hw_update = 1;
@@ -248,8 +250,10 @@ static int mlx4_ib_add_gid(struct ib_device *device,
 		if (!gids) {
 			ret = -ENOMEM;
 		} else {
-			for (i = 0; i < MLX4_MAX_PORT_GIDS; i++)
+			for (i = 0; i < MLX4_MAX_PORT_GIDS; i++) {
 				memcpy(&gids[i].gid, &port_gid_table->gids[i].gid, sizeof(union ib_gid));
+				gids[i].gid_type = port_gid_table->gids[i].gid_type;
+			}
 		}
 	}
 	spin_unlock_bh(&iboe->lock);
@@ -325,6 +329,7 @@ int mlx4_ib_gid_index_to_real_index(struct mlx4_ib_dev *ibdev,
 	int i;
 	int ret;
 	unsigned long flags;
+	struct ib_gid_attr attr;
 
 	if (port_num > MLX4_MAX_PORTS)
 		return -EINVAL;
@@ -335,10 +340,13 @@ int mlx4_ib_gid_index_to_real_index(struct mlx4_ib_dev *ibdev,
 	if (!rdma_cap_roce_gid_table(&ibdev->ib_dev, port_num))
 		return index;
 
-	ret = ib_get_cached_gid(&ibdev->ib_dev, port_num, index, &gid, NULL);
+	ret = ib_get_cached_gid(&ibdev->ib_dev, port_num, index, &gid, &attr);
 	if (ret)
 		return ret;
 
+	if (attr.ndev)
+		dev_put(attr.ndev);
+
 	if (!memcmp(&gid, &zgid, sizeof(gid)))
 		return -EINVAL;
 
@@ -346,7 +354,8 @@ int mlx4_ib_gid_index_to_real_index(struct mlx4_ib_dev *ibdev,
 	port_gid_table = &iboe->gids[port_num - 1];
 
 	for (i = 0; i < MLX4_MAX_PORT_GIDS; ++i)
-		if (!memcmp(&port_gid_table->gids[i].gid, &gid, sizeof(gid))) {
+		if (!memcmp(&port_gid_table->gids[i].gid, &gid, sizeof(gid)) &&
+		    attr.gid_type == port_gid_table->gids[i].gid_type) {
 			ctx = port_gid_table->gids[i].ctx;
 			break;
 		}
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 8916e9b..7179fb1 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -478,6 +478,7 @@ struct gid_cache_context {
 
 struct gid_entry {
 	union ib_gid	gid;
+	enum ib_gid_type gid_type;
 	struct gid_cache_context *ctx;
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
