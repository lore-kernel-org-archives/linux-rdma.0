From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/2] IPoIB and mlx5 fixes
Date: Thu, 21 Dec 2017 17:38:25 +0200
Message-ID: <20171221153827.16793-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There are two fixes in this series,

Fix from Alex who solved lockdep real complain about ABBA locks sequence.

Patch from Majd a little bit larger than I would like, but most of the
diffstat is simple code moves from one file to another.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-rc-2017-12-21

	Thanks
---------------------------------------

Alex Vesker (1):
  IB/ipoib: Fix lockdep issue found on ipoib_ib_dev_heavy_flush

Majd Dibbiny (1):
  IB/mlx5: Fix congestion counters in LAG mode

 drivers/infiniband/hw/mlx5/cmd.c              | 11 ------
 drivers/infiniband/hw/mlx5/cmd.h              |  2 -
 drivers/infiniband/hw/mlx5/main.c             | 35 +++--------------
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |  7 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 56 +++++++++++++++++++++++++++
 include/linux/mlx5/driver.h                   |  4 ++
 6 files changed, 69 insertions(+), 46 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
