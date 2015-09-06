From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 0/5] Support CQE versions
Date: Sun,  6 Sep 2015 12:30:07 +0300
Message-ID: <1441531812-27716-1-git-send-email-hagaya@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This series adds support for CQE (cookie) versions in libmlx5

Non-default cookie versions are a must for RAW PACKET Eth QPs.

The code is capable to work over kernels which don't have this
support yet for the sake of creating other QP types.

Haggai

Haggai Abramonvsky (5):
  libmlx5: Add infrastructure for resource tracking
  libmlx5: Add QPs and XSRQs resource tracking
  libmlx5: Added new poll_cq according to the new CQE format
  libmlx5: Added QP and XSRQ create/destroy flow with user index
  libmlx5: Work with CQE version 1

 src/cq.c       | 262 +++++++++++++++++++++++++++++++++++++++++++++++----------
 src/mlx5-abi.h |   8 +-
 src/mlx5.c     |  80 ++++++++++++++++++
 src/mlx5.h     |  54 +++++++++++-
 src/verbs.c    | 122 ++++++++++++++++++++-------
 5 files changed, 447 insertions(+), 79 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
