From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 23/87] infiniband: hns: Remove memset after dma_alloc_coherent in hns_roce_hw_v1.c
Date: Fri, 28 Jun 2019 01:37:24 +0800
Message-ID: <20190627173724.3043-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index e068a02122f5..36d9dcaaa8f9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -4265,7 +4265,6 @@ static int hns_roce_v1_create_eq(struct hns_roce_dev *hr_dev,
 		}
 
 		eq->buf_list[i].map = tmp_dma_addr;
-		memset(eq->buf_list[i].buf, 0, HNS_ROCE_BA_SIZE);
 	}
 	eq->cons_index = 0;
 	roce_set_field(tmp, ROCEE_CAEP_AEQC_AEQE_SHIFT_CAEP_AEQC_STATE_M,
-- 
2.11.0
