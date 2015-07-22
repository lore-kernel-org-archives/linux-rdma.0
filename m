From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 12/43] RDS: Convert to ib_alloc_mr
Date: Wed, 22 Jul 2015 09:55:12 +0300
Message-ID: <1437548143-24893-13-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 net/rds/iw_rdma.c | 5 +++--
 net/rds/iw_send.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/rds/iw_rdma.c b/net/rds/iw_rdma.c
index dba8d08..dac0131 100644
--- a/net/rds/iw_rdma.c
+++ b/net/rds/iw_rdma.c
@@ -667,11 +667,12 @@ static int rds_iw_init_fastreg(struct rds_iw_mr_pool *pool,
 	struct ib_mr *mr;
 	int err;
 
-	mr = ib_alloc_fast_reg_mr(rds_iwdev->pd, pool->max_message_size);
+	mr = ib_alloc_mr(rds_iwdev->pd, IB_MR_TYPE_FAST_REG,
+			 pool->max_message_size, 0);
 	if (IS_ERR(mr)) {
 		err = PTR_ERR(mr);
 
-		printk(KERN_WARNING "RDS/IW: ib_alloc_fast_reg_mr failed (err=%d)\n", err);
+		printk(KERN_WARNING "RDS/IW: ib_alloc_mr failed (err=%d)\n", err);
 		return err;
 	}
 
diff --git a/net/rds/iw_send.c b/net/rds/iw_send.c
index 334fe98..0d8e74b 100644
--- a/net/rds/iw_send.c
+++ b/net/rds/iw_send.c
@@ -153,9 +153,10 @@ void rds_iw_send_init_ring(struct rds_iw_connection *ic)
 		sge->length = sizeof(struct rds_header);
 		sge->lkey = 0;
 
-		send->s_mr = ib_alloc_fast_reg_mr(ic->i_pd, fastreg_message_size);
+		send->s_mr = ib_alloc_mr(ic->i_pd, IB_MR_TYPE_FAST_REG,
+					 fastreg_message_size, 0);
 		if (IS_ERR(send->s_mr)) {
-			printk(KERN_WARNING "RDS/IW: ib_alloc_fast_reg_mr failed\n");
+			printk(KERN_WARNING "RDS/IW: ib_alloc_mr failed\n");
 			break;
 		}
 
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
