From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 0/6] Add CM support to hip08
Date: Thu, 4 Jan 2018 12:19:17 +0800
Message-ID: <1515039563-73084-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series adds the CM(Connection Mangement) support
to hip08 RoCE driver. Changes done are primarily to add
support of APIs in IB device and some fixes over the
origin driver to support RDMA CM. This patch series
also adjust some codes style in order to fill the
sq wqe of ud type.

Lijun Ou (6):
  RDMA/hns: Create gsi qp in hip08
  RDMA/hns: Add gsi qp support for modifying qp in hip08
  RDMA/hns: Fill sq wqe context of ud type in hip08
  RDMA/hns: Assign zero for pkey_index of wc in hip08
  RDMA/hns: Update the verbs of polling for completion
  RDMA/hns: Set the guid for hip08 RoCE device

 drivers/infiniband/hw/hns/hns_roce_device.h |   1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 547 ++++++++++++++++++++--------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  86 ++++-
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  18 +-
 4 files changed, 487 insertions(+), 165 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
