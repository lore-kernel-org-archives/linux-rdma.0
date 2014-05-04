From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libcxgb4 2/2] kernel abi: adds explicit padding in struct c4iw_alloc_ucontext_resp
Date: Sun,  4 May 2014 23:31:52 +0200
Message-ID: <b2bbdebb50e91f6007484059460ba1ebf06626db.1399235229.git.ydroneaud@opteya.com>
References: <cover.1399235229.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1399235229.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1399235229.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> <cover.1399235229.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

i386 ABI disagree with most other ABIs regarding alignment
of data type larger than 4 bytes: on most ABIs a padding must
be added at end of the structures, while it is not
required on i386.

Such ABI disagreement will make an x86_64 kernel try to write past
the struct c4iw_alloc_ucontext_resp buffer provided by an i386
userspace binary. As struct c4iw_alloc_ucontext_resp is likely
on stack, see function c4iw_alloc_context(), side effects are
expected.

On kernel side, this structure was modified for kernel v3.15-rc1
by following commit:

  Commit 05eb23893c2cf9502a9cec0c32e7f1d1ed2895c8
  Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
  Date:   Fri Mar 14 21:52:08 2014 +0530

      cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixes

If boundary check is implemented on kernel side, the x86_64
kernel will instead refuse to write past the i386 userspace
provided buffer and the uverbs will fail.

To fix these issues, this patch adds an explicit padding at end
of structure so that i386 and others ABI share the same structure
layout. This patch makes c4iw_alloc_context() check for a value
in the padding field to detect newer kernel using the field for
a future purpose (only activated in debug).

With this patch, libcxgb4 will work against older kernel and
newer patched kernel.

Link: http://marc.info/?i=cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/cxgb4-abi.h | 1 +
 src/dev.c       | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/src/cxgb4-abi.h b/src/cxgb4-abi.h
index 23870f66dc0d..0b9f4d99d0e7 100644
--- a/src/cxgb4-abi.h
+++ b/src/cxgb4-abi.h
@@ -38,6 +38,7 @@ struct c4iw_alloc_ucontext_resp {
 	struct ibv_get_context_resp ibv_resp;
 	__u64 status_page_key;
 	__u32 status_page_size;
+	__u32 reserved;
 };
 
 struct c4iw_alloc_pd_resp {
diff --git a/src/dev.c b/src/dev.c
index 3236e6b2db6d..f66df71105e5 100644
--- a/src/dev.c
+++ b/src/dev.c
@@ -125,10 +125,15 @@ static struct ibv_context *c4iw_alloc_context(struct ibv_device *ibdev,
 	context->ibv_ctx.cmd_fd = cmd_fd;
 
 	resp.status_page_size = 0;
+	resp.reserved = 0;
 	if (ibv_cmd_get_context(&context->ibv_ctx, &cmd, sizeof cmd,
 				&resp.ibv_resp, sizeof resp))
 		goto err_free;
 
+	if (resp.reserved)
+		PDBG("%s c4iw_alloc_ucontext_resp reserved field modified by kernel\n",
+		     __FUNCTION__);
+
 	context->status_page_size = resp.status_page_size;
 	if (resp.status_page_size) {
 		context->status_page = mmap(NULL, resp.status_page_size,
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
