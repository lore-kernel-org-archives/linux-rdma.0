From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 01/22] IB/iser: Change some module parameters to be RO
Date: Thu,  6 Aug 2015 18:32:45 +0300
Message-ID: <1438875186-4310-2-git-send-email-sagig@mellanox.com>
References: <1438875186-4310-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438875186-4310-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jenny Falkovich <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Falkovich <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

While we're at it, use permission defines instead
of octal values and rearrange a little bit.

Signed-off-by: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index c969fc1..c7cea25 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -74,34 +74,33 @@
 
 #include "iscsi_iser.h"
 
+MODULE_DESCRIPTION("iSER (iSCSI Extensions for RDMA) Datamover");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Alex Nezhinsky, Dan Bar Dov, Or Gerlitz");
+MODULE_VERSION(DRV_VER);
+
 static struct scsi_host_template iscsi_iser_sht;
 static struct iscsi_transport iscsi_iser_transport;
 static struct scsi_transport_template *iscsi_iser_scsi_transport;
+static struct workqueue_struct *release_wq;
+struct iser_global ig;
+
+int iser_debug_level = 0;
+module_param_named(debug_level, iser_debug_level, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0 (default:disabled)");
 
 static unsigned int iscsi_max_lun = 512;
 module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
+MODULE_PARM_DESC(max_lun, "Max LUNs to allow per session (default:512");
 
-int iser_debug_level = 0;
 bool iser_pi_enable = false;
-int iser_pi_guard = 1;
-
-MODULE_DESCRIPTION("iSER (iSCSI Extensions for RDMA) Datamover");
-MODULE_LICENSE("Dual BSD/GPL");
-MODULE_AUTHOR("Alex Nezhinsky, Dan Bar Dov, Or Gerlitz");
-MODULE_VERSION(DRV_VER);
-
-module_param_named(debug_level, iser_debug_level, int, 0644);
-MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0 (default:disabled)");
-
-module_param_named(pi_enable, iser_pi_enable, bool, 0644);
+module_param_named(pi_enable, iser_pi_enable, bool, S_IRUGO);
 MODULE_PARM_DESC(pi_enable, "Enable T10-PI offload support (default:disabled)");
 
-module_param_named(pi_guard, iser_pi_guard, int, 0644);
+int iser_pi_guard;
+module_param_named(pi_guard, iser_pi_guard, int, S_IRUGO);
 MODULE_PARM_DESC(pi_guard, "T10-PI guard_type [deprecated]");
 
-static struct workqueue_struct *release_wq;
-struct iser_global ig;
-
 /*
  * iscsi_iser_recv() - Process a successfull recv completion
  * @conn:         iscsi connection
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
