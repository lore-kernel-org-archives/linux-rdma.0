From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 10/19] IB/hns: Fix bug of memory leakage for registering user mr
Date: Tue, 20 Sep 2016 17:07:03 +0100
Message-ID: <20160920160712.1190216-11-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Dongdong Huang <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

While the page size attribute of umem is illegal, we should release
umem that get by ib_umem_get interface.

Also, we should return a non-zero value while pbl number is wrong.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 59f5e2b..fb87883 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -564,11 +564,14 @@ struct ib_mr *hns_roce_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (mr->umem->page_size != HNS_ROCE_HEM_PAGE_SIZE) {
 		dev_err(dev, "Just support 4K page size but is 0x%x now!\n",
 			mr->umem->page_size);
+		ret = -EINVAL;
+		goto err_umem;
 	}
 
 	if (n > HNS_ROCE_MAX_MTPT_PBL_NUM) {
 		dev_err(dev, " MR len %lld err. MR is limited to 4G at most!\n",
 			length);
+		ret = -EINVAL;
 		goto err_umem;
 	}
 
-- 
1.9.1
