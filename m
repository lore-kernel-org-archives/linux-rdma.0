From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 0/5] Some fixes for HNS RoCE driver
Date: Tue, 6 Jun 2017 09:24:43 +0800
Message-ID: <1496712288-63434-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset introduces some fixes for the identified problems
according to the changed IB/core and others reviews.

Lijun Ou (5):
  IB/hns: Fix the bug of polling cq failed for loopback Qps
  IB/hns: Fix the bug with wild pointer when destroy rc qp
  IB/hns: Fix the bug with rdma operation
  IB/hns: Fix the bug with modifying the MAC address without removing
    the driver
  IB/hns: Fix for checkpatch.pl comment style warnings

 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 82 ++++++++++++++++++------------
 drivers/infiniband/hw/hns/hns_roce_main.c  |  3 --
 2 files changed, 50 insertions(+), 35 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
