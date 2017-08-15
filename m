From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 06/11] IB/uverbs: Add new SRQ type IB_SRQT_TM
Date: Tue, 15 Aug 2017 11:59:07 +0300
Message-ID: <20170815085912.10181-7-leon@kernel.org>
References: <20170815085912.10181-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815085912.10181-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add new SRQ type capable of new tag matching feature.

When SRQ receives a message it will search through the matching list
for the corresponding posted receive buffer. The process of searching
the matching list is called tag matching.

In case the tag matching results in a match, the received message will
be placed in the address specified by the receive buffer. In case no
match was found the message will be placed in a generic buffer until the
corresponding receive buffer will be posted. These messages are called
unexpected and their set is called an unexpected list.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yossi Itigin <yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index afa4c1b7891a..e3ac272a0fa9 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1430,7 +1430,7 @@ static int create_qp(struct ib_uverbs_file *file,
 			if (cmd->is_srq) {
 				srq = uobj_get_obj_read(srq, cmd->srq_handle,
 							file->ucontext);
-				if (!srq || srq->srq_type != IB_SRQT_BASIC) {
+				if (!srq || srq->srq_type == IB_SRQT_XRC) {
 					ret = -EINVAL;
 					goto err_put;
 				}
@@ -3463,6 +3463,9 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (IS_ERR(obj))
 		return PTR_ERR(obj);
 
+	if (cmd->srq_type == IB_SRQT_TM)
+		attr.ext.tag_matching.max_num_tags = cmd->max_num_tags;
+
 	if (cmd->srq_type == IB_SRQT_XRC) {
 		xrcd_uobj = uobj_get_read(uobj_get_type(xrcd), cmd->xrcd_handle,
 					  file->ucontext);
@@ -3597,6 +3600,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	memset(&xcmd, 0, sizeof(xcmd));
 	xcmd.response	 = cmd.response;
 	xcmd.user_handle = cmd.user_handle;
 	xcmd.srq_type	 = IB_SRQT_BASIC;
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
