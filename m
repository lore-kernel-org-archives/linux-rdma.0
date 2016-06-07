From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libmlx5 0/7] Completion timestamping
Date: Tue,  7 Jun 2016 15:11:32 +0300
Message-ID: <1465301499-21234-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This V1 series addressed few notes from V0 that we confirmed
to be useful, details below.

It was tested successfully with Doug's libibverbs GIT and
merged to my public GIT at:
git://openfabrics.org/~yishaih/libmlx5.git.

Any further changes, if will be needed, will come as some
incremental commits.

Yishai

Changes from V0:
Patch #1: Change mlx5_handle_error_cqe to return a value.
Patch #3: Prevent a stack frame creation on non debug mode as
          part of mlx5_cq_read_wc_opcode.
Patches 4 & 5: Use a more tidy scheme to set the matching 
               start/next/end poll functions.

Matan Barak (4):
  Refactor mlx5_poll_one
  Add support for creating an extended CQ
  Add ibv_query_rt_values support
  Use configuration symbol for always in-line

Yishai Hadas (3):
  Add lazy CQ polling
  Add inline functions to read completion's attributes
  Add ability to poll CQs through iterator's style API

 Makefile.am                 |   1 +
 configure.ac                |   3 +
 m4/ax_gcc_func_attribute.m4 | 223 ++++++++++++++
 src/cq.c                    | 737 +++++++++++++++++++++++++++++++++++++++-----
 src/mlx5-abi.h              |   5 +
 src/mlx5.c                  |  38 +++
 src/mlx5.h                  |  34 +-
 src/verbs.c                 | 139 ++++++++-
 8 files changed, 1083 insertions(+), 97 deletions(-)
 create mode 100644 m4/ax_gcc_func_attribute.m4

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
