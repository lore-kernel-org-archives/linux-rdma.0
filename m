From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V2 rdma-rc 1/3] RDMA/hns: Fix the issue of IOVA not page continuous in hip08
Date: Tue, 28 Nov 2017 15:10:26 +0800
Message-ID: <1511853028-35191-2-git-send-email-xavier.huwei@huawei.com>
References: <1511853028-35191-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511853028-35191-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobo.xu@intel.com, xavier.huwei@tom.com, zhangxiping3@huawei.com
List-Id: linux-rdma@vger.kernel.org

If the smmu is enabled, the length of sg obtained from
__iommu_map_sg_attrs is not 4kB. When the IOVA is set with the sg
dma address, the IOVA will not be page continuous. so, the current
code has MTPT configuration error that probably cause dma operation
failure. In order to fix this issue, the IOVA should be calculated
based on the sg length.

Fixes: 3958cc5("RDMA/hns: Configure the MTPT in hip08")
Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Signed-off-by: Xiping Zhang (Francis) <zhangxiping3@huawei.com>
---
changelog:
 v1 -> v2: Revise the commit message and add Fixes line at Jason's
    comment. The related link: https://lkml.org/lkml/2017/11/27/841
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 04281d0..4d3e976 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1131,9 +1131,11 @@ static int hns_roce_v2_write_mtpt(void *mb_buf, struct hns_roce_mr *mr,
 {
 	struct hns_roce_v2_mpt_entry *mpt_entry;
 	struct scatterlist *sg;
+	u64 page_addr;
 	u64 *pages;
+	int i, j;
+	int len;
 	int entry;
-	int i;
 
 	mpt_entry = mb_buf;
 	memset(mpt_entry, 0, sizeof(*mpt_entry));
@@ -1191,14 +1193,20 @@ static int hns_roce_v2_write_mtpt(void *mb_buf, struct hns_roce_mr *mr,
 
 	i = 0;
 	for_each_sg(mr->umem->sg_head.sgl, sg, mr->umem->nmap, entry) {
-		pages[i] = ((u64)sg_dma_address(sg)) >> 6;
-
-		/* Record the first 2 entry directly to MTPT table */
-		if (i >= HNS_ROCE_V2_MAX_INNER_MTPT_NUM - 1)
-			break;
-		i++;
+		len = sg_dma_len(sg) >> PAGE_SHIFT;
+		for (j = 0; j < len; ++j) {
+			page_addr = sg_dma_address(sg) +
+				    (j << mr->umem->page_shift);
+			pages[i] = page_addr >> 6;
+
+			/* Record the first 2 entry directly to MTPT table */
+			if (i >= HNS_ROCE_V2_MAX_INNER_MTPT_NUM - 1)
+				goto found;
+			i++;
+		}
 	}
 
+found:
 	mpt_entry->pa0_l = cpu_to_le32(lower_32_bits(pages[0]));
 	roce_set_field(mpt_entry->byte_56_pa0_h, V2_MPT_BYTE_56_PA0_H_M,
 		       V2_MPT_BYTE_56_PA0_H_S,
-- 
1.9.1
