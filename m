From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv7 8/9] mlx4: Allow interfaces to correspond to each other
Date: Tue, 5 Jan 2010 12:33:31 +0200
Message-ID: <20100105103331.GJ31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a mechanism for mlx4 core interfaces to get a pointer to other interfaces'
device object. For this, an exported function, mlx4_get_prot_dev() is added,
which allows an interfaces to get some other interface's device based on the
protocol that interface implements. Two new protocols are added, MLX4_PROT_IB
and MLX4_PROT_EN. This comes as a preperation for RoCEE so that mlx4_ib will be
able to refer to the corresponding en device.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/en_main.c  |   15 ++++++++++++---
 drivers/net/mlx4/intf.c     |   20 ++++++++++++++++++++
 drivers/net/mlx4/main.c     |    6 ++++++
 drivers/net/mlx4/mlx4.h     |    1 +
 include/linux/mlx4/driver.h |   16 ++++++++++++----
 5 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/drivers/net/mlx4/en_main.c b/drivers/net/mlx4/en_main.c
index 507e11f..00e72b3 100644
--- a/drivers/net/mlx4/en_main.c
+++ b/drivers/net/mlx4/en_main.c
@@ -100,6 +100,13 @@ static int mlx4_en_get_profile(struct mlx4_en_dev *mdev)
 	return 0;
 }
 
+static void *get_netdev(struct mlx4_dev *dev, void *ctx, u8 port)
+{
+	struct mlx4_en_dev *endev = ctx;
+
+	return endev->pndev[port];
+}
+
 static void mlx4_en_event(struct mlx4_dev *dev, void *endev_ptr,
 			  enum mlx4_dev_event event, int port)
 {
@@ -262,9 +269,11 @@ err_free_res:
 }
 
 static struct mlx4_interface mlx4_en_interface = {
-	.add	= mlx4_en_add,
-	.remove	= mlx4_en_remove,
-	.event	= mlx4_en_event,
+	.add		= mlx4_en_add,
+	.remove		= mlx4_en_remove,
+	.event		= mlx4_en_event,
+	.get_prot_dev	= get_netdev,
+	.protocol	= MLX4_PROT_EN,
 };
 
 static int __init mlx4_en_init(void)
diff --git a/drivers/net/mlx4/intf.c b/drivers/net/mlx4/intf.c
index 0e7eb10..d64530e 100644
--- a/drivers/net/mlx4/intf.c
+++ b/drivers/net/mlx4/intf.c
@@ -159,3 +159,23 @@ void mlx4_unregister_device(struct mlx4_dev *dev)
 
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
+		}
+
+	spin_unlock_irqrestore(&priv->ctx_lock, flags);
+
+	return result;
+}
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 291a505..2407396 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -104,6 +104,12 @@ static int log_mtts_per_seg = ilog2(MLX4_MTT_ENTRY_PER_SEG);
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
index bc72d6e..ab63445 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -362,6 +362,7 @@ int mlx4_restart_one(struct pci_dev *pdev);
 int mlx4_register_device(struct mlx4_dev *dev);
 void mlx4_unregister_device(struct mlx4_dev *dev);
 void mlx4_dispatch_event(struct mlx4_dev *dev, enum mlx4_dev_event type, int port);
+void *mlx4_find_get_prot_dev(struct mlx4_dev *dev, enum mlx4_prot proto, int port);
 
 struct mlx4_dev_cap;
 struct mlx4_init_hca_param;
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
index 53c5fdb..0083256 100644
--- a/include/linux/mlx4/driver.h
+++ b/include/linux/mlx4/driver.h
@@ -44,15 +44,23 @@ enum mlx4_dev_event {
 	MLX4_DEV_EVENT_PORT_REINIT,
 };
 
+enum mlx4_prot {
+	MLX4_PROT_IB,
+	MLX4_PROT_EN,
+};
+
 struct mlx4_interface {
-	void *			(*add)	 (struct mlx4_dev *dev);
-	void			(*remove)(struct mlx4_dev *dev, void *context);
-	void			(*event) (struct mlx4_dev *dev, void *context,
-					  enum mlx4_dev_event event, int port);
+	void *	(*add)	 (struct mlx4_dev *dev);
+	void   	(*remove)(struct mlx4_dev *dev, void *context);
+	void   	(*event) (struct mlx4_dev *dev, void *context,
+			  enum mlx4_dev_event event, int port);
+	void *	(*get_prot_dev) (struct mlx4_dev *dev, void *context, u8 port);
+	enum mlx4_prot		protocol;
 	struct list_head	list;
 };
 
 int mlx4_register_interface(struct mlx4_interface *intf);
 void mlx4_unregister_interface(struct mlx4_interface *intf);
+void *mlx4_get_prot_dev(struct mlx4_dev *dev, enum mlx4_prot proto, int port);
 
 #endif /* MLX4_DRIVER_H */
-- 
1.6.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
