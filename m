From: Joel Nider <joeln@il.ibm.com>
Subject: [PATCH 0/5] RDMA: reg_remote_mr
Date: Tue, 29 Jan 2019 15:26:21 +0200
Message-ID: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, Joel Nider <joeln@il.ibm.com>, linux-mm@kvack.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

As discussed at LPC'18, there is a need to be able to register a memory
region (MR) on behalf of another process. One example is the case of
post-copy container migration, in which CRIU is responsible for setting
up the migration, but the contents of the memory are from the migrating
process. In this case, we want all RDMA READ requests to be served by
the address space of the migration process directly (not by CRIU). This
patchset implements a new uverbs command which allows an application to
register a memory region in the address space of another process.

Joel Nider (5):
  mm: add get_user_pages_remote_longterm function
  RDMA/uverbs: add owner parameter to reg_user_mr
  RDMA/uverbs: add owner parameter to ib_umem_get
  RDMA/uverbs: add owner parameter to ib_umem_odp_get
  RDMA/uverbs: add UVERBS_METHOD_REG_REMOTE_MR

 drivers/infiniband/core/umem.c                |  26 ++++--
 drivers/infiniband/core/umem_odp.c            |  50 +++++-----
 drivers/infiniband/core/uverbs_cmd.c          |   2 +-
 drivers/infiniband/core/uverbs_std_types_mr.c | 129 +++++++++++++++++++++++++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  11 ++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h      |   1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c   |   6 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h        |   1 +
 drivers/infiniband/hw/cxgb4/mem.c             |   6 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c       |   2 +-
 drivers/infiniband/hw/hns/hns_roce_db.c       |   2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c       |   4 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c       |   2 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c      |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c     |   3 +-
 drivers/infiniband/hw/mlx4/cq.c               |   2 +-
 drivers/infiniband/hw/mlx4/doorbell.c         |   2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |   1 +
 drivers/infiniband/hw/mlx4/mr.c               |   3 +-
 drivers/infiniband/hw/mlx4/qp.c               |   2 +-
 drivers/infiniband/hw/mlx4/srq.c              |   2 +-
 drivers/infiniband/hw/mlx5/cq.c               |   4 +-
 drivers/infiniband/hw/mlx5/devx.c             |   2 +-
 drivers/infiniband/hw/mlx5/doorbell.c         |   2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   4 +-
 drivers/infiniband/hw/mlx5/mr.c               |  17 ++--
 drivers/infiniband/hw/mlx5/odp.c              |  11 ++-
 drivers/infiniband/hw/mlx5/qp.c               |   4 +-
 drivers/infiniband/hw/mlx5/srq.c              |   2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c  |   5 +-
 drivers/infiniband/hw/nes/nes_verbs.c         |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   |   6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h   |   3 +-
 drivers/infiniband/hw/qedr/verbs.c            |   8 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c  |   1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h  |   1 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c  |   2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c  |   2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  |   5 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c |   2 +-
 drivers/infiniband/sw/rdmavt/mr.c             |   3 +-
 drivers/infiniband/sw/rdmavt/mr.h             |   1 +
 drivers/infiniband/sw/rxe/rxe_mr.c            |   3 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c         |   4 +-
 include/linux/mm.h                            |  28 +++++-
 include/rdma/ib_umem.h                        |   3 +-
 include/rdma/ib_umem_odp.h                    |   6 +-
 include/rdma/ib_verbs.h                       |   9 ++
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  13 +++
 mm/gup.c                                      |  15 ++-
 50 files changed, 327 insertions(+), 103 deletions(-)

-- 
2.7.4
