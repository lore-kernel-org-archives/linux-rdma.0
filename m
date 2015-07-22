From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 00/43] New fast registration API
Date: Wed, 22 Jul 2015 09:55:00 +0300
Message-ID: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi all,

So I went ahead and tried to implement some of the stuff
we've been talking about. I figured I'd send out a WIP version
to try and communicate early where this is heading.

In order to have a sane patchset I followed a scheme that
add-new/port-existing/drop-old...

The set starts with:
- Convert ib_create_mr API to ib_alloc_mr as Christoph suggested (1)
- Add vendor drivers support for ib_alloc_mr (2-7)
- Port ULPs to use ib_alloc_mr (8-12)
- Drop alloc_fast_reg_mr API (core + vendor drivers) (13-20)

Continues with:
- Allocate vendor private page lists (21-27)
- Add a new fast registration API that will replace existing frwr (28)
- Add support for the new API in relevant vendor drivers (29-35)
  * its a bit hacky since just bluntly duplicated the registration routines
    keep in mind that this is transient until we drop the old API...
- Port ULPs to use the new API (iser, isert, xprtrdma for now) (36-38)
  this is on top of Chuck's nfs-rdma-for-4.3 and updated iser/isert code

The set should end with:
- Complete ULPs porting (svcrdma, rds, srp)
- Drop old fast registration API - FRWR (core + vendor drivers)
- Still have the huge-pages bit to work out.

I also added the arbitrary sg list registration support to mlx5 and iser
in a less intrusive API additions (39-43) just to show the concept.

This set was lightly tested on the ported ULPs over mlx5 (didn't have a
chance to test mlx4 yet).

The main reasons for this preview are:
- Help with testing (especially on devices that I don't have access to
  e.g cxgb3, cxgb4, ocrdma, nes, qib). I probably have bugs there
  as I just compile tested so far.
- Help with porting of the rest of the ULPs (rds, srp, svcrdma)
- Early code review

What I've noticed from this effort was that several drivers keep
a shadow mapped page lists for specific device settings. At registration
time, the drivers iterate on the page list and sets the mapped page list
entries with some extra information. I'd expect these drivers not to use
the core function to map SG list to pages and use it's own function which
will allow them to lose their page list duplication. I haven't done that yet.

Comments and review are welcomed (and needed!).

Sorry for the long series, but it's kinda transverse...

The code/patches can be found in:
https://github.com/sagigrimberg/linux/tree/fastreg_api_wip

Sagi Grimberg (43):
  IB: Modify ib_create_mr API
  IB/mlx4: Support ib_alloc_mr verb
  ocrdma: Support ib_alloc_mr verb
  iw_cxgb4: Support ib_alloc_mr verb
  cxgb3: Support ib_alloc_mr verb
  nes: Support ib_alloc_mr verb
  qib: Support ib_alloc_mr verb
  IB/iser: Convert to ib_alloc_mr
  iser-target: Convert to ib_alloc_mr
  IB/srp: Convert to ib_alloc_mr
  xprtrdma, svcrdma: Convert to ib_alloc_mr
  RDS: Convert to ib_alloc_mr
  mlx5: Drop mlx5_ib_alloc_fast_reg_mr
  mlx4: Drop mlx4_ib_alloc_fast_reg_mr
  ocrdma: Drop ocrdma_alloc_frmr
  qib: Drop qib_alloc_fast_reg_mr
  nes: Drop nes_alloc_fast_reg_mr
  cxgb4: Drop c4iw_alloc_fast_reg_mr
  cxgb3: Drop iwch_alloc_fast_reg_mr
  IB/core: Drop ib_alloc_fast_reg_mr
  mlx5: Allocate a private page list in ib_alloc_mr
  mlx4: Allocate a private page list in ib_alloc_mr
  ocrdma: Allocate a private page list in ib_alloc_mr
  cxgb3: Allocate a provate page list in ib_alloc_mr
  cxgb4: Allocate a private page list in ib_alloc_mr
  qib: Allocate a private page list in ib_alloc_mr
  nes: Allocate a private page list in ib_alloc_mr
  IB/core: Introduce new fast registration API
  mlx5: Support the new memory registration API
  mlx4: Support the new memory registration API
  ocrdma: Support the new memory registration API
  cxgb3: Support the new memory registration API
  cxgb4: Support the new memory registration API
  nes: Support the new memory registration API
  qib: Support the new memory registration API
  iser: Port to new fast registration api
  xprtrdma: Port to new memory registration API
  iser-target: Port to new memory registration API
  IB/core: Add arbitrary sg_list support
  mlx5: Allocate private context for arbitrary scatterlist registration
  mlx5: Add arbitrary sg list support
  iser: Accept arbitrary sg lists mapping if the device supports it
  iser: Move unaligned counter increment

 drivers/infiniband/core/verbs.c             | 164 ++++++++++++++++++----
 drivers/infiniband/hw/cxgb3/iwch_provider.c |  35 ++++-
 drivers/infiniband/hw/cxgb3/iwch_provider.h |   2 +
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |  48 +++++++
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |  12 +-
 drivers/infiniband/hw/cxgb4/mem.c           |  38 +++++-
 drivers/infiniband/hw/cxgb4/provider.c      |   3 +-
 drivers/infiniband/hw/cxgb4/qp.c            |  75 +++++++++-
 drivers/infiniband/hw/mlx4/main.c           |   3 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h        |  14 +-
 drivers/infiniband/hw/mlx4/mr.c             |  74 +++++++++-
 drivers/infiniband/hw/mlx4/qp.c             |  27 ++++
 drivers/infiniband/hw/mlx5/main.c           |   5 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h        |  20 ++-
 drivers/infiniband/hw/mlx5/mr.c             | 204 +++++++++++++++++++++-------
 drivers/infiniband/hw/mlx5/qp.c             | 107 +++++++++++++++
 drivers/infiniband/hw/nes/nes_verbs.c       | 129 +++++++++++++++++-
 drivers/infiniband/hw/nes/nes_verbs.h       |   5 +
 drivers/infiniband/hw/ocrdma/ocrdma.h       |   2 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  88 +++++++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |   8 +-
 drivers/infiniband/hw/qib/qib_keys.c        |  56 ++++++++
 drivers/infiniband/hw/qib/qib_mr.c          |  30 +++-
 drivers/infiniband/hw/qib/qib_verbs.c       |   8 +-
 drivers/infiniband/hw/qib/qib_verbs.h       |  12 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h    |   6 +-
 drivers/infiniband/ulp/iser/iser_memory.c   |  48 +++----
 drivers/infiniband/ulp/iser/iser_verbs.c    |  38 ++----
 drivers/infiniband/ulp/isert/ib_isert.c     | 128 ++++-------------
 drivers/infiniband/ulp/isert/ib_isert.h     |   2 -
 drivers/infiniband/ulp/srp/ib_srp.c         |   3 +-
 include/rdma/ib_verbs.h                     |  88 +++++++-----
 net/rds/iw_rdma.c                           |   5 +-
 net/rds/iw_send.c                           |   5 +-
 net/sunrpc/xprtrdma/frwr_ops.c              |  86 ++++++------
 net/sunrpc/xprtrdma/svc_rdma_transport.c    |   2 +-
 net/sunrpc/xprtrdma/xprt_rdma.h             |   4 +-
 38 files changed, 1223 insertions(+), 364 deletions(-)

-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
