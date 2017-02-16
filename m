From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 00/14] Revise the DMA barrier macros in ibverbs
Date: Thu, 16 Feb 2017 12:22:55 -0700
Message-ID: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Now that the header is private to the library we can change it.

We have never had a clear definition for what our wmb() or wc_wmb() even do,
and they don't match the same macros in the kernel. This causes problems for
non x86 arches as they have no idea what to put in their versions of the macros
and often just put the strongest thing.

This also causes problems for the driver authors who have no idea how to use
these barriers properly, there are several instances of that :(

My approach here is to introduce a selection of macros that have narrow and
clearly defined purposes. The selection is based on things the set of drivers
actually do, which turns out to be fairly narrowly defined.

Then I went through all the drivers and adjusted them to various degrees to
use the new macro names. In a few drivers I added more/stronger barriers.
Overall this tries hard not to break anything by weaking existing barriers.

A future project for someone would be to see if the CPU ASM makes sense..

https://github.com/linux-rdma/rdma-core/pull/79

Jason Gunthorpe (14):
  mlx5: Use stdatomic for the in_use barrier
  Provide new names for the CPU barriers related to DMA
  cxgb3: Update to use new udma write barriers
  cxgb4: Update to use new udma write barriers
  hns: Update to use new udma write barriers
  i40iw: Get rid of unique barrier macros
  mlx4: Update to use new udma write barriers
  mlx5: Update to use new udma write barriers
  nes: Update to use new udma write barriers
  mthca: Update to use new mmio write barriers
  ocrdma: Update to use new udma write barriers
  qedr: Update to use new udma write barriers
  vmw_pvrdma: Update to use new udma write barriers
  Remove the old barrier macros

 providers/cxgb3/cq.c             |   2 +
 providers/cxgb3/cxio_wr.h        |   2 +-
 providers/cxgb4/qp.c             |  20 +++-
 providers/cxgb4/t4.h             |  48 ++++++--
 providers/cxgb4/verbs.c          |   2 +
 providers/hns/hns_roce_u_hw_v1.c |  13 +-
 providers/i40iw/i40iw_osdep.h    |  14 ---
 providers/i40iw/i40iw_uk.c       |  26 ++--
 providers/mlx4/cq.c              |   6 +-
 providers/mlx4/qp.c              |  19 +--
 providers/mlx4/srq.c             |   2 +-
 providers/mlx5/cq.c              |   8 +-
 providers/mlx5/mlx5.h            |   7 +-
 providers/mlx5/qp.c              |  18 +--
 providers/mlx5/srq.c             |   2 +-
 providers/mthca/cq.c             |  10 +-
 providers/mthca/doorbell.h       |   2 +-
 providers/mthca/qp.c             |  20 ++--
 providers/mthca/srq.c            |   6 +-
 providers/nes/nes_uverbs.c       |  16 +--
 providers/ocrdma/ocrdma_verbs.c  |  16 ++-
 providers/qedr/qelr_verbs.c      |  32 +++--
 providers/vmw_pvrdma/cq.c        |   6 +-
 providers/vmw_pvrdma/qp.c        |   8 +-
 util/udma_barrier.h              | 250 +++++++++++++++++++++++++++------------
 25 files changed, 354 insertions(+), 201 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
