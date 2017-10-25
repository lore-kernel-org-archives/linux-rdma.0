From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/2] mlx4 RSS fixes for 4.15
Date: Wed, 25 Oct 2017 22:39:33 +0300
Message-ID: <20171025193935.1075-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

There are two mlx4 RSS fixes for v4.15

Thanks

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-10-25

	Thanks
---------------------------------------

Guy Levi (2):
  IB/mlx4: Add report for RSS capabilities by vendor channel
  IB/mlx4: Fix RSS's QPC attributes assignments

 drivers/infiniband/hw/mlx4/main.c    | 17 +++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h | 16 +++++++++++-----
 drivers/infiniband/hw/mlx4/qp.c      | 16 +++++++++-------
 3 files changed, 37 insertions(+), 12 deletions(-)

--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
