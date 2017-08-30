From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 17/20] RDMA/hns: Configure the MTPT in hip08
Date: Wed, 30 Aug 2017 17:23:15 +0800
Message-ID: <1504084998-64397-18-git-send-email-xavier.huwei@huawei.com>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504084998-64397-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The MTPT records the attribute of the registered MR. The MTPT format
will be updated in hip08, and the MTPT should be configured.

This patch is to configure the MTPT for the registered MR in hip08.

Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 94 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 68 +++++++++++++++++++++
 2 files changed, 162 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index b614177..4171f73 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1086,6 +1086,99 @@ static void hns_roce_v2_set_mac(struct hns_roce_dev *hr_dev, u8 phy_port,
 	roce_write(hr_dev, ROCEE_VF_SMAC_CFG1_REG + 0x08 * phy_port, val);
 }
 
+static int hns_roce_v2_write_mtpt(void *mb_buf, struct hns_roce_mr *mr,
+				  unsigned long mtpt_idx)
+{
+	struct hns_roce_v2_mpt_entry *mpt_entry;
+	struct scatterlist *sg;
+	u64 *pages;
+	int entry;
+	int i;
+
+	mpt_entry = mb_buf;
+	memset(mpt_entry, 0, sizeof(*mpt_entry));
+
+	roce_set_field(mpt_entry->byte_4_pd_hop_st, V2_MPT_BYTE_4_MPT_ST_M,
+		       V2_MPT_BYTE_4_MPT_ST_S, V2_MPT_ST_VALID);
+	roce_set_field(mpt_entry->byte_4_pd_hop_st, V2_MPT_BYTE_4_PBL_HOP_NUM_M,
+		       V2_MPT_BYTE_4_PBL_HOP_NUM_S, mr->pbl_hop_num ==
+		       HNS_ROCE_HOP_NUM_0 ? 0 : mr->pbl_hop_num);
+	roce_set_field(mpt_entry->byte_4_pd_hop_st,
+		       V2_MPT_BYTE_4_PBL_BA_PG_SZ_M,
+		       V2_MPT_BYTE_4_PBL_BA_PG_SZ_S, mr->pbl_ba_pg_sz);
+	roce_set_field(mpt_entry->byte_4_pd_hop_st, V2_MPT_BYTE_4_PD_M,
+		       V2_MPT_BYTE_4_PD_S, mr->pd);
+	mpt_entry->byte_4_pd_hop_st = cpu_to_le32(mpt_entry->byte_4_pd_hop_st);
+
+	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_RA_EN_S, 0);
+	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_R_INV_EN_S, 1);
+	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_L_INV_EN_S, 0);
+	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_BIND_EN_S,
+		     (mr->access & IB_ACCESS_MW_BIND ? 1 : 0));
+	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_ATOMIC_EN_S, 0);
+	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_RR_EN_S,
+		     (mr->access & IB_ACCESS_REMOTE_READ ? 1 : 0));
+	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_RW_EN_S,
+		     (mr->access & IB_ACCESS_REMOTE_WRITE ? 1 : 0));
+	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_LW_EN_S,
+		     (mr->access & IB_ACCESS_LOCAL_WRITE ? 1 : 0));
+	mpt_entry->byte_8_mw_cnt_en = cpu_to_le32(mpt_entry->byte_8_mw_cnt_en);
+
+	roce_set_bit(mpt_entry->byte_12_mw_pa, V2_MPT_BYTE_12_PA_S,
+		     mr->type == MR_TYPE_MR ? 0 : 1);
+	mpt_entry->byte_12_mw_pa = cpu_to_le32(mpt_entry->byte_12_mw_pa);
+
+	mpt_entry->len_l = cpu_to_le32(lower_32_bits(mr->size));
+	mpt_entry->len_h = cpu_to_le32(upper_32_bits(mr->size));
+	mpt_entry->lkey = cpu_to_le32(mr->key);
+	mpt_entry->va_l = cpu_to_le32(lower_32_bits(mr->iova));
+	mpt_entry->va_h = cpu_to_le32(upper_32_bits(mr->iova));
+
+	if (mr->type == MR_TYPE_DMA)
+		return 0;
+
+	mpt_entry->pbl_size = cpu_to_le32(mr->pbl_size);
+
+	mpt_entry->pbl_ba_l = cpu_to_le32(lower_32_bits(mr->pbl_ba >> 3));
+	roce_set_field(mpt_entry->byte_48_mode_ba, V2_MPT_BYTE_48_PBL_BA_H_M,
+		       V2_MPT_BYTE_48_PBL_BA_H_S,
+		       upper_32_bits(mr->pbl_ba >> 3));
+	mpt_entry->byte_48_mode_ba = cpu_to_le32(mpt_entry->byte_48_mode_ba);
+
+	pages = (u64 *)__get_free_page(GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	i = 0;
+	for_each_sg(mr->umem->sg_head.sgl, sg, mr->umem->nmap, entry) {
+		pages[i] = ((u64)sg_dma_address(sg)) >> 6;
+
+		/* Record the first 2 entry directly to MTPT table */
+		if (i >= HNS_ROCE_V2_MAX_INNER_MTPT_NUM - 1)
+			break;
+		i++;
+	}
+
+	mpt_entry->pa0_l = cpu_to_le32(lower_32_bits(pages[0]));
+	roce_set_field(mpt_entry->byte_56_pa0_h, V2_MPT_BYTE_56_PA0_H_M,
+		       V2_MPT_BYTE_56_PA0_H_S,
+		       upper_32_bits(pages[0]));
+	mpt_entry->byte_56_pa0_h = cpu_to_le32(mpt_entry->byte_56_pa0_h);
+
+	mpt_entry->pa1_l = cpu_to_le32(lower_32_bits(pages[1]));
+	roce_set_field(mpt_entry->byte_64_buf_pa1, V2_MPT_BYTE_64_PA1_H_M,
+		       V2_MPT_BYTE_64_PA1_H_S, upper_32_bits(pages[1]));
+
+	free_page((unsigned long)pages);
+
+	roce_set_field(mpt_entry->byte_64_buf_pa1,
+		       V2_MPT_BYTE_64_PBL_BUF_PG_SZ_M,
+		       V2_MPT_BYTE_64_PBL_BUF_PG_SZ_S, mr->pbl_buf_pg_sz);
+	mpt_entry->byte_64_buf_pa1 = cpu_to_le32(mpt_entry->byte_64_buf_pa1);
+
+	return 0;
+}
+
 static void *get_cqe_v2(struct hns_roce_cq *hr_cq, int n)
 {
 	return hns_roce_buf_offset(&hr_cq->hr_buf.hr_buf,
@@ -2903,6 +2996,7 @@ static int hns_roce_v2_destroy_qp(struct ib_qp *ibqp)
 	.chk_mbox = hns_roce_v2_chk_mbox,
 	.set_gid = hns_roce_v2_set_gid,
 	.set_mac = hns_roce_v2_set_mac,
+	.write_mtpt = hns_roce_v2_write_mtpt,
 	.write_cqc = hns_roce_v2_write_cqc,
 	.set_hem = hns_roce_v2_set_hem,
 	.clear_hem = hns_roce_v2_clear_hem,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 6172146..4fc4acd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -790,6 +790,74 @@ struct hns_roce_v2_cqe {
 
 #define	V2_CQE_BYTE_32_LPK_S 31
 
+struct hns_roce_v2_mpt_entry {
+	__le32	byte_4_pd_hop_st;
+	__le32	byte_8_mw_cnt_en;
+	__le32	byte_12_mw_pa;
+	__le32	bound_lkey;
+	__le32	len_l;
+	__le32	len_h;
+	__le32	lkey;
+	__le32	va_l;
+	__le32	va_h;
+	__le32	pbl_size;
+	__le32	pbl_ba_l;
+	__le32	byte_48_mode_ba;
+	__le32	pa0_l;
+	__le32	byte_56_pa0_h;
+	__le32	pa1_l;
+	__le32	byte_64_buf_pa1;
+};
+
+#define V2_MPT_BYTE_4_MPT_ST_S 0
+#define V2_MPT_BYTE_4_MPT_ST_M GENMASK(1, 0)
+
+#define V2_MPT_BYTE_4_PBL_HOP_NUM_S 2
+#define V2_MPT_BYTE_4_PBL_HOP_NUM_M GENMASK(3, 2)
+
+#define V2_MPT_BYTE_4_PBL_BA_PG_SZ_S 4
+#define V2_MPT_BYTE_4_PBL_BA_PG_SZ_M GENMASK(7, 4)
+
+#define V2_MPT_BYTE_4_PD_S 8
+#define V2_MPT_BYTE_4_PD_M GENMASK(31, 8)
+
+#define V2_MPT_BYTE_8_RA_EN_S 0
+
+#define V2_MPT_BYTE_8_R_INV_EN_S 1
+
+#define V2_MPT_BYTE_8_L_INV_EN_S 2
+
+#define V2_MPT_BYTE_8_BIND_EN_S 3
+
+#define V2_MPT_BYTE_8_ATOMIC_EN_S 4
+
+#define V2_MPT_BYTE_8_RR_EN_S 5
+
+#define V2_MPT_BYTE_8_RW_EN_S 6
+
+#define V2_MPT_BYTE_8_LW_EN_S 7
+
+#define V2_MPT_BYTE_12_PA_S 1
+
+#define V2_MPT_BYTE_12_INNER_PA_VLD_S 7
+
+#define V2_MPT_BYTE_12_MW_BIND_QPN_S 8
+#define V2_MPT_BYTE_12_MW_BIND_QPN_M GENMASK(31, 8)
+
+#define V2_MPT_BYTE_48_PBL_BA_H_S 0
+#define V2_MPT_BYTE_48_PBL_BA_H_M GENMASK(28, 0)
+
+#define V2_MPT_BYTE_48_BLK_MODE_S 29
+
+#define V2_MPT_BYTE_56_PA0_H_S 0
+#define V2_MPT_BYTE_56_PA0_H_M GENMASK(25, 0)
+
+#define V2_MPT_BYTE_64_PA1_H_S 0
+#define V2_MPT_BYTE_64_PA1_H_M GENMASK(25, 0)
+
+#define V2_MPT_BYTE_64_PBL_BUF_PG_SZ_S 28
+#define V2_MPT_BYTE_64_PBL_BUF_PG_SZ_M GENMASK(31, 28)
+
 #define	V2_DB_BYTE_4_TAG_S 0
 #define V2_DB_BYTE_4_TAG_M GENMASK(23, 0)
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
