From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 0/7] Change IDR usage and locking in uverbs
Date: Wed,  1 Feb 2017 14:38:58 +0200
Message-ID: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
This patch series changes that into a uverbs-file IDR table (since
in the new proposed ABI each device could have a different type
system and a uverbs-file refers for a specific device) and a unified
per-context objects list. Objects in this list could either be IDR
based objects or FD based objects.

A type is represented by an identifier, an allocation size, a free
function which is used in the context tear down and a release order.
The allocation function is actually the handler (for example,
create_qp). The release order determines the relations between objects.
Some relations are set in the hardware or user-space. For example,
a MW could be created before MR, but if this MW is bounded to the MR,
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
1. Serialize the user-space command to kernel-space structures.
2. Get all objects the handle needs (through the new centralized
     mechanism).
3. Do the actual command.
4. Commit or abort objects allocation/fetching/destruction.
5. Write response to the user.

We use the following locks/krefs:
1. ib_uobject: currently_used
	o Protects from concurrent read and write/destroy
2. ib_ucontext: lock
	o Protect from concurrently modifying the context uobject's list
3. ib_uobject: ref [kref]
	o Let's a handler delay the memory release of an uobject even if
	  it was already removed from the ucontext's objects list
	  (e.g. CQ takes a reference count on the completion handler)
	o rdma_core takes one reference count for all objects in its
	  repository.
4. ib_uverbs_file: cleanup_mutex [existing lock]
	o Protects concurrently closing a file from releasing the ucontext.
	  Since when removing a uobject, we need to remove it from the
	  uobjects list and thus we use the ucontext lock (clause 2),
	  we need to make sure the ucontext is alive throughout this process.

This patch-set is applied on top of Doug's k.o/for-4.11 branch.

Regards,
Matan

Changes from V0 - address some of Jason's comments:
1. Change idr table to be per uverbs_file and not per device.
2. Make changes more gradual
    a. Instead of doing a flags day approach, first introduce the idr
       uobjects with a new API and change their usages:
	 o Ditch the live flag
	 o Manage all idr objects through rdma_core
	 o create and cleanup context through rdma_core
    b. Add a lock to preserve old attch_mcast/detach_mcast behaviour.
    c. Add fd based objects infrastructure
    d. Change current completion channel to use this fd infrastructure.
3. Ditch the switch-case enums and favor a more OOP approach through a
   vtable.
4. Instead of having a kref-ed lock, put a new lock on the uverbs_file
   to synchronize fd objects deletion from context removal
    a. We favored this approach from keeping the ucontext alive, as the
       ucontext is allocated by the driver and thus we want to deallocate
       it through the same entity. We don't want to defer the whole
       deallocation process as in the current state we could rmmod the
       drivers code when applications are still running and trigger
       a disassociate flow.
5. Reduce the amount of macros - use only a macro for declaring idr
   types and a macro to declare fd types.
6. Use kref to manage all uobjects.
7. Use proper types for idr.

Leon Romanovsky (1):
  IB/core: Refactor idr to be per uverbs_file

Matan Barak (6):
  IB/core: Add support for idr types
  IB/core: Add idr based standard types
  IB/core: Change idr objects to use the new schema
  IB/core: Add lock to multicast handlers
  IB/core: Add support for fd objects
  IB/core: Change completion channel to use the reworked objects schema

 drivers/infiniband/core/Makefile           |   3 +-
 drivers/infiniband/core/rdma_core.c        | 437 +++++++++++++
 drivers/infiniband/core/rdma_core.h        |  74 +++
 drivers/infiniband/core/uverbs.h           |  50 +-
 drivers/infiniband/core/uverbs_cmd.c       | 980 +++++++++--------------------
 drivers/infiniband/core/uverbs_main.c      | 436 ++++++-------
 drivers/infiniband/core/uverbs_std_types.c | 193 ++++++
 include/rdma/ib_verbs.h                    |  27 +-
 include/rdma/uverbs_std_types.h            |  51 ++
 include/rdma/uverbs_types.h                | 148 +++++
 10 files changed, 1424 insertions(+), 975 deletions(-)
 create mode 100644 drivers/infiniband/core/rdma_core.c
 create mode 100644 drivers/infiniband/core/rdma_core.h
 create mode 100644 drivers/infiniband/core/uverbs_std_types.c
 create mode 100644 include/rdma/uverbs_std_types.h
 create mode 100644 include/rdma/uverbs_types.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
