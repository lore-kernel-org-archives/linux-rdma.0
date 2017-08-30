From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 09/20] RDMA/hns: Configure BT BA and BT attribute for the contexts in hip08
Date: Wed, 30 Aug 2017 17:23:07 +0800
Message-ID: <1504084998-64397-10-git-send-email-xavier.huwei@huawei.com>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504084998-64397-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

BT is used to retrieve the addresses of the contexts(QPC/MPT/CQC/SRQC)
in memory. In order to support multi hop addressing for the contexts,
the BT BA should be configured by mailbox, and the BT attribution will
be set by command.

This patch is to configure the BT BA and BT attribution for the
contexts.

Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_cmd.h   |  46 +++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 198 ++++++++++++++++++++++++++++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  49 +++++++
 3 files changed, 292 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.h b/drivers/infiniband/hw/hns/hns_roce_cmd.h
index f5a9ee2..fc40069 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cmd.h
+++ b/drivers/infiniband/hw/hns/hns_roce_cmd.h
@@ -37,6 +37,52 @@
 #define HNS_ROCE_CMD_TIMEOUT_MSECS	10000
 
 enum {
+	/* QPC BT commands */
+	HNS_ROCE_CMD_WRITE_QPC_BT0	= 0x0,
+	HNS_ROCE_CMD_WRITE_QPC_BT1	= 0x1,
+	HNS_ROCE_CMD_WRITE_QPC_BT2	= 0x2,
+	HNS_ROCE_CMD_READ_QPC_BT0	= 0x4,
+	HNS_ROCE_CMD_READ_QPC_BT1	= 0x5,
+	HNS_ROCE_CMD_READ_QPC_BT2	= 0x6,
+	HNS_ROCE_CMD_DESTROY_QPC_BT0	= 0x8,
+	HNS_ROCE_CMD_DESTROY_QPC_BT1	= 0x9,
+	HNS_ROCE_CMD_DESTROY_QPC_BT2	= 0xa,
+
+	/* CQC BT commands */
+	HNS_ROCE_CMD_WRITE_CQC_BT0	= 0x10,
+	HNS_ROCE_CMD_WRITE_CQC_BT1	= 0x11,
+	HNS_ROCE_CMD_WRITE_CQC_BT2	= 0x12,
+	HNS_ROCE_CMD_READ_CQC_BT0	= 0x14,
+	HNS_ROCE_CMD_READ_CQC_BT1	= 0x15,
+	HNS_ROCE_CMD_READ_CQC_BT2	= 0x1b,
+	HNS_ROCE_CMD_DESTROY_CQC_BT0	= 0x18,
+	HNS_ROCE_CMD_DESTROY_CQC_BT1	= 0x19,
+	HNS_ROCE_CMD_DESTROY_CQC_BT2	= 0x1a,
+
+	/* MPT BT commands */
+	HNS_ROCE_CMD_WRITE_MPT_BT0	= 0x20,
+	HNS_ROCE_CMD_WRITE_MPT_BT1	= 0x21,
+	HNS_ROCE_CMD_WRITE_MPT_BT2	= 0x22,
+	HNS_ROCE_CMD_READ_MPT_BT0	= 0x24,
+	HNS_ROCE_CMD_READ_MPT_BT1	= 0x25,
+	HNS_ROCE_CMD_READ_MPT_BT2	= 0x26,
+	HNS_ROCE_CMD_DESTROY_MPT_BT0	= 0x28,
+	HNS_ROCE_CMD_DESTROY_MPT_BT1	= 0x29,
+	HNS_ROCE_CMD_DESTROY_MPT_BT2	= 0x2a,
+
+	/* SRQC BT commands */
+	HNS_ROCE_CMD_WRITE_SRQC_BT0	= 0x30,
+	HNS_ROCE_CMD_WRITE_SRQC_BT1	= 0x31,
+	HNS_ROCE_CMD_WRITE_SRQC_BT2	= 0x32,
+	HNS_ROCE_CMD_READ_SRQC_BT0	= 0x34,
+	HNS_ROCE_CMD_READ_SRQC_BT1	= 0x35,
+	HNS_ROCE_CMD_READ_SRQC_BT2	= 0x36,
+	HNS_ROCE_CMD_DESTROY_SRQC_BT0	= 0x38,
+	HNS_ROCE_CMD_DESTROY_SRQC_BT1	= 0x39,
+	HNS_ROCE_CMD_DESTROY_SRQC_BT2	= 0x3a,
+};
+
+enum {
 	/* TPT commands */
 	HNS_ROCE_CMD_SW2HW_MPT		= 0xd,
 	HNS_ROCE_CMD_HW2SW_MPT		= 0xf,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 5127edc..77cf476 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -475,6 +475,62 @@ static int hns_roce_alloc_vf_resource(struct hns_roce_dev *hr_dev)
 	return hns_roce_cmq_send(hr_dev, desc, 2);
 }
 
+static int hns_roce_v2_set_bt(struct hns_roce_dev *hr_dev)
+{
+	u8 srqc_hop_num = hr_dev->caps.srqc_hop_num;
+	u8 qpc_hop_num = hr_dev->caps.qpc_hop_num;
+	u8 cqc_hop_num = hr_dev->caps.cqc_hop_num;
+	u8 mpt_hop_num = hr_dev->caps.mpt_hop_num;
+	struct hns_roce_cfg_bt_attr *req;
+	struct hns_roce_cmq_desc desc;
+
+	hns_roce_cmq_setup_basic_desc(&desc, HNS_ROCE_OPC_CFG_BT_ATTR, false);
+	req = (struct hns_roce_cfg_bt_attr *)desc.data;
+	memset(req, 0, sizeof(*req));
+
+	roce_set_field(req->vf_qpc_cfg, CFG_BT_ATTR_DATA_0_VF_QPC_BA_PGSZ_M,
+		       CFG_BT_ATTR_DATA_0_VF_QPC_BA_PGSZ_S,
+		       hr_dev->caps.qpc_ba_pg_sz);
+	roce_set_field(req->vf_qpc_cfg, CFG_BT_ATTR_DATA_0_VF_QPC_BUF_PGSZ_M,
+		       CFG_BT_ATTR_DATA_0_VF_QPC_BUF_PGSZ_S,
+		       hr_dev->caps.qpc_buf_pg_sz);
+	roce_set_field(req->vf_qpc_cfg, CFG_BT_ATTR_DATA_0_VF_QPC_HOPNUM_M,
+		       CFG_BT_ATTR_DATA_0_VF_QPC_HOPNUM_S,
+		       qpc_hop_num == HNS_ROCE_HOP_NUM_0 ? 0 : qpc_hop_num);
+
+	roce_set_field(req->vf_srqc_cfg, CFG_BT_ATTR_DATA_1_VF_SRQC_BA_PGSZ_M,
+		       CFG_BT_ATTR_DATA_1_VF_SRQC_BA_PGSZ_S,
+		       hr_dev->caps.srqc_ba_pg_sz);
+	roce_set_field(req->vf_srqc_cfg, CFG_BT_ATTR_DATA_1_VF_SRQC_BUF_PGSZ_M,
+		       CFG_BT_ATTR_DATA_1_VF_SRQC_BUF_PGSZ_S,
+		       hr_dev->caps.srqc_buf_pg_sz);
+	roce_set_field(req->vf_srqc_cfg, CFG_BT_ATTR_DATA_1_VF_SRQC_HOPNUM_M,
+		       CFG_BT_ATTR_DATA_1_VF_SRQC_HOPNUM_S,
+		       srqc_hop_num == HNS_ROCE_HOP_NUM_0 ? 0 : srqc_hop_num);
+
+	roce_set_field(req->vf_cqc_cfg, CFG_BT_ATTR_DATA_2_VF_CQC_BA_PGSZ_M,
+		       CFG_BT_ATTR_DATA_2_VF_CQC_BA_PGSZ_S,
+		       hr_dev->caps.cqc_ba_pg_sz);
+	roce_set_field(req->vf_cqc_cfg, CFG_BT_ATTR_DATA_2_VF_CQC_BUF_PGSZ_M,
+		       CFG_BT_ATTR_DATA_2_VF_CQC_BUF_PGSZ_S,
+		       hr_dev->caps.cqc_buf_pg_sz);
+	roce_set_field(req->vf_cqc_cfg, CFG_BT_ATTR_DATA_2_VF_CQC_HOPNUM_M,
+		       CFG_BT_ATTR_DATA_2_VF_CQC_HOPNUM_S,
+		       cqc_hop_num == HNS_ROCE_HOP_NUM_0 ? 0 : cqc_hop_num);
+
+	roce_set_field(req->vf_mpt_cfg, CFG_BT_ATTR_DATA_3_VF_MPT_BA_PGSZ_M,
+		       CFG_BT_ATTR_DATA_3_VF_MPT_BA_PGSZ_S,
+		       hr_dev->caps.mpt_ba_pg_sz);
+	roce_set_field(req->vf_mpt_cfg, CFG_BT_ATTR_DATA_3_VF_MPT_BUF_PGSZ_M,
+		       CFG_BT_ATTR_DATA_3_VF_MPT_BUF_PGSZ_S,
+		       hr_dev->caps.mpt_buf_pg_sz);
+	roce_set_field(req->vf_mpt_cfg, CFG_BT_ATTR_DATA_3_VF_MPT_HOPNUM_M,
+		       CFG_BT_ATTR_DATA_3_VF_MPT_HOPNUM_S,
+		       mpt_hop_num == HNS_ROCE_HOP_NUM_0 ? 0 : mpt_hop_num);
+
+	return hns_roce_cmq_send(hr_dev, &desc, 1);
+}
+
 static int hns_roce_v2_profile(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_caps *caps = &hr_dev->caps;
@@ -563,7 +619,12 @@ static int hns_roce_v2_profile(struct hns_roce_dev *hr_dev)
 	caps->local_ca_ack_delay = 0;
 	caps->max_mtu = IB_MTU_4096;
 
-	return 0;
+	ret = hns_roce_v2_set_bt(hr_dev);
+	if (ret)
+		dev_err(hr_dev->dev, "Configure bt attribute fail, ret = %d.\n",
+			ret);
+
+	return ret;
 }
 
 static int hns_roce_v2_cmd_pending(struct hns_roce_dev *hr_dev)
@@ -648,12 +709,147 @@ static int hns_roce_v2_chk_mbox(struct hns_roce_dev *hr_dev,
 	return 0;
 }
 
+static int hns_roce_v2_set_hem(struct hns_roce_dev *hr_dev,
+			       struct hns_roce_hem_table *table, int obj,
+			       int step_idx)
+{
+	struct device *dev = hr_dev->dev;
+	struct hns_roce_cmd_mailbox *mailbox;
+	struct hns_roce_hem_iter iter;
+	struct hns_roce_hem_mhop mhop;
+	struct hns_roce_hem *hem;
+	unsigned long mhop_obj = obj;
+	int i, j, k;
+	int ret = 0;
+	u64 hem_idx = 0;
+	u64 l1_idx = 0;
+	u64 bt_ba = 0;
+	u32 chunk_ba_num;
+	u32 hop_num;
+	u16 op = 0xff;
+
+	if (!hns_roce_check_whether_mhop(hr_dev, table->type))
+		return 0;
+
+	hns_roce_calc_hem_mhop(hr_dev, table, &mhop_obj, &mhop);
+	i = mhop.l0_idx;
+	j = mhop.l1_idx;
+	k = mhop.l2_idx;
+	hop_num = mhop.hop_num;
+	chunk_ba_num = mhop.bt_chunk_size / 8;
+
+	if (hop_num == 2) {
+		hem_idx = i * chunk_ba_num * chunk_ba_num + j * chunk_ba_num +
+			  k;
+		l1_idx = i * chunk_ba_num + j;
+	} else if (hop_num == 1) {
+		hem_idx = i * chunk_ba_num + j;
+	} else if (hop_num == HNS_ROCE_HOP_NUM_0) {
+		hem_idx = i;
+	}
+
+	switch (table->type) {
+	case HEM_TYPE_QPC:
+		op = HNS_ROCE_CMD_WRITE_QPC_BT0;
+		break;
+	case HEM_TYPE_MTPT:
+		op = HNS_ROCE_CMD_WRITE_MPT_BT0;
+		break;
+	case HEM_TYPE_CQC:
+		op = HNS_ROCE_CMD_WRITE_CQC_BT0;
+		break;
+	case HEM_TYPE_SRQC:
+		op = HNS_ROCE_CMD_WRITE_SRQC_BT0;
+		break;
+	default:
+		dev_warn(dev, "Table %d not to be written by mailbox!\n",
+			 table->type);
+		return 0;
+	}
+	op += step_idx;
+
+	mailbox = hns_roce_alloc_cmd_mailbox(hr_dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	if (check_whether_last_step(hop_num, step_idx)) {
+		hem = table->hem[hem_idx];
+		for (hns_roce_hem_first(hem, &iter);
+		     !hns_roce_hem_last(&iter); hns_roce_hem_next(&iter)) {
+			bt_ba = hns_roce_hem_addr(&iter);
+
+			/* configure the ba, tag, and op */
+			ret = hns_roce_cmd_mbox(hr_dev, bt_ba, mailbox->dma,
+						obj, 0, op,
+						HNS_ROCE_CMD_TIMEOUT_MSECS);
+		}
+	} else {
+		if (step_idx == 0)
+			bt_ba = table->bt_l0_dma_addr[i];
+		else if (step_idx == 1 && hop_num == 2)
+			bt_ba = table->bt_l1_dma_addr[l1_idx];
+
+		/* configure the ba, tag, and op */
+		ret = hns_roce_cmd_mbox(hr_dev, bt_ba, mailbox->dma, obj,
+					0, op, HNS_ROCE_CMD_TIMEOUT_MSECS);
+	}
+
+	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
+	return ret;
+}
+
+static int hns_roce_v2_clear_hem(struct hns_roce_dev *hr_dev,
+				 struct hns_roce_hem_table *table, int obj,
+				 int step_idx)
+{
+	struct device *dev = hr_dev->dev;
+	struct hns_roce_cmd_mailbox *mailbox;
+	int ret = 0;
+	u16 op = 0xff;
+
+	if (!hns_roce_check_whether_mhop(hr_dev, table->type))
+		return 0;
+
+	switch (table->type) {
+	case HEM_TYPE_QPC:
+		op = HNS_ROCE_CMD_DESTROY_QPC_BT0;
+		break;
+	case HEM_TYPE_MTPT:
+		op = HNS_ROCE_CMD_DESTROY_MPT_BT0;
+		break;
+	case HEM_TYPE_CQC:
+		op = HNS_ROCE_CMD_DESTROY_CQC_BT0;
+		break;
+	case HEM_TYPE_SRQC:
+		op = HNS_ROCE_CMD_DESTROY_SRQC_BT0;
+		break;
+	default:
+		dev_warn(dev, "Table %d not to be destroyed by mailbox!\n",
+			 table->type);
+		return 0;
+	}
+	op += step_idx;
+
+	mailbox = hns_roce_alloc_cmd_mailbox(hr_dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	/* configure the tag and op */
+	ret = hns_roce_cmd_mbox(hr_dev, 0, mailbox->dma, obj, 0, op,
+				HNS_ROCE_CMD_TIMEOUT_MSECS);
+
+	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
+	return ret;
+}
+
 static const struct hns_roce_hw hns_roce_hw_v2 = {
 	.cmq_init = hns_roce_v2_cmq_init,
 	.cmq_exit = hns_roce_v2_cmq_exit,
 	.hw_profile = hns_roce_v2_profile,
 	.post_mbox = hns_roce_v2_post_mbox,
 	.chk_mbox = hns_roce_v2_chk_mbox,
+	.set_hem = hns_roce_v2_set_hem,
+	.clear_hem = hns_roce_v2_clear_hem,
 };
 
 static const struct pci_device_id hns_roce_hw_v2_pci_tbl[] = {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 91f5161..cc8c8d0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -93,6 +93,11 @@
 #define HNS_ROCE_CMQ_EN_B		16
 #define HNS_ROCE_CMQ_ENABLE		BIT(HNS_ROCE_CMQ_EN_B)
 
+#define check_whether_last_step(hop_num, step_idx) \
+	((step_idx == 0 && hop_num == HNS_ROCE_HOP_NUM_0) || \
+	(step_idx == 1 && hop_num == 1) || \
+	(step_idx == 2 && hop_num == 2))
+
 /* CMQ command */
 enum hns_roce_opcode_type {
 	HNS_ROCE_OPC_QUERY_HW_VER			= 0x8000,
@@ -239,6 +244,50 @@ struct hns_roce_vf_res_b {
 #define VF_RES_B_DATA_3_VF_SL_NUM_S 16
 #define VF_RES_B_DATA_3_VF_SL_NUM_M GENMASK(19, 16)
 
+struct hns_roce_cfg_bt_attr {
+	u32 vf_qpc_cfg;
+	u32 vf_srqc_cfg;
+	u32 vf_cqc_cfg;
+	u32 vf_mpt_cfg;
+	u32 rsv[2];
+};
+
+#define CFG_BT_ATTR_DATA_0_VF_QPC_BA_PGSZ_S 0
+#define CFG_BT_ATTR_DATA_0_VF_QPC_BA_PGSZ_M GENMASK(3, 0)
+
+#define CFG_BT_ATTR_DATA_0_VF_QPC_BUF_PGSZ_S 4
+#define CFG_BT_ATTR_DATA_0_VF_QPC_BUF_PGSZ_M GENMASK(7, 4)
+
+#define CFG_BT_ATTR_DATA_0_VF_QPC_HOPNUM_S 8
+#define CFG_BT_ATTR_DATA_0_VF_QPC_HOPNUM_M GENMASK(9, 8)
+
+#define CFG_BT_ATTR_DATA_1_VF_SRQC_BA_PGSZ_S 0
+#define CFG_BT_ATTR_DATA_1_VF_SRQC_BA_PGSZ_M GENMASK(3, 0)
+
+#define CFG_BT_ATTR_DATA_1_VF_SRQC_BUF_PGSZ_S 4
+#define CFG_BT_ATTR_DATA_1_VF_SRQC_BUF_PGSZ_M GENMASK(7, 4)
+
+#define CFG_BT_ATTR_DATA_1_VF_SRQC_HOPNUM_S 8
+#define CFG_BT_ATTR_DATA_1_VF_SRQC_HOPNUM_M GENMASK(9, 8)
+
+#define CFG_BT_ATTR_DATA_2_VF_CQC_BA_PGSZ_S 0
+#define CFG_BT_ATTR_DATA_2_VF_CQC_BA_PGSZ_M GENMASK(3, 0)
+
+#define CFG_BT_ATTR_DATA_2_VF_CQC_BUF_PGSZ_S 4
+#define CFG_BT_ATTR_DATA_2_VF_CQC_BUF_PGSZ_M GENMASK(7, 4)
+
+#define CFG_BT_ATTR_DATA_2_VF_CQC_HOPNUM_S 8
+#define CFG_BT_ATTR_DATA_2_VF_CQC_HOPNUM_M GENMASK(9, 8)
+
+#define CFG_BT_ATTR_DATA_3_VF_MPT_BA_PGSZ_S 0
+#define CFG_BT_ATTR_DATA_3_VF_MPT_BA_PGSZ_M GENMASK(3, 0)
+
+#define CFG_BT_ATTR_DATA_3_VF_MPT_BUF_PGSZ_S 4
+#define CFG_BT_ATTR_DATA_3_VF_MPT_BUF_PGSZ_M GENMASK(7, 4)
+
+#define CFG_BT_ATTR_DATA_3_VF_MPT_HOPNUM_S 8
+#define CFG_BT_ATTR_DATA_3_VF_MPT_HOPNUM_M GENMASK(9, 8)
+
 struct hns_roce_cmq_desc {
 	u16 opcode;
 	u16 flag;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
