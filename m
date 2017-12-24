From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/2] mlx4/mlx5 RSS improvements
Date: Sun, 24 Dec 2017 14:51:23 +0200
Message-ID: <20171224125125.15661-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Two RSS patches, Maor's patch fixes wrongly reported inner RSS
capability in mlx5 and Guy provides such option for mlx4.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-12-24-1

	Thanks
---------------------------------------

Guy Levi (1):
  IB/mlx4: Add support to RSS hash for inner headers

Maor Gottlieb (1):
  IB/mlx5: Report inner RSS capability

 drivers/infiniband/hw/mlx4/main.c |  6 ++++++
 drivers/infiniband/hw/mlx4/qp.c   | 14 ++++++++++++++
 drivers/infiniband/hw/mlx5/main.c |  3 ++-
 include/uapi/rdma/mlx4-abi.h      |  7 ++++---
 include/uapi/rdma/mlx5-abi.h      |  2 +-
 5 files changed, 27 insertions(+), 5 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
