From: Hariprasad Shenai <hariprasad@chelsio.com>
Subject: [PATCHv2 net-next 16/31] iw_cxgb4: don't leak skb in c4iw_uld_rx_handler().
Date: Mon,  3 Mar 2014 12:11:00 +0530
Message-ID: <1393828875-13452-17-git-send-email-hariprasad@chelsio.com>
References: <1393828875-13452-1-git-send-email-hariprasad@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1393828875-13452-1-git-send-email-hariprasad@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: davem@davemloft.net, roland@purestorage.com, kumaras@chelsio.com, dm@chelsio.com, swise@opengridcomputing.com, leedom@chelsio.com, santosh@chelsio.com, hariprasad@chelsio.com, nirranjan@chelsio.com
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/hw/cxgb4/device.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 9542ccc..f73fea4 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -936,9 +936,11 @@ static int c4iw_uld_rx_handler(void *handle, const __be64 *rsp,
 	opcode = *(u8 *)rsp;
 	if (c4iw_handlers[opcode])
 		c4iw_handlers[opcode](dev, skb);
-	else
+	else {
 		pr_info("%s no handler opcode 0x%x...\n", __func__,
 		       opcode);
+		kfree_skb(skb);
+	}
 
 	return 0;
 nomem:
-- 
1.7.1
