From: Hariprasad Shenai <hariprasad@chelsio.com>
Subject: [PATCHv4 net-next 17/32] iw_cxgb4: don't leak skb in c4iw_uld_rx_handler()
Date: Fri,  7 Mar 2014 16:03:14 +0530
Message-ID: <1394188409-9739-18-git-send-email-hariprasad@chelsio.com>
References: <1394188409-9739-1-git-send-email-hariprasad@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1394188409-9739-1-git-send-email-hariprasad@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: davem@davemloft.net, roland@purestorage.com, santosh@chelsio.com, dm@chelsio.com, kumaras@chelsio.com, swise@opengridcomputing.com, leedom@chelsio.com, nirranjan@chelsio.com, hariprasad@chelsio.com
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/hw/cxgb4/device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 9ba3012..73d6226 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -924,11 +924,13 @@ static int c4iw_uld_rx_handler(void *handle, const __be64 *rsp,
 	}
 
 	opcode = *(u8 *)rsp;
-	if (c4iw_handlers[opcode])
+	if (c4iw_handlers[opcode]) {
 		c4iw_handlers[opcode](dev, skb);
-	else
+	} else {
 		pr_info("%s no handler opcode 0x%x...\n", __func__,
 		       opcode);
+		kfree_skb(skb);
+	}
 
 	return 0;
 nomem:
-- 
1.8.4
