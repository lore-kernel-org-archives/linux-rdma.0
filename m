From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH rdma-next 2/3] RDMA/hns: Stop sending mailbox&cmq&doorbell when reset occured or is occuring
Date: Fri, 23 Nov 2018 23:14:24 +0800
Message-ID: <1542986065-44265-3-git-send-email-xavier.huwei@huawei.com>
References: <1542986065-44265-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542986065-44265-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org

This patch stops sending mailbox&cmq&doorbell to the hardware
When reset occured or is occuring to ensure that hardware
can work normally.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_cmd.c    |  32 ++++--
 drivers/infiniband/hw/hns/hns_roce_device.h |   8 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 169 ++++++++++++++++++++++++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  14 +++
 4 files changed, 206 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
index a0ba19d..2acf946 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
@@ -176,17 +176,33 @@ int hns_roce_cmd_mbox(struct hns_roce_dev *hr_dev, u64 in_param, u64 out_param,
 		      unsigned long in_modifier, u8 op_modifier, u16 op,
 		      unsigned long timeout)
 {
-	if (hr_dev->is_reset)
-		return 0;
+	int ret;
+
+	if (hr_dev->hw->rst_prc_mbox) {
+		ret = hr_dev->hw->rst_prc_mbox(hr_dev);
+		if (ret == CMD_RST_PRC_SUCCESS)
+			return 0;
+		else if (ret == CMD_RST_PRC_EBUSY)
+			return -EBUSY;
+	}
 
 	if (hr_dev->cmd.use_events)
-		return hns_roce_cmd_mbox_wait(hr_dev, in_param, out_param,
-					      in_modifier, op_modifier, op,
-					      timeout);
+		ret = hns_roce_cmd_mbox_wait(hr_dev, in_param, out_param,
+					     in_modifier, op_modifier, op,
+					     timeout);
 	else
-		return hns_roce_cmd_mbox_poll(hr_dev, in_param, out_param,
-					      in_modifier, op_modifier, op,
-					      timeout);
+		ret = hns_roce_cmd_mbox_poll(hr_dev, in_param, out_param,
+					     in_modifier, op_modifier, op,
+					     timeout);
+
+	if (ret == CMD_RST_PRC_EBUSY)
+		return -EBUSY;
+
+	if (ret && (hr_dev->hw->rst_prc_mbox &&
+		    hr_dev->hw->rst_prc_mbox(hr_dev) == CMD_RST_PRC_SUCCESS))
+		return 0;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hns_roce_cmd_mbox);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index d0d03a6..259977b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -237,6 +237,12 @@ enum {
 	HNS_ROCE_RST_DIRECT_RETURN		= 0,
 };
 
+enum {
+	CMD_RST_PRC_OTHERS,
+	CMD_RST_PRC_SUCCESS,
+	CMD_RST_PRC_EBUSY,
+};
+
 #define HNS_ROCE_CMD_SUCCESS			1
 
 #define HNS_ROCE_PORT_DOWN			0
@@ -888,6 +894,7 @@ struct hns_roce_hw {
 			 u64 out_param, u32 in_modifier, u8 op_modifier, u16 op,
 			 u16 token, int event);
 	int (*chk_mbox)(struct hns_roce_dev *hr_dev, unsigned long timeout);
+	int (*rst_prc_mbox)(struct hns_roce_dev *hr_dev);
 	int (*set_gid)(struct hns_roce_dev *hr_dev, u8 port, int gid_index,
 		       const union ib_gid *gid, const struct ib_gid_attr *attr);
 	int (*set_mac)(struct hns_roce_dev *hr_dev, u8 phy_port, u8 *addr);
@@ -952,6 +959,7 @@ struct hns_roce_dev {
 	spinlock_t		bt_cmd_lock;
 	bool			active;
 	bool			is_reset;
+	bool			dis_db;
 	unsigned long		reset_cnt;
 	struct hns_roce_ib_iboe iboe;
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 896dd59..1d639a0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -587,7 +587,7 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
 		roce_set_field(sq_db.parameter, V2_DB_PARAMETER_SL_M,
 			       V2_DB_PARAMETER_SL_S, qp->sl);
 
-		hns_roce_write64_k((__le32 *)&sq_db, qp->sq.db_reg_l);
+		hns_roce_write64(hr_dev, (__le32 *)&sq_db, qp->sq.db_reg_l);
 
 		qp->sq_next_wqe = ind;
 		qp->next_sge = sge_ind;
@@ -712,6 +712,128 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp,
 	return ret;
 }
 
+static int hns_roce_v2_cmd_hw_reseted(struct hns_roce_dev *hr_dev,
+				      unsigned long instance_stage,
+				      unsigned long reset_stage)
+{
+	/* When hardware reset has been completed once or more, we should stop
+	 * sending mailbox&cmq&doorbell to hardware. If now in .init_instance()
+	 * function, we should exit with error. If now at HNAE3_INIT_CLIENT
+	 * stage of soft reset process, we should exit with error, and then
+	 * HNAE3_INIT_CLIENT related process can rollback the operation like
+	 * notifing hardware to free resources, HNAE3_INIT_CLIENT related
+	 * process will exit with error to notify NIC driver to reschedule soft
+	 * reset process once again.
+	 */
+	hr_dev->is_reset = true;
+	hr_dev->dis_db = true;
+
+	if (reset_stage == HNS_ROCE_STATE_RST_INIT ||
+	    instance_stage == HNS_ROCE_STATE_INIT)
+		return CMD_RST_PRC_EBUSY;
+
+	return CMD_RST_PRC_SUCCESS;
+}
+
+static int hns_roce_v2_cmd_hw_resetting(struct hns_roce_dev *hr_dev,
+					unsigned long instance_stage,
+					unsigned long reset_stage)
+{
+	struct hns_roce_v2_priv *priv = (struct hns_roce_v2_priv *)hr_dev->priv;
+	struct hnae3_handle *handle = priv->handle;
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	unsigned long end;
+
+	/* When hardware reset is detected, we should stop sending mailbox&cmq&
+	 * doorbell to hardware, and wait until hardware reset finished. If now
+	 * in .init_instance() function, we should exit with error. If now at
+	 * HNAE3_INIT_CLIENT stage of soft reset process, we should exit with
+	 * error, and then HNAE3_INIT_CLIENT related process can rollback the
+	 * operation like notifing hardware to free resources, HNAE3_INIT_CLIENT
+	 * related process will exit with error to notify NIC driver to
+	 * reschedule soft reset process once again.
+	 */
+	hr_dev->dis_db = true;
+	end = msecs_to_jiffies(HNS_ROCE_V2_HW_RST_TIMEOUT) + jiffies;
+	while (ops->get_hw_reset_stat(handle) && time_before(jiffies, end))
+		udelay(1);
+
+	if (!ops->get_hw_reset_stat(handle))
+		hr_dev->is_reset = true;
+	else
+		dev_warn(hr_dev->dev, "hw_resetting!\n");
+
+	if (!hr_dev->is_reset || reset_stage == HNS_ROCE_STATE_RST_INIT ||
+	    instance_stage == HNS_ROCE_STATE_INIT)
+		return CMD_RST_PRC_EBUSY;
+
+	return CMD_RST_PRC_SUCCESS;
+}
+
+static int hns_roce_v2_cmd_sw_resetting(struct hns_roce_dev *hr_dev)
+{
+	struct hns_roce_v2_priv *priv = (struct hns_roce_v2_priv *)hr_dev->priv;
+	struct hnae3_handle *handle = priv->handle;
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	unsigned long end;
+
+	/* When software reset is detected at .init_instance() function, we
+	 * should stop sending mailbox&cmq&doorbell to hardware, and
+	 * wait until hardware reset finished, we should exit with error.
+	 */
+	hr_dev->dis_db = true;
+	end = msecs_to_jiffies(HNS_ROCE_V2_HW_RST_TIMEOUT) + jiffies;
+	while (ops->ae_dev_reset_cnt(handle) == hr_dev->reset_cnt &&
+	       time_before(jiffies, end))
+		udelay(1);
+
+	if (ops->ae_dev_reset_cnt(handle) != hr_dev->reset_cnt)
+		hr_dev->is_reset = true;
+	else
+		dev_warn(hr_dev->dev, "reset_cnt no change!\n");
+
+	return CMD_RST_PRC_EBUSY;
+}
+
+static int hns_roce_v2_rst_process_cmd(struct hns_roce_dev *hr_dev)
+{
+	struct hns_roce_v2_priv *priv = (struct hns_roce_v2_priv *)hr_dev->priv;
+	struct hnae3_handle *handle = priv->handle;
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	unsigned long instance_stage;	/* the current instance stage */
+	unsigned long reset_stage;	/* the current reset stage */
+	unsigned long reset_cnt;
+	bool sw_resetting;
+	bool hw_resetting;
+
+	if (hr_dev->is_reset)
+		return CMD_RST_PRC_SUCCESS;
+
+	/* Get information about reset from NIC driver or RoCE driver itself,
+	 * the meaning of the following variables from NIC driver are described
+	 * as below:
+	 * reset_cnt -- The count value of completed hardware reset.
+	 * hw_resetting -- Whether hardware device is resetting now.
+	 * sw_resetting -- Whether NIC's software reset process is running now.
+	 */
+	instance_stage = handle->rinfo.instance_state;
+	reset_stage = handle->rinfo.reset_state;
+	reset_cnt = ops->ae_dev_reset_cnt(handle);
+	hw_resetting = ops->get_hw_reset_stat(handle);
+	sw_resetting = ops->ae_dev_resetting(handle);
+
+	if (reset_cnt != hr_dev->reset_cnt)
+		return hns_roce_v2_cmd_hw_reseted(hr_dev, instance_stage,
+						  reset_stage);
+	else if (hw_resetting)
+		return hns_roce_v2_cmd_hw_resetting(hr_dev, instance_stage,
+						    reset_stage);
+	else if (sw_resetting && instance_stage == HNS_ROCE_STATE_INIT)
+		return hns_roce_v2_cmd_sw_resetting(hr_dev);
+
+	return 0;
+}
+
 static int hns_roce_cmq_space(struct hns_roce_v2_cmq_ring *ring)
 {
 	int ntu = ring->next_to_use;
@@ -892,8 +1014,8 @@ static int hns_roce_cmq_csq_clean(struct hns_roce_dev *hr_dev)
 	return clean;
 }
 
-static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
-			     struct hns_roce_cmq_desc *desc, int num)
+static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
+			       struct hns_roce_cmq_desc *desc, int num)
 {
 	struct hns_roce_v2_priv *priv = (struct hns_roce_v2_priv *)hr_dev->priv;
 	struct hns_roce_v2_cmq_ring *csq = &priv->cmq.csq;
@@ -905,9 +1027,6 @@ static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	int ret = 0;
 	int ntc;
 
-	if (hr_dev->is_reset)
-		return 0;
-
 	spin_lock_bh(&csq->lock);
 
 	if (num > hns_roce_cmq_space(csq)) {
@@ -982,6 +1101,30 @@ static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
+int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
+			     struct hns_roce_cmq_desc *desc, int num)
+{
+	int retval;
+	int ret;
+
+	ret = hns_roce_v2_rst_process_cmd(hr_dev);
+	if (ret == CMD_RST_PRC_SUCCESS)
+		return 0;
+	if (ret == CMD_RST_PRC_EBUSY)
+		return ret;
+
+	ret = __hns_roce_cmq_send(hr_dev, desc, num);
+	if (ret) {
+		retval = hns_roce_v2_rst_process_cmd(hr_dev);
+		if (retval == CMD_RST_PRC_SUCCESS)
+			return 0;
+		else if (retval == CMD_RST_PRC_EBUSY)
+			return retval;
+	}
+
+	return ret;
+}
+
 static int hns_roce_cmq_query_hw_info(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_query_version *resp;
@@ -1816,6 +1959,9 @@ static int hns_roce_v2_chk_mbox(struct hns_roce_dev *hr_dev,
 
 	status = hns_roce_v2_cmd_complete(hr_dev);
 	if (status != 0x1) {
+		if (status == CMD_RST_PRC_EBUSY)
+			return status;
+
 		dev_err(dev, "mailbox status 0x%x!\n", status);
 		return -EBUSY;
 	}
@@ -2326,6 +2472,7 @@ static void hns_roce_v2_write_cqc(struct hns_roce_dev *hr_dev,
 static int hns_roce_v2_req_notify_cq(struct ib_cq *ibcq,
 				     enum ib_cq_notify_flags flags)
 {
+	struct hns_roce_dev *hr_dev = to_hr_dev(ibcq->device);
 	struct hns_roce_cq *hr_cq = to_hr_cq(ibcq);
 	u32 notification_flag;
 	u32 doorbell[2];
@@ -2351,7 +2498,7 @@ static int hns_roce_v2_req_notify_cq(struct ib_cq *ibcq,
 	roce_set_bit(doorbell[1], V2_CQ_DB_PARAMETER_NOTIFY_S,
 		     notification_flag);
 
-	hns_roce_write64_k(doorbell, hr_cq->cq_db_l);
+	hns_roce_write64(hr_dev, doorbell, hr_cq->cq_db_l);
 
 	return 0;
 }
@@ -4566,6 +4713,7 @@ static void hns_roce_v2_init_irq_work(struct hns_roce_dev *hr_dev,
 
 static void set_eq_cons_index_v2(struct hns_roce_eq *eq)
 {
+	struct hns_roce_dev *hr_dev = eq->hr_dev;
 	u32 doorbell[2];
 
 	doorbell[0] = 0;
@@ -4592,7 +4740,7 @@ static void set_eq_cons_index_v2(struct hns_roce_eq *eq)
 		       HNS_ROCE_V2_EQ_DB_PARA_S,
 		       (eq->cons_index & HNS_ROCE_V2_CONS_IDX_M));
 
-	hns_roce_write64_k(doorbell, eq->doorbell);
+	hns_roce_write64(hr_dev, doorbell, eq->doorbell);
 }
 
 static struct hns_roce_aeqe *get_aeqe_v2(struct hns_roce_eq *eq, u32 entry)
@@ -5814,6 +5962,7 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 				     const struct ib_recv_wr *wr,
 				     const struct ib_recv_wr **bad_wr)
 {
+	struct hns_roce_dev *hr_dev = to_hr_dev(ibsrq->device);
 	struct hns_roce_srq *srq = to_hr_srq(ibsrq);
 	struct hns_roce_v2_wqe_data_seg *dseg;
 	struct hns_roce_v2_db srq_db;
@@ -5875,7 +6024,7 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 		srq_db.byte_4 = HNS_ROCE_V2_SRQ_DB << 24 | srq->srqn;
 		srq_db.parameter = srq->head;
 
-		hns_roce_write64_k((__le32 *)&srq_db, srq->db_reg_l);
+		hns_roce_write64(hr_dev, (__le32 *)&srq_db, srq->db_reg_l);
 
 	}
 
@@ -5892,6 +6041,7 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 	.hw_exit = hns_roce_v2_exit,
 	.post_mbox = hns_roce_v2_post_mbox,
 	.chk_mbox = hns_roce_v2_chk_mbox,
+	.rst_prc_mbox = hns_roce_v2_rst_process_cmd,
 	.set_gid = hns_roce_v2_set_gid,
 	.set_mac = hns_roce_v2_set_mac,
 	.write_mtpt = hns_roce_v2_write_mtpt,
@@ -6147,6 +6297,7 @@ static int hns_roce_hw_v2_reset_notify_down(struct hnae3_handle *handle)
 		return 0;
 
 	hr_dev->active = false;
+	hr_dev->dis_db = true;
 
 	event.event = IB_EVENT_DEVICE_FATAL;
 	event.device = &hr_dev->ib_dev;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 2857669..c32d0d2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -95,6 +95,9 @@
 #define HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE	2
 #define HNS_ROCE_V2_RSV_QPS			8
 
+/* Time out for hardware to complete reset */
+#define HNS_ROCE_V2_HW_RST_TIMEOUT		1000
+
 /* The longest time for software reset process in NIC subsystem, if a timeout
  * occurs, it indicates that the network subsystem has encountered a serious
  * error and cannot be recovered from the reset processing.
@@ -1797,4 +1800,15 @@ struct hns_roce_scc_ctx_clr_done {
 	__le32 rsv[5];
 };
 
+static inline void hns_roce_write64(struct hns_roce_dev *hr_dev, __le32 val[2],
+				    void __iomem *dest)
+{
+	struct hns_roce_v2_priv *priv = (struct hns_roce_v2_priv *)hr_dev->priv;
+	struct hnae3_handle *handle = priv->handle;
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+
+	if (!hr_dev->dis_db && !ops->get_hw_reset_stat(handle))
+		hns_roce_write64_k(val, dest);
+}
+
 #endif
-- 
1.9.1
