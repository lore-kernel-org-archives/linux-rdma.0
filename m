From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0262/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:54:24 +0800
Message-ID: <20160802105424.31207-1-baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, bp@alien8.de
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com, hch@infradead.org, matanb@mellanox.com, markb@mellanox.com, jgunthorpe@obsidianresearch.com, dean.luick@intel.com
List-Id: linux-rdma@vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/infiniband/hw/mthca/mthca_catas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_catas.c b/drivers/infiniband/hw/mthca/mthca_catas.c
index 712d2a3..6138e95 100644
--- a/drivers/infiniband/hw/mthca/mthca_catas.c
+++ b/drivers/infiniband/hw/mthca/mthca_catas.c
@@ -53,7 +53,7 @@ static struct workqueue_struct *catas_wq;
 static struct work_struct catas_work;
 
 static int catas_reset_disable;
-module_param_named(catas_reset_disable, catas_reset_disable, int, 0644);
+module_param_named(catas_reset_disable, catas_reset_disable, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(catas_reset_disable, "disable reset on catastrophic event if nonzero");
 
 static void catas_reset(struct work_struct *work)
-- 
2.9.2
