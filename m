From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 3/3] IB/core: Fix possible deadlock in write_gid
Date: Mon,  3 Aug 2015 16:09:02 +0300
Message-ID: <1438607342-11964-4-git-send-email-matanb@mellanox.com>
References: <1438607342-11964-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438607342-11964-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixing the possible deadlock in write_gid:
write_gid -> write_lock()
<interrupt>
	find_gid -> read_lock_irqsave()
		    ** DEAD LOCK **LOCK

Fixing it by changing the write_lock to write_lock_irqsave.

Squash-into: 'IB/core: Add RoCE GID table management'
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 58a44bd..d7fdcb7 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -121,15 +121,16 @@ static int write_gid(struct ib_device *ib_dev, u8 port,
 {
 	int ret = 0;
 	struct net_device *old_net_dev;
+	unsigned long flags;
 
 	/* in rdma_cap_roce_gid_table, this funciton should be protected by a
 	 * sleep-able lock.
 	 */
-	write_lock(&table->data_vec[ix].lock);
+	write_lock_irqsave(&table->data_vec[ix].lock, flags);
 
 	if (rdma_cap_roce_gid_table(ib_dev, port)) {
 		table->data_vec[ix].props |= GID_TABLE_ENTRY_INVALID;
-		write_unlock(&table->data_vec[ix].lock);
+		write_unlock_irqrestore(&table->data_vec[ix].lock, flags);
 		/* GID_TABLE_WRITE_ACTION_MODIFY currently isn't supported by
 		 * RoCE providers and thus only updates the cache.
 		 */
@@ -139,7 +140,7 @@ static int write_gid(struct ib_device *ib_dev, u8 port,
 		else if (action == GID_TABLE_WRITE_ACTION_DEL)
 			ret = ib_dev->del_gid(ib_dev, port, ix,
 					      &table->data_vec[ix].context);
-		write_lock(&table->data_vec[ix].lock);
+		write_lock_irqsave(&table->data_vec[ix].lock, flags);
 	}
 
 	old_net_dev = table->data_vec[ix].attr.ndev;
@@ -161,7 +162,7 @@ static int write_gid(struct ib_device *ib_dev, u8 port,
 
 	table->data_vec[ix].props &= ~GID_TABLE_ENTRY_INVALID;
 
-	write_unlock(&table->data_vec[ix].lock);
+	write_unlock_irqrestore(&table->data_vec[ix].lock, flags);
 
 	if (!ret && rdma_cap_roce_gid_table(ib_dev, port)) {
 		struct ib_event event;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
