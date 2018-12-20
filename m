From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/5] Cleanup of CONFIG_INFINIBAND_ON_DEMAND_PAGING usage
Date: Thu, 20 Dec 2018 11:23:13 +0200
Message-ID: <20181220092318.32672-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

As a followup to Jason's request to rethink CONFIG_INFINIBAND_ON_DEMAND_PAGING
usage, this series cleans mlx5_ib and RDMA/core code and it is based on already
sent but not yet accepted patch https://patchwork.kernel.org/patch/10735547/

It is under extensive testing now, but I wanted to raise awareness as soon
as possible for the patch "RDMA/core: Don't depend device ODP capabilities
on kconfig option", which changes behavior for mlx5 devices with
CONFIG_INFINIBAND_ON_DEMAND_PAGING set to no.

Thanks

Leon Romanovsky (5):
  RDMA: Clean structures from CONFIG_INFINIBAND_ON_DEMAND_PAGING
  RDMA/core: Don't depend device ODP capabilities on kconfig option
  RDMA/mlx5: Introduce and reuse helper to identify ODP MR
  RDMA/mlx5: Embed into the code flow the ODP config option
  RDMA/mlx5: Delete declaration of already removed function

 drivers/infiniband/core/uverbs_cmd.c |  8 ++---
 drivers/infiniband/hw/mlx5/main.c    | 37 ++++++++++-------------
 drivers/infiniband/hw/mlx5/mem.c     |  5 +---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 12 ++++++--
 drivers/infiniband/hw/mlx5/mr.c      | 45 ++++++++--------------------
 drivers/infiniband/hw/mlx5/odp.c     |  6 ++--
 include/linux/mlx5/driver.h          |  4 ---
 include/rdma/ib_umem_odp.h           | 26 ++++++++--------
 include/rdma/ib_verbs.h              |  2 --
 9 files changed, 58 insertions(+), 87 deletions(-)
