From: Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] nes: handling failed allocation when creating workqueue
Date: Wed, 17 Feb 2016 13:06:33 -0500
Message-ID: <1455732393-11029-1-git-send-email-wuninsu@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: faisal.latif@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Since create_singlethread_workqueue uses kzalloc internally, 
it can be failed in memory pressure, so need to handle it.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/infiniband/hw/nes/nes_cm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index cb9f0f2..23afad6 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -2833,7 +2833,7 @@ static struct nes_cm_core *nes_cm_alloc_core(void)
 	/* alloc top level core control structure */
 	cm_core = kzalloc(sizeof(*cm_core), GFP_KERNEL);
 	if (!cm_core)
-		return NULL;
+		goto enomem_3;
 
 	INIT_LIST_HEAD(&cm_core->connected_nodes);
 	init_timer(&cm_core->tcp_timer);
@@ -2856,12 +2856,23 @@ static struct nes_cm_core *nes_cm_alloc_core(void)
 
 	nes_debug(NES_DBG_CM, "Enable QUEUE EVENTS\n");
 	cm_core->event_wq = create_singlethread_workqueue("nesewq");
+	if (!cm_core->event_wq)
+		goto enomem_2;
 	cm_core->post_event = nes_cm_post_event;
 	nes_debug(NES_DBG_CM, "Enable QUEUE DISCONNECTS\n");
 	cm_core->disconn_wq = create_singlethread_workqueue("nesdwq");
+	if (!cm_core->disconn_wq)
+		goto enomem_1;
 
 	print_core(cm_core);
 	return cm_core;
+
+enomem_1:
+	destroy_workqueue(cm_core->event_wq);
+enomem_2:
+	kfree(cm_core);
+enomem_3:
+	return NULL;
 }
 
 
-- 
1.9.1
