From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/3] IB/core: Refactor GID cache's ib_dispatch_event
Date: Wed, 28 Oct 2015 16:52:39 +0200
Message-ID: <1446043961-17667-2-git-send-email-matanb@mellanox.com>
References: <1446043961-17667-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446043961-17667-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Refactor ib_dispatch_event into a new function in order to avoid
duplicating code in the next patch.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 89bebea..f0703d2 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -112,6 +112,19 @@ struct ib_gid_table {
 	struct ib_gid_table_entry *data_vec;
 };
 
+static void dispatch_gid_change_event(struct ib_device *ib_dev, u8 port)
+{
+	if (rdma_cap_roce_gid_table(ib_dev, port)) {
+		struct ib_event event;
+
+		event.device		= ib_dev;
+		event.element.port_num	= port;
+		event.event		= IB_EVENT_GID_CHANGE;
+
+		ib_dispatch_event(&event);
+	}
+}
+
 static int write_gid(struct ib_device *ib_dev, u8 port,
 		     struct ib_gid_table *table, int ix,
 		     const union ib_gid *gid,
@@ -164,15 +177,9 @@ static int write_gid(struct ib_device *ib_dev, u8 port,
 
 	write_unlock_irqrestore(&table->data_vec[ix].lock, flags);
 
-	if (!ret && rdma_cap_roce_gid_table(ib_dev, port)) {
-		struct ib_event event;
+	if (!ret)
+		dispatch_gid_change_event(ib_dev, port);
 
-		event.device		= ib_dev;
-		event.element.port_num	= port;
-		event.event		= IB_EVENT_GID_CHANGE;
-
-		ib_dispatch_event(&event);
-	}
 	return ret;
 }
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
