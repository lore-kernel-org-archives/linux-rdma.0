From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/4] Add support for CQ moderation
Date: Mon, 30 Oct 2017 16:08:59 +0200
Message-ID: <1509372543-26603-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series from Yonatan is the supplementary part of the kernel series that
was sent for 4.15 few days ago.

The series introduces the ibv_modify_cq verb to enable CQ moderation, it can be
extended in the future for other options by using the attr_mask field.

By using the ibv_modify_cq verb a user can moderate completion events by
specifying the number of completions that cause an event and the timeout in
micro seconds to cause the event even if the number of completions was not
reached.

The series includes below:
Patch #1: Exposes the related moderation capabilities via ibv_query_device_ex.
Patch #2  Introduces the ibv_modify_cq verb to enable the moderation.
Patch #3: Add support in mlx4 driver.
Patch #4: Add support in mlx5 driver.

PR was sent:
https://github.com/linux-rdma/rdma-core/pull/238

Yonatan Cohen (4):
  verbs: Expose CQ moderation capabilities
  verbs: Add support for CQ moderation
  mlx4: Add support for CQ moderation
  mlx5: Add support for CQ moderation

 libibverbs/cmd.c                     | 34 +++++++++++++++++++++++++
 libibverbs/driver.h                  |  4 +++
 libibverbs/examples/devinfo.c        | 11 +++++++++
 libibverbs/kern-abi.h                | 22 +++++++++++++++++
 libibverbs/libibverbs.map.in         |  1 +
 libibverbs/man/CMakeLists.txt        |  1 +
 libibverbs/man/ibv_modify_cq.3       | 48 ++++++++++++++++++++++++++++++++++++
 libibverbs/man/ibv_query_device_ex.3 |  6 +++++
 libibverbs/verbs.h                   | 31 +++++++++++++++++++++++
 providers/mlx4/mlx4.c                |  1 +
 providers/mlx4/mlx4.h                |  1 +
 providers/mlx4/verbs.c               |  7 ++++++
 providers/mlx5/mlx5.c                |  1 +
 providers/mlx5/mlx5.h                |  1 +
 providers/mlx5/verbs.c               |  7 ++++++
 15 files changed, 176 insertions(+)
 create mode 100644 libibverbs/man/ibv_modify_cq.3

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
