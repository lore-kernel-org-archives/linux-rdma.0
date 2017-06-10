From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-rdma 0/5] Expose Issues for HNS driver
Date: Sat, 10 Jun 2017 18:49:20 +0800
Message-ID: <1497091765-10513-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set mainly fixes some issues exposed for hns driver. The issue
list as follows:
  1. Unload hns driver when test on the board which its ports less than six
  2. May happen wild pointer error excepted exit when destroy rc qp
  3. Should use rdma_wr() for RDMA operation when post send
  4. Delete unnecessary lock operation in hns_roce_mac()
  5. Fix checkpatch.pl check warnings.

Change from v1:
- re-write the changelog
- assgin rdma_ah_type type for roce in hns_roce_rsv_lp_qp()
  according to 4.12

Lijun Ou (5):
  IB/hns: Fix the bug of polling cq failed for loopback Qps
  IB/hns: Fix the bug with wild pointer when destroy rc qp
  IB/hns: Fix the bug with rdma operation
  IB/hns: Fix the bug with modifying the MAC address without removing
    the driver
  IB/hns: Fix for checkpatch.pl comment style warnings

 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 83 ++++++++++++++++++------------
 drivers/infiniband/hw/hns/hns_roce_main.c  |  3 --
 2 files changed, 51 insertions(+), 35 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
