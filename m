From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V2 for-next 0/8] Bug fixes & Code improvements in hip06 and hip08 RoCE driver
Date: Fri, 29 Sep 2017 23:10:06 +0800
Message-ID: <1506697814-98432-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com
List-Id: linux-rdma@vger.kernel.org

This patch-set introduces some bug fixes and code improvements
for hip06 and hip08 RoCE driver. It includes a patch for fixing
the assign algorithm of qp_attr->max_rd_atomic and
qp_attr->max_dest_rd_atomic, three patches for static check errors,
one for setting attr mask, one for returning RoCE device ah_attr
type when querying qp, one for unregistering inet addr, and the
last one for command queue delay processing in hip08 driver.

Lijun Ou (6):
  RDMA/hns: Modify the value with rd&dest_rd of qp_attr
  RDMA/hns: Factor out the code for checking sdb status into a new
    function
  RDMA/hns: Set mask for destination qp field of qp context assignment
  RDMA/hns: Set rdma_ah_attr type for querying qp
  RDMA/hns: Remove unnecessarily calling unregister_inetaddr_notifier
    function
  RDMA/hns: Replace usleep_range with udelay when checking command
    status

Wei Hu (Xavier) (2):
  RDMA/hns: Add return statement when kzalloc return NULL in
    hns_roce_v1_recreate_lp_qp
  RDMA/hns: Add return statement when checking error in
    hns_roce_v1_mr_free_work_fn

 drivers/infiniband/hw/hns/hns_roce_device.h |   3 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 131 +++++++++++++++++-----------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |   9 +-
 drivers/infiniband/hw/hns/hns_roce_main.c   |  18 ++--
 4 files changed, 96 insertions(+), 65 deletions(-)

-- 
1.9.1
