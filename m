From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/2] Small fix and code refactoring for mlx5
Date: Fri, 17 Jun 2016 15:33:30 +0300
Message-ID: <1466166812-730-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

These two patches are intended for rdna-next and related
to mlx5 only.

Despite the fact that these patches were tested and found
that no merge conflict is expected between IB and net parts
of mlx5 driver, we would like to ask you to take into your
tree this refactored code.

Such move will give us enough time to respond in case other
developers (non-Mellanox) will send patches in that area and
will cause to merge conflicts during Linus's merge window.

Thanks

Artemy Kovalyov (2):
  IB/mlx5: Fix MODIFY_QP command input structure
  {net, IB}/mlx5: Refactor internal SRQ API

 drivers/infiniband/hw/mlx5/srq.c              | 102 ++++------
 drivers/net/ethernet/mellanox/mlx5/core/srq.c | 265 ++++++++++++++------------
 include/linux/mlx5/driver.h                   |   6 +-
 include/linux/mlx5/qp.h                       |   5 +-
 include/linux/mlx5/srq.h                      |  25 +++
 5 files changed, 218 insertions(+), 185 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
