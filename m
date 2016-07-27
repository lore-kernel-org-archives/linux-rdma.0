From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libmlx5 0/6] libmlx5: fix various coverity/clang issues
Date: Wed, 27 Jul 2016 15:17:21 -0400
Message-ID: <1469647047-7544-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Part of Red Hat's release process involves running packages through a
scan in coverity, and inspecting anything that pops up. Well, with version
1.2.1, coverity was a bit chatty, so I started investigating, and have
attempted to come up with fixes for at least most of what it reported.

Jarod Wilson (6):
  fix size in malloc of qp->sq.wr_data
  fix coverity buffer overrun warning
  fix buffer overrun copying inline header
  fix check of mlx5_store_uidx return
  fix alloc of mlx5_resource table
  fix undefined uuar_index value assignment

CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

 src/mlx5.c  |  2 +-
 src/qp.c    |  2 +-
 src/verbs.c | 14 +++++++++-----
 src/wqe.h   |  2 +-
 4 files changed, 12 insertions(+), 8 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
