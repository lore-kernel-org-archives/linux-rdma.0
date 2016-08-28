From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 07/10] IB/uverbs: Add new SRQ type IB_SRQT_TAG_MATCHING
Date: Sun, 28 Aug 2016 14:00:47 +0300
Message-ID: <1472382050-25908-8-git-send-email-leon@kernel.org>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382050-25908-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add new SRQ type capable of new Tag Matching feature.

When SRQ receives a message it will search through the matching list
for the corresponding posted receive buffer. The process of searching
the matching list is called tag matching.
In case the tag matching results in a match, the received message will
be placed in the address specified by the receive buffer. In case no
match was found the message will be placed in a generic buffer until the
corresponding receive buffer will be posted. These messages are called
unexpected and their set is called an unexpected list.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 548d4b4..b240c9a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1831,7 +1831,7 @@ static int create_qp(struct ib_uverbs_file *file,
 			if (cmd->is_srq) {
 				srq = idr_read_srq(cmd->srq_handle,
 						   file->ucontext);
-				if (!srq || srq->srq_type != IB_SRQT_BASIC) {
+				if (!srq || srq->srq_type == IB_SRQT_XRC) {
 					ret = -EINVAL;
 					goto err_put;
 				}
@@ -3815,6 +3815,15 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 			ret = -EINVAL;
 			goto err_put_xrcd;
 		}
+	} else if (cmd->srq_type == IB_SRQT_TAG_MATCHING) {
+		attr.ext.tag_matching.cq  = idr_read_cq(cmd->cq_handle,
+							file->ucontext, 0);
+		if (!attr.ext.tag_matching.cq) {
+			ret = -EINVAL;
+			goto err;
+		}
+
+		attr.ext.tag_matching.list_size = cmd->tm_list_size;
 	}
 
 	pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
@@ -3851,6 +3860,9 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 		srq->ext.xrc.xrcd = attr.ext.xrc.xrcd;
 		atomic_inc(&attr.ext.xrc.cq->usecnt);
 		atomic_inc(&attr.ext.xrc.xrcd->usecnt);
+	} else if (cmd->srq_type == IB_SRQT_TAG_MATCHING) {
+		srq->ext.cq = attr.ext.tag_matching.cq;
+		atomic_inc(&attr.ext.tag_matching.cq->usecnt);
 	}
 
 	atomic_inc(&pd->usecnt);
@@ -3877,6 +3889,8 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (cmd->srq_type == IB_SRQT_XRC) {
 		put_uobj_read(xrcd_uobj);
 		put_cq_read(attr.ext.xrc.cq);
+	} else if (cmd->srq_type == IB_SRQT_TAG_MATCHING) {
+		put_cq_read(attr.ext.tag_matching.cq);
 	}
 	put_pd_read(pd);
 
@@ -3902,6 +3916,8 @@ err_put:
 err_put_cq:
 	if (cmd->srq_type == IB_SRQT_XRC)
 		put_cq_read(attr.ext.xrc.cq);
+	else if (cmd->srq_type == IB_SRQT_TAG_MATCHING)
+		put_cq_read(attr.ext.tag_matching.cq);
 
 err_put_xrcd:
 	if (cmd->srq_type == IB_SRQT_XRC) {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
