From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v2] iw_cxgb4: use wildcard mapping for getting remote addr
 info
Date: Thu, 07 May 2015 16:34:23 -0500
Message-ID: <20150507213423.30446.25092.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For listening endpoints bound to the wildcard address, we need to pass
the wildcard address mapping to iwpm_get_remote_info() instead of the
mapped address of the new child connection.

Without this fix, and with iwarp port mapping enabled, each iw_cxgb4
connection that is spawned from a listening endpoint bound to the wildcard
address, will generate an annoying dmesg entry about failing to find
the remote address mapping info, and the connection state displayed in
debugfs under /sys/kernel/debug/iw_cxgb4/<pci-slot-no>/eps  will not have
the peer's address/port mapping info.  The connection still works though.

Fixes: 5b6b8fe ("RDMA/cxgb4: Report the actual address of the remote connecting peer")

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

---

This should be included in 4.1-rc which is where 5b6b8fe was introduced.
---
 drivers/infiniband/hw/cxgb4/cm.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index bb95a6c..3ad8dc7 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -583,18 +583,18 @@ static void c4iw_record_pm_msg(struct c4iw_ep *ep,
 		sizeof(ep->com.mapped_remote_addr));
 }
 
-static int get_remote_addr(struct c4iw_ep *ep)
+static int get_remote_addr(struct c4iw_ep *parent_ep, struct c4iw_ep *child_ep)
 {
 	int ret;
 
-	print_addr(&ep->com, __func__, "get_remote_addr");
+	print_addr(&parent_ep->com, __func__, "get_remote_addr parent_ep ");
+	print_addr(&child_ep->com, __func__, "get_remote_addr child_ep ");
 
-	ret = iwpm_get_remote_info(&ep->com.mapped_local_addr,
-				   &ep->com.mapped_remote_addr,
-				   &ep->com.remote_addr, RDMA_NL_C4IW);
+	ret = iwpm_get_remote_info(&parent_ep->com.mapped_local_addr,
+				   &child_ep->com.mapped_remote_addr,
+				   &child_ep->com.remote_addr, RDMA_NL_C4IW);
 	if (ret)
-		pr_info(MOD "Unable to find remote peer addr info - err %d\n",
-			ret);
+		PDBG("Unable to find remote peer addr info - err %d\n", ret);
 
 	return ret;
 }
@@ -2420,7 +2420,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 	}
 	memcpy(&child_ep->com.remote_addr, &child_ep->com.mapped_remote_addr,
 	       sizeof(child_ep->com.remote_addr));
-	get_remote_addr(child_ep);
+	get_remote_addr(parent_ep, child_ep);
 
 	c4iw_get_ep(&parent_ep->com);
 	child_ep->parent_ep = parent_ep;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
