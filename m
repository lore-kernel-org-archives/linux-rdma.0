From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/7] Add mlx4 direct verbs
Date: Thu, 29 Jun 2017 14:47:01 +0300
Message-ID: <1498736828-17875-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset from Maor adds direct access to mlx4 devices, it follows same
solution from both API and packaging perspectives as was already accepted for
mlx5.

The libibverbs API is an abstract API. It is agnostic to any underlying
provider specific implementation. While this abstraction has the advantage of
user applications portability it has a performance penalty. For some
applications optimizing performance is more important than portability.

The mlx4 direct verbs API introduced in this patchset is intended for such
applications. It exposes mlx4 specific low level data path
(send/receive/completion) operations, allowing the application to bypass the
libibverbs data path API.

The proposed interface consists from one hardware specific header with relevant
inline functions and conversion logic from ibverbs structures to mlx4 related
structures.

New header is going to be installed in below path location:
/usr/inlcude/infiniband/mlx4dv.h

The direct include of mlx4dv.h together with linkage to mlx4 library will
allow usage of this new interface.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/155

Yishai

Maor Gottlieb (7):
  mlx4: Add mlx4 direct verbs
  mlx4: Add CQE fields
  mlx4: Convert datagram segment to use mlx4_av struct
  mlx4: Add WQE segments implementation
  mlx4: Convert to use predefined get CQE opcodes
  mlx4: Add direct verbs man pages
  mlx4: Export mlx4 direct verbs interface

 CMakeLists.txt                       |   1 +
 debian/ibverbs-providers.install     |   1 +
 debian/ibverbs-providers.symbols     |   4 +
 debian/libibverbs-dev.install        |   4 +
 providers/mlx4/CMakeLists.txt        |   7 +-
 providers/mlx4/cq.c                  |  65 +----
 providers/mlx4/libmlx4.map           |   7 +
 providers/mlx4/man/CMakeLists.txt    |   4 +
 providers/mlx4/man/mlx4dv.7          |  39 +++
 providers/mlx4/man/mlx4dv_init_obj.3 | 117 +++++++++
 providers/mlx4/mlx4.c                |  76 ++++++
 providers/mlx4/mlx4.h                |  73 +-----
 providers/mlx4/mlx4dv.h              | 465 +++++++++++++++++++++++++++++++++++
 providers/mlx4/qp.c                  |   3 +-
 providers/mlx4/srq.c                 |   1 -
 providers/mlx4/verbs.c               |   1 -
 providers/mlx4/wqe.h                 | 149 -----------
 redhat/rdma-core.spec                |   3 +
 18 files changed, 743 insertions(+), 277 deletions(-)
 create mode 100644 providers/mlx4/libmlx4.map
 create mode 100644 providers/mlx4/man/CMakeLists.txt
 create mode 100644 providers/mlx4/man/mlx4dv.7
 create mode 100644 providers/mlx4/man/mlx4dv_init_obj.3
 create mode 100644 providers/mlx4/mlx4dv.h
 delete mode 100644 providers/mlx4/wqe.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
