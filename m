From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 05/10]  query ib device from given mlx4 device
Date: Fri, 06 Aug 2010 15:50:42 -0700
Message-ID: <4C5C91C2.5040803@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010401050606070409040907"
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
--------------010401050606070409040907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Adding API to query ib_device with mlx4_dev

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>

 drivers/infiniband/hw/mlx4/main.c |   10 +++++++++-
 drivers/net/mlx4/intf.c           |   20 ++++++++++++++++++++
 drivers/net/mlx4/main.c           |   10 +++++++---
 drivers/net/mlx4/mlx4.h           |    1 +
 include/linux/mlx4/driver.h       |   10 ++++++++++
 7 files changed, 72 insertions(+), 15 deletions(-)


--------------010401050606070409040907
Content-Type: text/x-patch;
 name="mlx4_fc_0005_get_ib_dev_from_mlx4dev.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mlx4_fc_0005_get_ib_dev_from_mlx4dev.patch"

Adding API to query ib_device with mlx4_dev

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>

 drivers/infiniband/hw/mlx4/main.c |   10 +++++++++-
 drivers/net/mlx4/intf.c           |   20 ++++++++++++++++++++
 drivers/net/mlx4/main.c           |   10 +++++++---
 drivers/net/mlx4/mlx4.h           |    1 +
 include/linux/mlx4/driver.h       |   10 ++++++++++
 7 files changed, 72 insertions(+), 15 deletions(-)

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
diff --git a/drivers/net/mlx4/intf.c b/drivers/net/mlx4/intf.c
index beeed80..f8f97f9 100644
--- a/drivers/net/mlx4/intf.c
+++ b/drivers/net/mlx4/intf.c
@@ -191,3 +191,23 @@ void mlx4_unregister_device(struct mlx4_dev *dev)
 
 	mutex_unlock(&intf_mutex);
 }
+
+void *mlx4_find_get_prot_dev(struct mlx4_dev *dev, enum mlx4_prot proto, int port)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_device_context *dev_ctx;
+	unsigned long flags;
+	void *result = NULL;
+
+	spin_lock_irqsave(&priv->ctx_lock, flags);
+
+	list_for_each_entry(dev_ctx, &priv->ctx_list, list)
+		if (dev_ctx->intf->protocol == proto && dev_ctx->intf->get_prot_dev) {
+			result = dev_ctx->intf->get_prot_dev(dev, dev_ctx->context, port);
+			break;
+	}
+
+	spin_unlock_irqrestore(&priv->ctx_lock, flags);
+
+	return result;
+}
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 38fbf01..f14f0d6 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -105,6 +105,12 @@ static int log_mtts_per_seg = ilog2(MLX4_MTT_ENTRY_PER_SEG);
 module_param_named(log_mtts_per_seg, log_mtts_per_seg, int, 0444);
 MODULE_PARM_DESC(log_mtts_per_seg, "Log2 number of MTT entries per segment (1-5)");
 
+void *mlx4_get_prot_dev(struct mlx4_dev *dev, enum mlx4_prot proto, int port)
+{
+	return mlx4_find_get_prot_dev(dev, proto, port);
+}
+EXPORT_SYMBOL(mlx4_get_prot_dev);
+
 int mlx4_check_port_params(struct mlx4_dev *dev,
 			   enum mlx4_port_type *port_type)
 {
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 416aeca..9c62019 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -364,6 +364,7 @@ int mlx4_restart_one(struct pci_dev *pdev);
 int mlx4_register_device(struct mlx4_dev *dev);
 void mlx4_unregister_device(struct mlx4_dev *dev);
 void mlx4_dispatch_event(struct mlx4_dev *dev, enum mlx4_dev_event type, int port);
+void *mlx4_find_get_prot_dev(struct mlx4_dev *dev, enum mlx4_prot proto, int port);
 
 struct mlx4_dev_cap;
 struct mlx4_init_hca_param;
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
index 55b45a6..94c9617 100644
--- a/include/linux/mlx4/driver.h
+++ b/include/linux/mlx4/driver.h
@@ -49,17 +49,27 @@ enum mlx4_query_reply {
 	MLX4_QUERY_MINE_NOPORT 	= 0
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
+	void *  (*get_prot_dev) (struct mlx4_dev *dev, void *context, u8 port);
+	enum mlx4_prot          protocol;
+
 	enum mlx4_query_reply	(*query) (void *context, void *);
 	struct list_head	list;
 };
 
 int mlx4_register_interface(struct mlx4_interface *intf);
 void mlx4_unregister_interface(struct mlx4_interface *intf);
+void *mlx4_get_prot_dev(struct mlx4_dev *dev, enum mlx4_prot proto, int port);
+
 struct mlx4_dev *mlx4_query_interface(void *, int *port);
 
 #endif /* MLX4_DRIVER_H */

--------------010401050606070409040907
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------010401050606070409040907--
