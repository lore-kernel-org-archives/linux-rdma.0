From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 net-next 3/3] net: hns3: Refactors the requested reset & pending reset handling code
Date: Mon, 4 Dec 2017 01:29:55 +0000
Message-ID: <20171204012955.17560-4-salil.mehta@huawei.com>
References: <20171204012955.17560-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171204012955.17560-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: salil.mehta@huawei.com, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil.lnk@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

In exisiting code, the way to detect if driver/client reset should
be executed or if hardware should be be soft resetted was overly
complex.

Existing code use to read the interrupt status register from task
context to figure out if the interrupt source event was reset and
then use clear the interrupt source for reset while waiting for the
hardware to finish the reset. This behaviour again was confusing
and overly complex in terms of the flow.

This patch simplifies the handling of the requested reset and the
pending reset(i.e. reset which have already been asserted by the
software and hardware has acknowledged back to driver that it is
processing the hardware reset through interrupt)

Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: lipeng <lipeng321@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 100 +++++++++++++--------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 -
 2 files changed, 65 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 345868470201..d07c700c7ff8 100644
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
@@ -2569,12 +2569,12 @@ static int hclge_func_reset_cmd(struct hclge_dev *hdev, int func_id)
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
@@ -2596,11 +2596,56 @@ static void hclge_do_reset(struct hclge_dev *hdev, enum hnae3_reset_type type)
 		break;
 	default:
 		dev_warn(&pdev->dev,
-			 "Unsupported reset type: %d\n", type);
+			 "Unsupported reset type: %d\n", hdev->reset_type);
 		break;
 	}
 }
 
+static enum hnae3_reset_type hclge_get_reset_level(struct hclge_dev *hdev,
+						   unsigned long *addr)
+{
+	enum hnae3_reset_type rst_level = HNAE3_NONE_RESET;
+
+	/* return the highest priority reset level amongst all */
+	if (test_bit(HNAE3_GLOBAL_RESET, addr))
+		rst_level = HNAE3_GLOBAL_RESET;
+	else if (test_bit(HNAE3_CORE_RESET, addr))
+		rst_level = HNAE3_CORE_RESET;
+	else if (test_bit(HNAE3_IMP_RESET, addr))
+		rst_level = HNAE3_IMP_RESET;
+	else if (test_bit(HNAE3_FUNC_RESET, addr))
+		rst_level = HNAE3_FUNC_RESET;
+
+	/* now, clear all other resets */
+	clear_bit(HNAE3_GLOBAL_RESET, addr);
+	clear_bit(HNAE3_CORE_RESET, addr);
+	clear_bit(HNAE3_IMP_RESET, addr);
+	clear_bit(HNAE3_FUNC_RESET, addr);
+
+	return rst_level;
+}
+
+static void hclge_reset(struct hclge_dev *hdev)
+{
+	/* perform reset of the stack & ae device for a client */
+
+	hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
+
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
+	}
+
+	hclge_notify_client(hdev, HNAE3_UP_CLIENT);
+}
+
 static void hclge_reset_event(struct hnae3_handle *handle,
 			      enum hnae3_reset_type reset)
 {
@@ -2626,39 +2671,24 @@ static void hclge_reset_event(struct hnae3_handle *handle,
 
 static void hclge_reset_subtask(struct hclge_dev *hdev)
 {
-	bool do_reset;
-
-	do_reset = hdev->reset_type != HNAE3_NONE_RESET;
-
-
-	if (hdev->reset_type == HNAE3_NONE_RESET)
-		return;
-
-	switch (hdev->reset_type) {
-	case HNAE3_FUNC_RESET:
-	case HNAE3_CORE_RESET:
-	case HNAE3_GLOBAL_RESET:
-	case HNAE3_IMP_RESET:
-		hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
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
 
-		if (do_reset)
-			hclge_do_reset(hdev, hdev->reset_type);
-		else
-			set_bit(HCLGE_STATE_RESET_INT, &hdev->state);
+	/* check if we got any *new* reset requests to be honored */
+	hdev->reset_type = hclge_get_reset_level(hdev, &hdev->reset_request);
+	if (hdev->reset_type != HNAE3_NONE_RESET)
+		hclge_do_reset(hdev);
 
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
-	}
 	hdev->reset_type = HNAE3_NONE_RESET;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index fd04fd23b76a..aacec438b933 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -103,7 +103,6 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_RST_HANDLING,
 	HCLGE_STATE_MBX_HANDLING,
 	HCLGE_STATE_MBX_IRQ,
-	HCLGE_STATE_RESET_INT,
 	HCLGE_STATE_MAX
 };
 
-- 
2.11.0
