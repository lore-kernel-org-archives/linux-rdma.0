From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/7] Change IDR usage and locking in uverbs
Date: Wed, 11 Jan 2017 12:53:46 +0200
Message-ID: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series is the first part of introducing the new ABI.
It changes the IDR and locking mechanism in ib_uverbs.
This will allow handling all types in the same way, both IB/core
standard types and driver specific types. In that case, type is
referred to either IDR (such as QP, CQ, etc.) or FD such as
completion channel based uobjects.

Previously, we had global IDR tables per type and a per-type list on
the user context, which implied that the type system was fixed.
This patch series changes that into a per-device IDR table (since
in the new proposed ABI each device could have a different type
system) and a unified per-context objects list. Objects in this list
could either be IDR based objects or FD based objects.

A type is represented by an identifier, an allocation size, a free
function which is used in the context tear down and a release order.
The allocation function is actually the handler (for example,
create_qp). The release order determines the relations between objects.
Some relations are set in the hardware or user-space. For example,
you can create a MW before MR, but if this MW is bounded to the MR,
the MW should be released before the MR.
Later on, we'll add actions in an object-oriented programming manner
to each type. So, a type contains all required information for
allocating its size and freeing it.

The locking mechanism is changed as well. Previously, the uverbs_cmd
handlers created new objects themselves and dealt with the internals
of locking/unlocking them. This is now moved to a separate code which
either creates a new object, destroys an object or locks it for
read/write. This is possible since we have a descriptive type system.
Hence, we could have a shared code to create, lock and destroy types.

In contrast to the previous locking approach, we don't block the
user-space thread if an object is already locked, but we just return
-EBUSY and expect the user to handle this. In order to maintain
backward compatibility, we've added explicit locks to the uverbs_cmd
handlers (in non-racy scenarios of course), thus for sane flows the
behaviour should be the same as previous one.
The incentive here is to provide a robust infrastructure to add new
actions that can't create a dead-lock (e.g. two commands that try to
lock objects in AB-BA manner).
In addition, since objects creation and locking is dealt in a
centralized place, the new proposed ABI won't need to deal with it
explicitly in its handlers.

A typical flow of a handler will be:
1. Serialize the user-space command to kernel-space.
2. Get all objects the handle needs (through the new centralized
     mechanism).
3. Do the actual command.
4. Finalize objects (unlock/add/destroy/rollback) and write response
     to the user.

This patch-set is applied on top of Doug's k.o/for-4.11 branch.
The whole ABI proposal is available in my github [1] using the tag
abi-devel-latest.

Regards,
Matan

[1] https://github.com/matanb10/linux/

Leon Romanovsky (1):
  IB/core: Refactor IDR to be per-device

Matan Barak (6):
  IB/core: Add support for custom types
  IB/core: Add support for fd objects
  IB/core: Add generic ucontext initialization and teardown
  IB/core: Add macros for declaring types and type groups
  IB/core: Declare all common IB types
  IB/core: Use the new IDR and locking infrastructure in uverbs_cmd

 drivers/infiniband/core/Makefile             |    3 +-
 drivers/infiniband/core/device.c             |   14 +
 drivers/infiniband/core/rdma_core.c          |  496 ++++++++++++
 drivers/infiniband/core/rdma_core.h          |   89 ++
 drivers/infiniband/core/uverbs.h             |   28 +-
 drivers/infiniband/core/uverbs_cmd.c         | 1117 ++++++++------------------
 drivers/infiniband/core/uverbs_ioctl_cmd.c   |  212 +++++
 drivers/infiniband/core/uverbs_main.c        |  279 ++-----
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    4 +
 drivers/infiniband/hw/cxgb4/provider.c       |    4 +
 drivers/infiniband/hw/hns/hns_roce_main.c    |    4 +
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |    4 +
 drivers/infiniband/hw/mlx4/main.c            |    4 +
 drivers/infiniband/hw/mlx5/main.c            |    4 +
 drivers/infiniband/hw/mthca/mthca_provider.c |    4 +
 drivers/infiniband/hw/nes/nes_verbs.c        |    4 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    4 +
 drivers/infiniband/hw/usnic/usnic_ib_main.c  |    4 +
 drivers/infiniband/sw/rdmavt/vt.c            |    4 +
 drivers/infiniband/sw/rxe/rxe_verbs.c        |    4 +
 include/rdma/ib_verbs.h                      |   33 +-
 include/rdma/uverbs_ioctl.h                  |  128 +++
 include/rdma/uverbs_ioctl_cmd.h              |   68 ++
 23 files changed, 1511 insertions(+), 1004 deletions(-)
 create mode 100644 drivers/infiniband/core/rdma_core.c
 create mode 100644 drivers/infiniband/core/rdma_core.h
 create mode 100644 drivers/infiniband/core/uverbs_ioctl_cmd.c
 create mode 100644 include/rdma/uverbs_ioctl.h
 create mode 100644 include/rdma/uverbs_ioctl_cmd.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
