From: Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH] 9p/rdma: do not disconnect on down_interruptible EAGAIN
Date: Thu, 30 Aug 2018 12:35:07 +0200
Message-ID: <1535625307-18019-1-git-send-email-asmadeus@codewreck.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Van Hensbergen <ericvh@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>
Cc: Dominique Martinet <dominique.martinet@cea.fr>, v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Dominique Martinet <dominique.martinet@cea.fr>

9p/rdma would sometimes drop the connection and display errors in
recv_done when the user does ^C.
The errors were IB_WC_WR_FLUSH_ERR caused by recv buffers that were
posted at the time of disconnect, and we just do not want to disconnect
when down_interruptible is... interrupted.

As a bonus, re-evaluate the log importance of post_recv() failing: we
want to see that one if it ever happens.

Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
---

this had actually been bugging me forever, but I couldn't test the refcount
stuff properly around flush with that so I had to finally figure it out..

 net/9p/trans_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 9cc9b3a19ee7..9719bc4d9424 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -477,7 +477,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 
 	err = post_recv(client, rpl_context);
 	if (err) {
-		p9_debug(P9_DEBUG_FCALL, "POST RECV failed\n");
+		p9_debug(P9_DEBUG_ERROR, "POST RECV failed: %d\n", err);
 		goto recv_error;
 	}
 	/* remove posted receive buffer from request structure */
@@ -546,7 +546,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
  recv_error:
 	kfree(rpl_context);
 	spin_lock_irqsave(&rdma->req_lock, flags);
-	if (rdma->state < P9_RDMA_CLOSING) {
+	if (err != -EINTR && rdma->state < P9_RDMA_CLOSING) {
 		rdma->state = P9_RDMA_CLOSING;
 		spin_unlock_irqrestore(&rdma->req_lock, flags);
 		rdma_disconnect(rdma->cm_id);
-- 
2.17.1
