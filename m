From: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Subject: [PATCH] infiniband/hw/hns/hns_roce_hw_v2.c: Use dma_zalloc_coherent
Date: Fri, 9 Nov 2018 20:08:37 +0530
Message-ID: <5be59bf8.1c69fb81.a231.dcd6@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: oulijun@huawei.com, xavier.huwei@huawei.com, dledford@redhat.com, jgg@ziepe.ca
Cc: jrdr.linux@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-rdma@vger.kernel.org

Replaced dma_alloc_coherent + memset with dma_zalloc_coherent

Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a4c62ae..c9966ec 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4972,13 +4972,12 @@ static int hns_roce_mhop_alloc_eq(struct hns_roce_dev *hr_dev,
 				eqe_alloc = i * (buf_chk_sz / eq->eqe_size);
 				size = (eq->entries - eqe_alloc) * eq->eqe_size;
 			}
-			eq->buf[i] = dma_alloc_coherent(dev, size,
+			eq->buf[i] = dma_zalloc_coherent(dev, size,
 							&(eq->buf_dma[i]),
 							GFP_KERNEL);
 			if (!eq->buf[i])
 				goto err_dma_alloc_buf;
 
-			memset(eq->buf[i], 0, size);
 			*(eq->bt_l0 + i) = eq->buf_dma[i];
 
 			eq_buf_cnt++;
-- 
2.7.4
