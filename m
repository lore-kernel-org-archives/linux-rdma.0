From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH] infiniband: fix a subtle race condition
Date: Wed, 13 Jun 2018 16:49:47 -0700
Message-ID: <20180613234947.15767-1-xiyou.wangcong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

In ucma_event_handler() we lock the mutex like this:

mutex_lock(&ctx->file->mut);
...
mutex_unlock(&ctx->file->mut);

which seems correct, but we could translate it into this:

f = ctx->file;
mutex_lock(&f->mut);
...
f = ctx->file;
mutex_unlock(&f->mut);

as the compiler does. And, because ucma_event_handler() is
called in a workqueue so it could race with ucma_migrate_id(),
so the following race condition could happen:

CPU0			CPU1
f = ctx->file;
			ucma_lock_files(f, new_file);
			ctx->file = new_file
			ucma_lock_files(f, new_file);
mutex_lock(&f->mut); // still the old file!
...
f = ctx->file; // now the new one!!
mutex_unlock(&f->mut); // unlock new file!

Fix this by reading ctx->file once before mutex_lock(), so we
won't unlock a different mutex any more.

Reported-by: syzbot+e5579222b6a3edd96522@syzkaller.appspotmail.com
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 drivers/infiniband/core/ucma.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index ec8fb289621f..8729d6acf981 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -341,13 +341,15 @@ static int ucma_event_handler(struct rdma_cm_id *cm_id,
 {
 	struct ucma_event *uevent;
 	struct ucma_context *ctx = cm_id->context;
+	struct ucma_file *cur_file;
 	int ret = 0;
 
 	uevent = kzalloc(sizeof(*uevent), GFP_KERNEL);
 	if (!uevent)
 		return event->event == RDMA_CM_EVENT_CONNECT_REQUEST;
 
-	mutex_lock(&ctx->file->mut);
+	cur_file = ctx->file;
+	mutex_lock(&cur_file->mut);
 	uevent->cm_id = cm_id;
 	ucma_set_event_context(ctx, event, uevent);
 	uevent->resp.event = event->event;
@@ -382,12 +384,12 @@ static int ucma_event_handler(struct rdma_cm_id *cm_id,
 		goto out;
 	}
 
-	list_add_tail(&uevent->list, &ctx->file->event_list);
-	wake_up_interruptible(&ctx->file->poll_wait);
+	list_add_tail(&uevent->list, &cur_file->event_list);
+	wake_up_interruptible(&cur_file->poll_wait);
 	if (event->event == RDMA_CM_EVENT_DEVICE_REMOVAL)
 		ucma_removal_event_handler(cm_id);
 out:
-	mutex_unlock(&ctx->file->mut);
+	mutex_unlock(&cur_file->mut);
 	return ret;
 }
 
-- 
2.14.4
