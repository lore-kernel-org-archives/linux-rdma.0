From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC rdma-core 0/5] Add thread domain support
Date: Sun, 12 Nov 2017 23:41:38 +0200
Message-ID: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This RFC series is based on some initial discussion that was in the mailing
list to support resource domain.

The series includes detailed man pages of the suggested APIs and initial
patches in both verbs and mlx5 driver to demonstrate the expected usage.

The motivation behind the series is to allow an application finer grain control
over share hardware resources and locks when the resources are used by the same
thread.

Yishai

Yishai Hadas (5):
  verbs: Introduce thread domain and its related verbs
  verbs: Introduce parent domain and its related verbs
  mlx5: Add support for ibv_td object and its related verbs
  mlx5: Add support for ibv_parent domain and its related verbs
  mlx5: Handles QP creation with a given parent domain

 libibverbs/man/ibv_alloc_parent_domain.3 |  73 +++++++++++++++++++++
 libibverbs/man/ibv_alloc_td.3            |  52 +++++++++++++++
 libibverbs/verbs.h                       |  75 ++++++++++++++++++++++
 providers/mlx5/mlx5-abi.h                |   3 +-
 providers/mlx5/mlx5.c                    |   4 ++
 providers/mlx5/mlx5.h                    |  22 +++++++
 providers/mlx5/verbs.c                   | 107 +++++++++++++++++++++++++++++--
 7 files changed, 331 insertions(+), 5 deletions(-)
 create mode 100644 libibverbs/man/ibv_alloc_parent_domain.3
 create mode 100755 libibverbs/man/ibv_alloc_td.3

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
