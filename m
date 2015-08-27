From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] libibverbs: On-demand paging support
Date: Thu, 27 Aug 2015 18:22:32 +0300
Message-ID: <1440688955-7709-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series adds userspace support for on-demand paging. The first patch adds
support for the new extended query device verb. Patch 2 adds the capability and
interface bits related to on-demand paging, and patch 3 adds example code to
the rc_pingpong program to use on-demand paging.

Eli Cohen (1):
  Add support for extended query device capabilities

Haggai Eran (1):
  Add on-demand paging support

Majd Dibbiny (1):
  libibverbs/examples: Support odp in rc_pingpong

 Makefile.am                   |   3 +-
 examples/devinfo.c            |  67 ++++++++++++++++++++--
 examples/rc_pingpong.c        |  31 +++++++++-
 include/infiniband/driver.h   |   9 +++
 include/infiniband/kern-abi.h |  36 +++++++++++-
 include/infiniband/verbs.h    |  53 ++++++++++++++++-
 man/ibv_query_device_ex.3     |  70 +++++++++++++++++++++++
 man/ibv_reg_mr.3              |   2 +
 src/cmd.c                     | 129 +++++++++++++++++++++++++++++-------------
 src/libibverbs.map            |   2 +
 10 files changed, 352 insertions(+), 50 deletions(-)
 create mode 100644 man/ibv_query_device_ex.3

-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
