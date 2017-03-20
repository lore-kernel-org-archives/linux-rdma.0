From: Vlad Tsyrklevich <vlad-NIZqynvkaCU43zv7NVfAiQ@public.gmane.org>
Subject: [PATCH] infiniband: Fix integer overflows
Date: Mon, 20 Mar 2017 16:16:46 -0400
Message-ID: <1490041006-8092-1-git-send-email-vlad@tsyrklevich.net>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vlad Tsyrklevich <vlad-NIZqynvkaCU43zv7NVfAiQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The 'num_sge' variable is verfied to be smaller than the 'sge_count'
variable; however, since both are user-controlled it's possible to cause
an integer overflow for the kmalloc multiply on 32-bit platforms
(num_sge and sge_count are both defined u32). By crafting an input that
causes a smaller-than-expected allocation it's possible to write
controlled data out-of-bounds.
---
 drivers/infiniband/core/uverbs_cmd.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7007822..ebb34ae 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2542,9 +2542,12 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 static void *alloc_wr(size_t wr_size, __u32 num_sge)
 {
-	return kmalloc(ALIGN(wr_size, sizeof (struct ib_sge)) +
-			 num_sge * sizeof (struct ib_sge), GFP_KERNEL);
-};
+	size_t wr_align = ALIGN(wr_size, sizeof (struct ib_sge));
+	if (num_sge >= (U32_MAX - wr_align) / sizeof (struct ib_sge))
+		return NULL;
+
+	return kmalloc(wr_align + num_sge * sizeof (struct ib_sge), GFP_KERNEL);
+}
 
 ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			    struct ib_device *ib_dev,
@@ -2742,6 +2745,7 @@ static struct ib_recv_wr *ib_uverbs_unmarshall_recv(const char __user *buf,
 {
 	struct ib_uverbs_recv_wr *user_wr;
 	struct ib_recv_wr        *wr = NULL, *last, *next;
+	size_t                    wr_align;
 	int                       sg_ind;
 	int                       i;
 	int                       ret;
@@ -2771,7 +2775,14 @@ static struct ib_recv_wr *ib_uverbs_unmarshall_recv(const char __user *buf,
 			goto err;
 		}
 
-		next = kmalloc(ALIGN(sizeof *next, sizeof (struct ib_sge)) +
+		wr_align = ALIGN(sizeof *next, sizeof (struct ib_sge));
+		if (user_wr->num_sge >=
+		    (U32_MAX - wr_align) / sizeof (struct ib_sge)) {
+			ret = -EINVAL;
+			goto err;
+		}
+
+		next = kmalloc(wr_align +
 			       user_wr->num_sge * sizeof (struct ib_sge),
 			       GFP_KERNEL);
 		if (!next) {
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
