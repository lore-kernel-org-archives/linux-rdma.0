From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 00/20] IB/hns: Fixes for various misc. bugs
Date: Fri, 9 Sep 2016 18:30:31 +0800
Message-ID: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, xuwei5@hisilicon.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

This patch-set introduces fixes for various bugs and potential
problems found during internal review and testing phases of
the HNS RoCE driver.

NOTE: These fixes have been done over already floated CM
patch: https://lkml.org/lkml/2016/9/1/609

Fixes have been done & tested  by Oulijun and Huwei.

Lijun Ou (17):
  IB/hns: Remove unused parameters in some functions
  IB/hns: Remove parameters of resize cq
  IB/hns: Add the check for pointer ctrl
  IB/hns: Fix bug of using uninit refcount and free
  IB/hns: Simplify function of pd alloc and qp alloc
  IB/hns: Remove unused parameter named qp_type
  IB/hns: Modify the init of iboe lock
  IB/hns: Fix bug of memory leakage for registering user mr
  IB/hns: Return bad wr while post send failed
  IB/hns: Add check for some NULL pointer scenes
  IB/hns: The Ack timeout need a lower limit value
  IB/hns: Some items of qpc need to take user param
  IB/hns: Validate mtu when modified qp
  IB/hns: Cq has not been freed
  IB/hns: Update the rq head when modify qp state
  IB/hns: Fix the bug when platform_get_resource() exec fail
  IB/hns: Delete the redundant lines in hns_roce_v1_m_qp()

Wei Hu (Xavier) (3):
  IB/hns: Fix bug of clear hem
  IB/hns: Delete the sqp_start from the structure hns_roce_caps
  IB/hns: Optimize code of aeq and ceq interrupt handle and fix the bug
    of qpn

 drivers/infiniband/hw/hns/hns_roce_cq.c     |   23 ++-
 drivers/infiniband/hw/hns/hns_roce_device.h |   13 +-
 drivers/infiniband/hw/hns/hns_roce_eq.c     |  146 +++++++++---------
 drivers/infiniband/hw/hns/hns_roce_eq.h     |    4 +
 drivers/infiniband/hw/hns/hns_roce_hem.c    |   76 +---------
 drivers/infiniband/hw/hns/hns_roce_hem.h    |    4 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  217 +++++++++++++++++++++++----
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |    9 ++
 drivers/infiniband/hw/hns/hns_roce_main.c   |    4 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c     |    3 +
 drivers/infiniband/hw/hns/hns_roce_pd.c     |   18 +--
 drivers/infiniband/hw/hns/hns_roce_qp.c     |   39 ++---
 12 files changed, 324 insertions(+), 232 deletions(-)

-- 
1.7.9.5
