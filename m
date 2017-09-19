From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 00/10] Rework the verb init scheme
Date: Tue, 19 Sep 2017 15:18:41 -0600
Message-ID: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This changes how verbs providers register with the core and are bound to
drivers.

The end goal is to have textual a list of 'modalias' that each provider
supports, similar to the kernel. This list can then ultimately be used to
demand load the modules instead of loading every module like we do today.

This series does the work to bring all providers to use common code to match
their supported devices, and provides the core code the supported device
list. This is done by extending the verbs_driver_ops to include the matching
information that the driver needs.

Quite a lot of duplicated driver code is removed in the process, and verbs
startup reads fewer sysfs files.

https://github.com/linux-rdma/rdma-core/pull/214

Jason Gunthorpe (10):
  verbs: Change verbs_register_driver to accept the ops struct directly
  cxgb4: Move sysconf up to driver_init
  verbs: Split init_device into a match and alloc/bind step
  providers: Use the new match_device and allocate_device ops
  verbs: Remove the init_device entry point
  verbs: Provide common code to match providers against kernel devices
  providers: Use the new common PCI matching infrastructure
  cxgb: Use the new common PCI matching infrastructure
  hns: Use the generic modalias matcher
  rxe: Use VERBS_NAME_MATCH to match the rxe device

 libibverbs/driver.h                |  77 +++++++++++++++++-
 libibverbs/init.c                  | 162 +++++++++++++++++++++++++++++--------
 providers/bnxt_re/main.c           |  69 ++++------------
 providers/cxgb3/iwch.c             | 102 ++++++++---------------
 providers/cxgb4/dev.c              | 110 ++++++++++---------------
 providers/hfi1verbs/hfiverbs.c     |  65 +++++----------
 providers/hns/hns_roce_u.c         |  80 +++++-------------
 providers/hns/hns_roce_u.h         |   1 +
 providers/hns/hns_roce_u_hw_v1.c   |   1 +
 providers/i40iw/i40iw_umain.c      |  69 +++++-----------
 providers/ipathverbs/ipathverbs.c  |  66 +++++----------
 providers/mlx4/mlx4.c              |  75 +++++------------
 providers/mlx5/mlx5.c              |  77 +++++-------------
 providers/mthca/mthca.c            |  75 +++++------------
 providers/nes/nes_umain.c          |  80 +++++-------------
 providers/ocrdma/ocrdma_main.c     |  84 +++++--------------
 providers/qedr/qelr_main.c         |  73 ++++-------------
 providers/rxe/rxe.c                |  50 +++++-------
 providers/vmw_pvrdma/pvrdma_main.c |  76 +++++------------
 19 files changed, 530 insertions(+), 862 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
