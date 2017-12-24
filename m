From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/8] RDMA fixes and refactoring rdma-next-2017-12-24
Date: Sun, 24 Dec 2017 15:43:20 +0200
Message-ID: <20171224134328.17398-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Small series of various fixes to netlink, core and RXE found during
resource tracking development. It is based on
https://patchwork.kernel.org/patch/10093725/ and
https://patchwork.kernel.org/patch/10131941/

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-12-24-3

	Thanks
---------------------------------------

Leon Romanovsky (8):
  RDMA/rxe: Remove useless export symbol
  RDMA/netlink: Simplify code of autoload modules
  RDMA/core: Replace open-coded variant of put_device
  RDMA/nldev: Refactor nldev handle to be common function
  RDMA/core: Provide locked variant of device name to index function
  RDMA/netlink: Protect device query from device removal
  RDMA/nldev: Protect port query from accidental device removal
  RDMA/cma: Mark end of CMA ID messages

 drivers/infiniband/core/cma.c       |  1 +
 drivers/infiniband/core/core_priv.h |  1 +
 drivers/infiniband/core/device.c    | 18 +++++++-
 drivers/infiniband/core/netlink.c   |  8 ++--
 drivers/infiniband/core/nldev.c     | 82 +++++++++++++++++++++++--------------
 drivers/infiniband/sw/rxe/rxe.c     |  6 ---
 drivers/infiniband/sw/rxe/rxe.h     |  6 ++-
 7 files changed, 79 insertions(+), 43 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
