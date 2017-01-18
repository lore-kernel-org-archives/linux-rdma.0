From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/6] Expand ODP MR to support implicit registration
Date: Wed, 18 Jan 2017 16:58:05 +0200
Message-ID: <20170118145811.9136-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patchset comes from Artemy Kovalyov who proposed to expand
current ODP feature to register memory with simplified and enhanced
semantics.

In existing ODP implementation applications still register memory
buffers for communication, though registered memory regions
need not have valid mappings at registration time.

This patchset adds implicit ODP sematics, where applications are provided
with a special memory key that represents their complete address space.

Thus all IO accesses referencing this key (subject to the access rights
associated with the key) won't need register any virtual address range.

Thanks,
	Artemy, Ilya and Leon

---
CC: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
CC: Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
This patchset was generated against commit
f502d834950a ("net/mlx5: Activate support for 4K UARs") and it applies
cleanly on k.o/for-4.11 branch.

This series has merge conflict with "IB/mlx5: Remove deprecated
module parameter" commit which was sent earlier.

The conflict fix can be found at the following merge commit:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-next&id=ff2fc3dcef94ff36cdcac32afaef1e2ee2120755

Available in the "topic/odp-ksm" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/odp-ksm

Artemy Kovalyov (6):
  IB/core: Add implicit MR flag
  IB/umem: Update on demand page (ODP) support
  IB/umem: Indicate that process is being terminated
  IB/mlx5: Add null_mkey access
  IB/mlx5: Expose MR cache for mlx5_ib
  IB/mlx5: Add implicit MR support

 drivers/infiniband/core/umem.c        |   3 -
 drivers/infiniband/core/umem_odp.c    |  92 ++++++-
 drivers/infiniband/core/umem_rbtree.c |  21 +-
 drivers/infiniband/hw/mlx5/Makefile   |   2 +-
 drivers/infiniband/hw/mlx5/cmd.c      |  48 ++++
 drivers/infiniband/hw/mlx5/cmd.h      |  40 +++
 drivers/infiniband/hw/mlx5/main.c     |   2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |  29 +-
 drivers/infiniband/hw/mlx5/mr.c       | 128 +++++++--
 drivers/infiniband/hw/mlx5/odp.c      | 505 +++++++++++++++++++++++++++++++---
 include/linux/mlx5/driver.h           |   5 +-
 include/rdma/ib_umem_odp.h            |  21 +-
 include/rdma/ib_verbs.h               |   3 +-
 13 files changed, 800 insertions(+), 99 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/cmd.c
 create mode 100644 drivers/infiniband/hw/mlx5/cmd.h

--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
