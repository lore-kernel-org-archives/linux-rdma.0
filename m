From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 56/87] iw_cxgb4: fix srqidx leak during connection abort
Date: Wed, 27 Mar 2019 14:20:09 -0400
Message-ID: <20190327182040.17444-56-sashal@kernel.org>
References: <20190327182040.17444-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327182040.17444-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Raju Rangoju <rajur@chelsio.com>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>

[ Upstream commit f368ff188ae4b3ef6f740a15999ea0373261b619 ]

When an application aborts the connection by moving QP from RTS to ERROR,
then iw_cxgb4's modify_rc_qp() RTS->ERROR logic sets the
*srqidxp to 0 via t4_set_wq_in_error(&qhp->wq, 0), and aborts the
connection by calling c4iw_ep_disconnect().

c4iw_ep_disconnect() does the following:
 1. sends up a close_complete_upcall(ep, -ECONNRESET) to libcxgb4.
 2. sends abort request CPL to hw.

But, since the close_complete_upcall() is sent before sending the
ABORT_REQ to hw, libcxgb4 would fail to release the srqidx if the
connection holds one. Because, the srqidx is passed up to libcxgb4 only
after corresponding ABORT_RPL is processed by kernel in abort_rpl().

This patch handle the corner-case by moving the call to
close_complete_upcall() from c4iw_ep_disconnect() to abort_rpl().  So that
libcxgb4 is notified about the -ECONNRESET only after abort_rpl(), and
libcxgb4 can relinquish the srqidx properly.

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index dd18b74cd01d..a2322b2dbd82 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1872,8 +1872,10 @@ static int abort_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
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
@@ -3567,7 +3569,6 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 	if (close) {
 		if (abrupt) {
 			set_bit(EP_DISC_ABORT, &ep->com.history);
-			close_complete_upcall(ep, -ECONNRESET);
 			ret = send_abort(ep);
 		} else {
 			set_bit(EP_DISC_CLOSE, &ep->com.history);
-- 
2.19.1
