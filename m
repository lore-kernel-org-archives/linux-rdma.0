From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 v2 0/5] Support CQE versions
Date: Tue, 17 Nov 2015 23:52:17 +0200
Message-ID: <1447797142-24149-1-git-send-email-hagaya@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This series adds support for CQE (cookie) versions in libmlx5

Non-default cookie versions are a must for RAW PACKET Eth QPs.

The code is capable to work over kernels which don't have this
support yet for the sake of creating other QP types.

Haggai

Changes from v1:
	- Fixed Eli comment, remove unnecessary variable.
	- Removed unnecessary metadata from commit message.
	- Fix compilation error when enabling mlx5_debug mode.

Haggai Abramovsky (5):
  libmlx5: Add infrastructure for resource identification
  libmlx5: Add QPs and XSRQs resource tracking
  libmlx5: Added new poll_cq according to the new CQE format
  libmlx5: Added QP and XSRQ create/destroy flow with user index
  libmlx5: Work with CQE version 1

 src/cq.c       | 262 +++++++++++++++++++++++++++++++++++++++++++++++----------
 src/mlx5-abi.h |  10 ++-
 src/mlx5.c     |  80 ++++++++++++++++++
 src/mlx5.h     |  54 +++++++++++-
 src/verbs.c    | 149 +++++++++++++++++++++++---------
 5 files changed, 469 insertions(+), 86 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
