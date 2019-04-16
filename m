From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/6] BAR mappings fixes in RDMA
Date: Tue, 16 Apr 2019 14:07:24 +0300
Message-ID: <20190416110730.32230-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Feras Daoud <ferasda@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

>From Jason,

Upon review it turns out there are some long standing problems in BAR
mapping area:
 * BAR pages are being allowed to be executable.
 * BAR pages intended for read-only can be switched to writable via mprotect.
 * Missing use of rdma_user_mmap_io for the mlx5 clock BAR page.
 * Disassociate causes SIGBUS when touching the pages.
 * CPU pages are being mapped through to the process via remap_pfn_range
   instead of the more appropriate vm_insert_page, causing weird behaviors
   during disassociation.

This series adds the missing VM_* flag manipulation, adds faulting a zero
page for disassociation and revises the CPU page mappings to use vm_insert_page.

Thanks

Jason Gunthorpe (6):
  RDMA/mlx5: Do not allow the user to write to the clock page
  RDMA/mlx5: Use rdma_user_map_io for mapping BAR pages
  RDMA/ucontext: Do not allow BAR mappings to be executable
  RDMA/ucontext: Fix regression with disassociate
  RDMA/mlx5: Use get_zeroed_page() for clock_info
  RDMA: Remove rdma_user_mmap_page

 drivers/infiniband/core/uverbs.h              |   1 +
 drivers/infiniband/core/uverbs_main.c         | 115 ++++++++++--------
 drivers/infiniband/hw/mlx5/main.c             |  21 ++--
 .../ethernet/mellanox/mlx5/core/lib/clock.c   |  30 ++---
 include/linux/mlx5/driver.h                   |   1 -
 include/rdma/ib_verbs.h                       |   9 --
 6 files changed, 85 insertions(+), 92 deletions(-)
