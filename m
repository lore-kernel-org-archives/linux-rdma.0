From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RDMA PATCH 10/16] i40iw: Add virtual channel message queue
Date: Thu,  7 Apr 2016 11:30:58 -0500
Message-ID: <1460046664-552-11-git-send-email-mustafa.ismail@intel.com>
References: <1460046664-552-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460046664-552-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Queue users of virtual channel on a waitqueue until the channel is
clear instead of failing the call when the channel is occupied.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c     | 47 +++++++++++---
 drivers/infiniband/hw/i40iw/i40iw_osdep.h    |  1 +
 drivers/infiniband/hw/i40iw/i40iw_type.h     |  3 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c    | 11 ++--
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |  8 +--
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c | 96 +++++++++++++++-------------
 6 files changed, 103 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index f49aea1..9cf5b3e 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1528,7 +1528,10 @@ static enum i40iw_status_code i40iw_setup_init_state(struct i40iw_handler *hdl,
 		goto exit;
 	iwdev->obj_next = iwdev->obj_mem;
 	iwdev->push_mode = push_mode;
+
 	init_waitqueue_head(&iwdev->vchnl_waitq);
+	init_waitqueue_head(&dev->vf_reqs);
+
 	status = i40iw_initialize_dev(iwdev, ldev);
 exit:
 	if (status) {
@@ -1707,7 +1710,6 @@ static void i40iw_vf_reset(struct i40e_info *ldev, struct i40e_client *client, u
 	for (i = 0; i < I40IW_MAX_PE_ENABLED_VF_COUNT; i++) {
 		if (!dev->vf_dev[i] || (dev->vf_dev[i]->vf_id != vf_id))
 			continue;
-
 		/* free all resources allocated on behalf of vf */
 		tmp_vfdev = dev->vf_dev[i];
 		spin_lock_irqsave(&dev->dev_pestat.stats_lock, flags);
@@ -1816,8 +1818,6 @@ static int i40iw_virtchnl_receive(struct i40e_info *ldev,
 	dev = &hdl->device.sc_dev;
 	iwdev = dev->back_dev;
 
-	i40iw_debug(dev, I40IW_DEBUG_VIRT, "msg %p, message length %u\n", msg, len);
-
 	if (dev->vchnl_if.vchnl_recv) {
 		ret_code = dev->vchnl_if.vchnl_recv(dev, vf_id, msg, len);
 		if (!dev->is_pf) {
@@ -1829,6 +1829,39 @@ static int i40iw_virtchnl_receive(struct i40e_info *ldev,
 }
 
 /**
+ * i40iw_vf_clear_to_send - wait to send virtual channel message
+ * @dev: iwarp device *
+ * Wait for until virtual channel is clear
+ * before sending the next message
+ *
+ * Returns false if error
+ * Returns true if clear to send
+ */
+bool i40iw_vf_clear_to_send(struct i40iw_sc_dev *dev)
+{
+	struct i40iw_device *iwdev;
+	wait_queue_t wait;
+
+	iwdev = dev->back_dev;
+
+	if (!wq_has_sleeper(&dev->vf_reqs) &&
+	    (atomic_read(&iwdev->vchnl_msgs) == 0))
+		return true; /* virtual channel is clear */
+
+	init_wait(&wait);
+	add_wait_queue_exclusive(&dev->vf_reqs, &wait);
+
+	if (!wait_event_timeout(dev->vf_reqs,
+				(atomic_read(&iwdev->vchnl_msgs) == 0),
+				I40IW_VCHNL_EVENT_TIMEOUT))
+		dev->vchnl_up = false;
+
+	remove_wait_queue(&dev->vf_reqs, &wait);
+
+	return dev->vchnl_up;
+}
+
+/**
  * i40iw_virtchnl_send - send a message through the virtual channel
  * @dev: iwarp device
  * @vf_id: virtual function id associated with the message
@@ -1845,18 +1878,16 @@ static enum i40iw_status_code i40iw_virtchnl_send(struct i40iw_sc_dev *dev,
 {
 	struct i40iw_device *iwdev;
 	struct i40e_info *ldev;
-	enum i40iw_status_code ret_code = I40IW_ERR_BAD_PTR;
 
 	if (!dev || !dev->back_dev)
-		return ret_code;
+		return I40IW_ERR_BAD_PTR;
 
 	iwdev = dev->back_dev;
 	ldev = iwdev->ldev;
 
 	if (ldev && ldev->ops && ldev->ops->virtchnl_send)
-		ret_code = ldev->ops->virtchnl_send(ldev, &i40iw_client, vf_id, msg, len);
-
-	return ret_code;
+		return ldev->ops->virtchnl_send(ldev, &i40iw_client, vf_id, msg, len);
+	return I40IW_ERR_BAD_PTR;
 }
 
 /* client interface functions */
diff --git a/drivers/infiniband/hw/i40iw/i40iw_osdep.h b/drivers/infiniband/hw/i40iw/i40iw_osdep.h
index 7e20493..80f422b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_osdep.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_osdep.h
@@ -172,6 +172,7 @@ struct i40iw_hw;
 u8 __iomem *i40iw_get_hw_addr(void *dev);
 void i40iw_ieq_mpa_crc_ae(struct i40iw_sc_dev *dev, struct i40iw_sc_qp *qp);
 enum i40iw_status_code i40iw_vf_wait_vchnl_resp(struct i40iw_sc_dev *dev);
+bool i40iw_vf_clear_to_send(struct i40iw_sc_dev *dev);
 enum i40iw_status_code i40iw_ieq_check_mpacrc(struct shash_desc *desc, void *addr,
 					      u32 length, u32 value);
 struct i40iw_sc_qp *i40iw_ieq_get_qp(struct i40iw_sc_dev *dev, struct i40iw_puda_buf *buf);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
index edb3a8c..5b6a491 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_type.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
@@ -483,12 +483,13 @@ struct i40iw_sc_dev {
 
 	struct i40iw_hmc_fpm_misc hmc_fpm_misc;
 	u16 qs_handle;
-	u32	debug_mask;
+	u32 debug_mask;
 	u16 exception_lan_queue;
 	u8 hmc_fn_id;
 	bool is_pf;
 	bool vchnl_up;
 	u8 vf_id;
+	wait_queue_head_t vf_reqs;
 	u64 cqp_cmd_stats[OP_SIZE_CQP_STAT_ARRAY];
 	struct i40iw_vchnl_vf_msg_buffer vchnl_vf_msg_buf;
 	u8 hw_rev;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index 7ed998c..cddd639 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -990,21 +990,24 @@ enum i40iw_status_code i40iw_cqp_commit_fpm_values_cmd(struct i40iw_sc_dev *dev,
 enum i40iw_status_code i40iw_vf_wait_vchnl_resp(struct i40iw_sc_dev *dev)
 {
 	struct i40iw_device *iwdev = dev->back_dev;
-	enum i40iw_status_code err_code = 0;
 	int timeout_ret;
 
 	i40iw_debug(dev, I40IW_DEBUG_VIRT, "%s[%u] dev %p, iwdev %p\n",
 		    __func__, __LINE__, dev, iwdev);
-	atomic_add(2, &iwdev->vchnl_msgs);
+
+	atomic_set(&iwdev->vchnl_msgs, 2);
 	timeout_ret = wait_event_timeout(iwdev->vchnl_waitq,
 					 (atomic_read(&iwdev->vchnl_msgs) == 1),
 					 I40IW_VCHNL_EVENT_TIMEOUT);
 	atomic_dec(&iwdev->vchnl_msgs);
 	if (!timeout_ret) {
 		i40iw_pr_err("virt channel completion timeout = 0x%x\n", timeout_ret);
-		err_code = I40IW_ERR_TIMEOUT;
+		atomic_set(&iwdev->vchnl_msgs, 0);
+		dev->vchnl_up = false;
+		return I40IW_ERR_TIMEOUT;
 	}
-	return err_code;
+	wake_up(&dev->vf_reqs);
+	return 0;
 }
 
 /**
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 04aa956..b7fd9f3 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2146,7 +2146,6 @@ static int i40iw_get_protocol_stats(struct ib_device *ibdev,
 	struct i40iw_dev_hw_stats *hw_stats = &devstat->hw_stats;
 	struct timespec curr_time;
 	static struct timespec last_rd_time = {0, 0};
-	enum i40iw_status_code status = 0;
 	unsigned long flags;
 
 	curr_time = current_kernel_time();
@@ -2159,11 +2158,8 @@ static int i40iw_get_protocol_stats(struct ib_device *ibdev,
 		spin_unlock_irqrestore(&devstat->stats_lock, flags);
 	} else {
 		if (((u64)curr_time.tv_sec - (u64)last_rd_time.tv_sec) > 1)
-			status = i40iw_vchnl_vf_get_pe_stats(dev,
-							     &devstat->hw_stats);
-
-		if (status)
-			return -ENOSYS;
+			if (i40iw_vchnl_vf_get_pe_stats(dev, &devstat->hw_stats))
+				return -ENOSYS;
 	}
 
 	stats->iw.ipInReceives = hw_stats->stat_value_64[I40IW_HW_STAT_INDEX_IP4RXPKTS] +
diff --git a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
index 6b68f78..4e1d7c6 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
@@ -437,11 +437,9 @@ enum i40iw_status_code i40iw_vchnl_recv_pf(struct i40iw_sc_dev *dev,
 			vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
 		return I40IW_SUCCESS;
 	}
-	for (iw_vf_idx = 0; iw_vf_idx < I40IW_MAX_PE_ENABLED_VF_COUNT;
-	     iw_vf_idx++) {
+	for (iw_vf_idx = 0; iw_vf_idx < I40IW_MAX_PE_ENABLED_VF_COUNT; iw_vf_idx++) {
 		if (!dev->vf_dev[iw_vf_idx]) {
-			if (first_avail_iw_vf ==
-			    I40IW_MAX_PE_ENABLED_VF_COUNT)
+			if (first_avail_iw_vf == I40IW_MAX_PE_ENABLED_VF_COUNT)
 				first_avail_iw_vf = iw_vf_idx;
 			continue;
 		}
@@ -596,23 +594,25 @@ enum i40iw_status_code i40iw_vchnl_vf_get_ver(struct i40iw_sc_dev *dev,
 	struct i40iw_virtchnl_req vchnl_req;
 	enum i40iw_status_code ret_code;
 
+	if (!i40iw_vf_clear_to_send(dev))
+		return I40IW_ERR_TIMEOUT;
 	memset(&vchnl_req, 0, sizeof(vchnl_req));
 	vchnl_req.dev = dev;
 	vchnl_req.parm = vchnl_ver;
 	vchnl_req.parm_len = sizeof(*vchnl_ver);
 	vchnl_req.vchnl_msg = &dev->vchnl_vf_msg_buf.vchnl_msg;
+
 	ret_code = vchnl_vf_send_get_ver_req(dev, &vchnl_req);
-	if (!ret_code) {
-		ret_code = i40iw_vf_wait_vchnl_resp(dev);
-		if (!ret_code)
-			ret_code = vchnl_req.ret_code;
-		else
-			dev->vchnl_up = false;
-	} else {
+	if (ret_code) {
 		i40iw_debug(dev, I40IW_DEBUG_VIRT,
 			    "%s Send message failed 0x%0x\n", __func__, ret_code);
+		return ret_code;
 	}
-	return ret_code;
+	ret_code = i40iw_vf_wait_vchnl_resp(dev);
+	if (ret_code)
+		return ret_code;
+	else
+		return vchnl_req.ret_code;
 }
 
 /**
@@ -626,23 +626,25 @@ enum i40iw_status_code i40iw_vchnl_vf_get_hmc_fcn(struct i40iw_sc_dev *dev,
 	struct i40iw_virtchnl_req vchnl_req;
 	enum i40iw_status_code ret_code;
 
+	if (!i40iw_vf_clear_to_send(dev))
+		return I40IW_ERR_TIMEOUT;
 	memset(&vchnl_req, 0, sizeof(vchnl_req));
 	vchnl_req.dev = dev;
 	vchnl_req.parm = hmc_fcn;
 	vchnl_req.parm_len = sizeof(*hmc_fcn);
 	vchnl_req.vchnl_msg = &dev->vchnl_vf_msg_buf.vchnl_msg;
+
 	ret_code = vchnl_vf_send_get_hmc_fcn_req(dev, &vchnl_req);
-	if (!ret_code) {
-		ret_code = i40iw_vf_wait_vchnl_resp(dev);
-		if (!ret_code)
-			ret_code = vchnl_req.ret_code;
-		else
-			dev->vchnl_up = false;
-	} else {
+	if (ret_code) {
 		i40iw_debug(dev, I40IW_DEBUG_VIRT,
 			    "%s Send message failed 0x%0x\n", __func__, ret_code);
+		return ret_code;
 	}
-	return ret_code;
+	ret_code = i40iw_vf_wait_vchnl_resp(dev);
+	if (ret_code)
+		return ret_code;
+	else
+		return vchnl_req.ret_code;
 }
 
 /**
@@ -660,25 +662,27 @@ enum i40iw_status_code i40iw_vchnl_vf_add_hmc_objs(struct i40iw_sc_dev *dev,
 	struct i40iw_virtchnl_req vchnl_req;
 	enum i40iw_status_code ret_code;
 
+	if (!i40iw_vf_clear_to_send(dev))
+		return I40IW_ERR_TIMEOUT;
 	memset(&vchnl_req, 0, sizeof(vchnl_req));
 	vchnl_req.dev = dev;
 	vchnl_req.vchnl_msg = &dev->vchnl_vf_msg_buf.vchnl_msg;
+
 	ret_code = vchnl_vf_send_add_hmc_objs_req(dev,
 						  &vchnl_req,
 						  rsrc_type,
 						  start_index,
 						  rsrc_count);
-	if (!ret_code) {
-		ret_code = i40iw_vf_wait_vchnl_resp(dev);
-		if (!ret_code)
-			ret_code = vchnl_req.ret_code;
-		else
-			dev->vchnl_up = false;
-	} else {
+	if (ret_code) {
 		i40iw_debug(dev, I40IW_DEBUG_VIRT,
 			    "%s Send message failed 0x%0x\n", __func__, ret_code);
+		return ret_code;
 	}
-	return ret_code;
+	ret_code = i40iw_vf_wait_vchnl_resp(dev);
+	if (ret_code)
+		return ret_code;
+	else
+		return vchnl_req.ret_code;
 }
 
 /**
@@ -696,25 +700,27 @@ enum i40iw_status_code i40iw_vchnl_vf_del_hmc_obj(struct i40iw_sc_dev *dev,
 	struct i40iw_virtchnl_req vchnl_req;
 	enum i40iw_status_code ret_code;
 
+	if (!i40iw_vf_clear_to_send(dev))
+		return I40IW_ERR_TIMEOUT;
 	memset(&vchnl_req, 0, sizeof(vchnl_req));
 	vchnl_req.dev = dev;
 	vchnl_req.vchnl_msg = &dev->vchnl_vf_msg_buf.vchnl_msg;
+
 	ret_code = vchnl_vf_send_del_hmc_objs_req(dev,
 						  &vchnl_req,
 						  rsrc_type,
 						  start_index,
 						  rsrc_count);
-	if (!ret_code) {
-		ret_code = i40iw_vf_wait_vchnl_resp(dev);
-		if (!ret_code)
-			ret_code = vchnl_req.ret_code;
-		else
-			dev->vchnl_up = false;
-	} else {
+	if (ret_code) {
 		i40iw_debug(dev, I40IW_DEBUG_VIRT,
 			    "%s Send message failed 0x%0x\n", __func__, ret_code);
+		return ret_code;
 	}
-	return ret_code;
+	ret_code = i40iw_vf_wait_vchnl_resp(dev);
+	if (ret_code)
+		return ret_code;
+	else
+		return vchnl_req.ret_code;
 }
 
 /**
@@ -728,21 +734,23 @@ enum i40iw_status_code i40iw_vchnl_vf_get_pe_stats(struct i40iw_sc_dev *dev,
 	struct i40iw_virtchnl_req  vchnl_req;
 	enum i40iw_status_code ret_code;
 
+	if (!i40iw_vf_clear_to_send(dev))
+		return I40IW_ERR_TIMEOUT;
 	memset(&vchnl_req, 0, sizeof(vchnl_req));
 	vchnl_req.dev = dev;
 	vchnl_req.parm = hw_stats;
 	vchnl_req.parm_len = sizeof(*hw_stats);
 	vchnl_req.vchnl_msg = &dev->vchnl_vf_msg_buf.vchnl_msg;
+
 	ret_code = vchnl_vf_send_get_pe_stats_req(dev, &vchnl_req);
-	if (!ret_code) {
-		ret_code = i40iw_vf_wait_vchnl_resp(dev);
-		if (!ret_code)
-			ret_code = vchnl_req.ret_code;
-		else
-			dev->vchnl_up = false;
-	} else {
+	if (ret_code) {
 		i40iw_debug(dev, I40IW_DEBUG_VIRT,
 			    "%s Send message failed 0x%0x\n", __func__, ret_code);
+		return ret_code;
 	}
-	return ret_code;
+	ret_code = i40iw_vf_wait_vchnl_resp(dev);
+	if (ret_code)
+		return ret_code;
+	else
+		return vchnl_req.ret_code;
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
