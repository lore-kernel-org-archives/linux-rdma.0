From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/3] mlx5 and NLDEV fixes
Date: Mon, 30 Oct 2017 14:23:12 +0200
Message-ID: <20171030122315.21924-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

There are three patches targeted for this -RC, while mlx5 patches can
easily go to -next, the nldev patch better to be forwarded to Linus in
this cycle.

Because, we are in -rc7 now, I would really appreciate to hear your
plans regarding nldev patch.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-rc-2017-10-30

	Thanks
---------------------------------------

Leon Romanovsky (1):
  RDMA/nldev: Enforce device index check for port callback

Majd Dibbiny (2):
  IB/mlx5: Assign send CQ and recv CQ of UMR QP
  IB/mlx5: Fix RoCE Address Path fields

 drivers/infiniband/core/nldev.c   | 4 +++-
 drivers/infiniband/hw/mlx5/main.c | 2 ++
 drivers/infiniband/hw/mlx5/qp.c   | 8 ++++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
