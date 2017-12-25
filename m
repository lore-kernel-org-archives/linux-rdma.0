From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/9] Add thread domain support
Date: Mon, 25 Dec 2017 15:56:52 +0200
Message-ID: <1514210221-10466-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series enables grouping verbs objects together for the purpose of
optimizing the behavior of the driver in a multi-threaded environment.

The first use of this will be for mlx5 to group UAR registers in a way that
avoids needing locking on the post send path.

The series follows an RFC and a detailed discussion over it in the ML, the
matching kernel side was sent to rdma-next for 4.16.

A detailed description of the API and its usage appears as part of the man
pages and the commit logs which are part of the series. 

PR was sent:
https://github.com/linux-rdma/rdma-core/pull/280

Yishai

Yishai Hadas (9):
  verbs: Introduce ibv_thread_domain and its related verbs
  verbs: Introduce ibv_parent_domain and its related verbs
  mlx5: Add support for the ibv_td object and its related verbs
  mlx5: Add support for ibv_parent_domain
  mlx5: Dynamic BF size handling
  mlx5: Add support for dynamic UAR allocation
  mlx5: Add support for using a dedicated BF register
  mlx5: Add support for thread domain as part of QP creation
  mlx5: Expose max dynamic blue flame registers capability

 libibverbs/driver.h                      |  25 ++++
 libibverbs/man/CMakeLists.txt            |   5 +-
 libibverbs/man/ibv_alloc_parent_domain.3 |  74 ++++++++++
 libibverbs/man/ibv_alloc_td.3            |  61 +++++++++
 libibverbs/verbs.h                       |  67 +++++++++
 providers/mlx5/man/mlx5dv_query_device.3 |   4 +-
 providers/mlx5/mlx5-abi.h                |   5 +-
 providers/mlx5/mlx5.c                    |  44 +++++-
 providers/mlx5/mlx5.h                    |  64 ++++++++-
 providers/mlx5/mlx5dv.h                  |   4 +-
 providers/mlx5/verbs.c                   | 227 ++++++++++++++++++++++++++++++-
 11 files changed, 566 insertions(+), 14 deletions(-)
 create mode 100644 libibverbs/man/ibv_alloc_parent_domain.3
 create mode 100644 libibverbs/man/ibv_alloc_td.3

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
