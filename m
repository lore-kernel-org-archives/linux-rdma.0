From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 00/10] Add CM(Connection Manager) Support to HNS RoCe Driver
Date: Fri, 2 Sep 2016 05:37:15 +0800
Message-ID: <1472765845-118972-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

This patch-set adds the CM(Connection Manager) support to the
HNS RoCE driver. Changes done are primarily to add support of
APIs in IB device and some fixes over the base driver to
support RDMA Connection Manager. This patch-set also updates
the Device binding document as new parameter node-guid was
added to the DT.

All of the patches have been authored by Oulijun and reviewed
by Huwei.

Lijun Ou (10):
  IB/hns: Register HNS RoCE Driver get_netdev() with IB Core
  IB/hns: Register add_gid and del_gid for GID Table management
  IB/hns: Add & initialize "node_guid" parameter for RDMA CM
  IB/hns: Fix the value of device_cap_flags
  IB/hns: Fix two possible bugs for rdma cm
  IB/hns: Add phy_port for computing GSI/QPN
  IB/hns: Change the logic for allocating uar registers
  IB/hns: Fix the bug of rdma cm connecting on user mode
  IB/hns: Fix two bugs for rdma cm connecting
  IB/hns: Add node_guid definition to the bindings document

 .../bindings/infiniband/hisilicon-hns-roce.txt     |    2 +
 drivers/infiniband/hw/hns/hns_roce_device.h        |    4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |   80 ++++++++------------
 drivers/infiniband/hw/hns/hns_roce_main.c          |   45 ++++++++++-
 drivers/infiniband/hw/hns/hns_roce_pd.c            |    4 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   13 ++--
 6 files changed, 89 insertions(+), 59 deletions(-)

-- 
1.7.9.5
