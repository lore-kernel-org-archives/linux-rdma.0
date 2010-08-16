From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 08/10] mlx4: Add API to query protocol device of
 specific port on mlx4_device
Date: Mon, 16 Aug 2010 15:16:48 -0700
Message-ID: <4C69B8D0.5060608@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050108030208000807060406"
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------050108030208000807060406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------050108030208000807060406
Content-Type: text/x-patch;
 name="0008-mlx4-Add-API-to-query-protocol-device-of-specific-po.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0008-mlx4-Add-API-to-query-protocol-device-of-specific-po.pa";
 filename*1="tch"

>From f29fe7ee6b8563eb362e22b8276e817e0337f048 Mon Sep 17 00:00:00 2001
From: Vu Pham <vu-OnC3O1emZK9LiOotz6YBiwC/G2K4zDHf@public.gmane.org>
Date: Mon, 16 Aug 2010 10:16:42 -0700
Subject: [PATCH 08/10] mlx4: Add API to query protocol device of specific port on mlx4_device

Adding new fields in mlx4_interface to set the type of protocol (IB, EN,...)
and interface to query the underline protocol device of a specific port
on the mlx4_device provided

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   10 +++++++++-
 drivers/net/mlx4/en_main.c        |    9 +++++++++
 drivers/net/mlx4/intf.c           |   19 +++++++++++++++++++
 include/linux/mlx4/driver.h       |    9 +++++++++
 4 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 4e94e36..e071229 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -58,6 +58,12 @@ static const char mlx4_ib_version[] =
 	DRV_NAME ": Mellanox ConnectX InfiniBand driver v"
 	DRV_VERSION " (" DRV_RELDATE ")\n";
 
+static void *get_ibdev(struct mlx4_dev *dev, void *ctx, u8 port)
+{
+       struct mlx4_ib_dev *mlxibdev = ctx;
+       return &mlxibdev->ib_dev;
+}
+
 static void init_query_mad(struct ib_smp *mad)
 {
 	mad->base_version  = 1;
@@ -749,7 +755,9 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 static struct mlx4_interface mlx4_ib_interface = {
 	.add	= mlx4_ib_add,
 	.remove	= mlx4_ib_remove,
-	.event	= mlx4_ib_event
+	.event	= mlx4_ib_event,
+	.get_prot_dev = get_ibdev,
+	.protocol = MLX4_PROT_IB
 };
 
 static int __init mlx4_ib_init(void)
diff --git a/drivers/net/mlx4/en_main.c b/drivers/net/mlx4/en_main.c
index 97934f1..03a4c3e 100644
--- a/drivers/net/mlx4/en_main.c
+++ b/drivers/net/mlx4/en_main.c
@@ -281,10 +281,19 @@ err_free_res:
 	return NULL;
 }
 
+static void *get_netdev(struct mlx4_dev *dev, void *ctx, u8 port)
+{
+	struct mlx4_en_dev *mdev = ctx;
+
+	return (port <= MLX4_MAX_PORTS) ? mdev->pndev[port] : NULL;
+}
+
 static struct mlx4_interface mlx4_en_interface = {
 	.add	= mlx4_en_add,
 	.remove	= mlx4_en_remove,
 	.event	= mlx4_en_event,
+	.get_prot_dev = get_netdev,
+	.protocol = MLX4_PROT_EN
 };
 
 static int __init mlx4_en_init(void)
diff --git a/drivers/net/mlx4/intf.c b/drivers/net/mlx4/intf.c
index 5550678..10e18e4 100644
--- a/drivers/net/mlx4/intf.c
+++ b/drivers/net/mlx4/intf.c
@@ -80,6 +80,25 @@ static void mlx4_remove_device(struct mlx4_interface *intf, struct mlx4_priv *pr
 		}
 }
 
+void *mlx4_get_prot_dev(struct mlx4_dev *dev, enum mlx4_prot proto, int port)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_device_context *dev_ctx;
+	unsigned long flags;
+	void *result = NULL;
+
+	spin_lock_irqsave(&priv->ctx_lock, flags);
+	list_for_each_entry(dev_ctx, &priv->ctx_list, list)
+		if (dev_ctx->intf->protocol == proto && dev_ctx->intf->get_prot_dev) {
+			result = dev_ctx->intf->get_prot_dev(dev, dev_ctx->context, port);
+			break;
+	}
+	spin_unlock_irqrestore(&priv->ctx_lock, flags);
+
+	return result;
+}
+EXPORT_SYMBOL_GPL(mlx4_get_prot_dev);
+
 int mlx4_register_interface(struct mlx4_interface *intf)
 {
 	struct mlx4_priv *priv;
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
index 53c5fdb..370e90a 100644
--- a/include/linux/mlx4/driver.h
+++ b/include/linux/mlx4/driver.h
@@ -44,15 +44,24 @@ enum mlx4_dev_event {
 	MLX4_DEV_EVENT_PORT_REINIT,
 };
 
+enum mlx4_prot {
+	MLX4_PROT_IB,
+	MLX4_PROT_EN,
+};
+
 struct mlx4_interface {
 	void *			(*add)	 (struct mlx4_dev *dev);
 	void			(*remove)(struct mlx4_dev *dev, void *context);
 	void			(*event) (struct mlx4_dev *dev, void *context,
 					  enum mlx4_dev_event event, int port);
+	void *			(*get_prot_dev) (struct mlx4_dev *dev,
+						 void *context, u8 port);
+	enum mlx4_prot		protocol;
 	struct list_head	list;
 };
 
 int mlx4_register_interface(struct mlx4_interface *intf);
 void mlx4_unregister_interface(struct mlx4_interface *intf);
+void *mlx4_get_prot_dev(struct mlx4_dev *dev, enum mlx4_prot protocol, int port);
 
 #endif /* MLX4_DRIVER_H */
-- 
1.6.3.3


--------------050108030208000807060406
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------050108030208000807060406--
