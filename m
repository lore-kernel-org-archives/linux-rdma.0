From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2/3] iw_cxgb4: drop listen destroy replies if no ep found
Date: Tue, 5 Sep 2017 11:52:33 -0700
Message-ID: <20170915140752.A29BEE0C1D@smtp.ogc.us>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

If the thread waiting for a CLOSE_LISTSRV_RPL times out and bails,
then we need to handle a subsequent CPL if it arrives and the stid has
been released.  In this case silently drop it.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 6d85a5d..d76bfe3 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2333,9 +2333,14 @@ static int close_listsrv_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	unsigned int stid = GET_TID(rpl);
 	struct c4iw_listen_ep *ep = get_ep_from_stid(dev, stid);
 
+	if (!ep) {
+		pr_debug("%s stid %d lookup failure!\n", __func__, stid);
+		goto out;
+	}
 	pr_debug("%s ep %p\n", __func__, ep);
 	c4iw_wake_up(&ep->com.wr_wait, status2errno(rpl->status));
 	c4iw_put_ep(&ep->com);
+out:
 	return 0;
 }
 
-- 
1.8.3.1
