From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/7] Add mlx5 direct verbs
Date: Thu, 26 Jan 2017 17:56:15 +0200
Message-ID: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset from Leon adds direct access to mlx5 devices.

The libibverbs API is an abstract API. It is agnostic to any underlying
provider specific implementation. While this abstraction has the advantage of
user applications portability it has a performance penalty. For some
applications optimizing performance is more important than portability.

The mlx5 direct verbs API introduced in this patchset is intended for such
applications. It exposes mlx5 specific low level data path
(send/receive/completion) operations, allowing the application to bypass the
libibverbs data path API.

The proposed interface consists from small number of hardware specific headers
with relevant inline functions and conversion logic from ibverbs structures to
mlx5 related structures.

New headers are going to be installed to the /usr/include/infiniband/ folder in
such way that it will allow future extension and coexistence for other vendors.

* /usr/inlcude/infiniband/mlx5/dv.h               - shared code
* /usr/inlcude/infiniband/mlx5/dv-cqe.h           - CQE related functions
                                                    (general implementation)
* /usr/inlcude/infiniband/mlx5/dv-wqe.h           - WQE related functions
                                                    (general and SSE3 implementations)

The direct include of dv.h together with linkage to mlx5 library will
allow usage of this new interface.

Note: all Mellanox NIC devices starting from Connect-IB (Connect-IB,
ConnectX-4, ConnectX-4Lx, ConnectX-5 and more to come in the future)
implement the mlx5 API, thus using the mlx5 direct verbs does not limit
the applications to a single NIC HW device thus keeping some level of
portability.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/63

Yishai

Leon Romanovsky (7):
  mlx5: Add mlx5 direct verbs files
  mlx5: Add CQE fields
  mlx5: Add WQE segments implementation
  mlx5: Use macro for CQE version 1
  mlx5: Convert to use predefined get CQE opcodes
  mlx5: Unify exported and internal CQE format
  mlx5: Export mlx5 direct verbs interface

 buildlib/provider.map                 |  13 +-
 providers/mlx5/CMakeLists.txt         |   2 +
 providers/mlx5/cq.c                   | 120 +++----------
 providers/mlx5/include/CMakeLists.txt |   5 +
 providers/mlx5/include/dv-cqe.h       | 156 +++++++++++++++++
 providers/mlx5/include/dv-wqe.h       | 315 ++++++++++++++++++++++++++++++++++
 providers/mlx5/include/dv.h           | 181 +++++++++++++++++++
 providers/mlx5/mlx5.c                 | 111 +++++++++++-
 providers/mlx5/mlx5.h                 |  62 +------
 providers/mlx5/qp.c                   |   2 +-
 providers/mlx5/wqe.h                  |  97 +----------
 11 files changed, 806 insertions(+), 258 deletions(-)
 create mode 100644 providers/mlx5/include/CMakeLists.txt
 create mode 100644 providers/mlx5/include/dv-cqe.h
 create mode 100644 providers/mlx5/include/dv-wqe.h
 create mode 100644 providers/mlx5/include/dv.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
