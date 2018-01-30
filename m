From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 0/4] Fixes for hns
Date: Tue, 30 Jan 2018 20:20:41 +0800
Message-ID: <1517314845-126094-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series is small set of fixes for hns.
The first patch and the second patch mainly fix
the flowup reviews from Jason Gunthorpe and the
third patch mainly remove the checkpatch.pl warning
in order to the new checkpatch requirements and
the last patch fix the bug for cleaning mtt table.

Lijun Ou (4):
  RDMA/hns: Fix the endian problem for hns
  RDMA/hns: Remove unnecessary operator
  RDMA/hns: Fix the checkpatch.pl warning
  RDMA/hns: Remove repeated option for free mtt table

 drivers/infiniband/hw/hns/hns_roce_common.h |   6 +-
 drivers/infiniband/hw/hns/hns_roce_device.h |  10 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  57 ++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h  | 258 ++++++++++++-------------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  55 ++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 283 ++++++++++++++--------------
 drivers/infiniband/hw/hns/hns_roce_main.c   |   3 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  18 +-
 8 files changed, 363 insertions(+), 327 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
