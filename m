From: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband: hw: cxgb4: Use AF_INET for sin_family field
Date: Sat, 24 Dec 2016 07:14:35 +0530
Message-ID: <1482543875-17141-1-git-send-email-mayhs11saini@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Elsewhere the sin_family field holds a value with a name of the form
AF_..., so it seems reasonable to do so here as well.  Also the values
of PF_INET and AF_INET are the same.

The semantic patch that makes this change is as follows:

//</smpl>
@@
struct sockaddr_in sip;
@@

(
sip.sin_family ==
- PF_INET
+ AF_INET
|
sip.sin_family !=
- PF_INET
+ AF_INET
|
sip.sin_family =
- PF_INET
+ AF_INET
)
//</smpl>

Signed-off-by: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index f1510cc..9749c52 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2516,18 +2516,18 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 		struct sockaddr_in *sin = (struct sockaddr_in *)
 			&child_ep->com.local_addr;
 
-		sin->sin_family = PF_INET;
+		sin->sin_family = AF_INET;
 		sin->sin_port = local_port;
 		sin->sin_addr.s_addr = *(__be32 *)local_ip;
 
 		sin = (struct sockaddr_in *)&child_ep->com.local_addr;
-		sin->sin_family = PF_INET;
+		sin->sin_family = AF_INET;
 		sin->sin_port = ((struct sockaddr_in *)
 				 &parent_ep->com.local_addr)->sin_port;
 		sin->sin_addr.s_addr = *(__be32 *)local_ip;
 
 		sin = (struct sockaddr_in *)&child_ep->com.remote_addr;
-		sin->sin_family = PF_INET;
+		sin->sin_family = AF_INET;
 		sin->sin_port = peer_port;
 		sin->sin_addr.s_addr = *(__be32 *)peer_ip;
 	} else {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
