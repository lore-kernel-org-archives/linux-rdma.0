From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v5 00/17] Statistics counter support
Date: Tue,  2 Jul 2019 13:02:29 +0300
Message-ID: <20190702100246.17382-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
 v4 -> v5:
 * Patch #6 and #14 - consolidated many counter release functions,
   removed mutex lock protection from dealloc_counter() call
   and simplified kref_put/kref_get operations.
 * Added Saeed's ACK tags.
 v3 -> v4:
 * Add counter_dealloc() callback function
 * Moved to kref implementation
 * Fixed lock during spinlock
 v2 -> v3:
 * We didn't change use of atomics over kref for management of unbind
   counter from QP. The reason to it that bind and unbind are non-symmetric
   in regards of put and get, so we need to count differently memory
   release flows of HW objects (restrack) and SW bind operations.
 * Everything else was addressed.
 v1 -> v2:
 * Rebased to latest rdma-next
 v0 -> v1:
 * Changed wording of counter comment
 * Removed unneeded assignments
 * Added extra patch to present global counters

----------------------------------------------------

Hi,

This series from Mark provides dynamic statistics infrastructure.
He uses netlink interface to configure and retrieve those counters.

This infrastructure allows to users monitor various objects by binding
to them counters. As the beginning, we used QP object as target for
those counters, but future patches will include ODP MR information too.

Two binding modes are supported:
 - Auto: This allows a user to build automatic set of objects to a counter
   according to common criteria. For example in a per-type scheme, where in
   one process all QPs with same QP type are bound automatically to a single
   counter.
 - Manual: This allows a user to manually bind objects on a counter.

Those two modes are mutual-exclusive with separation between processes,
objects created by different processes cannot be bound to a same counter.

For objects which don't support counter binding, we will return
pre-allocated counters.

$ rdma statistic qp set link mlx5_2/1 auto type on
$ rdma statistic qp set link mlx5_2/1 auto off
$ rdma statistic qp bind link mlx5_2/1 lqpn 178
$ rdma statistic qp unbind link mlx5_2/1 cntn 4 lqpn 178
$ rdma statistic show
$ rdma statistic qp mode

Thanks


Mark Zhang (17):
  net/mlx5: Add rts2rts_qp_counters_set_id field in hca cap
  RDMA/restrack: Introduce statistic counter
  RDMA/restrack: Add an API to attach a task to a resource
  RDMA/restrack: Make is_visible_in_pid_ns() as an API
  RDMA/counter: Add set/clear per-port auto mode support
  RDMA/counter: Add "auto" configuration mode support
  IB/mlx5: Support set qp counter
  IB/mlx5: Add counter set id as a parameter for
    mlx5_ib_query_q_counters()
  IB/mlx5: Support statistic q counter configuration
  RDMA/nldev: Allow counter auto mode configration through RDMA netlink
  RDMA/netlink: Implement counter dumpit calback
  IB/mlx5: Add counter_alloc_stats() and counter_update_stats() support
  RDMA/core: Get sum value of all counters when perform a sysfs stat
    read
  RDMA/counter: Allow manual mode configuration support
  RDMA/nldev: Allow counter manual mode configration through RDMA
    netlink
  RDMA/nldev: Allow get counter mode through RDMA netlink
  RDMA/nldev: Allow get default counter statistics through RDMA netlink

 drivers/infiniband/core/Makefile     |   2 +-
 drivers/infiniband/core/counters.c   | 634 +++++++++++++++++++++++++++
 drivers/infiniband/core/device.c     |  10 +
 drivers/infiniband/core/nldev.c      | 551 ++++++++++++++++++++++-
 drivers/infiniband/core/restrack.c   |  49 ++-
 drivers/infiniband/core/restrack.h   |   3 +
 drivers/infiniband/core/sysfs.c      |  16 +-
 drivers/infiniband/core/verbs.c      |   9 +
 drivers/infiniband/hw/mlx5/main.c    |  77 +++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   6 +
 drivers/infiniband/hw/mlx5/qp.c      |  76 +++-
 include/linux/mlx5/mlx5_ifc.h        |   4 +-
 include/linux/mlx5/qp.h              |   1 +
 include/rdma/ib_verbs.h              |  31 ++
 include/rdma/rdma_counter.h          |  65 +++
 include/rdma/restrack.h              |   4 +
 include/uapi/rdma/rdma_netlink.h     |  52 ++-
 17 files changed, 1559 insertions(+), 31 deletions(-)
 create mode 100644 drivers/infiniband/core/counters.c
 create mode 100644 include/rdma/rdma_counter.h
