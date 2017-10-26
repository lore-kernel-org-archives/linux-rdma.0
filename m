From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH 2/3] RDMA/hns: Generate gid type of RoCEv2
Date: Thu, 26 Oct 2017 17:10:24 +0800
Message-ID: <1509009025-101743-3-git-send-email-xavier.huwei@huawei.com>
References: <1509009025-101743-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509009025-101743-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com, shaoboxu@tom.com, shaobo.xu@intel.com
List-Id: linux-rdma@vger.kernel.org

HNS_ROCE_CAP_FALG_ROCE_V1_V2 is added for selecting capability of
RoCE in hns driver. When HNS_ROCE_CAP_FALG_ROCE_V1_V2 is set,
driver will inform ib core that the related hns device can support
RoCEv2, and ib core can generate the gid of the related type.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
Signed-off-by: Yixian Liu <liuyixian@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 3 ++-
 drivers/infiniband/hw/hns/hns_roce_main.c   | 5 +++--
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 7b3f444..ba3bb36 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -172,6 +172,7 @@ enum {
 
 enum {
 	HNS_ROCE_CAP_FLAG_REREG_MR		= BIT(0),
+	HNS_ROCE_CAP_FLAG_ROCE_V1_V2		= BIT(1),
 };
 
 enum hns_roce_mtt_type {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 7e24e1f..2e17dc1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -945,7 +945,8 @@ static int hns_roce_v2_profile(struct hns_roce_dev *hr_dev)
 	caps->cqe_hop_num	= HNS_ROCE_CQE_HOP_NUM;
 	caps->chunk_sz		= HNS_ROCE_V2_TABLE_CHUNK_SIZE;
 
-	caps->flags		= HNS_ROCE_CAP_FLAG_REREG_MR;
+	caps->flags		= HNS_ROCE_CAP_FLAG_REREG_MR |
+				  HNS_ROCE_CAP_FLAG_ROCE_V1_V2;
 	caps->pkey_table_len[0] = 1;
 	caps->gid_table_len[0] = 2;
 	caps->local_ca_ack_delay = 0;
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 63a2f3b..8bb75ea 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -406,8 +406,6 @@ static int hns_roce_port_immutable(struct ib_device *ib_dev, u8 port_num,
 	struct ib_port_attr attr;
 	int ret;
 
-	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
-
 	ret = ib_query_port(ib_dev, port_num, &attr);
 	if (ret)
 		return ret;
@@ -416,6 +414,9 @@ static int hns_roce_port_immutable(struct ib_device *ib_dev, u8 port_num,
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 
 	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
+	if (to_hr_dev(ib_dev)->caps.flags & HNS_ROCE_CAP_FLAG_ROCE_V1_V2)
+		immutable->core_cap_flags |= RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
 
 	return 0;
 }
-- 
1.9.1
