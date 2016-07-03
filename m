From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-next 0/2] uverbs and mlx5 fixes for 4.8
Date: Sun,  3 Jul 2016 15:28:17 +0300
Message-ID: <1467548899-21923-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here are two more fixes which are queued for 4.8. They apply cleanly
on top of your k.o/for-4.8 branch.

ConnectX-4/Connect-IB fix is marked to be sent to stable.

These patches are available in the "topic/fixes-ib-next" branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/fixes-ib-next

Thanks

Jason Gunthorpe (1):
  IB/uverbs: Fix race between uverbs_close and remove_one

Slava Shwartsman (1):
  IB/mlx5: Fix iteration overrun in GSI qps

 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_main.c | 37 +++++++++++++++++++++++------------
 drivers/infiniband/hw/mlx5/gsi.c      | 19 ++++++------------
 3 files changed, 31 insertions(+), 26 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
