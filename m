From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH/RFC] mlx4_core: Clean up error flow in mlx4_register_mac()
Date: Tue, 20 Sep 2011 00:53:47 -0700
Message-ID: <1316505227-6031-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Fix a leak of entry if radix_tree_insert() fails.

Also, reduce the indentation and make the flow easier to read by
sticking to the conventional

    err = do_something();
    if (err)
            return err;

    err = do_another();
    if (err)
            return err;

rather than mixing the direction of the test as

    err = do_something();
    if (!err) {
            err = do_another();
            if (err)
                    return err;
    } else
            return err;

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/net/mlx4/port.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/mlx4/port.c b/drivers/net/mlx4/port.c
index 609e0ec..ef10113 100644
--- a/drivers/net/mlx4/port.c
+++ b/drivers/net/mlx4/port.c
@@ -148,22 +148,26 @@ int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *qpn, u8 wrap)
 
 	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_UC_STEER) {
 		err = mlx4_uc_steer_add(dev, port, mac, qpn, 1);
-		if (!err) {
-			entry = kmalloc(sizeof *entry, GFP_KERNEL);
-			if (!entry) {
-				mlx4_uc_steer_release(dev, port, mac, *qpn, 1);
-				return -ENOMEM;
-			}
-			entry->mac = mac;
-			err = radix_tree_insert(&info->mac_tree, *qpn, entry);
-			if (err) {
-				mlx4_uc_steer_release(dev, port, mac, *qpn, 1);
-				return err;
-			}
-		} else
+		if (err)
 			return err;
+
+		entry = kmalloc(sizeof *entry, GFP_KERNEL);
+		if (!entry) {
+			mlx4_uc_steer_release(dev, port, mac, *qpn, 1);
+			return -ENOMEM;
+		}
+
+		entry->mac = mac;
+		err = radix_tree_insert(&info->mac_tree, *qpn, entry);
+		if (err) {
+			kfree(entry);
+			mlx4_uc_steer_release(dev, port, mac, *qpn, 1);
+			return err;
+		}
 	}
+
 	mlx4_dbg(dev, "Registering MAC: 0x%llx\n", (unsigned long long) mac);
+
 	mutex_lock(&table->mutex);
 	for (i = 0; i < MLX4_MAX_MAC_NUM - 1; i++) {
 		if (free < 0 && !table->refs[i]) {
-- 
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
