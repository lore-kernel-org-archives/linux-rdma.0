From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 00/11] Update the usages of some fields
Date: Fri, 10 Nov 2017 16:55:42 +0800
Message-ID: <1510304153-91394-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series mainly configure some fields of qp context and
cqe for hardware using as well as fix some bugs for hip08 RoCE.

Lijun Ou (11):
  {topost} RDMA/hns: Update calculation of irrl_ba field for hip08
  {topost} RDMA/hns: Configure TRRL field in hip08 RoCE device
  {topost} RDMA/hns: Configure fence attribute in hip08 RoCE
  {topost} RDMA/hns: Set se attribute of sqwqe in hip08
  {topost} RDMA/hns: Enable the cqe field of sqwqe of RC
  {topost} RDMA/hns: Set sq_cur_sge_blk_addr field in QPC in hip08
  {topost} RDMA/hns: Update the usage of ack timeout in hip08
  {topost} RDMA/hns: Add sq_invld_flg field in QP context
  {topost} RDMA/hns: Set the owner field of SQWQE in hip08 RoCE
  {topost} RDMA/hns: Unify the calculation for hem index in hip08
  {topost} RDMA/hns: Modify the usage of cmd_sn in hip08

 drivers/infiniband/hw/hns/hns_roce_cq.c     |  2 +
 drivers/infiniband/hw/hns/hns_roce_device.h |  3 ++
 drivers/infiniband/hw/hns/hns_roce_hem.c    | 13 +++--
 drivers/infiniband/hw/hns/hns_roce_hem.h    |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 75 ++++++++++++++++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  9 ++--
 drivers/infiniband/hw/hns/hns_roce_main.c   | 21 +++++++-
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 19 +++++++-
 8 files changed, 121 insertions(+), 22 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
