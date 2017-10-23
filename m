From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 00/10] Add tag matching support
Date: Mon, 23 Oct 2017 16:17:51 +0300
Message-ID: <1508764681-4531-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch set from Artemy is the supplementary part of the kernel series that
was accepted upstream into 4.14 and enables the RDMA tag-matching offload to
user space applications.

The verbs API follows an RFC [1] which included the verbs patches, man pages
and a detailed documentation.

A detailed description of the concept and the API exist at
Documentation/tag_matching.md which is built incrementally during the series
and as part of the relevant man pages.

The series introduces the API and its matching implementation in mlx5 driver.

[1] https://www.spinics.net/lists/linux-rdma/msg50838.html

PR was sent:
https://github.com/linux-rdma/rdma-core/pull/227

Note:
Travis error in GITHUB is some checkpatch false alarm related
to BEGIN_C_DECLS.

Yishai

Artemy Kovalyov (10):
  verbs: Hardware tag matching
  verbs: Expose tag matching capabilities
  verbs: Introduce tag matching SRQ
  mlx5: Add support to tag matching SRQ type
  verbs: Tag matching list manipulation interface
  mlx5: Tag matching post list operation
  mlx5: Tag matching list operation completions
  verbs: Tag matching send interface
  verbs: Tag matching receive interface
  mlx5: Tag matching receive implementation

 Documentation/CMakeLists.txt         |   1 +
 Documentation/tag_matching.md        | 341 +++++++++++++++++++++++++++++++++++
 debian/libibverbs-dev.install        |   1 +
 debian/rdma-core.install             |   1 +
 libibverbs/CMakeLists.txt            |   1 +
 libibverbs/cmd.c                     |  28 +++
 libibverbs/enum_strs.c               |   6 +-
 libibverbs/examples/devinfo.c        |  17 ++
 libibverbs/kern-abi.h                |  12 +-
 libibverbs/man/CMakeLists.txt        |   1 +
 libibverbs/man/ibv_create_cq_ex.3    |  11 ++
 libibverbs/man/ibv_create_srq_ex.3   |  13 +-
 libibverbs/man/ibv_post_srq_ops.3    | 100 ++++++++++
 libibverbs/man/ibv_query_device_ex.3 |  17 ++
 libibverbs/tm_types.h                |  70 +++++++
 libibverbs/verbs.h                   | 110 ++++++++++-
 providers/mlx5/cq.c                  | 240 +++++++++++++++++++++++-
 providers/mlx5/mlx5.c                |   1 +
 providers/mlx5/mlx5.h                |  50 ++++-
 providers/mlx5/mlx5dv.h              |  51 +++++-
 providers/mlx5/qp.c                  | 303 ++++++++++++++++++++++++++-----
 providers/mlx5/verbs.c               | 166 +++++++++++++++--
 redhat/rdma-core.spec                |   1 +
 suse/rdma-core.spec                  |   1 +
 24 files changed, 1456 insertions(+), 87 deletions(-)
 create mode 100644 Documentation/tag_matching.md
 create mode 100644 libibverbs/man/ibv_post_srq_ops.3
 create mode 100644 libibverbs/tm_types.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
