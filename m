From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH net-next 0/5] net: hns3: Add support of hardware GRO to HNS3 Driver
Date: Tue, 13 Nov 2018 10:13:02 +0000
Message-ID: <20181113101307.6020-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: salil.mehta@huawei.com, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil@opnsrc.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

This patch-set adds support of hardware assisted GRO feature to
HNS3 driver on Rev B(=0x21) platform. Current hardware only
supports TCP/IPv{4|6} flows.

Peng Li (5):
  net: hns3: Enable HW GRO for Rev B(=0x21) HNS3 hardware
  net: hns3: Add handling of GRO Pkts not fully RX'ed in NAPI poll
  net: hns3: Add support for ethtool -K to enable/disable HW GRO
  net: hns3: Add skb chain when num of RX buf exceeds MAX_SKB_FRAGS
  net: hns3: Adds GRO params to SKB for the stack

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   7 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 289 ++++++++++++++----
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  17 +-
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |   7 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  45 +++
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       |   8 +
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  45 +++
 7 files changed, 351 insertions(+), 67 deletions(-)

-- 
2.17.1
