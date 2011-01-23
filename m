From: Ralf Thielow <ralf.thielow-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: [PATCH] infiniband: hw: amso1100: Fixed compile warning.
Date: Sun, 23 Jan 2011 17:30:03 +0100
Message-ID: <1295800203-9552-1-git-send-email-ralf.thielow@googlemail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ralf Thielow <ralf.thielow-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixed compile warning by use "unsigned long" instead of "u64"
on assign NULL to "c2_vq_req->reply_msg".

Signed-off-by: Ralf Thielow <ralf.thielow-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
---
 drivers/infiniband/hw/amso1100/c2_vq.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_vq.c b/drivers/infiniband/hw/amso1100/c2_vq.c
index 9ce7819..807b730 100644
--- a/drivers/infiniband/hw/amso1100/c2_vq.c
+++ b/drivers/infiniband/hw/amso1100/c2_vq.c
@@ -107,7 +107,7 @@ struct c2_vq_req *vq_req_alloc(struct c2_dev *c2dev)
 	r = kmalloc(sizeof(struct c2_vq_req), GFP_KERNEL);
 	if (r) {
 		init_waitqueue_head(&r->wait_object);
-		r->reply_msg = (u64) NULL;
+		r->reply_msg = (unsigned long) NULL;
 		r->event = 0;
 		r->cm_id = NULL;
 		r->qp = NULL;
@@ -123,7 +123,7 @@ struct c2_vq_req *vq_req_alloc(struct c2_dev *c2dev)
  */
 void vq_req_free(struct c2_dev *c2dev, struct c2_vq_req *r)
 {
-	r->reply_msg = (u64) NULL;
+	r->reply_msg = (unsigned long) NULL;
 	if (atomic_dec_and_test(&r->refcnt)) {
 		kfree(r);
 	}
@@ -151,7 +151,7 @@ void vq_req_get(struct c2_dev *c2dev, struct c2_vq_req *r)
 void vq_req_put(struct c2_dev *c2dev, struct c2_vq_req *r)
 {
 	if (atomic_dec_and_test(&r->refcnt)) {
-		if (r->reply_msg != (u64) NULL)
+		if (r->reply_msg != (unsigned long) NULL)
 			vq_repbuf_free(c2dev,
 				       (void *) (unsigned long) r->reply_msg);
 		kfree(r);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
