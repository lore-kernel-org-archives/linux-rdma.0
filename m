From: Knut Omang <knut.omang@oracle.com>
Subject: [PATCH v2 0/8] SIF related verbs patches
Date: Fri, 16 Sep 2016 20:31:11 +0200
Message-ID: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Knut Omang <knut.omang@oracle.com>
List-Id: linux-rdma@vger.kernel.org

This patch set contains the changes and bug fixes necessary
to support Oracle's new Infiniband HCA (SIF) from the kernel side.

The exception is patch 3 which is a useful consolidation and simplification
made possible by patch 2 and the replacement of the dma_attr type with
a plain bitmask.

The changes to other rdma drivers are just trivial consequences of
the extended umem_get and create_ah calls and should hopefully be
uncontroversial.

Patches 4-7 are related to corresponding libibverbs patches.
These make minor changes (fixing end alignment) to some uverbs
data structures, but these are carefully made to be backward
binary compatible between user and kernel for existing provider
libraries.

Changes since v1:
 - Improved explanation for patch 1
 - Fix a remaining provider case with ib_create_ah, detected by kbuild test robot
 - Relax length checks in ib_uverbs_reg_mr to avoid breaking binary compatibility
   with user space provider libraries built with old libibverbs.
 - Removed "ib_verbs: Add a new qp create flag to request features for Ethernet over IB"

Dag Moxnes (1):
  ib_mad: incoming sminfo SMPs gets discarded if no process_mad function is registered

Knut Omang (7):
  ib_umem: Add a new, more generic ib_umem_get_attrs
  ib_umem: With the new ib_umem_get_attrs, simplify ib_umem_get
  ib: Add udata argument to create_ah
  ib_uverbs: Add padding to end align ib_uverbs_reg_mr_resp
  ib_uverbs: Avoid vendor specific masking of attributes in query_qp
  ib_{uverbs/core}: add new ib_create_qp_ex with udata arg
  ib_uverbs: Support for kernel implementation of XRC

 drivers/infiniband/core/core_priv.h          |  3 +-
 drivers/infiniband/core/mad.c                |  6 ++-
 drivers/infiniband/core/smi.h                |  6 +--
 drivers/infiniband/core/umem.c               | 23 +++---
 drivers/infiniband/core/uverbs_cmd.c         | 81 ++++++++++++---------
 drivers/infiniband/core/verbs.c              | 15 +++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  5 +-
 drivers/infiniband/hw/cxgb4/mem.c            |  2 +-
 drivers/infiniband/hw/cxgb4/provider.c       |  3 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |  5 +-
 drivers/infiniband/hw/mlx4/ah.c              |  3 +-
 drivers/infiniband/hw/mlx4/cq.c              |  4 +-
 drivers/infiniband/hw/mlx4/doorbell.c        |  2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |  3 +-
 drivers/infiniband/hw/mlx4/mr.c              |  5 +-
 drivers/infiniband/hw/mlx4/qp.c              | 21 ++++-
 drivers/infiniband/hw/mlx4/srq.c             |  2 +-
 drivers/infiniband/hw/mlx5/ah.c              |  3 +-
 drivers/infiniband/hw/mlx5/cq.c              | 12 +--
 drivers/infiniband/hw/mlx5/doorbell.c        |  2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  3 +-
 drivers/infiniband/hw/mlx5/mr.c              |  2 +-
 drivers/infiniband/hw/mlx5/qp.c              | 21 ++++-
 drivers/infiniband/hw/mlx5/srq.c             |  2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c | 11 ++-
 drivers/infiniband/hw/nes/nes_verbs.c        |  5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |  5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h     |  3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  3 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h |  3 +-
 drivers/infiniband/sw/rdmavt/mr.c            |  2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c           |  2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c        |  3 +-
 include/rdma/ib_umem.h                       | 19 ++++-
 include/rdma/ib_verbs.h                      | 15 +++-
 include/uapi/rdma/ib_user_verbs.h            |  3 +-
 37 files changed, 215 insertions(+), 95 deletions(-)

-- 
git-series 0.8.10
