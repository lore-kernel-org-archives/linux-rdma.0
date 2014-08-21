From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 2/7] IB/mlx4: Don't duplicate the default RoCE GID
Date: Thu, 21 Aug 2014 14:28:38 +0300
Message-ID: <1408620523-10616-3-git-send-email-ogerlitz@mellanox.com>
References: <1408620523-10616-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408620523-10616-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When reading the IPv6 addresses from the net-device, make sure to avoid
adding duplicate entry to the GID table as of equality between the default
GID we generate to the default IPv6 link-local address of the device.

Fixes: acc4fcc ('IB/mlx4: Make sure GID index 0 is always occupied')
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index a6a9e57..61910f4 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1676,6 +1676,7 @@ static void mlx4_ib_get_dev_addr(struct net_device *dev,
 	struct inet6_dev *in6_dev;
 	union ib_gid  *pgid;
 	struct inet6_ifaddr *ifp;
+	union ib_gid default_gid;
 #endif
 	union ib_gid gid;
 
@@ -1696,12 +1697,15 @@ static void mlx4_ib_get_dev_addr(struct net_device *dev,
 		in_dev_put(in_dev);
 	}
 #if IS_ENABLED(CONFIG_IPV6)
+	mlx4_make_default_gid(dev, &default_gid);
 	/* IPv6 gids */
 	in6_dev = in6_dev_get(dev);
 	if (in6_dev) {
 		read_lock_bh(&in6_dev->lock);
 		list_for_each_entry(ifp, &in6_dev->addr_list, if_list) {
 			pgid = (union ib_gid *)&ifp->addr;
+			if (!memcmp(pgid, &default_gid, sizeof(*pgid)))
+				continue;
 			update_gid_table(ibdev, port, pgid, 0, 0);
 		}
 		read_unlock_bh(&in6_dev->lock);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
