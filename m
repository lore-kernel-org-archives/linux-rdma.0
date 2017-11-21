From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/2] RDMA fixes for 4.15
Date: Tue, 21 Nov 2017 12:26:16 +0200
Message-ID: <20171121102618.31216-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There are two fixes, one from Daniel fixes iWARP regression
caused by SELinux patches and another from Moni to create PSN
according to IBTA specification.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-rc-2017-11-21

	Thanks
---------------------------------------

Daniel Jurgens (1):
  IB/core: Only enforce security for InfiniBand

Moni Shoua (1):
  RDMA/cma: Make sure that PSN is not over max allowed

 drivers/infiniband/core/cma.c      | 1 +
 drivers/infiniband/core/security.c | 9 +++++++++
 2 files changed, 10 insertions(+)

-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
