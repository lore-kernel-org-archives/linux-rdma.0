From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH 6/7] IB/uverbs: pack struct ib_uverbs_event_file tighter
Date: Fri, 29 Jan 2010 14:45:28 -0700
Message-ID: <20100129214528.17745.56022.stgit@bob.kio>
References: <20100129214039.17745.38679.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100129214039.17745.38679.stgit-tBlMHHroXgg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Eliminate some padding in the structure by rearranging the members.

sizeof(struct ib_uverbs_event_file) is now 72 bytes (from 80) and
more members now fit in the first cacheline.

Signed-off-by: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
---

 drivers/infiniband/core/uverbs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index e695f65..e54d9ac 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -80,13 +80,13 @@ struct ib_uverbs_device {
 
 struct ib_uverbs_event_file {
 	struct kref				ref;
+	int					is_async;
 	struct ib_uverbs_file		       *uverbs_file;
 	spinlock_t				lock;
+	int					is_closed;
 	wait_queue_head_t			poll_wait;
 	struct fasync_struct		       *async_queue;
 	struct list_head			event_list;
-	int					is_async;
-	int					is_closed;
 };
 
 struct ib_uverbs_file {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
