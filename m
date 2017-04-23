From: Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] iw_cxgb4: check return value of alloc_skb
Date: Sun, 23 Apr 2017 17:09:11 +0800
Message-ID: <1492938551-17824-1-git-send-email-bianpan2016@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-rdma@vger.kernel.org

Function alloc_skb() will return a NULL pointer when there is no enough
memory. However, the return value of alloc_skb() is directly used
without validation in function send_fw_pass_open_req(). This patches
checks the return value of alloc_skb() against NULL.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 03a1b0e..196969c 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3800,6 +3800,8 @@ static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff *skb,
 	int ret;
 
 	req_skb = alloc_skb(sizeof(struct fw_ofld_connection_wr), GFP_KERNEL);
+	if (!req_skb)
+		return;
 	req = (struct fw_ofld_connection_wr *)__skb_put(req_skb, sizeof(*req));
 	memset(req, 0, sizeof(*req));
 	req->op_compl = htonl(WR_OP_V(FW_OFLD_CONNECTION_WR) | FW_WR_COMPL_F);
-- 
1.9.1
