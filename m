From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-4.5] iw_cxgb4: Take clip reference first, before creating IPv6 listening servers
Date: Wed, 13 Jan 2016 10:03:14 +0530
Message-ID: <1452659594-7875-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The h/w is designed in such a way that, if you do anything IPv6
related, a valid clip entry must be there. So take clip reference
before creating IPv6 listening servers, and then if we fail to
create server, release the clip entry.

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index c9cffced00ca..704680471567 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3271,6 +3271,12 @@ static int create_server6(struct c4iw_dev *dev, struct c4iw_listen_ep *ep)
 	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)
 				    &ep->com.mapped_local_addr;
 
+	if (ipv6_addr_type(&sin6->sin6_addr) != IPV6_ADDR_ANY) {
+		err = cxgb4_clip_get(ep->com.dev->rdev.lldi.ports[0],
+				     (const u32 *)&sin6->sin6_addr.s6_addr, 1);
+		if (err)
+			return err;
+	}
 	c4iw_init_wr_wait(&ep->com.wr_wait);
 	err = cxgb4_create_server6(ep->com.dev->rdev.lldi.ports[0],
 				   ep->stid, &sin6->sin6_addr,
@@ -3282,13 +3288,13 @@ static int create_server6(struct c4iw_dev *dev, struct c4iw_listen_ep *ep)
 					  0, 0, __func__);
 	else if (err > 0)
 		err = net_xmit_errno(err);
-	if (err)
+	if (err) {
+		cxgb4_clip_release(ep->com.dev->rdev.lldi.ports[0],
+				   (const u32 *)&sin6->sin6_addr.s6_addr, 1);
 		pr_err("cxgb4_create_server6/filter failed err %d stid %d laddr %pI6 lport %d\n",
 		       err, ep->stid,
 		       sin6->sin6_addr.s6_addr, ntohs(sin6->sin6_port));
-	else
-		cxgb4_clip_get(ep->com.dev->rdev.lldi.ports[0],
-			       (const u32 *)&sin6->sin6_addr.s6_addr, 1);
+	}
 	return err;
 }
 
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
