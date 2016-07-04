From: Amitoj Kaur Chawla <amitoj1606-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/cxgb3: Use AF_INET for sin_family field
Date: Mon, 4 Jul 2016 18:27:45 +0530
Message-ID: <20160704125744.GA16796@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: julia.lawall-L2FTfq7BK8M@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Elsewhere the sin_family field holds a value with a name of the form
AF_..., so it seems reasonable to do so here as well.  Also the values
of PF_INET and AF_INET are the same.

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
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
// </smpl>

Signed-off-by: Amitoj Kaur Chawla <amitoj1606-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 3e8431b..04bbf17 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1396,10 +1396,10 @@ static int pass_accept_req(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	state_set(&child_ep->com, CONNECTING);
 	child_ep->com.tdev = tdev;
 	child_ep->com.cm_id = NULL;
-	child_ep->com.local_addr.sin_family = PF_INET;
+	child_ep->com.local_addr.sin_family = AF_INET;
 	child_ep->com.local_addr.sin_port = req->local_port;
 	child_ep->com.local_addr.sin_addr.s_addr = req->local_ip;
-	child_ep->com.remote_addr.sin_family = PF_INET;
+	child_ep->com.remote_addr.sin_family = AF_INET;
 	child_ep->com.remote_addr.sin_port = req->peer_port;
 	child_ep->com.remote_addr.sin_addr.s_addr = req->peer_ip;
 	get_ep(&parent_ep->com);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
