From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv1 2/6] IB/uverbs: check userspace output buffer size
Date: Mon,  4 May 2015 15:00:48 +0200
Message-ID: <a4236d7b71a1c884907ea2c6055ad5729440e26c.1430743694.git.ydroneaud@opteya.com>
References: <cover.1430743694.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
patched kernels.

Applications using libibverbs are not going to be affected
by this patch, but unknown broken applications using directly
kernel uverbs API may fail.

Link: http://marc.info/?i=1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org
Link: http://marc.info/?i=cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6d26bfab1bc6..a3a3b6eafd1d 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1486,6 +1486,9 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1554,6 +1557,9 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1633,6 +1639,9 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1982,6 +1991,9 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2198,6 +2210,9 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2261,6 +2276,9 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2505,6 +2523,9 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2557,6 +2578,9 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -3356,6 +3380,9 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
