From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2 1/2] IB/core: Fix user mode post post wr corruption
Date: Mon, 30 Nov 2015 17:23:57 -0500
Message-ID: <20151130222216.29332.64213.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit e622f2f4ad21 ("IB: split struct ib_send_wr")
introduced a regression for HCAs whose user mode post
sends go through ib_uverbs_post_send().

The code didn't account for the fact that the first sge is
offset by an operation dependent length.  The allocation did,
but the pointer to the destination sge list is computed without
that knowledge.  The sge list copy_from_user() then corrupts
fields in the work request

Store the operation dependent length in a local variable and
compute the sge list copy_from_user() destination using that length.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
differences from v1
 - address comments from Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

 drivers/infiniband/core/uverbs_cmd.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 94816ae..4cb8e9d 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2446,6 +2446,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	int                             i, sg_ind;
 	int				is_ud;
 	ssize_t                         ret = -EINVAL;
+	size_t                          next_size;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
@@ -2490,7 +2491,8 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 				goto out_put;
 			}
 
-			ud = alloc_wr(sizeof(*ud), user_wr->num_sge);
+			next_size = sizeof(*ud);
+			ud = alloc_wr(next_size, user_wr->num_sge);
 			if (!ud) {
 				ret = -ENOMEM;
 				goto out_put;
@@ -2511,7 +2513,8 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			   user_wr->opcode == IB_WR_RDMA_READ) {
 			struct ib_rdma_wr *rdma;
 
-			rdma = alloc_wr(sizeof(*rdma), user_wr->num_sge);
+			next_size = sizeof(*rdma);
+			rdma = alloc_wr(next_size, user_wr->num_sge);
 			if (!rdma) {
 				ret = -ENOMEM;
 				goto out_put;
@@ -2525,7 +2528,8 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			   user_wr->opcode == IB_WR_ATOMIC_FETCH_AND_ADD) {
 			struct ib_atomic_wr *atomic;
 
-			atomic = alloc_wr(sizeof(*atomic), user_wr->num_sge);
+			next_size = sizeof(*atomic);
+			atomic = alloc_wr(next_size, user_wr->num_sge);
 			if (!atomic) {
 				ret = -ENOMEM;
 				goto out_put;
@@ -2540,7 +2544,8 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 		} else if (user_wr->opcode == IB_WR_SEND ||
 			   user_wr->opcode == IB_WR_SEND_WITH_IMM ||
 			   user_wr->opcode == IB_WR_SEND_WITH_INV) {
-			next = alloc_wr(sizeof(*next), user_wr->num_sge);
+			next_size = sizeof(*next);
+			next = alloc_wr(next_size, user_wr->num_sge);
 			if (!next) {
 				ret = -ENOMEM;
 				goto out_put;
@@ -2572,7 +2577,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 
 		if (next->num_sge) {
 			next->sg_list = (void *) next +
-				ALIGN(sizeof *next, sizeof (struct ib_sge));
+				ALIGN(next_size, sizeof(struct ib_sge));
 			if (copy_from_user(next->sg_list,
 					   buf + sizeof cmd +
 					   cmd.wr_count * cmd.wqe_size +

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
