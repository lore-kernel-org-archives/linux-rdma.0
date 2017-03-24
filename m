From: Vlad Tsyrklevich <vlad-NIZqynvkaCU43zv7NVfAiQ@public.gmane.org>
Subject: [PATCH v2] infiniband/uverbs: Fix integer overflows
Date: Fri, 24 Mar 2017 15:55:17 -0400
Message-ID: <1490385317-35641-1-git-send-email-vlad@tsyrklevich.net>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Vlad Tsyrklevich <vlad-NIZqynvkaCU43zv7NVfAiQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The 'num_sge' variable is verfied to be smaller than the 'sge_count'
variable; however, since both are user-controlled it's possible to cause
an integer overflow for the kmalloc multiply on 32-bit platforms
(num_sge and sge_count are both defined u32). By crafting an input that
causes a smaller-than-expected allocation it's possible to write
controlled data out-of-bounds.

Signed-off-by: Vlad Tsyrklevich <vlad-NIZqynvkaCU43zv7NVfAiQ@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7007822..5469088 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2542,9 +2542,13 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 static void *alloc_wr(size_t wr_size, __u32 num_sge)
 {
+	if (num_sge >= (U32_MAX - ALIGN(wr_size, sizeof (struct ib_sge))) /
+		       sizeof (struct ib_sge))
+		return NULL;
+
 	return kmalloc(ALIGN(wr_size, sizeof (struct ib_sge)) +
 			 num_sge * sizeof (struct ib_sge), GFP_KERNEL);
-};
+}
 
 ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			    struct ib_device *ib_dev,
@@ -2771,6 +2775,13 @@ static struct ib_recv_wr *ib_uverbs_unmarshall_recv(const char __user *buf,
 			goto err;
 		}
 
+		if (user_wr->num_sge >=
+		    (U32_MAX - ALIGN(sizeof *next, sizeof (struct ib_sge))) /
+		    sizeof (struct ib_sge)) {
+			ret = -EINVAL;
+			goto err;
+		}
+
 		next = kmalloc(ALIGN(sizeof *next, sizeof (struct ib_sge)) +
 			       user_wr->num_sge * sizeof (struct ib_sge),
 			       GFP_KERNEL);
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
