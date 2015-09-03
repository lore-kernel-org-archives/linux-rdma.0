From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 0/3] libibverbs: On-demand paging support
Date: Thu,  3 Sep 2015 17:56:36 +0300
Message-ID: <1441292199-8371-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series adds userspace support for on-demand paging. The first patch adds
support for the new extended query device verb. Patch 2 adds the capability and
interface bits related to on-demand paging, and patch 3 adds example code to
the rc_pingpong program to use on-demand paging.

Changes from v1:
- Patch 1:
  * move code to revert to legacy ibv_query_device when ibv_query_device_ex
    is missing to the inline function.
  * add an input parameter to the ibv_query_device_ex verb for future
    extension.
  * add the size of the ibv_device_attr_ex struct as a parameter to the
    ibv_query_device_ex verb, to allow the verb to handle older
    applications.
  * check the validity of the input parameter and output struct size.
  * remove reserved words from ibv_query_device_resp_ex, and remove unused
    ibv_device_attr_ex_resp struct.
- Patch 2:
  * let print_odp_caps() receive a const pointer instead of a by-value
    struct.
  * check that the application has enough space for ODP capabilities in the
    provided ibv_device_attr_ex struct.

Eli Cohen (1):
  Add support for extended query device capabilities

Haggai Eran (1):
  Add on-demand paging support

Majd Dibbiny (1):
  libibverbs/examples: Support odp in rc_pingpong

 Makefile.am                   |   3 +-
 examples/devinfo.c            | 145 +++++++++++++++++++++++++++--------------
 examples/rc_pingpong.c        |  31 ++++++++-
 include/infiniband/driver.h   |  10 +++
 include/infiniband/kern-abi.h |  36 ++++++++++-
 include/infiniband/verbs.h    |  68 ++++++++++++++++++-
 man/ibv_query_device_ex.3     |  70 ++++++++++++++++++++
 man/ibv_reg_mr.3              |   2 +
 src/cmd.c                     | 147 ++++++++++++++++++++++++++++++------------
 src/libibverbs.map            |   2 +
 10 files changed, 420 insertions(+), 94 deletions(-)
 create mode 100644 man/ibv_query_device_ex.3

-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
