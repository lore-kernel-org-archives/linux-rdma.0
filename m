From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V4 2/5] IB/uverbs: Explicitly pass ib_dev to uverbs commands
Date: Thu, 11 Jun 2015 15:56:51 +0300
Message-ID: <1434027414-711-3-git-send-email-yishaih@mellanox.com>
References: <1434027414-711-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434027414-711-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Done in preparation for deploying RCU for the device removal
flow. Allows isolating the RCU handling to the uverb_main layer and
keeping the uverbs_cmd code as is.

Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |    3 +
 drivers/infiniband/core/uverbs_cmd.c  |  100 ++++++++++++++++++++++-----------
 drivers/infiniband/core/uverbs_main.c |   21 +++++--
 3 files changed, 85 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index b716b08..1bf9d04 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -177,6 +177,7 @@ extern struct idr ib_uverbs_rule_idr;
 void idr_remove_uobj(struct idr *idp, struct ib_uobject *uobj);
 
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
+					struct ib_device *ib_dev,
 					int is_async);
 struct ib_uverbs_event_file *ib_uverbs_lookup_comp_file(int fd);
 
@@ -212,6 +213,7 @@ struct ib_uverbs_flow_spec {
 
 #define IB_UVERBS_DECLARE_CMD(name)					\
 	ssize_t ib_uverbs_##name(struct ib_uverbs_file *file,		\
+				 struct ib_device *ib_dev,              \
 				 const char __user *buf, int in_len,	\
 				 int out_len)
 
@@ -253,6 +255,7 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
 
 #define IB_UVERBS_DECLARE_EX_CMD(name)				\
 	int ib_uverbs_ex_##name(struct ib_uverbs_file *file,	\
+				struct ib_device *ib_dev,		\
 				struct ib_udata *ucore,		\
 				struct ib_udata *uhw)
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 0bbab72..6f77beb 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -282,13 +282,13 @@ static void put_xrcd_read(struct ib_uobject *uobj)
 }
 
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
+			      struct ib_device *ib_dev,
 			      const char __user *buf,
 			      int in_len, int out_len)
 {
 	struct ib_uverbs_get_context      cmd;
 	struct ib_uverbs_get_context_resp resp;
 	struct ib_udata                   udata;
-	struct ib_device                 *ibdev = file->device->ib_dev;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	struct ib_device_attr		  dev_attr;
 #endif
@@ -313,13 +313,13 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	ucontext = ibdev->alloc_ucontext(ibdev, &udata);
+	ucontext = ib_dev->alloc_ucontext(ib_dev, &udata);
 	if (IS_ERR(ucontext)) {
 		ret = PTR_ERR(ucontext);
 		goto err;
 	}
 
-	ucontext->device = ibdev;
+	ucontext->device = ib_dev;
 	INIT_LIST_HEAD(&ucontext->pd_list);
 	INIT_LIST_HEAD(&ucontext->mr_list);
 	INIT_LIST_HEAD(&ucontext->mw_list);
@@ -340,7 +340,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	ucontext->odp_mrs_count = 0;
 	INIT_LIST_HEAD(&ucontext->no_private_counters);
 
-	ret = ib_query_device(ibdev, &dev_attr);
+	ret = ib_query_device(ib_dev, &dev_attr);
 	if (ret)
 		goto err_free;
 	if (!(dev_attr.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
@@ -355,7 +355,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		goto err_free;
 	resp.async_fd = ret;
 
-	filp = ib_uverbs_alloc_event_file(file, 1);
+	filp = ib_uverbs_alloc_event_file(file, ib_dev, 1);
 	if (IS_ERR(filp)) {
 		ret = PTR_ERR(filp);
 		goto err_fd;
@@ -384,7 +384,7 @@ err_fd:
 
 err_free:
 	put_pid(ucontext->tgid);
-	ibdev->dealloc_ucontext(ucontext);
+	ib_dev->dealloc_ucontext(ucontext);
 
 err:
 	mutex_unlock(&file->mutex);
@@ -392,11 +392,12 @@ err:
 }
 
 static void copy_query_dev_fields(struct ib_uverbs_file *file,
+				  struct ib_device *ib_dev,
 				  struct ib_uverbs_query_device_resp *resp,
 				  struct ib_device_attr *attr)
 {
 	resp->fw_ver		= attr->fw_ver;
-	resp->node_guid		= file->device->ib_dev->node_guid;
+	resp->node_guid		= ib_dev->node_guid;
 	resp->sys_image_guid	= attr->sys_image_guid;
 	resp->max_mr_size	= attr->max_mr_size;
 	resp->page_size_cap	= attr->page_size_cap;
@@ -434,10 +435,11 @@ static void copy_query_dev_fields(struct ib_uverbs_file *file,
 	resp->max_srq_sge		= attr->max_srq_sge;
 	resp->max_pkeys			= attr->max_pkeys;
 	resp->local_ca_ack_delay	= attr->local_ca_ack_delay;
-	resp->phys_port_cnt		= file->device->ib_dev->phys_port_cnt;
+	resp->phys_port_cnt		= ib_dev->phys_port_cnt;
 }
 
 ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
+			       struct ib_device *ib_dev,
 			       const char __user *buf,
 			       int in_len, int out_len)
 {
@@ -452,12 +454,12 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	ret = ib_query_device(file->device->ib_dev, &attr);
+	ret = ib_query_device(ib_dev, &attr);
 	if (ret)
 		return ret;
 
 	memset(&resp, 0, sizeof resp);
-	copy_query_dev_fields(file, &resp, &attr);
+	copy_query_dev_fields(file, ib_dev, &resp, &attr);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -467,6 +469,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
+			     struct ib_device *ib_dev,
 			     const char __user *buf,
 			     int in_len, int out_len)
 {
@@ -481,7 +484,7 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	ret = ib_query_port(file->device->ib_dev, cmd.port_num, &attr);
+	ret = ib_query_port(ib_dev, cmd.port_num, &attr);
 	if (ret)
 		return ret;
 
@@ -506,7 +509,7 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.active_width    = attr.active_width;
 	resp.active_speed    = attr.active_speed;
 	resp.phys_state      = attr.phys_state;
-	resp.link_layer      = rdma_port_get_link_layer(file->device->ib_dev,
+	resp.link_layer      = rdma_port_get_link_layer(ib_dev,
 							cmd.port_num);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
@@ -517,6 +520,7 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
+			   struct ib_device *ib_dev,
 			   const char __user *buf,
 			   int in_len, int out_len)
 {
@@ -544,14 +548,13 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
 	down_write(&uobj->mutex);
 
-	pd = file->device->ib_dev->alloc_pd(file->device->ib_dev,
-					    file->ucontext, &udata);
+	pd = ib_dev->alloc_pd(ib_dev, file->ucontext, &udata);
 	if (IS_ERR(pd)) {
 		ret = PTR_ERR(pd);
 		goto err;
 	}
 
-	pd->device  = file->device->ib_dev;
+	pd->device  = ib_dev;
 	pd->uobject = uobj;
 	atomic_set(&pd->usecnt, 0);
 
@@ -591,6 +594,7 @@ err:
 }
 
 ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
+			     struct ib_device *ib_dev,
 			     const char __user *buf,
 			     int in_len, int out_len)
 {
@@ -711,6 +715,7 @@ static void xrcd_table_delete(struct ib_uverbs_device *dev,
 }
 
 ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
+			    struct ib_device *ib_dev,
 			    const char __user *buf, int in_len,
 			    int out_len)
 {
@@ -769,15 +774,14 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	down_write(&obj->uobject.mutex);
 
 	if (!xrcd) {
-		xrcd = file->device->ib_dev->alloc_xrcd(file->device->ib_dev,
-							file->ucontext, &udata);
+		xrcd = ib_dev->alloc_xrcd(ib_dev, file->ucontext, &udata);
 		if (IS_ERR(xrcd)) {
 			ret = PTR_ERR(xrcd);
 			goto err;
 		}
 
 		xrcd->inode   = inode;
-		xrcd->device  = file->device->ib_dev;
+		xrcd->device  = ib_dev;
 		atomic_set(&xrcd->usecnt, 0);
 		mutex_init(&xrcd->tgt_qp_mutex);
 		INIT_LIST_HEAD(&xrcd->tgt_qp_list);
@@ -848,6 +852,7 @@ err_tree_mutex_unlock:
 }
 
 ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
+			     struct ib_device *ib_dev,
 			     const char __user *buf, int in_len,
 			     int out_len)
 {
@@ -925,6 +930,7 @@ void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
 }
 
 ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
+			 struct ib_device *ib_dev,
 			 const char __user *buf, int in_len,
 			 int out_len)
 {
@@ -1034,6 +1040,7 @@ err_free:
 }
 
 ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
+			   struct ib_device *ib_dev,
 			   const char __user *buf, int in_len,
 			   int out_len)
 {
@@ -1127,6 +1134,7 @@ put_uobjs:
 }
 
 ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
+			   struct ib_device *ib_dev,
 			   const char __user *buf, int in_len,
 			   int out_len)
 {
@@ -1165,8 +1173,9 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
-			 const char __user *buf, int in_len,
-			 int out_len)
+			   struct ib_device *ib_dev,
+			   const char __user *buf, int in_len,
+			   int out_len)
 {
 	struct ib_uverbs_alloc_mw      cmd;
 	struct ib_uverbs_alloc_mw_resp resp;
@@ -1247,8 +1256,9 @@ err_free:
 }
 
 ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
-			   const char __user *buf, int in_len,
-			   int out_len)
+			     struct ib_device *ib_dev,
+			     const char __user *buf, int in_len,
+			     int out_len)
 {
 	struct ib_uverbs_dealloc_mw cmd;
 	struct ib_mw               *mw;
@@ -1285,6 +1295,7 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
+				      struct ib_device *ib_dev,
 				      const char __user *buf, int in_len,
 				      int out_len)
 {
@@ -1304,7 +1315,7 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 		return ret;
 	resp.fd = ret;
 
-	filp = ib_uverbs_alloc_event_file(file, 0);
+	filp = ib_uverbs_alloc_event_file(file, ib_dev, 0);
 	if (IS_ERR(filp)) {
 		put_unused_fd(resp.fd);
 		return PTR_ERR(filp);
@@ -1322,6 +1333,7 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
+			    struct ib_device *ib_dev,
 			    const char __user *buf, int in_len,
 			    int out_len)
 {
@@ -1367,15 +1379,14 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&obj->comp_list);
 	INIT_LIST_HEAD(&obj->async_list);
 
-	cq = file->device->ib_dev->create_cq(file->device->ib_dev, cmd.cqe,
-					     cmd.comp_vector,
-					     file->ucontext, &udata);
+	cq = ib_dev->create_cq(ib_dev, cmd.cqe, cmd.comp_vector,
+			       file->ucontext, &udata);
 	if (IS_ERR(cq)) {
 		ret = PTR_ERR(cq);
 		goto err_file;
 	}
 
-	cq->device        = file->device->ib_dev;
+	cq->device        = ib_dev;
 	cq->uobject       = &obj->uobject;
 	cq->comp_handler  = ib_uverbs_comp_handler;
 	cq->event_handler = ib_uverbs_cq_event_handler;
@@ -1423,6 +1434,7 @@ err:
 }
 
 ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
+			    struct ib_device *ib_dev,
 			    const char __user *buf, int in_len,
 			    int out_len)
 {
@@ -1486,6 +1498,7 @@ static int copy_wc_to_user(void __user *dest, struct ib_wc *wc)
 }
 
 ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
+			  struct ib_device *ib_dev,
 			  const char __user *buf, int in_len,
 			  int out_len)
 {
@@ -1537,6 +1550,7 @@ out_put:
 }
 
 ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
+				struct ib_device *ib_dev,
 				const char __user *buf, int in_len,
 				int out_len)
 {
@@ -1559,6 +1573,7 @@ ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
+			     struct ib_device *ib_dev,
 			     const char __user *buf, int in_len,
 			     int out_len)
 {
@@ -1611,6 +1626,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
+			    struct ib_device *ib_dev,
 			    const char __user *buf, int in_len,
 			    int out_len)
 {
@@ -1806,6 +1822,7 @@ err_put:
 }
 
 ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
+			  struct ib_device *ib_dev,
 			  const char __user *buf, int in_len, int out_len)
 {
 	struct ib_uverbs_open_qp        cmd;
@@ -1900,6 +1917,7 @@ err_put:
 }
 
 ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
+			   struct ib_device *ib_dev,
 			   const char __user *buf, int in_len,
 			   int out_len)
 {
@@ -2014,6 +2032,7 @@ static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
 }
 
 ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
+			    struct ib_device *ib_dev,
 			    const char __user *buf, int in_len,
 			    int out_len)
 {
@@ -2110,6 +2129,7 @@ out:
 }
 
 ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
+			     struct ib_device *ib_dev,
 			     const char __user *buf, int in_len,
 			     int out_len)
 {
@@ -2168,6 +2188,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
+			    struct ib_device *ib_dev,
 			    const char __user *buf, int in_len,
 			    int out_len)
 {
@@ -2412,6 +2433,7 @@ err:
 }
 
 ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
+			    struct ib_device *ib_dev,
 			    const char __user *buf, int in_len,
 			    int out_len)
 {
@@ -2461,6 +2483,7 @@ out:
 }
 
 ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
+				struct ib_device *ib_dev,
 				const char __user *buf, int in_len,
 				int out_len)
 {
@@ -2510,6 +2533,7 @@ out:
 }
 
 ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
+			    struct ib_device *ib_dev,
 			    const char __user *buf, int in_len,
 			    int out_len)
 {
@@ -2602,6 +2626,7 @@ err:
 }
 
 ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
+			     struct ib_device *ib_dev,
 			     const char __user *buf, int in_len, int out_len)
 {
 	struct ib_uverbs_destroy_ah cmd;
@@ -2638,6 +2663,7 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
+			       struct ib_device *ib_dev,
 			       const char __user *buf, int in_len,
 			       int out_len)
 {
@@ -2685,6 +2711,7 @@ out_put:
 }
 
 ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
+			       struct ib_device *ib_dev,
 			       const char __user *buf, int in_len,
 			       int out_len)
 {
@@ -2765,6 +2792,7 @@ static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
 }
 
 int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
+			     struct ib_device *ib_dev,
 			     struct ib_udata *ucore,
 			     struct ib_udata *uhw)
 {
@@ -2925,6 +2953,7 @@ err_free_attr:
 }
 
 int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
+			      struct ib_device *ib_dev,
 			      struct ib_udata *ucore,
 			      struct ib_udata *uhw)
 {
@@ -2967,6 +2996,7 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 }
 
 static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
+				struct ib_device *ib_dev,
 				struct ib_uverbs_create_xsrq *cmd,
 				struct ib_udata *udata)
 {
@@ -3100,6 +3130,7 @@ err:
 }
 
 ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
+			     struct ib_device *ib_dev,
 			     const char __user *buf, int in_len,
 			     int out_len)
 {
@@ -3127,7 +3158,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	ret = __uverbs_create_xsrq(file, &xcmd, &udata);
+	ret = __uverbs_create_xsrq(file, ib_dev, &xcmd, &udata);
 	if (ret)
 		return ret;
 
@@ -3135,6 +3166,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
+			      struct ib_device *ib_dev,
 			      const char __user *buf, int in_len, int out_len)
 {
 	struct ib_uverbs_create_xsrq     cmd;
@@ -3152,7 +3184,7 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	ret = __uverbs_create_xsrq(file, &cmd, &udata);
+	ret = __uverbs_create_xsrq(file, ib_dev, &cmd, &udata);
 	if (ret)
 		return ret;
 
@@ -3160,6 +3192,7 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
+			     struct ib_device *ib_dev,
 			     const char __user *buf, int in_len,
 			     int out_len)
 {
@@ -3190,6 +3223,7 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
+			    struct ib_device *ib_dev,
 			    const char __user *buf,
 			    int in_len, int out_len)
 {
@@ -3230,6 +3264,7 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 }
 
 ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
+			      struct ib_device *ib_dev,
 			      const char __user *buf, int in_len,
 			      int out_len)
 {
@@ -3287,16 +3322,15 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 }
 
 int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
+			      struct ib_device *ib_dev,
 			      struct ib_udata *ucore,
 			      struct ib_udata *uhw)
 {
 	struct ib_uverbs_ex_query_device_resp resp;
 	struct ib_uverbs_ex_query_device  cmd;
 	struct ib_device_attr attr;
-	struct ib_device *device;
 	int err;
 
-	device = file->device->ib_dev;
 	if (ucore->inlen < sizeof(cmd))
 		return -EINVAL;
 
@@ -3315,11 +3349,11 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	if (ucore->outlen < resp.response_length)
 		return -ENOSPC;
 
-	err = device->query_device(device, &attr);
+	err = ib_dev->query_device(ib_dev, &attr);
 	if (err)
 		return err;
 
-	copy_query_dev_fields(file, &resp.base, &attr);
+	copy_query_dev_fields(file, ib_dev, &resp.base, &attr);
 	resp.comp_mask = 0;
 
 	if (ucore->outlen < resp.response_length + sizeof(resp.odp_caps))
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 882d24d..8675290 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -79,6 +79,7 @@ static DEFINE_SPINLOCK(map_lock);
 static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
 
 static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
+				     struct ib_device *ib_dev,
 				     const char __user *buf, int in_len,
 				     int out_len) = {
 	[IB_USER_VERBS_CMD_GET_CONTEXT]		= ib_uverbs_get_context,
@@ -119,6 +120,7 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 };
 
 static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
+				    struct ib_device *ib_dev,
 				    struct ib_udata *ucore,
 				    struct ib_udata *uhw) = {
 	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	= ib_uverbs_ex_create_flow,
@@ -540,6 +542,7 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 }
 
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
+					struct ib_device	*ib_dev,
 					int is_async)
 {
 	struct ib_uverbs_event_file *ev_file;
@@ -567,7 +570,7 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 	if (is_async) {
 		uverbs_file->async_file = ev_file;
 		INIT_IB_EVENT_HANDLER(&uverbs_file->event_handler,
-				      uverbs_file->device->ib_dev,
+				      ib_dev,
 				      ib_uverbs_event_handler);
 		ret = ib_register_event_handler(&uverbs_file->event_handler);
 		if (ret)
@@ -618,9 +621,13 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			     size_t count, loff_t *pos)
 {
 	struct ib_uverbs_file *file = filp->private_data;
+	struct ib_device *ib_dev = file->device->ib_dev;
 	struct ib_uverbs_cmd_hdr hdr;
 	__u32 flags;
 
+	if (!ib_dev)
+		return -ENODEV;
+
 	if (count < sizeof hdr)
 		return -EINVAL;
 
@@ -647,13 +654,13 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		    command != IB_USER_VERBS_CMD_GET_CONTEXT)
 			return -EINVAL;
 
-		if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull << command)))
+		if (!(ib_dev->uverbs_cmd_mask & (1ull << command)))
 			return -ENOSYS;
 
 		if (hdr.in_words * 4 != count)
 			return -EINVAL;
 
-		return uverbs_cmd_table[command](file,
+		return uverbs_cmd_table[command](file, ib_dev,
 						 buf + sizeof(hdr),
 						 hdr.in_words * 4,
 						 hdr.out_words * 4);
@@ -680,7 +687,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		if (!file->ucontext)
 			return -EINVAL;
 
-		if (!(file->device->ib_dev->uverbs_ex_cmd_mask & (1ull << command)))
+		if (!(ib_dev->uverbs_ex_cmd_mask & (1ull << command)))
 			return -ENOSYS;
 
 		if (count < (sizeof(hdr) + sizeof(ex_hdr)))
@@ -721,6 +728,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 				       ex_hdr.provider_out_words * 8);
 
 		err = uverbs_ex_cmd_table[command](file,
+						   ib_dev,
 						   &ucore,
 						   &uhw);
 
@@ -736,11 +744,12 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct ib_uverbs_file *file = filp->private_data;
+	struct ib_device *ib_dev = file->device->ib_dev;
 
-	if (!file->ucontext)
+	if (!ib_dev || !file->ucontext)
 		return -ENODEV;
 	else
-		return file->device->ib_dev->mmap(file->ucontext, vma);
+		return ib_dev->mmap(file->ucontext, vma);
 }
 
 /*
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
