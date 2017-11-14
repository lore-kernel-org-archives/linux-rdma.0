From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 00/31] RDMA fixes and refactoring for 4.15
Date: Tue, 14 Nov 2017 14:51:47 +0200
Message-ID: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please consider to take the following series to your coming pull request.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-11-14

	Thanks
---------------------------------------

Artemy Kovalyov (1):
  IB/umem: Fix use of npages/nmap fields

Daniel Jurgens (1):
  IB/cm: Add debug prints to ib_cm

Erez Alfasi (1):
  IB/mlx4: Remove unused ibpd parameter

Erez Shitrit (2):
  IB/ipoib: Avoid memory leak if neigh destination was changed
  IB/ipoib: Update pathrec field if not valid record

Majd Dibbiny (1):
  IB/core: Make sure that PSN does not overflow

Matan Barak (1):
  IB/core: Fix memory leak in cm_req_handler error flows

Parav Pandit (24):
  IB/core: Fix do not add RoCEv2 default GID when IPv6 is disabled
  IB/{core/cm}: Fix dmac query for IPv6 link local destination
  IB/core: Depend on IPv6 stack to resolve link local address
  IB/core: Avoid exporting module internal function
  RDMA/cma: Fix consider size of destination address
  RDMA/cma: Set default GID type as RoCE when resolving RoCE route
  RDMA/cma: Simplify netdev check
  RDMA/cma: Avoid setting path record type twice
  RDMA/cma: Introduce and use helper functions to init work
  IB/core: Avoid unnecessary type cast
  IB/core: Refactor to avoid unnecessary check on GID lookup miss
  IB/rxe: Avoid passing unused index pointer which is optional
  IB/core: Avoid exporting module internal ib_find_gid_by_filter()
  RDMA/core: Avoid redundant memcpy in resolving address
  IB/core: Removed unused function
  RDMA/{core, cma}: Simplify rdma_translate_ip
  RDMA/core: Avoid copying ifindex twice
  IB/{core, ipoib}: Simplify ib_find_gid to search only for IB link
    layer
  IB/{cm, umad}: Fix honor av init error
  IB/cm: Fix honor address handle attribute init error
  IB/cm: Fix avoid sleep while spin lock is held
  IB/{core, cm, cma, ipoib}: Rename ib_init_ah_from_path to
    ib_init_ah_attr_from_path
  IB/{core, umad, cm}: Rename ib_init_ah_from_wc to
    ib_init_ah_attr_from_wc
  IB/cm: Refactor to avoid setting path record software only fields

 drivers/infiniband/core/addr.c            |  65 ++--------
 drivers/infiniband/core/cache.c           |  25 ++--
 drivers/infiniband/core/cm.c              | 191 ++++++++++++++++++++----------
 drivers/infiniband/core/cma.c             | 118 +++++++++---------
 drivers/infiniband/core/core_priv.h       |  13 --
 drivers/infiniband/core/device.c          |  16 +--
 drivers/infiniband/core/sa_query.c        |   8 +-
 drivers/infiniband/core/security.c        |  10 +-
 drivers/infiniband/core/umem.c            |   2 +-
 drivers/infiniband/core/user_mad.c        |  10 +-
 drivers/infiniband/core/verbs.c           | 183 ++++++++++++++--------------
 drivers/infiniband/hw/mlx4/qp.c           |   4 +-
 drivers/infiniband/sw/rxe/rxe_recv.c      |   3 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   |   3 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  62 +++++++---
 include/rdma/ib_addr.h                    |   5 +-
 include/rdma/ib_sa.h                      |  10 +-
 include/rdma/ib_verbs.h                   |  11 +-
 18 files changed, 379 insertions(+), 360 deletions(-)

--
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
