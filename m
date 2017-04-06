From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH v2 0/6] Automatic affinity settings for nvme over rdma
Date: Thu,  6 Apr 2017 13:36:32 +0300
Message-ID: <1491474998-16423-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

This patch set is aiming to automatically find the optimal
queue <-> irq multi-queue assignments in storage ULPs (demonstrated
on nvme-rdma) based on the underlying rdma device irq affinity
settings.

Changes from v1:
- Removed mlx5e_get_cpu as Christoph suggested
- Fixed up nvme-rdma queue comp_vector selection to get a better match
- Added a comment on why we limit on @dev->num_comp_vectors
- rebased to Jens's for-4.12/block
- Collected review tags

Sagi Grimberg (6):
  mlx5: convert to generic pci_alloc_irq_vectors
  mlx5: move affinity hints assignments to generic code
  RDMA/core: expose affinity mappings per completion vector
  mlx5: support ->get_vector_affinity
  block: Add rdma affinity based queue mapping helper
  nvme-rdma: use intelligent affinity based queue mappings

 block/Kconfig                                      |   5 +
 block/Makefile                                     |   1 +
 block/blk-mq-rdma.c                                |  54 +++++++++++
 drivers/infiniband/hw/mlx5/main.c                  |  10 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  14 +--
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 108 +++------------------
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   1 -
 drivers/nvme/host/rdma.c                           |  29 ++++--
 include/linux/blk-mq-rdma.h                        |  10 ++
 include/linux/mlx5/driver.h                        |   2 -
 include/rdma/ib_verbs.h                            |  24 +++++
 14 files changed, 149 insertions(+), 122 deletions(-)
 create mode 100644 block/blk-mq-rdma.c
 create mode 100644 include/linux/blk-mq-rdma.h

-- 
2.7.4
