From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V3 rdma-next 0/3] RDMA/hns: Some fixes for hns RoCE driver
Date: Sat, 26 Jan 2019 11:59:20 +0800
Message-ID: <1548475163-44098-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, liudongdong3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org

Hi, Jason and Doug

This patch series includes three bugfixes for reset related operations
and are maked based on wip/jgg-for-next branch.

Best Regards
Xavier

Wei Hu (Xavier) (3):
  RDMA/hns: Fix the Oops during rmmod or insmod ko when reset occurs
  RDMA/hns: Fix the chip hanging caused by sending mailbox&CMQ during
    reset
  RDMA/hns: Fix the chip hanging caused by sending doorbell during reset

 drivers/infiniband/hw/hns/hns_roce_cmd.c    |  32 +++-
 drivers/infiniband/hw/hns/hns_roce_device.h |  29 +++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 270 +++++++++++++++++++++++++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  14 ++
 4 files changed, 316 insertions(+), 29 deletions(-)

-- 
1.9.1
