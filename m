From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv1 1/6] IB/uverbs: check userspace input buffer size
Date: Mon,  4 May 2015 15:00:47 +0200
Message-ID: <9e747d3144e247a50c025f58051f7037dc9c7571.1430743694.git.ydroneaud@opteya.com>
References: <cover.1430743694.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
patched kernels.

Applications using libibverbs are not going to be affected
by this patch, but unknown broken applications using directly
kernel uverbs API may fail.

Link: http://marc.info/?i=1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org
Link: http://marc.info/?i=cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 105 +++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a9f048990dfc..6d26bfab1bc6 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -296,6 +296,9 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	struct file			 *filp;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -455,6 +458,9 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	struct ib_device_attr              attr;
 	int                                ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -484,6 +490,9 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	struct ib_port_attr              attr;
 	int                              ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -536,6 +545,9 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	struct ib_pd                  *pd;
 	int                            ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -607,6 +619,9 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	struct ib_uobject          *uobj;
 	int                         ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -733,6 +748,9 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	int				ret = 0;
 	int				new_xrcd = 0;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -868,6 +886,9 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	int                         live;
 	int                         ret = 0;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -945,6 +966,9 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	struct ib_mr                *mr;
 	int                          ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1055,6 +1079,9 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	int                          ret;
 	struct ib_uobject	    *uobj;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -1144,6 +1171,9 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	struct ib_uobject	 *uobj;
 	int                       ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1184,6 +1214,9 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	struct ib_mw                  *mw;
 	int                            ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -1264,6 +1297,9 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	struct ib_uobject	   *uobj;
 	int                         ret = -EINVAL;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -1302,6 +1338,9 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 	struct file				  *filp;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1342,6 +1381,9 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	struct ib_cq                   *cq;
 	int                             ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1441,6 +1483,9 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 	struct ib_cq			*cq;
 	int				ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1506,6 +1551,9 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	struct ib_wc                   wc;
 	int                            ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1552,6 +1600,9 @@ ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
 	struct ib_uverbs_req_notify_cq cmd;
 	struct ib_cq                  *cq;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1579,6 +1630,9 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	struct ib_uverbs_event_file	*ev_file;
 	int                        	 ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1637,6 +1691,9 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	struct ib_qp_init_attr          attr;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1827,6 +1884,9 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	struct ib_qp_open_attr          attr;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1919,6 +1979,9 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	struct ib_qp_init_attr         *init_attr;
 	int                            ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2032,6 +2095,9 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	struct ib_qp_attr         *attr;
 	int                        ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2129,6 +2195,9 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	struct ib_uqp_object        	*obj;
 	int                        	 ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2189,6 +2258,9 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	int				is_ud;
 	ssize_t                         ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2430,6 +2502,9 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	struct ib_qp                   *qp;
 	ssize_t                         ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2479,6 +2554,9 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	struct ib_srq                      *srq;
 	ssize_t                             ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2530,6 +2608,9 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	struct ib_ah_attr		attr;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -2618,6 +2699,9 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	struct ib_uobject	   *uobj;
 	int			    ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2656,6 +2740,9 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 	struct ib_uverbs_mcast_entry *mcast;
 	int                           ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2703,6 +2790,9 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	struct ib_uverbs_mcast_entry *mcast;
 	int                           ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -3118,6 +3208,9 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	struct ib_udata                  udata;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -3151,6 +3244,9 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 	struct ib_udata                  udata;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -3178,6 +3274,9 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 	struct ib_srq_attr          attr;
 	int                         ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -3208,6 +3307,9 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 	struct ib_srq                   *srq;
 	int                             ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -3251,6 +3353,9 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	struct ib_usrq_object		 *us;
 	enum ib_srq_type		  srq_type;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
