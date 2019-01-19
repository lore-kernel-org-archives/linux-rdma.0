From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V2 rdma-next 2/3] RDMA/hns: Fix the chip hanging caused by sending mailbox&CMQ during reset
Date: Sat, 19 Jan 2019 11:36:06 +0800
Message-ID: <1547868967-115951-3-git-send-email-xavier.huwei@huawei.com>
References: <1547868967-115951-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1547868967-115951-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, liudongdong3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org

On hi08 chip, There is a possibility of chip hanging and
some errors when sending mailbox & doorbell during reset.
We can fix it by prohibiting mailbox and doorbell during
reset and reset occurred to ensure that hardware can work
normally.

Fixes: a04ff739f2a9 ("RDMA/hns: Add command queue support for hip08 RoCE driver")
Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_cmd.c    |  32 ++++--
 drivers/infiniband/hw/hns/hns_roce_device.h |   7 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 154 +++++++++++++++++++++++++++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   2 +
 4 files changed, 182 insertions(+), 13 deletions(-)

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
index 0f3fe90..65eb4bc 100644
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
@@ -874,6 +880,7 @@ struct hns_roce_hw {
 			 u64 out_param, u32 in_modifier, u8 op_modifier, u16 op,
 			 u16 token, int event);
 	int (*chk_mbox)(struct hns_roce_dev *hr_dev, unsigned long timeout);
+	int (*rst_prc_mbox)(struct hns_roce_dev *hr_dev);
 	int (*set_gid)(struct hns_roce_dev *hr_dev, u8 port, int gid_index,
 		       const union ib_gid *gid, const struct ib_gid_attr *attr);
 	int (*set_mac)(struct hns_roce_dev *hr_dev, u8 phy_port, u8 *addr);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 575a233..811e186 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -712,6 +712,125 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp,
 	return ret;
 }
 
+static int hns_roce_v2_cmd_hw_reseted(struct hns_roce_dev *hr_dev,
+				      unsigned long instance_stage,
+				      unsigned long reset_stage)
+{
+	/* When hardware reset has been completed once or more, we should stop
+	 * sending mailbox&cmq to hardware. If now in .init_instance()
+	 * function, we should exit with error. If now at HNAE3_INIT_CLIENT
+	 * stage of soft reset process, we should exit with error, and then
+	 * HNAE3_INIT_CLIENT related process can rollback the operation like
+	 * notifing hardware to free resources, HNAE3_INIT_CLIENT related
+	 * process will exit with error to notify NIC driver to reschedule soft
+	 * reset process once again.
+	 */
+	hr_dev->is_reset = true;
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
+	/* When hardware reset is detected, we should stop sending mailbox&cmq
+	 * to hardware, and wait until hardware reset finished. If now
+	 * in .init_instance() function, we should exit with error. If now at
+	 * HNAE3_INIT_CLIENT stage of soft reset process, we should exit with
+	 * error, and then HNAE3_INIT_CLIENT related process can rollback the
+	 * operation like notifing hardware to free resources, HNAE3_INIT_CLIENT
+	 * related process will exit with error to notify NIC driver to
+	 * reschedule soft reset process once again.
+	 */
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
+	 * should stop sending mailbox&cmq to hardware, and
+	 * wait until hardware reset finished, we should exit with error.
+	 */
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
@@ -892,8 +1011,8 @@ static int hns_roce_cmq_csq_clean(struct hns_roce_dev *hr_dev)
 	return clean;
 }
 
-static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
-			     struct hns_roce_cmq_desc *desc, int num)
+static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
+			       struct hns_roce_cmq_desc *desc, int num)
 {
 	struct hns_roce_v2_priv *priv = (struct hns_roce_v2_priv *)hr_dev->priv;
 	struct hns_roce_v2_cmq_ring *csq = &priv->cmq.csq;
@@ -905,9 +1024,6 @@ static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	int ret = 0;
 	int ntc;
 
-	if (hr_dev->is_reset)
-		return 0;
-
 	spin_lock_bh(&csq->lock);
 
 	if (num > hns_roce_cmq_space(csq)) {
@@ -982,6 +1098,30 @@ static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
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
@@ -1857,6 +1997,9 @@ static int hns_roce_v2_chk_mbox(struct hns_roce_dev *hr_dev,
 
 	status = hns_roce_v2_cmd_complete(hr_dev);
 	if (status != 0x1) {
+		if (status == CMD_RST_PRC_EBUSY)
+			return status;
+
 		dev_err(dev, "mailbox status 0x%x!\n", status);
 		return -EBUSY;
 	}
@@ -5978,6 +6121,7 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 	.hw_exit = hns_roce_v2_exit,
 	.post_mbox = hns_roce_v2_post_mbox,
 	.chk_mbox = hns_roce_v2_chk_mbox,
+	.rst_prc_mbox = hns_roce_v2_rst_process_cmd,
 	.set_gid = hns_roce_v2_set_gid,
 	.set_mac = hns_roce_v2_set_mac,
 	.write_mtpt = hns_roce_v2_write_mtpt,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 938d36a..f22094e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -96,6 +96,8 @@
 #define HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE	2
 #define HNS_ROCE_V2_RSV_QPS			8
 
+#define HNS_ROCE_V2_HW_RST_TIMEOUT             1000
+
 #define HNS_ROCE_CONTEXT_HOP_NUM		1
 #define HNS_ROCE_SCCC_HOP_NUM			1
 #define HNS_ROCE_MTT_HOP_NUM			1
-- 
1.9.1
