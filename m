From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/9] SIF related verbs patches
Date: Fri,  2 Sep 2016 02:09:20 +0200
Message-ID: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch set contains the changes and bug fixes necessary
to support Oracle's new Infiniband HCA (SIF) from the kernel side.

The exception is patch 2 which is a useful consolidation and simplification
made possible by patch 1 and the replacement of the dma_attr type with
a plain bitmask.

The changes to other rdma drivers are just trivial consequences of
the extended umem_get and create_ah calls and should hopefully be
uncontroversial.

Patches 4, 6 and 7 are related to corresponding libibverbs patches.

Patch 8 reserves a bit in ib_qp_create_flags for indicating to
the driver that the QP is going to be used for Ethernet over IB.

The patch set is based on commit 64278fe89b729dddb8dbe5ea52220685f6103d1b
in Doug's k.o/for-4.9 branch.

Dag Moxnes (1):
  ib_mad: incoming sminfo SMPs gets discarded if no process_mad function
    is registered

Knut Omang (8):
  ib_umem: Add a new, more generic ib_umem_get_attrs
  ib_umem: With the new ib_umem_get_attrs, simplify ib_umem_get
  ib: Add udata argument to create_ah
  ib_uverbs: Add padding to end align ib_uverbs_reg_mr_resp
  ib_uverbs: Avoid vendor specific masking of attributes in query_qp
  ib_{uverbs/core}: add new ib_create_qp_ex with udata arg
  ib_uverbs: Support for kernel implementation of XRC
  ib_verbs: Add a new qp create flag to request features for Ethernet
    over IB

 drivers/infiniband/core/core_priv.h          |  3 ++
 drivers/infiniband/core/mad.c                |  6 +++
 drivers/infiniband/core/smi.h                |  6 +--
 drivers/infiniband/core/umem.c               | 23 +++++----
 drivers/infiniband/core/uverbs_cmd.c         | 71 +++++++++++++++++-----------
 drivers/infiniband/core/verbs.c              | 15 ++++--
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  5 +-
 drivers/infiniband/hw/cxgb4/mem.c            |  2 +-
 drivers/infiniband/hw/cxgb4/provider.c       |  3 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |  2 +-
 drivers/infiniband/hw/mlx4/ah.c              |  3 +-
 drivers/infiniband/hw/mlx4/cq.c              |  4 +-
 drivers/infiniband/hw/mlx4/doorbell.c        |  2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |  3 +-
 drivers/infiniband/hw/mlx4/mr.c              |  5 +-
 drivers/infiniband/hw/mlx4/qp.c              | 21 +++++++-
 drivers/infiniband/hw/mlx4/srq.c             |  2 +-
 drivers/infiniband/hw/mlx5/ah.c              |  3 +-
 drivers/infiniband/hw/mlx5/cq.c              | 12 +++--
 drivers/infiniband/hw/mlx5/doorbell.c        |  2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  3 +-
 drivers/infiniband/hw/mlx5/mr.c              |  2 +-
 drivers/infiniband/hw/mlx5/qp.c              | 21 +++++++-
 drivers/infiniband/hw/mlx5/srq.c             |  2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c | 11 +++--
 drivers/infiniband/hw/nes/nes_verbs.c        |  5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |  5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h     |  3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  3 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h |  3 +-
 drivers/infiniband/sw/rdmavt/mr.c            |  2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c           |  2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c        |  3 +-
 include/rdma/ib_umem.h                       | 19 ++++++--
 include/rdma/ib_verbs.h                      | 16 ++++++-
 include/uapi/rdma/ib_user_verbs.h            |  3 ++
 37 files changed, 208 insertions(+), 90 deletions(-)

--
2.5.5
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
