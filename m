From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/3] RSS related capabilities
Date: Sun, 28 Aug 2016 11:28:42 +0300
Message-ID: <1472372925-17660-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series exposes the RSS related capabilities to user space domain.
It comes as supplementary part to previous series of RSS that was
already accepted.

The series includes three patches:
Patch #1: Exposes the related properties from the IB core layer.
Patch #2: The uverbs layer queries the related properties from the
              core layer and exposes to user space area.
Patch #3: Exposes the related capabilities from the mlx5 driver.

Available in the "topic/rss_cap" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/rss_cap

Thanks,
  Yishai & Leon

Yishai Hadas (3):
  IB/core: Expose RSS related capabilities
  IB/uverbs: Expose RSS related capabilities
  IB/mlx5: Expose RSS related capabilities

 drivers/infiniband/core/uverbs_cmd.c | 17 +++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c    | 31 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/user.h    |  7 +++++++
 include/rdma/ib_verbs.h              | 12 ++++++++++++
 include/uapi/rdma/ib_user_verbs.h    | 14 ++++++++++++++
 5 files changed, 81 insertions(+)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
