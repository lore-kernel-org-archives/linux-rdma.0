From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V2 for-next 3/8] RDMA/hns: Add return statement when kzalloc return NULL in hns_roce_v1_recreate_lp_qp
Date: Fri, 29 Sep 2017 23:10:09 +0800
Message-ID: <1506697814-98432-4-git-send-email-xavier.huwei@huawei.com>
References: <1506697814-98432-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506697814-98432-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com
List-Id: linux-rdma@vger.kernel.org

When lp_qp_work is NULL, it should be returned ENOMEM. This patch
mainly adds the error checking branch, modifies the return value of
the function named hns_roce_v1_set_mac that calling
hns_roce_v1_recreate_lp_qp.

Ihis patch fixes the smatch error as below:
drivers/infiniband/hw/hns/hns_roce_hw_v1.c:918 hns_roce_v1_recreate_lp_qp()
error: potential null dereference 'lp_qp_work'.  (kzalloc returns null)

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
---
Patch V2: Address comments by Leon:
	 https://lkml.org/lkml/2017/9/28/382

Patch V1: Initial Submit
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 16 +++++++++++++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  6 ++++--
 drivers/infiniband/hw/hns/hns_roce_main.c   | 17 +++++++++++------
 4 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 4f43c91..4d9d5d7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -581,7 +581,7 @@ struct hns_roce_hw {
 	int (*chk_mbox)(struct hns_roce_dev *hr_dev, unsigned long timeout);
 	void (*set_gid)(struct hns_roce_dev *hr_dev, u8 port, int gid_index,
 			union ib_gid *gid);
-	void (*set_mac)(struct hns_roce_dev *hr_dev, u8 phy_port, u8 *addr);
+	int (*set_mac)(struct hns_roce_dev *hr_dev, u8 phy_port, u8 *addr);
 	void (*set_mtu)(struct hns_roce_dev *hr_dev, u8 phy_port,
 			enum ib_mtu mtu);
 	int (*write_mtpt)(void *mb_buf, struct hns_roce_mr *mr,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 95f5c88..6f309f7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -912,6 +912,8 @@ static int hns_roce_v1_recreate_lp_qp(struct hns_roce_dev *hr_dev)
 
 	lp_qp_work = kzalloc(sizeof(struct hns_roce_recreate_lp_qp_work),
 			     GFP_KERNEL);
+	if (!lp_qp_work)
+		return -ENOMEM;
 
 	INIT_WORK(&(lp_qp_work->work), hns_roce_v1_recreate_lp_qp_work_fn);
 
@@ -1719,7 +1721,8 @@ void hns_roce_v1_set_gid(struct hns_roce_dev *hr_dev, u8 port, int gid_index,
 		       (HNS_ROCE_V1_GID_NUM * gid_idx));
 }
 
-void hns_roce_v1_set_mac(struct hns_roce_dev *hr_dev, u8 phy_port, u8 *addr)
+static int hns_roce_v1_set_mac(struct hns_roce_dev *hr_dev, u8 phy_port,
+			       u8 *addr)
 {
 	u32 reg_smac_l;
 	u16 reg_smac_h;
@@ -1732,8 +1735,13 @@ void hns_roce_v1_set_mac(struct hns_roce_dev *hr_dev, u8 phy_port, u8 *addr)
 	 * because of smac not equal to dmac.
 	 * We Need to release and create reserved qp again.
 	 */
-	if (hr_dev->hw->dereg_mr && hns_roce_v1_recreate_lp_qp(hr_dev))
-		dev_warn(&hr_dev->pdev->dev, "recreate lp qp timeout!\n");
+	if (hr_dev->hw->dereg_mr) {
+		int ret;
+
+		ret = hns_roce_v1_recreate_lp_qp(hr_dev);
+		if (ret && ret != -ETIMEDOUT)
+			return ret;
+	}
 
 	p = (u32 *)(&addr[0]);
 	reg_smac_l = *p;
@@ -1748,6 +1756,8 @@ void hns_roce_v1_set_mac(struct hns_roce_dev *hr_dev, u8 phy_port, u8 *addr)
 		       ROCEE_SMAC_H_ROCEE_SMAC_H_S, reg_smac_h);
 	roce_write(hr_dev, ROCEE_SMAC_H_0_REG + phy_port * PHY_PORT_OFFSET,
 		   val);
+
+	return 0;
 }
 
 void hns_roce_v1_set_mtu(struct hns_roce_dev *hr_dev, u8 phy_port,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 4171f73..e5fe2cd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1068,8 +1068,8 @@ static void hns_roce_v2_set_gid(struct hns_roce_dev *hr_dev, u8 port,
 	roce_write(hr_dev, ROCEE_VF_SGID_CFG4_REG + 0x20 * gid_index, val);
 }
 
-static void hns_roce_v2_set_mac(struct hns_roce_dev *hr_dev, u8 phy_port,
-				u8 *addr)
+static int hns_roce_v2_set_mac(struct hns_roce_dev *hr_dev, u8 phy_port,
+			       u8 *addr)
 {
 	u16 reg_smac_h;
 	u32 reg_smac_l;
@@ -1084,6 +1084,8 @@ static void hns_roce_v2_set_mac(struct hns_roce_dev *hr_dev, u8 phy_port,
 	roce_set_field(val, ROCEE_VF_SMAC_CFG1_VF_SMAC_H_M,
 		       ROCEE_VF_SMAC_CFG1_VF_SMAC_H_S, reg_smac_h);
 	roce_write(hr_dev, ROCEE_VF_SMAC_CFG1_REG + 0x08 * phy_port, val);
+
+	return 0;
 }
 
 static int hns_roce_v2_write_mtpt(void *mb_buf, struct hns_roce_mr *mr,
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 7a0c1e8..6f2d572 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -59,19 +59,19 @@ int hns_get_gid_index(struct hns_roce_dev *hr_dev, u8 port, int gid_index)
 }
 EXPORT_SYMBOL_GPL(hns_get_gid_index);
 
-static void hns_roce_set_mac(struct hns_roce_dev *hr_dev, u8 port, u8 *addr)
+static int hns_roce_set_mac(struct hns_roce_dev *hr_dev, u8 port, u8 *addr)
 {
 	u8 phy_port;
 	u32 i = 0;
 
 	if (!memcmp(hr_dev->dev_addr[port], addr, MAC_ADDR_OCTET_NUM))
-		return;
+		return 0;
 
 	for (i = 0; i < MAC_ADDR_OCTET_NUM; i++)
 		hr_dev->dev_addr[port][i] = addr[i];
 
 	phy_port = hr_dev->iboe.phy_port[port];
-	hr_dev->hw->set_mac(hr_dev, phy_port, addr);
+	return hr_dev->hw->set_mac(hr_dev, phy_port, addr);
 }
 
 static int hns_roce_add_gid(struct ib_device *device, u8 port_num,
@@ -119,6 +119,7 @@ static int handle_en_event(struct hns_roce_dev *hr_dev, u8 port,
 {
 	struct device *dev = hr_dev->dev;
 	struct net_device *netdev;
+	int ret = 0;
 
 	netdev = hr_dev->iboe.netdevs[port];
 	if (!netdev) {
@@ -131,7 +132,7 @@ static int handle_en_event(struct hns_roce_dev *hr_dev, u8 port,
 	case NETDEV_CHANGE:
 	case NETDEV_REGISTER:
 	case NETDEV_CHANGEADDR:
-		hns_roce_set_mac(hr_dev, port, netdev->dev_addr);
+		ret = hns_roce_set_mac(hr_dev, port, netdev->dev_addr);
 		break;
 	case NETDEV_DOWN:
 		/*
@@ -143,7 +144,7 @@ static int handle_en_event(struct hns_roce_dev *hr_dev, u8 port,
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int hns_roce_netdev_event(struct notifier_block *self,
@@ -172,13 +173,17 @@ static int hns_roce_netdev_event(struct notifier_block *self,
 
 static int hns_roce_setup_mtu_mac(struct hns_roce_dev *hr_dev)
 {
+	int ret;
 	u8 i;
 
 	for (i = 0; i < hr_dev->caps.num_ports; i++) {
 		if (hr_dev->hw->set_mtu)
 			hr_dev->hw->set_mtu(hr_dev, hr_dev->iboe.phy_port[i],
 					    hr_dev->caps.max_mtu);
-		hns_roce_set_mac(hr_dev, i, hr_dev->iboe.netdevs[i]->dev_addr);
+		ret = hns_roce_set_mac(hr_dev, i,
+				       hr_dev->iboe.netdevs[i]->dev_addr);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-- 
1.9.1
