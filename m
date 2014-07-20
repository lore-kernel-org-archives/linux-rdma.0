From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] IB/uverbs: check userspace input buffer size
Date: Sun, 20 Jul 2014 21:51:09 +0200
Message-ID: <1e64a875d1dacc592996133ef31defb32d3b5d2a.1405884453.git.ydroneaud@opteya.com>
References: <cover.1405884453.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch makes uverbs functions check the length of the input
buffer before reading the command content.

This will detect truncated command and will prevent uverbs from
reading past userspace provided buffer.

Additionally, it will also prevent underflow while computing
remaining input space. Such underflow would set inlen field in
struct ib_udata in call to INIT_UDATA() to a meaningless value.

For example:

    INIT_UDATA(&udata, buf + sizeof cmd,
               (unsigned long) cmd.response + sizeof resp,
               in_len - sizeof cmd, out_len - sizeof resp);

If in_len is less than sizeof(cmd), the result of subtraction
is a negative value since in_len is an int per function prototype.
But inlen field in struct ib_udata is unsigned, so the result is
an overly large value in struct ib_udata. Such value will make
further size checking useless, allowing more out of bound read
in providers (eg. hw/) code.

Note that checking the input size and preventing the underflow
and/or overflow might break existing userspace program that
incorrectly set the buffer length in a uverbs request.

It's theoretically possible for a userspace driver to send
a request with a wrong size that can still be processed
correctly with the kernel:

Let's build a request through fake 'libibverbs' and
'libvendor-rdma' userspace driver.

It's a request which might be valid with current kernel
but will set inlen to (size_t) -1 while it will be possible
for vendor driver (eg. provider, under hw/) to read vendor
fields:

    #include <infiniband/kern-abi.h>

    /* aka. struct ib_uverbs_cmd_hdr */
    struct ibv_cmd_hdr {
        __u32 command;
        __u16 in_words;
        __u16 out_words;
    };

    struct vendor_create_cq {
        struct ibv_create_cq ibv_cmd;
        /* vendor defined fields */
    };

    struct vendor_create_cq_resp resp {
        struct ibv_create_cq_resp ibv_resp;
        /* vendor defined fields */
    };

    struct ibv_cq *vendor_create_cq_broken_inlen(...)
    {
        struct vendor_create_cq      cmd;
        struct vendor_create_cq_resp resp;
        size_t cmd_size;

        /* the command header size must be subtracted here
           to ensure (inlen - sizeof(struct ib_uverbs_create_cq)
           is equal to 0 in ib_uverbs_create_cq(), as the header
           size is not subtracted in ib_uverbs_write() before
           invoking ib_uverbs_create_cq() */

        assert(sizeof(struct ibv_create_cq) >= sizeof(struct ibv_cmd_hdr));
        cmd_size = sizeof(struct ibv_create_cq) -
                   sizeof(struct ibv_cmd_hdr);

        /* instead of 0, make (inlen - sizeof(cmd)) underflow */
        cmd_size--;

        /* For the command to be valid in ib_uverbs_write(),
           it size must be at least equal to sizeof(struct
           ib_uverbs_cmd_hdr). */

        assert(cmd_size >= sizeof(struct ibv_cmd_hdr));
        ...

        IBV_INIT_CMD_RESP(&cmd,
                          cmd_size,
                          CREATE_CQ,
                          &resp,
                          sizeof(resp));

        ...

        write(context->cmd_fd,
              &cmd,
              cmd_size);

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
 drivers/infiniband/core/uverbs_cmd.c | 102 +++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ea6203ee7bcc..353cbd5229bb 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -292,6 +292,9 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	struct file			 *filp;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -387,6 +390,9 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	struct ib_device_attr              attr;
 	int                                ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -456,6 +462,9 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	struct ib_port_attr              attr;
 	int                              ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -508,6 +517,9 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	struct ib_pd                  *pd;
 	int                            ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -579,6 +591,9 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	struct ib_uobject          *uobj;
 	int                         ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -705,6 +720,9 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	int				ret = 0;
 	int				new_xrcd = 0;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -840,6 +858,9 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	int                         live;
 	int                         ret = 0;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -917,6 +938,9 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	struct ib_mr                *mr;
 	int                          ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1011,6 +1035,9 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	struct ib_uobject	 *uobj;
 	int                       ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1051,6 +1078,9 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	struct ib_mw                  *mw;
 	int                            ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -1131,6 +1161,9 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	struct ib_uobject	   *uobj;
 	int                         ret = -EINVAL;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -1169,6 +1202,9 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 	struct file				  *filp;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1209,6 +1245,9 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	struct ib_cq                   *cq;
 	int                             ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1308,6 +1347,9 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 	struct ib_cq			*cq;
 	int				ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1373,6 +1415,9 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	struct ib_wc                   wc;
 	int                            ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1419,6 +1464,9 @@ ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
 	struct ib_uverbs_req_notify_cq cmd;
 	struct ib_cq                  *cq;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1446,6 +1494,9 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	struct ib_uverbs_event_file	*ev_file;
 	int                        	 ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1504,6 +1555,9 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	struct ib_qp_init_attr          attr;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1694,6 +1748,9 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	struct ib_qp_open_attr          attr;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1786,6 +1843,9 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	struct ib_qp_init_attr         *init_attr;
 	int                            ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1899,6 +1959,9 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	struct ib_qp_attr         *attr;
 	int                        ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1995,6 +2058,9 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	struct ib_uqp_object        	*obj;
 	int                        	 ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2055,6 +2121,9 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	int				is_ud;
 	ssize_t                         ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2296,6 +2365,9 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	struct ib_qp                   *qp;
 	ssize_t                         ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2345,6 +2417,9 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	struct ib_srq                      *srq;
 	ssize_t                             ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2396,6 +2471,9 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	struct ib_ah_attr		attr;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -2482,6 +2560,9 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	struct ib_uobject	   *uobj;
 	int			    ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2520,6 +2601,9 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 	struct ib_uverbs_mcast_entry *mcast;
 	int                           ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2567,6 +2651,9 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	struct ib_uverbs_mcast_entry *mcast;
 	int                           ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2982,6 +3069,9 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	struct ib_udata                  udata;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -3015,6 +3105,9 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 	struct ib_udata                  udata;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -3042,6 +3135,9 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 	struct ib_srq_attr          attr;
 	int                         ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -3072,6 +3168,9 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 	struct ib_srq                   *srq;
 	int                             ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -3115,6 +3214,9 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	struct ib_usrq_object		 *us;
 	enum ib_srq_type		  srq_type;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
