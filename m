From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 13/20] RDMA/hns: Configure mac&gid and user access region for hip08 RoCE driver
Date: Wed, 30 Aug 2017 17:23:11 +0800
Message-ID: <1504084998-64397-14-git-send-email-xavier.huwei@huawei.com>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504084998-64397-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In hip08, the user access region(UAR) pfn is calculated
from pci device memory resource.

This patch mainly sets mac and gid table by configuring
the relevant registers and updates the uar pfn for hip08 SoC.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_common.h |  9 ++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 49 +++++++++++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  7 +++++
 drivers/infiniband/hw/hns/hns_roce_pd.c     | 16 +++++++---
 4 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_common.h b/drivers/infiniband/hw/hns/hns_roce_common.h
index 0c950f8..7ecb7a4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_common.h
+++ b/drivers/infiniband/hw/hns/hns_roce_common.h
@@ -376,4 +376,13 @@
 #define ROCEE_RX_CMQ_TAIL_REG			0x07024
 #define ROCEE_RX_CMQ_HEAD_REG			0x07028
 
+#define ROCEE_VF_SMAC_CFG0_REG			0x12000
+#define ROCEE_VF_SMAC_CFG1_REG			0x12004
+
+#define ROCEE_VF_SGID_CFG0_REG			0x10000
+#define ROCEE_VF_SGID_CFG1_REG			0x10004
+#define ROCEE_VF_SGID_CFG2_REG			0x10008
+#define ROCEE_VF_SGID_CFG3_REG			0x1000c
+#define ROCEE_VF_SGID_CFG4_REG			0x10010
+
 #endif /* _HNS_ROCE_COMMON_H */
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 542540d..e7aeb53 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -718,6 +718,53 @@ static int hns_roce_v2_chk_mbox(struct hns_roce_dev *hr_dev,
 	return 0;
 }
 
+static void hns_roce_v2_set_gid(struct hns_roce_dev *hr_dev, u8 port,
+				int gid_index, union ib_gid *gid)
+{
+	u32 *p;
+	u32 val;
+
+	p = (u32 *)&gid->raw[0];
+	roce_raw_write(*p, hr_dev->reg_base + ROCEE_VF_SGID_CFG0_REG +
+		       0x20 * gid_index);
+
+	p = (u32 *)&gid->raw[4];
+	roce_raw_write(*p, hr_dev->reg_base + ROCEE_VF_SGID_CFG1_REG +
+		       0x20 * gid_index);
+
+	p = (u32 *)&gid->raw[8];
+	roce_raw_write(*p, hr_dev->reg_base + ROCEE_VF_SGID_CFG2_REG +
+		       0x20 * gid_index);
+
+	p = (u32 *)&gid->raw[0xc];
+	roce_raw_write(*p, hr_dev->reg_base + ROCEE_VF_SGID_CFG3_REG +
+		       0x20 * gid_index);
+
+	val = roce_read(hr_dev, ROCEE_VF_SGID_CFG4_REG + 0x20 * gid_index);
+	roce_set_field(val, ROCEE_VF_SGID_CFG4_SGID_TYPE_M,
+		       ROCEE_VF_SGID_CFG4_SGID_TYPE_S, 0);
+
+	roce_write(hr_dev, ROCEE_VF_SGID_CFG4_REG + 0x20 * gid_index, val);
+}
+
+static void hns_roce_v2_set_mac(struct hns_roce_dev *hr_dev, u8 phy_port,
+				u8 *addr)
+{
+	u16 reg_smac_h;
+	u32 reg_smac_l;
+	u32 val;
+
+	reg_smac_l = *(u32 *)(&addr[0]);
+	roce_raw_write(reg_smac_l, hr_dev->reg_base + ROCEE_VF_SMAC_CFG0_REG +
+		       0x08 * phy_port);
+	val = roce_read(hr_dev, ROCEE_VF_SMAC_CFG1_REG + 0x08 * phy_port);
+
+	reg_smac_h  = *(u16 *)(&addr[4]);
+	roce_set_field(val, ROCEE_VF_SMAC_CFG1_VF_SMAC_H_M,
+		       ROCEE_VF_SMAC_CFG1_VF_SMAC_H_S, reg_smac_h);
+	roce_write(hr_dev, ROCEE_VF_SMAC_CFG1_REG + 0x08 * phy_port, val);
+}
+
 static int hns_roce_v2_set_hem(struct hns_roce_dev *hr_dev,
 			       struct hns_roce_hem_table *table, int obj,
 			       int step_idx)
@@ -857,6 +904,8 @@ static int hns_roce_v2_clear_hem(struct hns_roce_dev *hr_dev,
 	.hw_profile = hns_roce_v2_profile,
 	.post_mbox = hns_roce_v2_post_mbox,
 	.chk_mbox = hns_roce_v2_chk_mbox,
+	.set_gid = hns_roce_v2_set_gid,
+	.set_mac = hns_roce_v2_set_mac,
 	.set_hem = hns_roce_v2_set_hem,
 	.clear_hem = hns_roce_v2_clear_hem,
 };
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 593d886..aee8f34 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -246,6 +246,13 @@ struct hns_roce_vf_res_b {
 #define VF_RES_B_DATA_3_VF_SL_NUM_S 16
 #define VF_RES_B_DATA_3_VF_SL_NUM_M GENMASK(19, 16)
 
+/* Reg field definition */
+#define ROCEE_VF_SMAC_CFG1_VF_SMAC_H_S 0
+#define ROCEE_VF_SMAC_CFG1_VF_SMAC_H_M GENMASK(15, 0)
+
+#define ROCEE_VF_SGID_CFG4_SGID_TYPE_S 0
+#define ROCEE_VF_SGID_CFG4_SGID_TYPE_M GENMASK(1, 0)
+
 struct hns_roce_cfg_bt_attr {
 	u32 vf_qpc_cfg;
 	u32 vf_srqc_cfg;
diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
index 079bb10..bdab218 100644
--- a/drivers/infiniband/hw/hns/hns_roce_pd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/pci.h>
 #include "hns_roce_device.h"
 
 static int hns_roce_pd_alloc(struct hns_roce_dev *hr_dev, unsigned long *pdn)
@@ -111,12 +112,17 @@ int hns_roce_uar_alloc(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
 		uar->index = (uar->index - 1) %
 			     (hr_dev->caps.phy_num_uars - 1) + 1;
 
-	res = platform_get_resource(hr_dev->pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&hr_dev->pdev->dev, "memory resource not found!\n");
-		return -EINVAL;
+	if (!dev_is_pci(hr_dev->dev)) {
+		res = platform_get_resource(hr_dev->pdev, IORESOURCE_MEM, 0);
+		if (!res) {
+			dev_err(&hr_dev->pdev->dev, "memory resource not found!\n");
+			return -EINVAL;
+		}
+		uar->pfn = ((res->start) >> PAGE_SHIFT) + uar->index;
+	} else {
+		uar->pfn = ((pci_resource_start(hr_dev->pci_dev, 2))
+			   >> PAGE_SHIFT);
 	}
-	uar->pfn = ((res->start) >> PAGE_SHIFT) + uar->index;
 
 	return 0;
 }
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
