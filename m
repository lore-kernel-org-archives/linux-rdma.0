From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V2 rdma-next 0/4] Misc update for hns driver
Date: Wed, 23 May 2018 18:16:26 +0800
Message-ID: <1527070590-94399-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patchset included fixing bug, some optimization, reset
process for hns driver.

v1->v2: 1.pull the patch out of the series. The name of the patch is 
	  RDMA/hns: Implement the disassociate_ucontext API.
	2.Modify the fixes statement according to Leon's comment.
	3.Address the Jason's comment in reset relevant patch.

Wei Hu (Xavier) (4):
  RDMA/hns: Modify uar allocation algorithm to avoid bitmap exhaust
  RDMA/hns: Increase checking CMQ status timeout value
  RDMA/hns: Add reset process for RoCE in hip08
  RDMA/hns: Fix the illegal memory operation when cross page

 drivers/infiniband/hw/hns/hns_roce_cmd.c    |   3 +
 drivers/infiniband/hw/hns/hns_roce_device.h |   3 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 146 ++++++++++++++++++++++++----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   3 +-
 drivers/infiniband/hw/hns/hns_roce_main.c   |   7 ++
 drivers/infiniband/hw/hns/hns_roce_pd.c     |  10 +-
 6 files changed, 147 insertions(+), 25 deletions(-)

-- 
1.9.1
