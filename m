From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [pull request][rdma-rc v1 0/4] RDMA fixes for-4.13
Date: Tue,  1 Aug 2017 09:41:33 +0300
Message-ID: <20170801064137.8360-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changelog:
 v0 -> v1:
  * Added Reviewed-by tags
  * Moved 10 patches to -next

Thanks
----------------------------------------------------------------

The following changes since commit 5dc78ad1904db597bdb4427f3ead437aae86f54c:

  IB/ipoib: Notify on modify QP failure only when relevant (2017-07-23 10:52:00 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-rc-2017-08-01

for you to fetch changes up to 0626c5a5dec2e601f06a2c03b295fb7d7288e29c:

  RDMA/mlx5: Fix existence check for extended address vector (2017-07-31 20:43:06 +0300)

----------------------------------------------------------------
RDMA fixes for 4.13

This patchset contains four patches:
 * Two kernel panic fixes from Yishai and Parav.
 * The bugfix to mlx5 wrong usage of big-endian variable.
 * Preventing leak of reserved field.

----------------------------------------------------------------
Leon Romanovsky (2):
      RDMA/uverbs: Prevent leak of reserved field
      RDMA/mlx5: Fix existence check for extended address vector

Parav Pandit (1):
      IB/core: Fix race condition in resolving IP to MAC

Yishai Hadas (1):
      IB/uverbs: Fix device cleanup

 drivers/infiniband/core/addr.c        | 62 +++++++++++++++++++++++++++--------
 drivers/infiniband/core/uverbs_cmd.c  |  2 +-
 drivers/infiniband/core/uverbs_main.c |  3 +-
 drivers/infiniband/hw/mlx5/odp.c      |  2 +-
 include/linux/mlx5/qp.h               |  1 -
 5 files changed, 51 insertions(+), 19 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
