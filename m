From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 93/99] RDMA/hns: Bugfix for mapping user db
Date: Tue,  7 May 2019 01:32:27 -0400
Message-ID: <20190507053235.29900-93-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lijun Ou <oulijun@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 2557fabd6e29f349bfa0ac13f38ac98aa5eafc74 ]

When the maximum send wr delivered by the user is zero, the qp does not
have a sq.

When allocating the sq db buffer to store the user sq pi pointer and map
it to the kernel mode, max_send_wr is used as the trigger condition, while
the kernel does not consider the max_send_wr trigger condition when
mapmping db. It will cause sq record doorbell map fail and create qp fail.

The failed print information as follows:

 hns3 0000:7d:00.1: Send cmd: tail - 418, opcode - 0x8504, flag - 0x0011, retval - 0x0000
 hns3 0000:7d:00.1: Send cmd: 0xe59dc000 0x00000000 0x00000000 0x00000000 0x00000116 0x0000ffff
 hns3 0000:7d:00.1: sq record doorbell map failed!
 hns3 0000:7d:00.1: Create RC QP failed

Fixes: 0425e3e6e0c7 ("RDMA/hns: Support flush cqe for hip08 in kernel space")
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 54031c5b53fa..89dd2380fc81 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -517,7 +517,7 @@ static int hns_roce_set_kernel_sq_size(struct hns_roce_dev *hr_dev,
 
 static int hns_roce_qp_has_sq(struct ib_qp_init_attr *attr)
 {
-	if (attr->qp_type == IB_QPT_XRC_TGT)
+	if (attr->qp_type == IB_QPT_XRC_TGT || !attr->cap.max_send_wr)
 		return 0;
 
 	return 1;
-- 
2.20.1
