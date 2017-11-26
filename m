From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc v1 0/2] RDMA fixes for 4.15
Date: Sun, 26 Nov 2017 20:23:52 +0200
Message-ID: <20171126182354.18709-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changelog:
 v0->v1: Added proper SElinux patch

---------------------------------------
There are two fixes, one from Daniel fixes iWARP regression
caused by SELinux patches and another from Moni to create PSN
according to IBTA specification.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-rc-2017-11-26

	Thanks
---------------------------------------

Daniel Jurgens (1):
  IB/core: Only enforce security for InfiniBand

Moni Shoua (1):
  RDMA/cma: Make sure that PSN is not over max allowed

 drivers/infiniband/core/cma.c      |  1 +
 drivers/infiniband/core/security.c | 43 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 2 deletions(-)

--
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
