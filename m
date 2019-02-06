From: Raju Rangoju <rajur@chelsio.com>
Subject: [PATCH 3/3] iw_cxgb4: fix srqidx leak during connection abort
Date: Wed,  6 Feb 2019 22:54:44 +0530
Message-ID: <20190206172444.21997-4-rajur@chelsio.com>
References: <20190206172444.21997-1-rajur@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190206172444.21997-1-rajur@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: jgg@mellanox.com, davem@davemloft.net, linux-rdma@vger.kernel.org
Cc: netdev@vger.kernel.org, swise@opengridcomputing.com, rajur@chelsio.com
List-Id: linux-rdma@vger.kernel.org

When an application aborts the connection by moving QP from RTS to
ERROR, then iw_cxgb4's modify_rc_qp() RTS->ERROR logic sets the
*srqidxp to 0 via t4_set_wq_in_error(&qhp->wq, 0), and aborts the
connection by calling c4iw_ep_disconnect().

c4iw_ep_disconnect() does the following:
 1. sends up a close_complete_upcall(ep, -ECONNRESET) to libcxgb4.
 2. sends abort request CPL to hw.

But, since the close_complete_upcall() is sent before sending the
ABORT_REQ to hw, libcxgb4 would fail to release the srqidx if the
connection holds one. Because, the srqidx is passed up to libcxgb4
only after corresponding ABORT_RPL is processed by kernel in
abort_rpl().

This patch handle the corner-case by moving the call to
close_complete_upcall() from c4iw_ep_disconnect() to abort_rpl().
So that libcxgb4 is notified about the -ECONNRESET only after
abort_rpl(), and libcxgb4 can relinquish the srqidx properly.

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 7aca5d73c19e..f45044d8de4d 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1941,8 +1941,10 @@ static int abort_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	}
 	mutex_unlock(&ep->com.mutex);
 
-	if (release)
+	if (release) {
+		close_complete_upcall(ep, -ECONNRESET);
 		release_ep_resources(ep);
+	}
 	c4iw_put_ep(&ep->com);
 	return 0;
 }
@@ -3675,7 +3677,6 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 	if (close) {
 		if (abrupt) {
 			set_bit(EP_DISC_ABORT, &ep->com.history);
-			close_complete_upcall(ep, -ECONNRESET);
 			ret = send_abort(ep);
 		} else {
 			set_bit(EP_DISC_CLOSE, &ep->com.history);
-- 
2.13.0
