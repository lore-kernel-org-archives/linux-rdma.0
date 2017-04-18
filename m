From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 5/6] IB/core: Don't use is_async in event files to infer events size
Date: Tue, 18 Apr 2017 12:03:41 +0300
Message-ID: <1492506222-28999-6-git-send-email-matanb@mellanox.com>
References: <1492506222-28999-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492506222-28999-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Previously, we inferred the events size in ib_uverbs_event_read by
using the is_async flag. Instead of that, we pass the event size
directly.

Fixes: 1e7710f3f656 ('IB/core: Change completion channel to use the reworked objects schema')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 0b0dab8..4ab0e5d 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -257,10 +257,9 @@ static ssize_t ib_uverbs_event_read(struct ib_uverbs_event_file *file,
 				    struct ib_uverbs_file *uverbs_file,
 				    struct file *filp, char __user *buf,
 				    size_t count, loff_t *pos,
-				    bool is_async)
+				    size_t eventsz)
 {
 	struct ib_uverbs_event *event;
-	int eventsz;
 	int ret = 0;
 
 	spin_lock_irq(&file->lock);
@@ -290,11 +289,6 @@ static ssize_t ib_uverbs_event_read(struct ib_uverbs_event_file *file,
 
 	event = list_entry(file->event_list.next, struct ib_uverbs_event, list);
 
-	if (is_async)
-		eventsz = sizeof (struct ib_uverbs_async_event_desc);
-	else
-		eventsz = sizeof (struct ib_uverbs_comp_event_desc);
-
 	if (eventsz > count) {
 		ret   = -EINVAL;
 		event = NULL;
@@ -326,7 +320,8 @@ static ssize_t ib_uverbs_async_event_read(struct file *filp, char __user *buf,
 	struct ib_uverbs_async_event_file *file = filp->private_data;
 
 	return ib_uverbs_event_read(&file->ev_file, file->uverbs_file, filp,
-				    buf, count, pos, true);
+				    buf, count, pos,
+				    sizeof(struct ib_uverbs_async_event_desc));
 }
 
 static ssize_t ib_uverbs_comp_event_read(struct file *filp, char __user *buf,
@@ -337,7 +332,8 @@ static ssize_t ib_uverbs_comp_event_read(struct file *filp, char __user *buf,
 
 	return ib_uverbs_event_read(&comp_ev_file->ev_file,
 				    comp_ev_file->uobj_file.ufile, filp,
-				    buf, count, pos, false);
+				    buf, count, pos,
+				    sizeof(struct ib_uverbs_comp_event_desc));
 }
 
 static unsigned int ib_uverbs_event_poll(struct ib_uverbs_event_file *file,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
