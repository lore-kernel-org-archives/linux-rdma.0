From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/4] RDMA fixes for 4.15
Date: Tue,  5 Dec 2017 22:30:00 +0200
Message-ID: <20171205203004.28386-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The patches from Daniel are targeted for stable@.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-rc-2017-12-05

	Thanks
---------------------------------------

Daniel Jurgens (2):
  IB/core: Bound check alternate path port number
  IB/core: Don't enforce PKey security on SMI MADs

Guy Levi (1):
  IB/mlx4: Fix RSS hash fields restrictions

Leon Romanovsky (1):
  RDMA/netlink: Fix general protection fault

 drivers/infiniband/core/cma.c        |  2 +-
 drivers/infiniband/core/device.c     |  2 +-
 drivers/infiniband/core/iwcm.c       |  2 +-
 drivers/infiniband/core/nldev.c      |  2 +-
 drivers/infiniband/core/security.c   |  7 +++++--
 drivers/infiniband/core/uverbs_cmd.c |  6 ++++++
 drivers/infiniband/hw/mlx4/qp.c      | 26 +++++++++++++++++++-------
 7 files changed, 34 insertions(+), 13 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
