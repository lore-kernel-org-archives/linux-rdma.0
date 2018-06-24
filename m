From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 00/12] RDMA fixes 2018-06-24
Date: Sun, 24 Jun 2018 11:23:41 +0300
Message-ID: <20180624082353.16138-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is bunch of patches trigged by running syzkaller internally.

I'm sending them based on rdma-next mainly for two reasons:
1, Most of the patches fix the old issues and it doesn't matter when
they will hit the Linus's tree: now or later in a couple of weeks
during merge window.
2. They interleave with code cleanup, mlx5-next patches and Michael's
feedback on flow counters series.

Thanks

Leon Romanovsky (12):
  RDMA/uverbs: Protect from attempts to create flows on unsupported QP
  RDMA/uverbs: Check existence of create_flow callback
  RDMA/verbs: Drop kernel variant of create_flow
  RDMA/verbs: Drop kernel variant of destroy_flow
  net/mlx5: Rate limit errors in command interface
  RDMA/uverbs: Don't overwrite NULL pointer with ZERO_SIZE_PTR
  RDMA/umem: Don't check for negative return value of dma_map_sg_attrs()
  overflow.h: Add arithmetic shift helper
  RDMA/mlx5: Fix shift overflow in mlx5_ib_create_wq
  RDMA/mlx5: Reuse existed shift_overlow helper
  RDMA/uverbs: Remove redundant check
  RDMA/uverbs: Fix slab-out-of-bounds in ib_uverbs_ex_create_flow

 drivers/infiniband/core/umem.c                     |  2 +-
 drivers/infiniband/core/uverbs_cmd.c               | 49 ++++++++++++++--------
 drivers/infiniband/core/uverbs_std_types.c         |  9 ++--
 drivers/infiniband/core/verbs.c                    | 29 -------------
 drivers/infiniband/hw/mlx5/qp.c                    | 16 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 11 ++---
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  6 +++
 include/linux/overflow.h                           | 23 ++++++++++
 include/rdma/ib_verbs.h                            |  4 --
 9 files changed, 83 insertions(+), 66 deletions(-)
