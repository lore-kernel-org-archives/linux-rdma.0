From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 net-next 0/3] net: hns3: Refactors "reset" handling code in HCLGE layer of HNS3 driver
Date: Mon, 4 Dec 2017 01:29:52 +0000
Message-ID: <20171204012955.17560-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: salil.mehta@huawei.com, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil.lnk@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

This patch refactors the code of the reset feature in HCLGE layer
of HNS3 PF driver. Prime motivation to do this change is: 
1. To reduce the time for which common miscellaneous Vector 0
   interrupt is disabled because of the reset. Simplification
   of the common miscellaneous interrupt handler routine(for
   Vector 0) used to handle reset and other sources of Vector
   0 interrupt.
2. Separate the task for handling the reset
3. Simplification of reset request submission and pending reset
   logic.


To achieve above below few things have been done:
1. Interrupt is disabled while common miscellaneous interrupt
   handler is entered and re-enabled before it is exit. This
   reduces the interrupt handling latency as compared to older
   interrupt handling scheme where interrupt was being disabled
   in interrupt handler context and re-enabled in task context
   some time later. Made Miscellaneous interrupt handler more
   generic to handle all sources including reset interrupt source.
2. New reset service task has been introduced to service the 
   reset handling.
3. Introduces new reset service task for honoring software reset
   requests like from network stack related to timeout and serving
   the pending reset request(to reset the driver and associated
   clients).


Change Log:
Patch V2: Addressed comment by Andrew Lunn
   Link: https://lkml.org/lkml/2017/12/1/366
Patch V1: Initial Submit

Salil Mehta (3):
  net: hns3: Refactor of the reset interrupt handling logic
  net: hns3: Add reset service task for handling reset requests
  net: hns3: Refactors the requested reset & pending reset handling code

 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 222 ++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  12 +-
 2 files changed, 166 insertions(+), 68 deletions(-)

-- 
2.11.0
