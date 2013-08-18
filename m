From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 18/22] uverbs: check input length
Date: Sun, 18 Aug 2013 20:28:54 +0200
Message-ID: <54462c7808e1a7ecff5cf4c745596c4b0023be65.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Makes verbs functions check the length of the input buffer
before reading the command content: this will detect
truncated command and will prevent uverbs from reading past
userspace provided buffer.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 102 +++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6ca3c86..d0f9854 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -298,6 +298,9 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	struct file			 *filp;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -392,6 +395,9 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	struct ib_device_attr              attr;
 	int                                ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -461,6 +467,9 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	struct ib_port_attr              attr;
 	int                              ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -513,6 +522,9 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	struct ib_pd                  *pd;
 	int                            ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -584,6 +596,9 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	struct ib_uobject          *uobj;
 	int                         ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -710,6 +725,9 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	int				ret = 0;
 	int				new_xrcd = 0;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -845,6 +863,9 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	int                         live;
 	int                         ret = 0;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -922,6 +943,9 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	struct ib_mr                *mr;
 	int                          ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1020,6 +1044,9 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	struct ib_uobject	 *uobj;
 	int                       ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1060,6 +1087,9 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	struct ib_mw                  *mw;
 	int                            ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -1140,6 +1170,9 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	struct ib_uobject	   *uobj;
 	int                         ret = -EINVAL;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -1178,6 +1211,9 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 	struct file				  *filp;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1218,6 +1254,9 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	struct ib_cq                   *cq;
 	int                             ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1317,6 +1356,9 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 	struct ib_cq			*cq;
 	int				ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1382,6 +1424,9 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	struct ib_wc                   wc;
 	int                            ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1428,6 +1473,9 @@ ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
 	struct ib_uverbs_req_notify_cq cmd;
 	struct ib_cq                  *cq;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1455,6 +1503,9 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	struct ib_uverbs_event_file	*ev_file;
 	int                        	 ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1513,6 +1564,9 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	struct ib_qp_init_attr          attr;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1703,6 +1757,9 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	struct ib_qp_open_attr          attr;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -1795,6 +1852,9 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	struct ib_qp_init_attr         *init_attr;
 	int                            ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1908,6 +1968,9 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	struct ib_qp_attr         *attr;
 	int                        ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2001,6 +2064,9 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	struct ib_uqp_object        	*obj;
 	int                        	 ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2061,6 +2127,9 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	int				is_ud;
 	ssize_t                         ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2299,6 +2368,9 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	struct ib_qp                   *qp;
 	ssize_t                         ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2348,6 +2420,9 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	struct ib_srq                      *srq;
 	ssize_t                             ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2399,6 +2474,9 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	struct ib_ah_attr		attr;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -2485,6 +2563,9 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	struct ib_uobject	   *uobj;
 	int			    ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2523,6 +2604,9 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 	struct ib_uverbs_mcast_entry *mcast;
 	int                           ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2570,6 +2654,9 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	struct ib_uverbs_mcast_entry *mcast;
 	int                           ret = -EINVAL;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2740,6 +2827,9 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	struct ib_udata                  udata;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -2773,6 +2863,9 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 	struct ib_udata                  udata;
 	int ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -2800,6 +2893,9 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 	struct ib_srq_attr          attr;
 	int                         ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2830,6 +2926,9 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 	struct ib_srq                   *srq;
 	int                             ret;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
@@ -2873,6 +2972,9 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	struct ib_usrq_object		 *us;
 	enum ib_srq_type		  srq_type;
 
+	if (in_len < sizeof cmd)
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
