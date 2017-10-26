From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH 0/3] RDMA/hns: Add rereg mr & RoCEv2 support for hip08
Date: Thu, 26 Oct 2017 17:10:22 +0800
Message-ID: <1509009025-101743-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com, shaoboxu@tom.com, shaobo.xu@intel.com
List-Id: linux-rdma@vger.kernel.org

This patch-set introduce rereg mr support, RoCEv2 support for hip08.

Wei Hu (Xavier) (3):
  RDMA/hns: Add rereg mr support for hip08
  RDMA/hns: Generate gid type of RoCEv2
  RDMA/hns: Configure sgid type for hip08 RoCE

 drivers/infiniband/hw/hns/hns_roce_cmd.h    |   3 +
 drivers/infiniband/hw/hns/hns_roce_device.h |  17 +++-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |   7 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  79 +++++++++++++++++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   7 ++
 drivers/infiniband/hw/hns/hns_roce_main.c   |  20 +++--
 drivers/infiniband/hw/hns/hns_roce_mr.c     | 123 ++++++++++++++++++++++++++++
 7 files changed, 242 insertions(+), 14 deletions(-)

-- 
1.9.1
