From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 0/9] Bug fixes & Code improvements in hip06 and hip08 RoCE driver
Date: Thu, 28 Sep 2017 12:57:25 +0800
Message-ID: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch-set introduces some bug fixes and code improvements
for hip06 and hip08 RoCE driver. It includes a patch for fixing
the assign algorithm of qp_attr->max_rd_atomic and
qp_attr->max_dest_rd_atomic, three patches for static check errors,
one for setting attr mask, one for returning RoCE device ah_attr
type when querying qp, one for the abi structure between libhns and
hns_roce drvier, one for unregistering inet addr, and the last one
for command queue delay processing in hip08 driver.

Lijun Ou (8):
  RDMA/hns: Modify the value with rd&dest_rd of qp_attr
  RDMA/hns: Factor out the code for checking sdb status into a new
    function
  RDMA/hns: Add return statement when kzalloc return NULL in
    hns_roce_v1_recreate_lp_qp
  RDMA/hns: Set mask for destination qp field of qp context assignment
  RDMA/hns: Set rdma_ah_attr type for querying qp
  RDMA/hns: Remove unnecessarily calling unregister_inetaddr_notifier
    function
  RDMA/hns: Remove unused struct members in hns-abi.h
  RDMA/hns: Replace usleep_range with udelay when checking command
    status

Wei Hu (Xavier) (1):
  RDMA/hns: Add return statement when checking error in
    hns_roce_v1_mr_free_work_fn

 drivers/infiniband/hw/hns/hns_roce_device.h |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 117 ++++++++++++++++------------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |   3 +-
 drivers/infiniband/hw/hns/hns_roce_main.c   |   1 -
 include/uapi/rdma/hns-abi.h                 |   2 -
 5 files changed, 69 insertions(+), 55 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
