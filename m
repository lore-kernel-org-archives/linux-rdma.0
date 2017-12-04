From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 net-next 1/3] net: hns3: Refactor of the reset interrupt handling logic
Date: Mon, 4 Dec 2017 01:29:53 +0000
Message-ID: <20171204012955.17560-2-salil.mehta@huawei.com>
References: <20171204012955.17560-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171204012955.17560-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: salil.mehta@huawei.com, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil.lnk@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

The reset interrupt event shares common miscellaneous interrupt
Vector 0. In the existing reset interrupt handling we disable
the Vector 0 interrupt in misc interrupt handler and re-enable
them later in context to common service task.

This also means other event sources like mailbox would also be
deferred or if the interrupt event was due to mailbox(which shall
be supported for VF soon), it could delay the reset handling.

This patch reorganizes the reset interrupt handling logic and
makes it more fair to other events.

Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: lipeng <lipeng321@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 103 ++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   7 ++
 2 files changed, 78 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 59ed806a52c3..0c0543e84957 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2362,6 +2362,46 @@ static void hclge_service_complete(struct hclge_dev *hdev)
 	clear_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state);
 }
 
+static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
+{
+	u32 rst_src_reg;
+
+	/* fetch the events from their corresponding regs */
+	rst_src_reg = hclge_read_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG);
+
+	/* check for vector0 reset event sources */
+	if (BIT(HCLGE_VECTOR0_GLOBALRESET_INT_B) & rst_src_reg) {
+		set_bit(HNAE3_GLOBAL_RESET, &hdev->reset_pending);
+		*clearval = BIT(HCLGE_VECTOR0_GLOBALRESET_INT_B);
+		return HCLGE_VECTOR0_EVENT_RST;
+	}
+
+	if (BIT(HCLGE_VECTOR0_CORERESET_INT_B) & rst_src_reg) {
+		set_bit(HNAE3_CORE_RESET, &hdev->reset_pending);
+		*clearval = BIT(HCLGE_VECTOR0_CORERESET_INT_B);
+		return HCLGE_VECTOR0_EVENT_RST;
+	}
+
+	if (BIT(HCLGE_VECTOR0_IMPRESET_INT_B) & rst_src_reg) {
+		set_bit(HNAE3_IMP_RESET, &hdev->reset_pending);
+		*clearval = BIT(HCLGE_VECTOR0_IMPRESET_INT_B);
+		return HCLGE_VECTOR0_EVENT_RST;
+	}
+
+	/* mailbox event sharing vector 0 interrupt would be placed here */
+
+	return HCLGE_VECTOR0_EVENT_OTHER;
+}
+
+static void hclge_clear_event_cause(struct hclge_dev *hdev, u32 event_type,
+				    u32 regclr)
+{
+	if (event_type == HCLGE_VECTOR0_EVENT_RST)
+		hclge_write_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG, regclr);
+
+	/* mailbox event sharing vector 0 interrupt would be placed here */
+}
+
 static void hclge_enable_vector(struct hclge_misc_vector *vector, bool enable)
 {
 	writel(enable ? 1 : 0, vector->addr);
@@ -2370,10 +2410,28 @@ static void hclge_enable_vector(struct hclge_misc_vector *vector, bool enable)
 static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 {
 	struct hclge_dev *hdev = data;
+	u32 event_cause;
+	u32 clearval;
 
 	hclge_enable_vector(&hdev->misc_vector, false);
-	if (!test_and_set_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state))
-		schedule_work(&hdev->service_task);
+	event_cause = hclge_check_event_cause(hdev, &clearval);
+
+	/* vector 0 interrupt is shared with reset and mailbox source events.
+	 * For now, we are not handling mailbox events.
+	 */
+	switch (event_cause) {
+	case HCLGE_VECTOR0_EVENT_RST:
+		/* reset task to be scheduled here */
+		break;
+	default:
+		dev_dbg(&hdev->pdev->dev,
+			"received unknown or unhandled event of vector0\n");
+		break;
+	}
+
+	/* we should clear the source of interrupt */
+	hclge_clear_event_cause(hdev, event_cause, clearval);
+	hclge_enable_vector(&hdev->misc_vector, true);
 
 	return IRQ_HANDLED;
 }
@@ -2404,9 +2462,9 @@ static int hclge_misc_irq_init(struct hclge_dev *hdev)
 
 	hclge_get_misc_vector(hdev);
 
-	ret = devm_request_irq(&hdev->pdev->dev,
-			       hdev->misc_vector.vector_irq,
-			       hclge_misc_irq_handle, 0, "hclge_misc", hdev);
+	/* this would be explicitly freed in the end */
+	ret = request_irq(hdev->misc_vector.vector_irq, hclge_misc_irq_handle,
+			  0, "hclge_misc", hdev);
 	if (ret) {
 		hclge_free_vector(hdev, 0);
 		dev_err(&hdev->pdev->dev, "request misc irq(%d) fail\n",
@@ -2416,6 +2474,12 @@ static int hclge_misc_irq_init(struct hclge_dev *hdev)
 	return ret;
 }
 
+static void hclge_misc_irq_uninit(struct hclge_dev *hdev)
+{
+	free_irq(hdev->misc_vector.vector_irq, hdev);
+	hclge_free_vector(hdev, 0);
+}
+
 static int hclge_notify_client(struct hclge_dev *hdev,
 			       enum hnae3_reset_notify_type type)
 {
@@ -2471,12 +2535,6 @@ static int hclge_reset_wait(struct hclge_dev *hdev)
 		cnt++;
 	}
 
-	/* must clear reset status register to
-	 * prevent driver detect reset interrupt again
-	 */
-	reg = hclge_read_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG);
-	hclge_write_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG, reg);
-
 	if (cnt >= HCLGE_RESET_WAIT_CNT) {
 		dev_warn(&hdev->pdev->dev,
 			 "Wait for reset timeout: %d\n", hdev->reset_type);
@@ -2534,22 +2592,6 @@ static void hclge_do_reset(struct hclge_dev *hdev, enum hnae3_reset_type type)
 	}
 }
 
-static enum hnae3_reset_type hclge_detected_reset_event(struct hclge_dev *hdev)
-{
-	enum hnae3_reset_type rst_level = HNAE3_NONE_RESET;
-	u32 rst_reg_val;
-
-	rst_reg_val = hclge_read_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG);
-	if (BIT(HCLGE_VECTOR0_GLOBALRESET_INT_B) & rst_reg_val)
-		rst_level = HNAE3_GLOBAL_RESET;
-	else if (BIT(HCLGE_VECTOR0_CORERESET_INT_B) & rst_reg_val)
-		rst_level = HNAE3_CORE_RESET;
-	else if (BIT(HCLGE_VECTOR0_IMPRESET_INT_B) & rst_reg_val)
-		rst_level = HNAE3_IMP_RESET;
-
-	return rst_level;
-}
-
 static void hclge_reset_event(struct hnae3_handle *handle,
 			      enum hnae3_reset_type reset)
 {
@@ -2584,9 +2626,6 @@ static void hclge_reset_subtask(struct hclge_dev *hdev)
 
 	do_reset = hdev->reset_type != HNAE3_NONE_RESET;
 
-	/* Reset is detected by interrupt */
-	if (hdev->reset_type == HNAE3_NONE_RESET)
-		hdev->reset_type = hclge_detected_reset_event(hdev);
 
 	if (hdev->reset_type == HNAE3_NONE_RESET)
 		return;
@@ -2622,7 +2661,6 @@ static void hclge_reset_subtask(struct hclge_dev *hdev)
 static void hclge_misc_irq_service_task(struct hclge_dev *hdev)
 {
 	hclge_reset_subtask(hdev);
-	hclge_enable_vector(&hdev->misc_vector, true);
 }
 
 static void hclge_service_task(struct work_struct *work)
@@ -4661,6 +4699,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hdev->pdev = pdev;
 	hdev->ae_dev = ae_dev;
 	hdev->reset_type = HNAE3_NONE_RESET;
+	hdev->reset_pending = 0;
 	ae_dev->priv = hdev;
 
 	ret = hclge_pci_init(hdev);
@@ -4895,8 +4934,8 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	/* Disable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, false);
-	hclge_free_vector(hdev, 0);
 	hclge_destroy_cmd_queue(&hdev->hw);
+	hclge_misc_irq_uninit(hdev);
 	hclge_pci_uninit(hdev);
 	ae_dev->priv = NULL;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 7027814ea5d7..d4429496f4b5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -105,6 +105,12 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_MAX
 };
 
+enum hclge_evt_cause {
+	HCLGE_VECTOR0_EVENT_RST,
+	HCLGE_VECTOR0_EVENT_MBX,
+	HCLGE_VECTOR0_EVENT_OTHER,
+};
+
 #define HCLGE_MPF_ENBALE 1
 struct hclge_caps {
 	u16 num_tqp;
@@ -420,6 +426,7 @@ struct hclge_dev {
 	unsigned long state;
 
 	enum hnae3_reset_type reset_type;
+	unsigned long reset_pending;	/* client rst is pending to be served */
 	u32 fw_version;
 	u16 num_vmdq_vport;		/* Num vmdq vport this PF has set up */
 	u16 num_tqps;			/* Num task queue pairs of this PF */
-- 
2.11.0
