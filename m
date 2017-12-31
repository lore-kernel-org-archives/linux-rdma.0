From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/2] RDMA fixes 2017-12-31
Date: Sun, 31 Dec 2017 15:33:13 +0200
Message-ID: <20171231133315.28801-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nitzan Carmi <nitzanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

There are two small fixes, one fix to mlx4_ib_alloc_mr error flow, very
similar to commit 45e6ae7ef21b ("IB/mlx5: Fix mlx5_ib_alloc_mr error
flow") and another fix to race condition in IPoIB revealed by Enhanced
IPoIB tests.

Thanks

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-rc-2017-12-31

	Thanks
---------------------------------------

Erez Shitrit (1):
  IB/ipoib: Fix race condition in neigh creation

Leon Romanovsky (1):
  IB/mlx4: Fix mlx4_ib_alloc_mr error flow

 drivers/infiniband/hw/mlx4/mr.c                |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 25 ++++++++++++++++++-------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  5 ++++-
 3 files changed, 23 insertions(+), 9 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
