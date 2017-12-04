From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 net-next 2/3] net: hns3: Add reset service task for handling reset requests
Date: Mon, 4 Dec 2017 01:29:54 +0000
Message-ID: <20171204012955.17560-3-salil.mehta@huawei.com>
References: <20171204012955.17560-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171204012955.17560-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Existing common service task was being used to service the reset
requests. This patch tries to make the handling of reset cleaner
by separating task to handle the reset requests. This might in
turn help in adapting similar handling approach for other
interrupt events like mailbox, sharing vector 0 interrupt.

Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: lipeng <lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 41 ++++++++++++++++------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  4 +++
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0c0543e84957..345868470201 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
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
@@ -2421,7 +2427,7 @@ static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 	 */
 	switch (event_cause) {
 	case HCLGE_VECTOR0_EVENT_RST:
-		/* reset task to be scheduled here */
+		hclge_reset_task_schedule(hdev);
 		break;
 	default:
 		dev_dbg(&hdev->pdev->dev,
@@ -2584,6 +2590,9 @@ static void hclge_do_reset(struct hclge_dev *hdev, enum hnae3_reset_type type)
 	case HNAE3_FUNC_RESET:
 		dev_info(&pdev->dev, "PF Reset requested\n");
 		hclge_func_reset_cmd(hdev, 0);
+		/* schedule again to check later */
+		set_bit(HNAE3_FUNC_RESET, &hdev->reset_pending);
+		hclge_reset_task_schedule(hdev);
 		break;
 	default:
 		dev_warn(&pdev->dev,
@@ -2605,14 +2614,9 @@ static void hclge_reset_event(struct hnae3_handle *handle,
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
@@ -2658,9 +2662,19 @@ static void hclge_reset_subtask(struct hclge_dev *hdev)
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
+
+	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
 }
 
 static void hclge_service_task(struct work_struct *work)
@@ -2668,7 +2682,6 @@ static void hclge_service_task(struct work_struct *work)
 	struct hclge_dev *hdev =
 		container_of(work, struct hclge_dev, service_task);
 
-	hclge_misc_irq_service_task(hdev);
 	hclge_update_speed_duplex(hdev);
 	hclge_update_link_status(hdev);
 	hclge_update_stats_for_all(hdev);
@@ -4699,6 +4712,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hdev->pdev = pdev;
 	hdev->ae_dev = ae_dev;
 	hdev->reset_type = HNAE3_NONE_RESET;
+	hdev->reset_request = 0;
 	hdev->reset_pending = 0;
 	ae_dev->priv = hdev;
 
@@ -4811,12 +4825,15 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
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
@@ -4928,6 +4945,8 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 		del_timer_sync(&hdev->service_timer);
 	if (hdev->service_task.func)
 		cancel_work_sync(&hdev->service_task);
+	if (hdev->rst_service_task.func)
+		cancel_work_sync(&hdev->rst_service_task);
 
 	if (mac->phydev)
 		mdiobus_unregister(mac->mdio_bus);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index d4429496f4b5..fd04fd23b76a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -99,6 +99,8 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_REMOVING,
 	HCLGE_STATE_SERVICE_INITED,
 	HCLGE_STATE_SERVICE_SCHED,
+	HCLGE_STATE_RST_SERVICE_SCHED,
+	HCLGE_STATE_RST_HANDLING,
 	HCLGE_STATE_MBX_HANDLING,
 	HCLGE_STATE_MBX_IRQ,
 	HCLGE_STATE_RESET_INT,
@@ -426,6 +428,7 @@ struct hclge_dev {
 	unsigned long state;
 
 	enum hnae3_reset_type reset_type;
+	unsigned long reset_request;	/* reset has been requested */
 	unsigned long reset_pending;	/* client rst is pending to be served */
 	u32 fw_version;
 	u16 num_vmdq_vport;		/* Num vmdq vport this PF has set up */
@@ -476,6 +479,7 @@ struct hclge_dev {
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
