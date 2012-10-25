From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: [PATCH] amsol1100: missing break
Date: Thu, 25 Oct 2012 15:36:51 +0100
Message-ID: <20121025143646.17225.57722.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Signed-off-by: Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---

 drivers/infiniband/hw/amso1100/c2_ae.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/amso1100/c2_ae.c b/drivers/infiniband/hw/amso1100/c2_ae.c
index 32d34e8..706cf97 100644
--- a/drivers/infiniband/hw/amso1100/c2_ae.c
+++ b/drivers/infiniband/hw/amso1100/c2_ae.c
@@ -311,6 +311,7 @@ void c2_ae_event(struct c2_dev *c2dev, u32 mq_index)
 		if (cq->ibcq.event_handler)
 			cq->ibcq.event_handler(&ib_event,
 					       cq->ibcq.cq_context);
+		break;
 	}
 
 	default:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
