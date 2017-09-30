From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 0/4] Add Features & Code improvements for hip08
Date: Sat, 30 Sep 2017 17:28:57 +0800
Message-ID: <1506763741-81429-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org, shaoboxu-WVlzvzqoTvw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch-set introduce PBL page size configuration support,IOMMU
support, updating PD&CQE&MTT specification and IRRL table chunk
size for hip08.

Shaobo Xu (1):
  RDMA/hns: Support WQE/CQE/PBL page size configurable feature in hip08

Wei Hu (Xavier) (3):
  RDMA/hns: Add IOMMU enable support in hip08
  RDMA/hns: Update the IRRL table chunk size in hip08
  RDMA/hns: Update the PD&CQE&MTT specification in hip08

 drivers/infiniband/hw/hns/hns_roce_alloc.c  | 34 +++++++----
 drivers/infiniband/hw/hns/hns_roce_cq.c     | 21 ++++++-
 drivers/infiniband/hw/hns/hns_roce_device.h | 13 ++--
 drivers/infiniband/hw/hns/hns_roce_hem.c    | 61 +++++++++++++------
 drivers/infiniband/hw/hns/hns_roce_hem.h    |  6 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |  2 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 23 ++++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 10 ++--
 drivers/infiniband/hw/hns/hns_roce_mr.c     | 93 ++++++++++++++++++++---------
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 46 ++++++++++----
 11 files changed, 222 insertions(+), 88 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
