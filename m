From: Salil Mehta <salil.mehta@huawei.com>
Subject: [RFC PATCH 00/10] net: hns3: Adds support of debugfs to HNS3 driver
Date: Fri, 9 Nov 2018 22:07:33 +0000
Message-ID: <20181109220743.10264-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: salil.mehta@huawei.com, andrew@lunn.ch, yuvalm@mellanox.com, leon@kernel.org, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil@opnsrc.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

This patchset adds support of debugfs to the HNS3 driver. 

Support has been added to query info related to below items:
1. Queue related
2. Flow Director
3. Promisc mode
4. TC config
5. Transmit Module/Scheduler
6. Checksum
7. QoS buffer
8. QoS prio map

Note: This patch-set has been floated as an RFC as it is an
an effort to understand what type information can be fetched
from the kernel and how it can be exported to user-space in
the HNS3 driver. There are few questions revolving our minds
like,
1. Is it allowed to dump the information of register in the
   syslog using the printk or we should use debugfs
   to export information to user-space using file interface only?
2. Can we export the information from the firmware to the
   userspace using debugfs?
3. Debugfs looks more unstructured unlike sysfs. Is there any
   de-facto standard of the user-api or drivers are allowed to
   use it in any way to expose the information from kernel.
4. Last but not least, is there any good driver reference
   within kernel which can be used as a reference. We could
   see Intel IXGBE/i40e/mellanox drivers having debugfs
   interface but with some discussions it looked they have
   some of the *might be* objectionable implementations.
5. With the idea started from Greg KH original patch
   Link: https://lwn.net/Articles/115282/
   Is the heart-and-soul of debugfs i.e. the reason why it was
   created still the same?

It would be a great help if people can help in throwing light
and reviewing this patch-set.

Thanks!


liuzhongzhu (10):
  net: hns3: Add debugfs framework registration
  net: hns3: Add "queue info" query function
  net: hns3: Add "FD flow table" info query function
  net: hns3: Add "promisc mode" config info query function
  net: hns3: Add "tc config" info query function
  net: hns3: Add "tm config" info query function
  net: hns3: Add checksum info query function
  net: hns3: Add PFC config info query function
  net: hns3: Add "qos prio map" info query function
  net: hns3: Add "qos buffer" config info query function

 drivers/net/ethernet/hisilicon/hns3/Makefile       |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 264 +++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  17 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   4 +
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   4 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 589 +++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |  24 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   6 +
 12 files changed, 912 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h

-- 
2.7.4
