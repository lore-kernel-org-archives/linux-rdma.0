From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 for-next 0/7] Add CM and a bugfix to hip08
Date: Wed, 10 Jan 2018 14:39:46 +0800
Message-ID: <1515566393-63888-1-git-send-email-oulijun@huawei.com>
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
sq wqe of ud type and fix a bug for tx_cqn field.

Change from V1:
- Add a new patch named assign the correct value for
  tx_cqn splited from the first patchset
- Fix the comments given by Leon Romanovsky
- Add the options for free sq lock when qp is illegal
  qp type
 
Lijun Ou (7):
  RDMA/hns: Assign the correct value for tx_cqn
  RDMA/hns: Create gsi qp in hip08
  RDMA/hns: Add gsi qp support for modifying qp in hip08
  RDMA/hns: Fill sq wqe context of ud type in hip08
  RDMA/hns: Assign zero for pkey_index of wc in hip08
  RDMA/hns: Update the verbs of polling for completion
  RDMA/hns: Set the guid for hip08 RoCE device

 drivers/infiniband/hw/hns/hns_roce_device.h |   1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 531 +++++++++++++++++++---------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  86 ++++-
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  18 +-
 4 files changed, 471 insertions(+), 165 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
