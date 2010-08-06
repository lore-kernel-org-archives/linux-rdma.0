From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 02/10] api to query mlx4_en device for given mlx4
	device
Date: Fri, 06 Aug 2010 15:50:01 -0700
Message-ID: <4C5C9199.8060901@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050606070501050400040004"
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
--------------050606070501050400040004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

mlx4_en: Add API to query interfaces for given internal device

Updated mlx4_en interface to provide a query function for it's
internal net_device structure.

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>
        
 drivers/net/mlx4/en_main.c  |   14 ++++++++++++++
 drivers/net/mlx4/intf.c     |   30 ++++++++++++++++++++++++++++++
 include/linux/mlx4/driver.h |    7 +++++++
 3 files changed, 51 insertions(+), 0 deletions(-)
 

--------------050606070501050400040004
Content-Type: text/x-patch;
 name="mlx4_fc_0002_query_internal_dev.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mlx4_fc_0002_query_internal_dev.patch"

mlx4: Add API to query interfaces for given internal device

Updated mlx4_en interface to provide a query function for it's
internal net_device structure.

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>

 drivers/net/mlx4/en_main.c  |   14 ++++++++++++++
 drivers/net/mlx4/intf.c     |   30 ++++++++++++++++++++++++++++++
 include/linux/mlx4/driver.h |    7 +++++++
 3 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/en_main.c b/drivers/net/mlx4/en_main.c
index cbabf14..6fce433 100644
--- a/drivers/net/mlx4/en_main.c
+++ b/drivers/net/mlx4/en_main.c
@@ -262,10 +262,24 @@ err_free_res:
 	return NULL;
 }
 
+enum mlx4_query_reply mlx4_en_query(void *endev_ptr, void *int_dev)
+{
+	struct mlx4_en_dev *mdev = endev_ptr;
+	struct net_device *netdev = int_dev;
+	int p;
+	
+	for (p = 1; p <= MLX4_MAX_PORTS; ++p)
+		if (mdev->pndev[p] == netdev)
+			return p;
+
+	return MLX4_QUERY_NOT_MINE;
+}
+
 static struct mlx4_interface mlx4_en_interface = {
 	.add	= mlx4_en_add,
 	.remove	= mlx4_en_remove,
 	.event	= mlx4_en_event,
+	.query  = mlx4_en_query
 };
 
 static int __init mlx4_en_init(void)
diff --git a/drivers/net/mlx4/intf.c b/drivers/net/mlx4/intf.c
index 5550678..beeed80 100644
--- a/drivers/net/mlx4/intf.c
+++ b/drivers/net/mlx4/intf.c
@@ -114,6 +114,36 @@ void mlx4_unregister_interface(struct mlx4_interface *intf)
 }
 EXPORT_SYMBOL_GPL(mlx4_unregister_interface);
 
+struct mlx4_dev *mlx4_query_interface(void *int_dev, int *port)
+{
+	struct mlx4_priv *priv;
+	struct mlx4_device_context *dev_ctx;
+	enum mlx4_query_reply r;
+	unsigned long flags;
+
+	mutex_lock(&intf_mutex);
+
+	list_for_each_entry(priv, &dev_list, dev_list) {
+		spin_lock_irqsave(&priv->ctx_lock, flags);
+		list_for_each_entry(dev_ctx, &priv->ctx_list, list) {
+			if (!dev_ctx->intf->query)
+				continue;
+			r = dev_ctx->intf->query(dev_ctx->context, int_dev);
+			if (r != MLX4_QUERY_NOT_MINE) {
+				*port = r;
+				spin_unlock_irqrestore(&priv->ctx_lock, flags);
+				mutex_unlock(&intf_mutex);
+				return &priv->dev;
+			}
+		}
+		spin_unlock_irqrestore(&priv->ctx_lock, flags);
+	}
+
+	mutex_unlock(&intf_mutex);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(mlx4_query_interface);
+
 void mlx4_dispatch_event(struct mlx4_dev *dev, enum mlx4_dev_event type, int port)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
index 53c5fdb..55b45a6 100644
--- a/include/linux/mlx4/driver.h
+++ b/include/linux/mlx4/driver.h
@@ -44,15 +44,22 @@ enum mlx4_dev_event {
 	MLX4_DEV_EVENT_PORT_REINIT,
 };
 
+enum mlx4_query_reply {
+	MLX4_QUERY_NOT_MINE	= -1,
+	MLX4_QUERY_MINE_NOPORT 	= 0
+};
+
 struct mlx4_interface {
 	void *			(*add)	 (struct mlx4_dev *dev);
 	void			(*remove)(struct mlx4_dev *dev, void *context);
 	void			(*event) (struct mlx4_dev *dev, void *context,
 					  enum mlx4_dev_event event, int port);
+	enum mlx4_query_reply	(*query) (void *context, void *);
 	struct list_head	list;
 };
 
 int mlx4_register_interface(struct mlx4_interface *intf);
 void mlx4_unregister_interface(struct mlx4_interface *intf);
+struct mlx4_dev *mlx4_query_interface(void *, int *port);
 
 #endif /* MLX4_DRIVER_H */

--------------050606070501050400040004
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------050606070501050400040004--
