From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V2 0/3] RDMA/hns: Add Features & Code improvements for hip08
Date: Wed, 18 Oct 2017 17:32:43 +0800
Message-ID: <1508319166-116987-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com, shaoboxu@tom.com, shaobo.xu@intel.com
List-Id: linux-rdma@vger.kernel.org

This patch-set introduce PBL page size configuration support,
updating PD&CQE&MTT specification and IRRL table chunk size
for hip08.

Wei Hu (Xavier) (3):
  RDMA/hns: Support WQE/CQE/PBL page size configurable feature in hip08
  RDMA/hns: Update the IRRL table chunk size in hip08
  RDMA/hns: Update the PD&CQE&MTT specification in hip08

 drivers/infiniband/hw/hns/hns_roce_alloc.c  | 29 +++++----
 drivers/infiniband/hw/hns/hns_roce_cq.c     | 21 ++++++-
 drivers/infiniband/hw/hns/hns_roce_device.h | 12 ++--
 drivers/infiniband/hw/hns/hns_roce_hem.c    | 29 ++++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |  2 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 10 ++--
 drivers/infiniband/hw/hns/hns_roce_mr.c     | 93 ++++++++++++++++++++---------
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 46 ++++++++++----
 10 files changed, 167 insertions(+), 77 deletions(-)

-- 
1.9.1
