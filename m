From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH rdma-next 0/3] RDMA/hns: Updates for reset process of roce device in hip08
Date: Fri, 23 Nov 2018 23:14:22 +0800
Message-ID: <1542986065-44265-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org

Hi, Doug and Janson

This series mainly include updates for reset process of roce device
in hip08.
One patch adds support for reset and loading or unloading driver occur
simultaneously to ensure work normally, one stops sending mailbox&cmq&
doorbell when reset occured or reset is occuring, the last one modifies
the name of hns RoCE device's name in order to ensure that the name is
consistent before and after reset.

This series relies on the the new interfaces in hns NIC driver those
had been accepted by David, the related commit as below:
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 
commit cb7ea80c6dfda472a068d40f4f9755d034b2dfde

Best Regards
Xavier


Wei Hu (Xavier) (3):
  RDMA/hns: Add support for reset and loading or unloading driver occur
    simultaneously
  RDMA/hns: Stop sending mailbox&cmq&doorbell when reset occured or is
    occuring
  RDMA/hns: Modify hns RoCE device's name

 drivers/infiniband/hw/hns/hns_roce_cmd.c    |  32 ++-
 drivers/infiniband/hw/hns/hns_roce_device.h |  30 +++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 323 ++++++++++++++++++++++++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  21 ++
 drivers/infiniband/hw/hns/hns_roce_main.c   |   4 +-
 5 files changed, 382 insertions(+), 28 deletions(-)

-- 
1.9.1
