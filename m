From: Christoph Paasch <christoph.paasch-MkR3pAKDJcQFHpyHPIa6Kw@public.gmane.org>
Subject: [PATCH] cxgb4: Remove duplicate tcp-options clearing
Date: Tue, 24 Jun 2014 13:34:02 +0200
Message-ID: <1403609642-27757-1-git-send-email-christoph.paasch@uclouvain.be>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

tmp_opt is memset to 0. Thus, no need for another call to
tcp_clear_options which simply sets some fields explicitly to 0 again.

Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Christoph Paasch <christoph.paasch-MkR3pAKDJcQFHpyHPIa6Kw@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 96d7131ab974..2106a6dc62b3 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3326,7 +3326,6 @@ static void build_cpl_pass_accept_req(struct sk_buff *skb, int stid , u8 tos)
 	 * to generate cpl_pass_accept_req.
 	 */
 	memset(&tmp_opt, 0, sizeof(tmp_opt));
-	tcp_clear_options(&tmp_opt);
 	tcp_parse_options(skb, &tmp_opt, 0, NULL);
 
 	req = (struct cpl_pass_accept_req *)__skb_push(skb, sizeof(*req));
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
