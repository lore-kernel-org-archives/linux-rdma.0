From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v5 0/8] RDMA resource tracking
Date: Mon, 22 Jan 2018 14:51:11 +0200
Message-ID: <20180122125119.26419-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changelog:
v4->v5:
  * Rewrote logic to acquire kernel owners of PD and CQ objects
  * Simplified interface.
  * Added logic to return summary for all PID namespaces and not only
    init PID namespace.
  * Changed DB implementation from struct with arrays to be struct with
    hash table.
  * Moved to use SRCU per-hash table.
  * Dropped RW semaphores in favor of mutex to protect linked lists.
  * Dropped QP named annotation patch.
  * Used SPDX licenses.
v3->v4:
  * Added Steve ROB tags.
  * Updated restrack.h to be compatible with kernel-doc format
  * Fixed bug when not all QPs (more than one netlink page) were
    returned by netlink interface
  * Removed "MAX" values from object summary. In followup patches,
    I will eturn object summary per-namespace and not for init PID
    namespace only. Max values can be seen with ibv_devinfo tool.
  * Renamed "comm" to be kern_name.
  * Fix spelling errors.
v2->v3:
  * Added support of PID namespaces.
  * Rewrote rdma_restraack_add function to ensure that it won't
    appear in lists before it is valid.
  * Replace pid/task name caching logic to use task_struct instead.
  * Removed report of name of task's for user space objects. Users
    are expected to read it through /proc/PID/comm.
v1->v2:
 * Rebased on latest rdma/for-next
 * Replaced mutex lock which protect linked lists to be RW semaphore.
   It has no impact on current implementation, because there is only one
   reader (nldev) and it is serialized. However better to be prepared
   for multiple readers from the beginning.
 * Added reinitialization next QP entry logic to ensure that it exists
   and didn't vanish during fill_req_qp() work.
v0->v1:
 * Dropped RFC
 * Separated to thre series, one for for-rc, and two for-next.

-------
The original goal of this series was to allow ability to view connection
(QP) information about running processes, however I used this opportunity and
created common infrastructure to track and report various resources. The report
part is implemented in netlink (nldev), but smart ULPs can now create
advanced usage models based on device utilization.

The current implementation relies on one lock per-object per-device, so
creation/destroying of various objects (CQ, PD, e.t.c) on various or the
same devices doesn't interfere each with another.

The data protection is performed with SRCU and its reader-writer model
ensures that resource won't be destroyed till readers will finish their
work.

Possible future work will include:
 * Reducing number of locks in RDMA, because of SRCU.
 * Converting CMA to be based completely on resource tracking.
 * Addition of other objects and extending current to give full
   and detailed state of the RDMA kernel stack.
 * Replacing synchronize_srcu with call_srcu to make destroy flow
   non-blocking.
 * Provide reliable device reset flow, preserving resource creation ordering.

	Thanks
---------------------------------------

Leon Romanovsky (8):
  RDMA/core: Print caller name instead of function name
  RDMA/core: Save kernel caller name in PD and CQ objects
  RDMA/restrack: Add general infrastructure to track RDMA resources
  RDMA/core: Add resource tracking for create and destroy QPs
  RDMA/core: Add resource tracking for create and destroy CQs
  RDMA/core: Add resource tracking for create and destroy PDs
  RDMA/nldev: Provide global resource utilization
  RDMA/nldev: Provide detailed QP information

 drivers/infiniband/core/Makefile           |   2 +-
 drivers/infiniband/core/core_priv.h        |  21 ++
 drivers/infiniband/core/cq.c               |  16 +-
 drivers/infiniband/core/device.c           |   7 +
 drivers/infiniband/core/nldev.c            | 364 +++++++++++++++++++++++++++++
 drivers/infiniband/core/restrack.c         | 135 +++++++++++
 drivers/infiniband/core/uverbs_cmd.c       |   7 +-
 drivers/infiniband/core/uverbs_std_types.c |   3 +
 drivers/infiniband/core/verbs.c            |  13 +-
 include/rdma/ib_verbs.h                    |  27 ++-
 include/rdma/restrack.h                    | 136 +++++++++++
 include/uapi/rdma/rdma_netlink.h           |  55 +++++
 12 files changed, 773 insertions(+), 13 deletions(-)
 create mode 100644 drivers/infiniband/core/restrack.c
 create mode 100644 include/rdma/restrack.h

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
