From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 rdma-core 0/7] Add mlx5 direct verbs
Date: Tue, 14 Feb 2017 15:48:17 +0200
Message-ID: <1487080104-28991-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset from Leon adds direct access to mlx5 devices.
Sending V2 to handle few notes around packaging and man pages, details below.

The libibverbs API is an abstract API. It is agnostic to any underlying
provider specific implementation. While this abstraction has the advantage of
user applications portability it has a performance penalty. For some
applications optimizing performance is more important than portability.

The mlx5 direct verbs API introduced in this patchset is intended for such
applications. It exposes mlx5 specific low level data path
(send/receive/completion) operations, allowing the application to bypass the
libibverbs data path API.

The proposed interface consists from one hardware specific header with relevant
inline functions and conversion logic from ibverbs structures to mlx5 related
structures.

New header is going to be installed in below path location:
/usr/inlcude/infiniband/mlx5dv.h

The direct include of mlx5dv.h together with linkage to mlx5 library will
allow usage of this new interface.

Note: all Mellanox NIC devices starting from Connect-IB (Connect-IB,
ConnectX-4, ConnectX-4Lx, ConnectX-5 and more to come in the future) implement
the mlx5 API, thus using the mlx5 direct verbs does not limit the applications
to a single NIC HW device thus keeping some level of portability.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/63

Yishai

Changes from V1:
     * Moved man pages and header files to *-dev packages.
     * Changed license for newly created files from BSD variant to MIT.
     * Updated man pages.

Changes from V0:
     * Removed mlx5 and include sub-directories from installed
       path and source code.
     * Put all DV code into one header file.
     * Renamed mlx5/dv.h to be mlx5dv.h file.
     * Added providers/mlx5/libmlx5.map file with exported functions.
     * Allowed mlx5 provider to be shared library.
     * Added manual pages for direct verbs.
     * Rebased to latest rdma-core.
     * Create symlink for libmlx5-rdmav2.so to point to libmlx5.so.
     * Dropped patch which changed INLINE_SCATTER defines.
     * Replaced ntohll functions to be64toh, followup of
       https://github.com/linux-rdma/rdma-core/commit/b21ff60e0e111e295a18cc8e3397347893c524bc
     * Added Jason's SOB tag for his debian/redhat/Cmake work.

Leon Romanovsky (7):
  mlx5: Add mlx5 direct verbs
  mlx5: Add CQE fields
  mlx5: Add WQE segments implementation
  mlx5: Use macro for CQE version 1
  mlx5: Convert to use predefined get CQE opcodes
  mlx5: Add direct verbs man pages
  mlx5: Export mlx5 direct verbs interface

 CMakeLists.txt                           |   1 +
 buildlib/rdma_functions.cmake            |  51 +++
 buildlib/relpath                         |   7 +
 debian/ibverbs-providers.install         |   1 +
 debian/ibverbs-providers.symbols         |   4 +
 debian/libibverbs-dev.install            |   3 +
 providers/mlx5/CMakeLists.txt            |   7 +-
 providers/mlx5/cq.c                      |  96 +----
 providers/mlx5/libmlx5.map               |   8 +
 providers/mlx5/man/CMakeLists.txt        |   5 +
 providers/mlx5/man/mlx5dv.7              |  44 +++
 providers/mlx5/man/mlx5dv_init_obj.3     | 130 +++++++
 providers/mlx5/man/mlx5dv_query_device.3 |  50 +++
 providers/mlx5/mlx5.c                    | 111 +++++-
 providers/mlx5/mlx5.h                    |  62 +---
 providers/mlx5/mlx5dv.h                  | 588 +++++++++++++++++++++++++++++++
 providers/mlx5/qp.c                      |   2 +-
 providers/mlx5/wqe.h                     |  97 +----
 redhat/rdma-core.spec                    |   3 +
 19 files changed, 1027 insertions(+), 243 deletions(-)
 create mode 100644 buildlib/relpath
 create mode 100644 debian/ibverbs-providers.symbols
 create mode 100644 providers/mlx5/libmlx5.map
 create mode 100644 providers/mlx5/man/CMakeLists.txt
 create mode 100644 providers/mlx5/man/mlx5dv.7
 create mode 100644 providers/mlx5/man/mlx5dv_init_obj.3
 create mode 100644 providers/mlx5/man/mlx5dv_query_device.3
 create mode 100644 providers/mlx5/mlx5dv.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
