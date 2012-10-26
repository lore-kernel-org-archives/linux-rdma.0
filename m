From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 26 Oct 2012 12:55:00 -0700
Message-ID: <1351281300-27825-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Small batch of fixes for 3.7:
 - Fix crash in error path in cxgb4
 - Fix build error on 32 bits in mlx4
 - Fix SR-IOV bugs in mlx4

----------------------------------------------------------------
Dotan Barak (1):
      mlx4_core: Perform correct resource cleanup if mlx4_QUERY_ADAPTER() fails

Doug Ledford (1):
      IB/mlx4: Fix build error on platforms where UL is not 64 bits

Eli Cohen (1):
      IB/mlx4: Synchronize cleanup of MCGs in MCG paravirtualization

Jack Morgenstein (1):
      IB/mlx4: Fix QP1 P_Key processing in the Primary Physical Function (PPF)

Or Gerlitz (1):
      mlx4_core: Remove annoying debug messages from SR-IOV flow

Roland Dreier (1):
      Merge branches 'cxgb4' and 'mlx4' into for-next

Thadeu Lima de Souza Cascardo (1):
      RDMA/cxgb4: Don't free chunk that we have failed to allocate

 drivers/infiniband/hw/cxgb4/mem.c                  |    2 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |    2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   85 +++++++++-----------
 drivers/infiniband/hw/mlx4/mcg.c                   |   18 +++--
 drivers/net/ethernet/mellanox/mlx4/eq.c            |    6 --
 drivers/net/ethernet/mellanox/mlx4/main.c          |    5 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    6 --
 7 files changed, 56 insertions(+), 68 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
