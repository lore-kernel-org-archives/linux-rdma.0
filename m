From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/4] ConnectX-3 RSS Implementation
Date: Thu, 22 Jun 2017 16:44:08 +0300
Message-ID: <20170622134412.7680-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch set adds to ConnectX-3 devices the ability to use RSS
feature, which was initially implemented in mlx5-based devices [1].

The backport of RSS feature to ConnectX-3 hardware was a challenge
task due to differences in architectures between mlx4 and mlx5 based
devices.

It caused to a limited number of usage limitations, mentioned in the relevant
commit messages where it applies.

This series supports all RSS related verbs.

Thanks.

[1] https://www.spinics.net/lists/linux-rdma/msg36526.html

---
We based this series on our previous mlx4 submissions to reduce merge conflicts.
For your convenience, I prepared the branch with the following merge sequence:
"topic/no-io" -> "topic/mlx4-resource-utilization" -> "topic/mlx4-receive-inline"

Available in the "topic/mlx4-rss" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/mlx4-rss

Thanks

Guy Levi (4):
  IB/mlx4: Add support for WQ related verbs
  IB/mlx4: Add support for WQ indirection table related verbs
  IB/mlx4: Add support for RSS QP
  IB/mlx4: Expose RSS capabilities

 drivers/infiniband/hw/mlx4/main.c    |  51 ++
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  32 +-
 drivers/infiniband/hw/mlx4/qp.c      | 907 ++++++++++++++++++++++++++++++++---
 include/uapi/rdma/mlx4-abi.h         |  49 ++
 4 files changed, 975 insertions(+), 64 deletions(-)

--
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
