From: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Subject: [PATCH] IB/usnic: delete unneeded IS_ERR test
Date: Sat, 19 Dec 2015 21:48:59 +0100
Message-ID: <1450558139-466-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

kzalloc doesn't return ERR_PTR, so there is no need to test for it.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,e;
@@

* x = kzalloc(...)
... when != x = e
* IS_ERR_OR_NULL(x)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>

---
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index f8e3211..20f53e5 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -625,8 +625,8 @@ struct ib_mr *usnic_ib_reg_mr(struct ib_pd *pd, u64 start, u64 length,
 			virt_addr, length);
 
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (IS_ERR_OR_NULL(mr))
-		return ERR_PTR(mr ? PTR_ERR(mr) : -ENOMEM);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
 
 	mr->umem = usnic_uiom_reg_get(to_upd(pd)->umem_pd, start, length,
 					access_flags, 0);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
