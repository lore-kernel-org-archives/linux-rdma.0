From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V7 libmlx4 0/2] Add extension and XRC QP support
Date: Thu, 11 Jul 2013 18:07:42 +0300
Message-ID: <1373555264-1787-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Extend XRC support to user space. Because XRC requires
new verbs and extensions to existing verbs, we first implement the
infra-structure changes needed to support verbs extensions matching to
libibverbs scheme, later XRC support is built on top of that infrastructure.

Changes from V6:
Adapted to latest master branch.
Bug fixes, details in relevant patches.

Sean Hefty (1):
  Add support for XRC QPs

Yishai Hadas (1):
  Infra-structure changes to support verbs extensions

 src/buf.c      |    6 +-
 src/cq.c       |   42 ++++++++---
 src/mlx4-abi.h |    6 ++
 src/mlx4.c     |  106 ++++++++++++++++++---------
 src/mlx4.h     |   70 ++++++++++++++++--
 src/qp.c       |   39 ++++++----
 src/srq.c      |  153 ++++++++++++++++++++++++++++++++++++++
 src/verbs.c    |  224 +++++++++++++++++++++++++++++++++++++++++--------------
 8 files changed, 518 insertions(+), 128 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
