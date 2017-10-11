From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 09/45] RDMA/cxgb3: Annotate an RCU pointer
Date: Wed, 11 Oct 2017 10:48:51 -0700
Message-ID: <20171011174927.25113-10-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Annotate t3cdev.l2opt with __rcu since it is used as an RCU pointer.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/net/ethernet/chelsio/cxgb3/t3cdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/t3cdev.h b/drivers/net/ethernet/chelsio/cxgb3/t3cdev.h
index 705713b56636..3c3e6cf6aca6 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/t3cdev.h
+++ b/drivers/net/ethernet/chelsio/cxgb3/t3cdev.h
@@ -60,7 +60,7 @@ struct t3cdev {
 	int (*ctl)(struct t3cdev *dev, unsigned int req, void *data);
 	void (*neigh_update)(struct t3cdev *dev, struct neighbour *neigh);
 	void *priv;		/* driver private data */
-	void *l2opt;		/* optional layer 2 data */
+	void __rcu *l2opt;	/* optional layer 2 data */
 	void *l3opt;		/* optional layer 3 data */
 	void *l4opt;		/* optional layer 4 data */
 	void *ulp;		/* ulp stuff */
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
