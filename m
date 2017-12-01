From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH net-next] net: hns3: Refactors "reset" handling code in HCLGE layer of HNS3 driver
Date: Fri, 1 Dec 2017 03:37:44 +0000
Message-ID: <20171201033744.19104-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch refactors the code of the reset feature in HCLGE layer
of HNS3 PF driver. Prime motivation to do this change is:
1. To reduce the time for which common miscellaneous Vector 0
   interrupt is disabled because of the reset.
2. Simplification of reset request submission and pending reset
   logic.
3. Simplification of the common miscellaneous interrupt handler
   routine(for Vector 0) used to handle reset and other sources
   of Vector 0 interrupt.

To achieve above below few things have been done:
1. Interrupt is disabled while common miscellaneous interrupt
   handler is entered and re-enabled before it is exit. This
   reduces the interrupt handling latency as compared to older
   interrupt handling scheme where interrupt was being disabled
   in interrupt handler context and re-enabled in task context
   some time later.
2. Introduces new reset service task for honoring software reset
   requests like from network stack related to timeout and serving
   the pending reset request(to reset the driver and associated
   clients).
3. Made Miscellaneous interrupt handler more generic to handle
   all sources including reset interrupt source.

Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: lipeng <lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 229 ++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  12 +-
 2 files changed, 167 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 59ed806a52c3..063be1c50a1d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -17,7 +17,7 @@
 #include <linux/netdevice.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
-
+#include <net/rtnetlink.h>
 #include "hclge_cmd.h"
 #include "hclge_dcb.h"
 #include "hclge_main.h"
@@ -2226,6 +2226,12 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 	return hclge_cfg_func_mta_filter(hdev, 0, hdev->accept_mta_mc);
 }
 
+static void hclge_reset_task_schedule(struct hclge_dev *hdev)
+{
+	if (!test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
+		schedule_work(&hdev->rst_service_task);
+}
+
 static void hclge_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_DOWN, &hdev->state) &&
@@ -2362,6 +2368,42 @@ static void hclge_service_complete(struct hclge_dev *hdev)
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
+	return HCLGE_VECTOR0_EVENT_OTHER;
+}
+
+static void hclge_clear_event_cause(struct hclge_dev *hdev, u32 event_type,
+				    u32 regclr)
+{
+	if (event_type == HCLGE_VECTOR0_EVENT_RST)
+		hclge_write_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG, regclr);
+}
+
 static void hclge_enable_vector(struct hclge_misc_vector *vector, bool enable)
 {
 	writel(enable ? 1 : 0, vector->addr);
@@ -2370,10 +2412,28 @@ static void hclge_enable_vector(struct hclge_misc_vector *vector, bool enable)
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
+		hclge_reset_task_schedule(hdev);
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
@@ -2404,9 +2464,9 @@ static int hclge_misc_irq_init(struct hclge_dev *hdev)
 
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
@@ -2416,6 +2476,12 @@ static int hclge_misc_irq_init(struct hclge_dev *hdev)
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
@@ -2471,12 +2537,6 @@ static int hclge_reset_wait(struct hclge_dev *hdev)
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
@@ -2505,12 +2565,12 @@ static int hclge_func_reset_cmd(struct hclge_dev *hdev, int func_id)
 	return ret;
 }
 
-static void hclge_do_reset(struct hclge_dev *hdev, enum hnae3_reset_type type)
+static void hclge_do_reset(struct hclge_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
 	u32 val;
 
-	switch (type) {
+	switch (hdev->reset_type) {
 	case HNAE3_GLOBAL_RESET:
 		val = hclge_read_dev(&hdev->hw, HCLGE_GLOBAL_RESET_REG);
 		hnae_set_bit(val, HCLGE_GLOBAL_RESET_BIT, 1);
@@ -2526,30 +2586,17 @@ static void hclge_do_reset(struct hclge_dev *hdev, enum hnae3_reset_type type)
 	case HNAE3_FUNC_RESET:
 		dev_info(&pdev->dev, "PF Reset requested\n");
 		hclge_func_reset_cmd(hdev, 0);
+		/* schedule again to check later */
+		set_bit(HNAE3_FUNC_RESET, &hdev->reset_pending);
+		hclge_reset_task_schedule(hdev);
 		break;
 	default:
 		dev_warn(&pdev->dev,
-			 "Unsupported reset type: %d\n", type);
+			 "Unsupported reset type: %d\n", hdev->reset_type);
 		break;
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
@@ -2563,14 +2610,9 @@ static void hclge_reset_event(struct hnae3_handle *handle,
 	case HNAE3_FUNC_RESET:
 	case HNAE3_CORE_RESET:
 	case HNAE3_GLOBAL_RESET:
-		if (test_bit(HCLGE_STATE_RESET_INT, &hdev->state)) {
-			dev_err(&hdev->pdev->dev, "Already in reset state");
-			return;
-		}
-		hdev->reset_type = reset;
-		set_bit(HCLGE_STATE_RESET_INT, &hdev->state);
-		set_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state);
-		schedule_work(&hdev->service_task);
+		/* request reset & schedule reset task */
+		set_bit(reset, &hdev->reset_request);
+		hclge_reset_task_schedule(hdev);
 		break;
 	default:
 		dev_warn(&hdev->pdev->dev, "Unsupported reset event:%d", reset);
@@ -2578,51 +2620,87 @@ static void hclge_reset_event(struct hnae3_handle *handle,
 	}
 }
 
-static void hclge_reset_subtask(struct hclge_dev *hdev)
+static enum hnae3_reset_type hclge_get_reset_level(struct hclge_dev *hdev,
+						   unsigned long *addr)
 {
-	bool do_reset;
+	enum hnae3_reset_type rst_level = HNAE3_NONE_RESET;
 
-	do_reset = hdev->reset_type != HNAE3_NONE_RESET;
+	/* return the highest priority reset level amongst all */
+	if (test_bit(HNAE3_GLOBAL_RESET, addr))
+		rst_level = HNAE3_GLOBAL_RESET;
+	else if (test_bit(HNAE3_CORE_RESET, addr))
+		rst_level = HNAE3_CORE_RESET;
+	else if (test_bit(HNAE3_IMP_RESET, addr))
+		rst_level = HNAE3_IMP_RESET;
+	else if (test_bit(HNAE3_FUNC_RESET, addr))
+		rst_level = HNAE3_FUNC_RESET;
 
-	/* Reset is detected by interrupt */
-	if (hdev->reset_type == HNAE3_NONE_RESET)
-		hdev->reset_type = hclge_detected_reset_event(hdev);
+	/* now, clear all other resets */
+	clear_bit(HNAE3_GLOBAL_RESET, addr);
+	clear_bit(HNAE3_CORE_RESET, addr);
+	clear_bit(HNAE3_IMP_RESET, addr);
+	clear_bit(HNAE3_FUNC_RESET, addr);
 
-	if (hdev->reset_type == HNAE3_NONE_RESET)
-		return;
+	return rst_level;
+}
 
-	switch (hdev->reset_type) {
-	case HNAE3_FUNC_RESET:
-	case HNAE3_CORE_RESET:
-	case HNAE3_GLOBAL_RESET:
-	case HNAE3_IMP_RESET:
-		hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
+static void hclge_reset(struct hclge_dev *hdev)
+{
+	/* perform reset of the stack & ae device for a client */
 
-		if (do_reset)
-			hclge_do_reset(hdev, hdev->reset_type);
-		else
-			set_bit(HCLGE_STATE_RESET_INT, &hdev->state);
+	hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
 
-		if (!hclge_reset_wait(hdev)) {
-			hclge_notify_client(hdev, HNAE3_UNINIT_CLIENT);
-			hclge_reset_ae_dev(hdev->ae_dev);
-			hclge_notify_client(hdev, HNAE3_INIT_CLIENT);
-			clear_bit(HCLGE_STATE_RESET_INT, &hdev->state);
-		}
-		hclge_notify_client(hdev, HNAE3_UP_CLIENT);
-		break;
-	default:
-		dev_err(&hdev->pdev->dev, "Unsupported reset type:%d\n",
-			hdev->reset_type);
-		break;
+	if (!hclge_reset_wait(hdev)) {
+		rtnl_lock();
+		hclge_notify_client(hdev, HNAE3_UNINIT_CLIENT);
+		hclge_reset_ae_dev(hdev->ae_dev);
+		hclge_notify_client(hdev, HNAE3_INIT_CLIENT);
+		rtnl_unlock();
+	} else {
+		/* schedule again to check pending resets later */
+		set_bit(hdev->reset_type, &hdev->reset_pending);
+		hclge_reset_task_schedule(hdev);
 	}
+
+	hclge_notify_client(hdev, HNAE3_UP_CLIENT);
+}
+
+static void hclge_reset_subtask(struct hclge_dev *hdev)
+{
+	/* check if there is any ongoing reset in the hardware. This status can
+	 * be checked from reset_pending. If there is then, we need to wait for
+	 * hardware to complete reset.
+	 *    a. If we are able to figure out in reasonable time that hardware
+	 *       has fully resetted then, we can proceed with driver, client
+	 *       reset.
+	 *    b. else, we can come back later to check this status so re-sched
+	 *       now.
+	 */
+	hdev->reset_type = hclge_get_reset_level(hdev, &hdev->reset_pending);
+	if (hdev->reset_type != HNAE3_NONE_RESET)
+		hclge_reset(hdev);
+
+	/* check if we got any *new* reset requests to be honored */
+	hdev->reset_type = hclge_get_reset_level(hdev, &hdev->reset_request);
+	if (hdev->reset_type != HNAE3_NONE_RESET)
+		hclge_do_reset(hdev);
+
 	hdev->reset_type = HNAE3_NONE_RESET;
 }
 
-static void hclge_misc_irq_service_task(struct hclge_dev *hdev)
+static void hclge_reset_service_task(struct work_struct *work)
 {
+	struct hclge_dev *hdev =
+		container_of(work, struct hclge_dev, rst_service_task);
+
+	if (test_and_set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+		return;
+
+	clear_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state);
+
 	hclge_reset_subtask(hdev);
-	hclge_enable_vector(&hdev->misc_vector, true);
+
+	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
 }
 
 static void hclge_service_task(struct work_struct *work)
@@ -2630,7 +2708,6 @@ static void hclge_service_task(struct work_struct *work)
 	struct hclge_dev *hdev =
 		container_of(work, struct hclge_dev, service_task);
 
-	hclge_misc_irq_service_task(hdev);
 	hclge_update_speed_duplex(hdev);
 	hclge_update_link_status(hdev);
 	hclge_update_stats_for_all(hdev);
@@ -4661,6 +4738,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hdev->pdev = pdev;
 	hdev->ae_dev = ae_dev;
 	hdev->reset_type = HNAE3_NONE_RESET;
+	hdev->reset_request = 0;
 	ae_dev->priv = hdev;
 
 	ret = hclge_pci_init(hdev);
@@ -4772,12 +4850,15 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	timer_setup(&hdev->service_timer, hclge_service_timer, 0);
 	INIT_WORK(&hdev->service_task, hclge_service_task);
+	INIT_WORK(&hdev->rst_service_task, hclge_reset_service_task);
 
 	/* Enable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, true);
 
 	set_bit(HCLGE_STATE_SERVICE_INITED, &hdev->state);
 	set_bit(HCLGE_STATE_DOWN, &hdev->state);
+	clear_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state);
+	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
 
 	pr_info("%s driver initialization finished.\n", HCLGE_DRIVER_NAME);
 	return 0;
@@ -4889,14 +4970,16 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 		del_timer_sync(&hdev->service_timer);
 	if (hdev->service_task.func)
 		cancel_work_sync(&hdev->service_task);
+	if (hdev->rst_service_task.func)
+		cancel_work_sync(&hdev->rst_service_task);
 
 	if (mac->phydev)
 		mdiobus_unregister(mac->mdio_bus);
 
 	/* Disable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, false);
-	hclge_free_vector(hdev, 0);
 	hclge_destroy_cmd_queue(&hdev->hw);
+	hclge_misc_irq_uninit(hdev);
 	hclge_pci_uninit(hdev);
 	ae_dev->priv = NULL;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 7027814ea5d7..aacec438b933 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -99,12 +99,19 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_REMOVING,
 	HCLGE_STATE_SERVICE_INITED,
 	HCLGE_STATE_SERVICE_SCHED,
+	HCLGE_STATE_RST_SERVICE_SCHED,
+	HCLGE_STATE_RST_HANDLING,
 	HCLGE_STATE_MBX_HANDLING,
 	HCLGE_STATE_MBX_IRQ,
-	HCLGE_STATE_RESET_INT,
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
@@ -420,6 +427,8 @@ struct hclge_dev {
 	unsigned long state;
 
 	enum hnae3_reset_type reset_type;
+	unsigned long reset_request;	/* reset has been requested */
+	unsigned long reset_pending;	/* client rst is pending to be served */
 	u32 fw_version;
 	u16 num_vmdq_vport;		/* Num vmdq vport this PF has set up */
 	u16 num_tqps;			/* Num task queue pairs of this PF */
@@ -469,6 +478,7 @@ struct hclge_dev {
 	unsigned long service_timer_previous;
 	struct timer_list service_timer;
 	struct work_struct service_task;
+	struct work_struct rst_service_task;
 
 	bool cur_promisc;
 	int num_alloc_vfs;	/* Actual number of VFs allocated */
-- 
2.11.0


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
