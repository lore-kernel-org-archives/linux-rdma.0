From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] IB/uverbs: check userspace output buffer size
Date: Sun, 20 Jul 2014 21:51:10 +0200
Message-ID: <2b532e19e2e84ea87aab2d91eaa939edf21b4489.1405884453.git.ydroneaud@opteya.com>
References: <cover.1405884453.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch makes uverbs functions check the length of the
output buffer.

This will prevent uverbs from writing past userspace provided
buffer.

Additionally, it will prevent an underflow while computing
remaining output space. Such underflow would set outlen field in
struct ib_udata in call to INIT_UDATA() to a meaningless value.

For example:

    INIT_UDATA(&udata, buf + sizeof cmd,
               (unsigned long) cmd.response + sizeof resp,
               in_len - sizeof cmd, out_len - sizeof resp);

If out_len is less than sizeof(resp), the result of subtraction
is a negative value since out_len is an int per function prototype.
But outlen field in struct ib_udata is unsigned, so the result is
an overly large value in struct ib_udata. Such value will make
further size checking useless, allowing more out of bound write
in providers (eg. hw/) code.

Note that checking the output size and preventing the underflow
and/or overflow might break existing userspace program that
incorrectly set the buffer length in a uverbs request.

It's theoretically possible for a userspace driver to send
a request with a wrong size that can still be processed
correctly with the kernel:

Let's build a request through fake 'libibverbs' and
'libvendor-rdma' userspace driver.

It's a request which might be valid with current kernel
but will set outlen to (size_t) -1 while it will be possible
for vendor driver (eg. provider, under hw/) to write vendor
fields:

    #include <infiniband/kern-abi.h>

    /* aka. struct ib_uverbs_cmd_hdr */
    struct ibv_cmd_hdr {
        __u32 command;
        __u16 in_words;
        __u16 out_words;
    };

    struct vendor_resize_cq {
        struct ibv_resize_cq ibv_cmd;
        /* vendor defined fields */
    };

    struct vendor_resize_cq_resp resp {
        struct ibv_resize_cq_resp ibv_resp;
        /* vendor defined fields */
    };

    struct ibv_cq *vendor_resize_cq_broken_outlen(...)
    {
        struct vendor_resize_cq      cmd;
        struct vendor_resize_cq_resp resp;
        size_t                       resp_size;

        ...

        /* slightly less than struct ib_uverbs_resize_cq_resp */
        resp_size = sizeof(struct ibv_create_cq_resp);
        resp_size--;

        ...

        IBV_INIT_CMD_RESP(&cmd,
                          sizeof(cmd),
                          RESIZE_CQ,
                          &resp,
                          resp_size);
        ...
        write(context->cmd_fd,
              &cmd,
              sizeof(cmd));
        ...
    }

This example shows how a request can be created to trigger
un-handled underflow while allowing provider (eg. hw/) to
process the request.

The provided patch will make it impossible to do it on
patched kernels, but might make unknown broken applications
fail.

Link: http://marc.info/?i=cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://marc.info/?i=1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 353cbd5229bb..9b971514db88 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1350,6 +1350,9 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1418,6 +1421,9 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1497,6 +1503,9 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1846,6 +1855,9 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2061,6 +2073,9 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2124,6 +2139,9 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2368,6 +2386,9 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2420,6 +2441,9 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -3217,6 +3241,9 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
