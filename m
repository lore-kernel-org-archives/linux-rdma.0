From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 50/79] RDMA/hns: Fix bug that caused srq creation to fail
Date: Fri, 26 Apr 2019 21:38:09 -0400
Message-ID: <20190427013838.6596-50-sashal@kernel.org>
References: <20190427013838.6596-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190427013838.6596-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lijun Ou <oulijun@huawei.com>, chenglang <chenglang@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 4772e03d239484f3461e33c79d721c8ea03f7416 ]

Due to the incorrect use of the seg and obj information, the position of
the mtt is calculated incorrectly, and the free space of the page is not
enough to store the entire mtt, resulting in access to the next page. This
patch fixes this problem.

 Unable to handle kernel paging request at virtual address ffff00006e3cd000
 ...
 Call trace:
  hns_roce_write_mtt+0x154/0x2f0 [hns_roce]
  hns_roce_buf_write_mtt+0xa8/0xd8 [hns_roce]
  hns_roce_create_srq+0x74c/0x808 [hns_roce]
  ib_create_srq+0x28/0xc8

Fixes: 0203b14c4f32 ("RDMA/hns: Unify the calculation for hem index in hip08")
Signed-off-by: chenglang <chenglang@huawei.com>
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 6 ++++--
 drivers/infiniband/hw/hns/hns_roce_mr.c  | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 4cdbcafa5915..cae23364cfea 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -763,6 +763,8 @@ void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
 		idx_offset = (obj & (table->num_obj - 1)) % obj_per_chunk;
 		dma_offset = offset = idx_offset * table->obj_size;
 	} else {
+		u32 seg_size = 64; /* 8 bytes per BA and 8 BA per segment */
+
 		hns_roce_calc_hem_mhop(hr_dev, table, &mhop_obj, &mhop);
 		/* mtt mhop */
 		i = mhop.l0_idx;
@@ -774,8 +776,8 @@ void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
 			hem_idx = i;
 
 		hem = table->hem[hem_idx];
-		dma_offset = offset = (obj & (table->num_obj - 1)) *
-				       table->obj_size % mhop.bt_chunk_size;
+		dma_offset = offset = (obj & (table->num_obj - 1)) * seg_size %
+				       mhop.bt_chunk_size;
 		if (mhop.hop_num == 2)
 			dma_offset = offset = 0;
 	}
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index ee5991bd4171..dd4bb0ec6113 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -746,7 +746,6 @@ static int hns_roce_write_mtt_chunk(struct hns_roce_dev *hr_dev,
 	struct hns_roce_hem_table *table;
 	dma_addr_t dma_handle;
 	__le64 *mtts;
-	u32 s = start_index * sizeof(u64);
 	u32 bt_page_size;
 	u32 i;
 
@@ -780,7 +779,8 @@ static int hns_roce_write_mtt_chunk(struct hns_roce_dev *hr_dev,
 		return -EINVAL;
 
 	mtts = hns_roce_table_find(hr_dev, table,
-				mtt->first_seg + s / hr_dev->caps.mtt_entry_sz,
+				mtt->first_seg +
+				start_index / HNS_ROCE_MTT_ENTRY_PER_SEG,
 				&dma_handle);
 	if (!mtts)
 		return -ENOMEM;
-- 
2.19.1
