From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 1/3] iw_cxgb4: put ep reference in pass_accept_req()
Date: Wed, 13 Sep 2017 09:52:32 -0700
Message-ID: <20170915140722.9641AE0C1D@smtp.ogc.us>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The listening endpoint should always be dereferenced at the end of
pass_accept_req().

Fixes: f86fac79afec ("RDMA/iw_cxgb4: atomic find and reference for listening endpoints")

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e49b34c..6d85a5d 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2594,9 +2594,9 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 	c4iw_put_ep(&child_ep->com);
 reject:
 	reject_cr(dev, hwtid, skb);
+out:
 	if (parent_ep)
 		c4iw_put_ep(&parent_ep->com);
-out:
 	return 0;
 }
 
-- 
1.8.3.1
