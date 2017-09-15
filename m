From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH for-next] RDMA/hns: Delete the unnecessary initializing enum to zero
Date: Fri, 15 Sep 2017 10:49:09 +0800
Message-ID: <1505443749-68733-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, xavier_huwei@163.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, leon@kernel.org
List-Id: linux-rdma@vger.kernel.org

It deletes the unnecessary initializing enum to zero.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
Signed-off-by: Lijun Ou <oulijun@huawei.com>
---
This patch is based on the patchset as below:
[PATCH for-next 00/20] RDMA/hns: Add hip08 RoCE driver support,
the related link:
https://www.spinics.net/lists/linux-rdma/msg54098.html

This patch addresses the comment at Leon's suggestion.
https://www.spinics.net/lists/linux-rdma/msg54392.html
https://www.spinics.net/lists/linux-rdma/msg54400.html
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index b45dba5..4f43c91 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -171,7 +171,7 @@ enum {
 };
 
 enum hns_roce_mtt_type {
-	MTT_TYPE_WQE = 0,
+	MTT_TYPE_WQE,
 	MTT_TYPE_CQE,
 };
 
-- 
1.9.1
