From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 for-next 00/19] IB/hns: Fixes for various misc. bugs
Date: Tue, 20 Sep 2016 17:06:53 +0100
Message-ID: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch-set introduces fixes for various bugs and potential
problems found during internal review and testing phases of
the HNS RoCE driver.

NOTE: These fixes have been done over already floated CM
patch: https://lkml.org/lkml/2016/9/1/609

All fixes have been done & tested by Oulijun and Huwei.

V1->V2: * PATCH 3/20 and 13/20 have been dropped after rework
          of comments by Leon Romanovsky on V1 patch.
        * New patch "Fix for removal of redundant code" has
          been added to remove the redundant code.

Lijun Ou (15):
  IB/hns: Remove unused parameters in some functions
  IB/hns: Remove parameters of resize cq
  IB/hns: Fix bug of using uninit refcount and free
  IB/hns: Simplify function of pd alloc and qp alloc
  IB/hns: Remove unused parameter named qp_type
  IB/hns: Modify the init of iboe lock
  IB/hns: Fix bug of memory leakage for registering user mr
  IB/hns: Return bad wr while post send failed
  IB/hns: The Ack timeout need a lower limit value
  IB/hns: Some items of qpc need to take user param
  IB/hns: Validate mtu when modified qp
  IB/hns: Cq has not been freed
  IB/hns: Update the rq head when modify qp state
  IB/hns: Fix the bug when platform_get_resource() exec fail
  IB/hns: Delete the redundant lines in hns_roce_v1_m_qp()

Salil Mehta (1):
  IB/hns: Fix for removal of redundant code

Wei Hu (Xavier) (3):
  IB/hns: Fix bug of clear hem
  IB/hns: Delete the sqp_start from the structure hns_roce_caps
  IB/hns: Optimize code of aeq and ceq interrupt handle and fix the bug
    of qpn

 drivers/infiniband/hw/hns/hns_roce_cq.c     |  23 +--
 drivers/infiniband/hw/hns/hns_roce_device.h |  13 +-
 drivers/infiniband/hw/hns/hns_roce_eq.c     | 146 ++++++++++---------
 drivers/infiniband/hw/hns/hns_roce_eq.h     |   4 +
 drivers/infiniband/hw/hns/hns_roce_hem.c    |  76 +---------
 drivers/infiniband/hw/hns/hns_roce_hem.h    |   4 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 211 +++++++++++++++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |   9 ++
 drivers/infiniband/hw/hns/hns_roce_main.c   |   4 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c     |   3 +
 drivers/infiniband/hw/hns/hns_roce_pd.c     |  18 +--
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  57 +++-----
 12 files changed, 312 insertions(+), 256 deletions(-)

-- 
1.9.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
