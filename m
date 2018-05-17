From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH rdma-next 0/5] Misc update for hns driver
Date: Thu, 17 May 2018 16:02:48 +0800
Message-ID: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org

This patchset included fixing bug, some optimization, reset
process and implementation of the disassociate_ucontext API
for hns driver.

Wei Hu (Xavier) (5):
  RDMA/hns: Implement the disassociate_ucontext API
  RDMA/hns: Modify uar allocation algorithm to avoid bitmap exhaust
  RDMA/hns: Increase checking CMQ status timeout value
  RDMA/hns: Add reset process for RoCE in hip08
  RDMA/hns: Fix the illegal memory operation when cross page

 drivers/infiniband/hw/hns/hns_roce_cmd.c    |   3 +
 drivers/infiniband/hw/hns/hns_roce_device.h |   3 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 130 +++++++++++++++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   3 +-
 drivers/infiniband/hw/hns/hns_roce_main.c   |  43 +++++++++
 drivers/infiniband/hw/hns/hns_roce_pd.c     |  10 ++-
 6 files changed, 167 insertions(+), 25 deletions(-)

-- 
1.9.1
