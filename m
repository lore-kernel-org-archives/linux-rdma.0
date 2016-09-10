From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 0/8] Bug Fixes and Code Improvement in HNS driver
Date: Sat, 10 Sep 2016 05:09:22 +0100
Message-ID: <20160910040930.25988-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch-set introduces fix to some Bugs, potential problems
and code improvements identified during internal review and
testing of Hisilicon Network Subsystem driver.

Hi Doug,
These are few HNS patches which are not related to HNS RoCE driver but
are being sent through your repository hns-roce (as requested) to mitigate
any conflicts with HNS RoCE driver for the 4.9 merge window. In future
i.e. after 4.9 we will go by more formal git-pull request method once
HNS RoCE base driver becomes part of 4.9.


Daode Huang (6):
  net: hns: bug fix about setting coalsecs-usecs to 0
  net: hns: add fini_process for v2 napi process
  net: hns: delete repeat read fbd num after while
  net: hns: fix the bug of forwarding table
  net: hns: bug fix about broadcast/multicast packets
  net: hns: delete redundant broadcast packet filter process

Kejian Yan (1):
  net: hns: fix port not available after testing loopback

lipeng (1):
  net: hns: fix port unavailable after hnae_reserve_buffer_map fail

 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c  |  11 ++-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |  13 ++-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h  |   2 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |  10 --
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h |   1 -
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c  |  16 ++++
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_reg.h  |   4 +
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      | 106 ++++++++++++++-------
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |   7 ++
 9 files changed, 117 insertions(+), 53 deletions(-)

-- 
1.9.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
