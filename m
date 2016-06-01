From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 0/7] Completion timestamping
Date: Wed,  1 Jun 2016 16:47:55 +0300
Message-ID: <1464788882-1876-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series from Matan and me implements the libibverbs
'Completion timestamping' API.

It can serve as some vendor code to justify the new API,
from both clarity and performance aspects.

As already pointed,
Benchmarks we ran in our test lab found that this new approach generally
equals to current API but *not* worse than. As the new API enables
extending the polled fields we can overall say that it's a better API than
the legacy one.

Yishai
 


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
 m4/ax_gcc_func_attribute.m4 | 223 +++++++++++++
 src/cq.c                    | 745 ++++++++++++++++++++++++++++++++++++++++----
 src/mlx5-abi.h              |   5 +
 src/mlx5.c                  |  38 +++
 src/mlx5.h                  |  34 +-
 src/verbs.c                 | 139 ++++++++-
 8 files changed, 1106 insertions(+), 82 deletions(-)
 create mode 100644 m4/ax_gcc_func_attribute.m4

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
