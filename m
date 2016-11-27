From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/4] Mellanox ConnectX-3/ConnectX-4 fixes for 4.10
Date: Sun, 27 Nov 2016 15:18:18 +0200
Message-ID: <1480252702-8005-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below four different fixes to ConnectX-3/ConnectX-4.

This patchset was generated against v4.9-rc6 and targeted for 4.10.

Available in the "topic/mlx-fixes-4.10" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/mlx-fixes-4.10

Thanks

Eli Cohen (1):
  IB/mlx5: Avoid system crash when enabling many VFs

Jack Morgenstein (1):
  IB/mlx4: Fix out-of-range array index in destroy qp flow

Maor Gottlieb (2):
  IB/mlx5: Assign SRQ type earlier
  IB/mlx5: Use u64 for UMR length

 drivers/infiniband/hw/mlx4/qp.c      | 3 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
 drivers/infiniband/hw/mlx5/mr.c      | 3 ++-
 drivers/infiniband/hw/mlx5/srq.c     | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
