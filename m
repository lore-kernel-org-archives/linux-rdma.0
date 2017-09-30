From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH for-next 4/4] RDMA/hns: Update the PD&CQE&MTT specification in hip08
Date: Sat, 30 Sep 2017 17:29:01 +0800
Message-ID: <1506763741-81429-5-git-send-email-xavier.huwei@huawei.com>
References: <1506763741-81429-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506763741-81429-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, xavier.huwei@tom.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com, shaoboxu@tom.com
List-Id: linux-rdma@vger.kernel.org

This patch updates the PD specification to 16M for hip08. And it
updates the numbers of mtt and cqe segments for the buddy.

As the CQE supports hop num 1 addressing, the CQE specification is
64k. This patch updates to set the CQE specification to 64k.

Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Lijun Ou <oulijun@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 65ed3f8..6106ad1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -47,16 +47,16 @@
 #define HNS_ROCE_V2_MAX_QP_NUM			0x2000
 #define HNS_ROCE_V2_MAX_WQE_NUM			0x8000
 #define HNS_ROCE_V2_MAX_CQ_NUM			0x8000
-#define HNS_ROCE_V2_MAX_CQE_NUM			0x400000
+#define HNS_ROCE_V2_MAX_CQE_NUM			0x10000
 #define HNS_ROCE_V2_MAX_RQ_SGE_NUM		0x100
 #define HNS_ROCE_V2_MAX_SQ_SGE_NUM		0xff
 #define HNS_ROCE_V2_MAX_SQ_INLINE		0x20
 #define HNS_ROCE_V2_UAR_NUM			256
 #define HNS_ROCE_V2_PHY_UAR_NUM			1
 #define HNS_ROCE_V2_MAX_MTPT_NUM		0x8000
-#define HNS_ROCE_V2_MAX_MTT_SEGS		0x100000
-#define HNS_ROCE_V2_MAX_CQE_SEGS		0x10000
-#define HNS_ROCE_V2_MAX_PD_NUM			0x400000
+#define HNS_ROCE_V2_MAX_MTT_SEGS		0x1000000
+#define HNS_ROCE_V2_MAX_CQE_SEGS		0x1000000
+#define HNS_ROCE_V2_MAX_PD_NUM			0x1000000
 #define HNS_ROCE_V2_MAX_QP_INIT_RDMA		128
 #define HNS_ROCE_V2_MAX_QP_DEST_RDMA		128
 #define HNS_ROCE_V2_MAX_SQ_DESC_SZ		64
-- 
1.9.1
