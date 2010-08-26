From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv10 07/12] mlx4: Allow interfaces to correspond to each other
Date: Thu, 26 Aug 2010 17:18:43 +0300
Message-ID: <20100826141843.GH8795@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a mechanism for mlx4 core interfaces to get a pointer to other interfaces'
device object. For this, an exported function, mlx4_get_prot_dev() is added,
which allows an interfaces to get some other interface's device based on the
protocol that interface implements. Two new protocols are added, MLX4_PROT_IB
and MLX4_PROT_EN. This comes as a preperation for IBoE so that mlx4_ib will be
able to refer to the corresponding en device.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/en_main.c  |   15 ++++++++++++---
 drivers/net/mlx4/intf.c     |   21 +++++++++++++++++++++
 drivers/net/mlx4/mlx4.h     |    1 +
 include/linux/mlx4/driver.h |   16 ++++++++++++----
 4 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/drivers/net/mlx4/en_main.c b/drivers/net/mlx4/en_main.c
index cbabf14..93e0239 100644
--- a/drivers/net/mlx4/en_main.c
+++ b/drivers/net/mlx4/en_main.c
@@ -101,6 +101,13 @@ static int mlx4_en_get_profile(struct mlx4_en_dev *mdev)
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
@@ -263,9 +270,11 @@ err_free_res:
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
index 5550678..70d67bc 100644
--- a/drivers/net/mlx4/intf.c
+++ b/drivers/net/mlx4/intf.c
@@ -161,3 +161,24 @@ void mlx4_unregister_device(struct mlx4_dev *dev)
 
 	mutex_unlock(&intf_mutex);
 }
+
+void *mlx4_get_prot_dev(struct mlx4_dev *dev, enum mlx4_prot proto, int port)
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
+EXPORT_SYMBOL(mlx4_get_prot_dev);
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 13343e8..4dcf567 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -363,6 +363,7 @@ int mlx4_restart_one(struct pci_dev *pdev);
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
1.7.2.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
