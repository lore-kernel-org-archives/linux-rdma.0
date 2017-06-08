From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/5] RDMA/netlink: Remove redundant owner option for netlink callbacks
Date: Thu,  8 Jun 2017 17:38:49 +0300
Message-ID: <20170608143852.9072-3-leon@kernel.org>
References: <20170608143852.9072-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170608143852.9072-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Owner field is not needed to be set because netlink is part of ib_core
which will be unloaded last after all other modules are unloaded.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c     | 3 +--
 drivers/infiniband/core/netlink.c | 2 --
 include/rdma/rdma_netlink.h       | 1 -
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d7e29d86469b..a4013b0908e2 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4478,8 +4478,7 @@ static int cma_get_id_stats(struct sk_buff *skb, struct netlink_callback *cb)
 }

 static const struct ibnl_client_cbs cma_cb_table[] = {
-	[RDMA_NL_RDMA_CM_ID_STATS] = { .dump = cma_get_id_stats,
-				       .module = THIS_MODULE },
+	[RDMA_NL_RDMA_CM_ID_STATS] = { .dump = cma_get_id_stats},
 };

 static int cma_init_net(struct net *net)
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 976562b88637..fd9c782dc32d 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -173,12 +173,10 @@ static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		cb.skb = skb;
 		cb.nlh = nlh;
 		cb.dump = rdma_nl_types[index].cb_table[op].dump;
-		cb.module = rdma_nl_types[index].cb_table[op].module;
 		return cb.dump(skb, &cb);
 	}

 	c.dump = rdma_nl_types[index].cb_table[op].dump;
-	c.module = rdma_nl_types[index].cb_table[op].module;
 	return netlink_dump_start(nls, skb, nlh, &c);
 }

diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index 6735dcf5d2a3..761517105a36 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -7,7 +7,6 @@

 struct ibnl_client_cbs {
 	int (*dump)(struct sk_buff *skb, struct netlink_callback *nlcb);
-	struct module *module;
 };

 int rdma_nl_init(void);
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
