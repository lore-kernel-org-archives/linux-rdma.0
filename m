From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 0/7] RDMA fixes and refactoring
Date: Mon,  1 Jan 2018 13:07:10 +0200
Message-ID: <20180101110717.29686-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changelog:
 v0 -> v1:
  * Squashed patches related to __ib_device_get_by_index and removed
    that function from core_priv.h.
  * Change write semaphore to be read semaphore in ib_device_get_by_index()

---------------------------------------

Small series of various fixes to netlink, core and RXE found
during resource tracking development.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2018-01-01-1

	Thanks
---------------------------------------

Leon Romanovsky (7):
  RDMA/rxe: Remove useless export symbol
  RDMA/netlink: Simplify code of autoload modules
  RDMA/core: Replace open-coded variant of put_device
  RDMA/nldev: Refactor nldev handle to be common function
  RDMA/core: Provide locked variant of device name to index function
  RDMA/netlink: Protect device and port queries from device removal
  RDMA/cma: Mark end of CMA ID messages

 drivers/infiniband/core/cma.c       |  1 +
 drivers/infiniband/core/core_priv.h |  2 +-
 drivers/infiniband/core/device.c    | 23 ++++++++++-
 drivers/infiniband/core/netlink.c   |  8 ++--
 drivers/infiniband/core/nldev.c     | 82 +++++++++++++++++++++++--------------
 drivers/infiniband/sw/rxe/rxe.c     |  6 ---
 drivers/infiniband/sw/rxe/rxe.h     |  6 ++-
 7 files changed, 83 insertions(+), 45 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
