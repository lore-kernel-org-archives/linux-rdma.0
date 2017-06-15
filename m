From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/5] IB/rxe: Use "foo *bar" instead of "foo * bar"
Date: Thu, 15 Jun 2017 11:29:03 +0300
Message-ID: <20170615082907.5658-2-leon@kernel.org>
References: <20170615082907.5658-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170615082907.5658-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalheib1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamal Heib <kamalheib1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.h b/drivers/infiniband/sw/rxe/rxe.h
index ecdba2fce083..40ff6b23ddbc 100644
--- a/drivers/infiniband/sw/rxe/rxe.h
+++ b/drivers/infiniband/sw/rxe/rxe.h
@@ -94,7 +94,7 @@ int rxe_rcv(struct sk_buff *skb);
 
 void rxe_dev_put(struct rxe_dev *rxe);
 struct rxe_dev *net_to_rxe(struct net_device *ndev);
-struct rxe_dev *get_rxe_by_name(const char* name);
+struct rxe_dev *get_rxe_by_name(const char *name);
 
 void rxe_port_up(struct rxe_dev *rxe);
 void rxe_port_down(struct rxe_dev *rxe);
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
