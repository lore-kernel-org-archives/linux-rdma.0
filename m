From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/core: Eliminate sparse false positive warning on context imbalance
Date: Wed, 30 Dec 2015 16:14:17 +0200
Message-ID: <1451484858-1530-2-git-send-email-matanb@mellanox.com>
References: <1451484858-1530-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451484858-1530-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When write_gid function needs to do a sleep-able operation, it unlocks
table->rwlock and then relocks it. Sparse complains about context
imbalance.

This is safe as write_gid is always called with table->rwlock.
write_gid protects from simultaneous writes to this GID entry
by setting the GID_TABLE_ENTRY_INVALID flag.

Fixes: 9c584f049596 ('IB/core: Change per-entry lock in RoCE GID table to
		     one lock')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
Hi Doug,

This patch eliminates a sparse false-positive warning about context
imbalance. We use __releases and __acquires in order to do so.

Regards,
Matan

 drivers/infiniband/core/cache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 92cadbd..53343ff 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -174,6 +174,7 @@ static int write_gid(struct ib_device *ib_dev, u8 port,
 		     const struct ib_gid_attr *attr,
 		     enum gid_table_write_action action,
 		     bool  default_gid)
+	__releases(&table->rwlock) __acquires(&table->rwlock)
 {
 	int ret = 0;
 	struct net_device *old_net_dev;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
