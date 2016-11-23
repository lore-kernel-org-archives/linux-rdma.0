From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/5] Optimize RoCE address handle creation for userspace
Date: Wed, 23 Nov 2016 08:23:21 +0200
Message-ID: <1479882206-31212-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below the patchset from Moni.

--------------------------------------------------------------------------
Creating a UD address handler (user or kernel) when link layer is Ethernet
requires resolving the remote L3 address (GID) to a L2 address (MAC/VLAN).

Doing it in kernel is easy with an interface in that the module ib_addr
provides. In userspace such an interface does not exist and kernel help
is required.

Until now the way to resolve GID (which is the remote IP or a function
of it) to a MAC was with an interface supplied by libnl. The implementation
of this interface is heavy and fails on large load of requests to create an
address handle.

This series of patches is an infrastructure for user drivers that care
for it to optimize the resolution of L3 to L2 addresses with uverbs
interface.
------------------------------------------------------------------------

The patch #3 was originally posted by Knut Omang and Moni extended it to
support all available drivers along with enhanced commit message. We are
sending the same patch as it exists in our review system, but feel free to
change authorship to Knut if it is matter.

Thanks

Available in the "topic/create_ah" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/create_ah

Moni Shoua (5):
  IB/core: Enhance ib_resolve_eth_dmac to be usable for creating AH
  IB/mlx5: Report that device supports user data response in create_ah
  IB/core: Let the verb create_ah return extended response to user
  IB/mlx5: Use kernel driver to help userspace create address handle
  IB/mlx5: Make create/destroy address handle available to userspace

 drivers/infiniband/core/core_priv.h          |  3 -
 drivers/infiniband/core/uverbs_cmd.c         | 19 ++++--
 drivers/infiniband/core/verbs.c              | 86 ++++++++++++++--------------
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  3 +-
 drivers/infiniband/hw/cxgb4/provider.c       |  4 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c      |  3 +-
 drivers/infiniband/hw/hns/hns_roce_device.h  |  3 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |  4 +-
 drivers/infiniband/hw/mlx4/ah.c              |  4 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |  3 +-
 drivers/infiniband/hw/mlx5/ah.c              | 25 +++++++-
 drivers/infiniband/hw/mlx5/main.c            |  5 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  3 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |  4 +-
 drivers/infiniband/hw/nes/nes_verbs.c        |  3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |  3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h     |  4 +-
 drivers/infiniband/hw/qedr/verbs.c           |  3 +-
 drivers/infiniband/hw/qedr/verbs.h           |  3 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  4 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h |  4 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c        |  4 +-
 include/rdma/ib_verbs.h                      |  6 +-
 include/uapi/rdma/mlx5-abi.h                 |  7 +++
 24 files changed, 140 insertions(+), 70 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
