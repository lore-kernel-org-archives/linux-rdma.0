From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH] Checks for Null return of skb_alloc in function send_flowc
Date: Tue, 17 Jun 2014 11:55:13 -0400
Message-ID: <1403020513-6284-1-git-send-email-xerofoify@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: swise@chelsio.com
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 7e3d663..6c069c2 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -457,10 +457,8 @@ static void send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
 	int i;
 
 	skb = get_skb(skb, flowclen, GFP_KERNEL);
+	if (!skb)
+		return;
 	flowc = (struct fw_flowc_wr *)__skb_put(skb, flowclen);
 
 	flowc->op_to_nparams = cpu_to_be32(FW_WR_OP(FW_FLOWC_WR) |
-- 
1.9.1
