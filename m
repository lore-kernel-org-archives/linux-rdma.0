From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 0/8] Completion timestamping
Date: Wed, 24 Feb 2016 11:41:56 +0200
Message-ID: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series from Matan adds completion timestamp for libibverbs.
The kernel part was already accepted.

We made some extra review on V0 and addressed some issues,
details below.

The series was retested successfully with mlx4 driver (lib, kernel)
and can be accessed also from my openfabrics GIT at:
git://openfabrics.org/~yishaih/libibverbs.git
branch: for-upstream

This timestamp series is sent on top of QP creation flags patch
that is pending your merge.

If may be helpful, it exists also on top of the master branch 
from my public GIT above, branch: ts.

Yishai
------

In order to do so, we add an extensible poll cq. The problem with
extending the WC is that you could run out of the current cache
line when adding new features and degrade performance. This is solved
by introducing a custom WC.

The user creates a CQ using ibv_create_cq_ex, stating which WC fields
should be returned by this CQ. When the user calls ibv_poll_cq_ex,
this custom WC is returned. The fields orders and sizes are declared
in advanced (we avoid alignment rules by putting the fields starting
from the 64bit fields --> 8bit fields). Each WC has a wc_flags field
representing which fields are valid in this WC.
The vendor drivers could optimize those calls extensively.

Completion timestamp is added on top of these extended ibv_create_cq_ex
verb and ibv_poll_cq_ex verb. The user should call ibv_create_cq_ex
stating that this CQ should support reporting completion timestamp.
ibv_poll_cq_ex reports this raw completion timestamp value in every
packet.

The timestamp mask (number of supported bits) and the HCA's frequency
are given in ibv_query_device_ex verb.

We also give the user an ability to read the HCA's current clock.
This is done via ibv_query_rt_values_ex. This verb could be extended
in the future for other interesting information.

Changes from V0:
- Split the series to small logical patches.
- Align naming in some places to match other verbs.
- Fix and improve the man pages.
- Add an example code as part of rc_pingpong.

Matan Barak (7):
  Add ibv_poll_cq_ex verb
  Add timestamp_mask and hca_core_clock to ibv_query_device_ex
  Add support for extended ibv_create_cq
  Add completion timestamp support for ibv_poll_cq_ex
  Add helper functions to work with the extended WC
  Add ibv_query_rt_values_ex
  Man pages for time stamping support

Yishai Hadas (1):
  Add timestamp support in rc_pingpong

 Makefile.am                   |   7 +-
 examples/devinfo.c            |  10 ++
 examples/rc_pingpong.c        | 130 ++++++++++++++---
 include/infiniband/compiler.h |  91 ++++++++++++
 include/infiniband/driver.h   |   9 ++
 include/infiniband/kern-abi.h |  22 +++
 include/infiniband/verbs.h    | 318 ++++++++++++++++++++++++++++++++++++++++++
 man/ibv_create_cq_ex.3        |  75 ++++++++++
 man/ibv_poll_cq_ex.3          | 181 ++++++++++++++++++++++++
 man/ibv_query_device_ex.3     |   6 +-
 man/ibv_query_rt_values_ex.3  |  50 +++++++
 src/cmd.c                     |  63 +++++++++
 src/device.c                  |  44 ++++++
 src/ibverbs.h                 |   5 +
 src/libibverbs.map            |   1 +
 15 files changed, 992 insertions(+), 20 deletions(-)
 create mode 100644 include/infiniband/compiler.h
 create mode 100644 man/ibv_create_cq_ex.3
 create mode 100644 man/ibv_poll_cq_ex.3
 create mode 100644 man/ibv_query_rt_values_ex.3

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
