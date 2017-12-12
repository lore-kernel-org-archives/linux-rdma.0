From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 net-next 8/8] net: hns3: Add mailbox interrupt handling to PF driver
Date: Tue, 12 Dec 2017 17:52:05 +0000
Message-ID: <20171212175205.236-9-salil.mehta@huawei.com>
References: <20171212175205.236-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171212175205.236-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

All PF mailbox events are conveyed through a common interrupt
(vector 0). This interrupt vector is shared by reset and mailbox.

This patch adds the handling of mailbox interrupt event and its
deferred processing in context to a separate mailbox task.

Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: lipeng <lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 68 +++++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  8 ++-
 2 files changed, 68 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3b1fc49..e97fd66 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2227,6 +2227,12 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 	return hclge_cfg_func_mta_filter(hdev, 0, hdev->accept_mta_mc);
 }
 
+static void hclge_mbx_task_schedule(struct hclge_dev *hdev)
+{
+	if (!test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state))
+		schedule_work(&hdev->mbx_service_task);
+}
+
 static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
@@ -2372,9 +2378,18 @@ static void hclge_service_complete(struct hclge_dev *hdev)
 static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 {
 	u32 rst_src_reg;
+	u32 cmdq_src_reg;
 
 	/* fetch the events from their corresponding regs */
 	rst_src_reg = hclge_read_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG);
+	cmdq_src_reg = hclge_read_dev(&hdev->hw, HCLGE_VECTOR0_CMDQ_SRC_REG);
+
+	/* Assumption: If by any chance reset and mailbox events are reported
+	 * together then we will only process reset event in this go and will
+	 * defer the processing of the mailbox events. Since, we would have not
+	 * cleared RX CMDQ event this time we would receive again another
+	 * interrupt from H/W just for the mailbox.
+	 */
 
 	/* check for vector0 reset event sources */
 	if (BIT(HCLGE_VECTOR0_GLOBALRESET_INT_B) & rst_src_reg) {
@@ -2395,7 +2410,12 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 		return HCLGE_VECTOR0_EVENT_RST;
 	}
 
-	/* mailbox event sharing vector 0 interrupt would be placed here */
+	/* check for vector0 mailbox(=CMDQ RX) event source */
+	if (BIT(HCLGE_VECTOR0_RX_CMDQ_INT_B) & cmdq_src_reg) {
+		cmdq_src_reg &= ~BIT(HCLGE_VECTOR0_RX_CMDQ_INT_B);
+		*clearval = cmdq_src_reg;
+		return HCLGE_VECTOR0_EVENT_MBX;
+	}
 
 	return HCLGE_VECTOR0_EVENT_OTHER;
 }
@@ -2403,10 +2423,14 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 static void hclge_clear_event_cause(struct hclge_dev *hdev, u32 event_type,
 				    u32 regclr)
 {
-	if (event_type == HCLGE_VECTOR0_EVENT_RST)
+	switch (event_type) {
+	case HCLGE_VECTOR0_EVENT_RST:
 		hclge_write_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG, regclr);
-
-	/* mailbox event sharing vector 0 interrupt would be placed here */
+		break;
+	case HCLGE_VECTOR0_EVENT_MBX:
+		hclge_write_dev(&hdev->hw, HCLGE_VECTOR0_CMDQ_SRC_REG, regclr);
+		break;
+	}
 }
 
 static void hclge_enable_vector(struct hclge_misc_vector *vector, bool enable)
@@ -2423,13 +2447,23 @@ static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 	hclge_enable_vector(&hdev->misc_vector, false);
 	event_cause = hclge_check_event_cause(hdev, &clearval);
 
-	/* vector 0 interrupt is shared with reset and mailbox source events.
-	 * For now, we are not handling mailbox events.
-	 */
+	/* vector 0 interrupt is shared with reset and mailbox source events.*/
 	switch (event_cause) {
 	case HCLGE_VECTOR0_EVENT_RST:
 		hclge_reset_task_schedule(hdev);
 		break;
+	case HCLGE_VECTOR0_EVENT_MBX:
+		/* If we are here then,
+		 * 1. Either we are not handling any mbx task and we are not
+		 *    scheduled as well
+		 *                        OR
+		 * 2. We could be handling a mbx task but nothing more is
+		 *    scheduled.
+		 * In both cases, we should schedule mbx task as there are more
+		 * mbx messages reported by this interrupt.
+		 */
+		hclge_mbx_task_schedule(hdev);
+
 	default:
 		dev_dbg(&hdev->pdev->dev,
 			"received unknown or unhandled event of vector0\n");
@@ -2708,6 +2742,21 @@ static void hclge_reset_service_task(struct work_struct *work)
 	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
 }
 
+static void hclge_mailbox_service_task(struct work_struct *work)
+{
+	struct hclge_dev *hdev =
+		container_of(work, struct hclge_dev, mbx_service_task);
+
+	if (test_and_set_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state))
+		return;
+
+	clear_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state);
+
+	hclge_mbx_handler(hdev);
+
+	clear_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state);
+}
+
 static void hclge_service_task(struct work_struct *work)
 {
 	struct hclge_dev *hdev =
@@ -4815,6 +4864,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	timer_setup(&hdev->service_timer, hclge_service_timer, 0);
 	INIT_WORK(&hdev->service_task, hclge_service_task);
 	INIT_WORK(&hdev->rst_service_task, hclge_reset_service_task);
+	INIT_WORK(&hdev->mbx_service_task, hclge_mailbox_service_task);
 
 	/* Enable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, true);
@@ -4823,6 +4873,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	set_bit(HCLGE_STATE_DOWN, &hdev->state);
 	clear_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state);
 	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
+	clear_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state);
+	clear_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state);
 
 	pr_info("%s driver initialization finished.\n", HCLGE_DRIVER_NAME);
 	return 0;
@@ -4936,6 +4988,8 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 		cancel_work_sync(&hdev->service_task);
 	if (hdev->rst_service_task.func)
 		cancel_work_sync(&hdev->rst_service_task);
+	if (hdev->mbx_service_task.func)
+		cancel_work_sync(&hdev->mbx_service_task);
 
 	if (mac->phydev)
 		mdiobus_unregister(mac->mdio_bus);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index c7c9a28..fb043b5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -92,6 +92,11 @@
 #define HCLGE_VECTOR0_CORERESET_INT_B	6
 #define HCLGE_VECTOR0_IMPRESET_INT_B	7
 
+/* Vector0 interrupt CMDQ event source register(RW) */
+#define HCLGE_VECTOR0_CMDQ_SRC_REG	0x27100
+/* CMDQ register bits for RX event(=MBX event) */
+#define HCLGE_VECTOR0_RX_CMDQ_INT_B	1
+
 enum HCLGE_DEV_STATE {
 	HCLGE_STATE_REINITING,
 	HCLGE_STATE_DOWN,
@@ -101,8 +106,8 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_SERVICE_SCHED,
 	HCLGE_STATE_RST_SERVICE_SCHED,
 	HCLGE_STATE_RST_HANDLING,
+	HCLGE_STATE_MBX_SERVICE_SCHED,
 	HCLGE_STATE_MBX_HANDLING,
-	HCLGE_STATE_MBX_IRQ,
 	HCLGE_STATE_MAX
 };
 
@@ -479,6 +484,7 @@ struct hclge_dev {
 	struct timer_list service_timer;
 	struct work_struct service_task;
 	struct work_struct rst_service_task;
+	struct work_struct mbx_service_task;
 
 	bool cur_promisc;
 	int num_alloc_vfs;	/* Actual number of VFs allocated */
-- 
2.7.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
