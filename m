From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V6 00/14] SG-based RDMA ABI Proposal
Date: Sun, 11 Dec 2016 14:57:54 +0200
Message-ID: <1481461088-56355-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch set comes to enrich security model as a follow up
to commit e6bd18f57aad ('IB/security: Restrict use of the write() interface').

DISCLAIMER:
These patches are far from being completed. They present working init_ucontext
and query_device (both regular and extended version). In addition, they are
given as a basis of discussions.

The ideas presented here are based on our previous series in addition to some
ideas presented in OFVWG and Sean's series.

This patch series add ioctl() interface to the existing write() interface and
provide an easy route to backport this change to legacy supported systems.
Analyzing the current uverbs role in dispatching and parsing commands, we find
that:
(a) uverbs validates the basic properties of the command
(b) uverbs is responsible of doing all the IDR and uobject management and
    locking. It's also responsible of handling completion FDs.
(c) uverbs transforms the user<-->kernel ABI to kernel API.

(a) and (b) are valid for every kABI. Although the nature of commands could
change, they still have to be validated and transform to kernel pointers.
In order to avoid duplications between the various drivers, we would like to
keep (a) and (b) as shared code.

In addition, this is a good time to expand the ABI to be more scalable, so we
added a few goals:
(1) Command's attributes shall be extensible in an easy one. Either by allowing
    drivers to have their own extensible set of attributes or core code
    extensible attributes. Moreover, driver's specific attributes could some
    day become core's standard attributes. We would like to still support
    old user-space while avoid duplicating the code in kernel.
(2) Each driver may have specific type system (i.e QP, CQ, ....). It may
    or may not even implement the standard type system. It could extend this
    type system in the future. Try to avoid duplicating existing types or
    actions.
(3) Do not change or recompile driver libraries and don't copy their data.
(4) Efficient dispatching.

Thus, in order to allow this flexibility, we decide giving (a) and (b) as a
common infrastructure, but use per-driver guidelines in order to do that
parsing and uobject management. Handlers are also set by the drivers
themselves (though they can point to either shared common code) or
driver specific code.

Since types are no longer enforced by the common infrastructure, there is no
point of pre-allocating common IDR types in the common code. Instead, we
provide an API for driver to add new types. We use one IDR per driver
for all its types. The driver declared all its supported types, their
free function and release order. After that, all uboject, exclusive access
and types are handled automatically for the driver by the infrastructure.

Scatter gather was chosen in order to allow us not to recompile user space
drivers. By using pointers to driver specific data, we could just use it
without introduce copying data and without changing the user-space driver at
all.

We chose to go with non blocking lock user objects. When exclusive
(WRITE or DESTROY) access is required, we dispatch the action if and only if
no other action needs this object as well. Otherwise, -EBUSY is returned to
the user-space. Device removal is synced with SRCU as of today.
If we were using locks, we would have need to sort the given user-space handles.
Otherwise, a user-space application may result in causing a deadlock.
Moving to a non blocking lock based behaviour, the dispatching in kernel
becomes more efficient.

We implement a compatibility layer between the old write implementation and
the new IOCTL based implementation by:
(a) Create IOCTL header and attributes descriptors.
(b) The attribute descriptors are mapped straight to the user-space supplied
    buffers. We expect that every subset of consecutive fields in the old ABI
    could be directly mapped to an attribute in the new ABI.
(c) We pass a flag telling the parsing function whether the headers reside in
    kernel-space or user-space.

We would like to use this opportunity to introduce a more syntactic way of
querying a device features. Each feature is represented in a parsing tree
(which consists of type groups, types, action groups, actions, attribute groups
and attributes). When a driver registers itself to the IB subsystem, it merges
all feature trees into one parsing tree. Later on, this parsing tree is used
in order to parse and validate all commands. We plan to allow user-space to
read this parsing tree and by that figuring out which features are supported.

Further uverbs related subsystem (such as RDMA-CM) may use other fds or use
other ioctl codes. When implementing this infrastructure to RDMA-CM, we may
need to replace ib_device with an ioctl_device and ib_ucontext with
ioctl_context. However, this could be done in a later stage.

Note, we might switch to submitting one task (i.e - change locking schema) once
the concepts are more mature.

This series is based on Doug's k.o/for-4.9-fixed branch [1] + Leon's [1] series.

Regards,
Liran, Haggai, Leon and Matan

[0] 2937f3757519 ('staging/lustre: Disable InfiniBand support')
[1] RDMA/core: Unify style of IOCTL commands series

Changes from V5:
1. Allow inlined input attributes.
2. Using the DSL macros in an inlined more compact way.
3. Specify mandatory attributes (both from user-space and kernel).
4. Specify minimum size check for attributes.
5. Introduce a way to merge feature trees.
   - Each feature will be defined in its own parsing tree.
   - We merge all these trees into one big parsing tree.
   - Driver data is declared exactly in such a tree.
6. Remove all unnecessary EXPORT_SYMBOL (we'll add them later if we need).
7. Convert __u8/16/32 to kernel's native types.
8. Make the code bisect-able.
   - Make the write uverbs handlers use the new locking/objects allocation
     infrastructure.
9. Get rid of the sizeof() requirement in the macro language.
10. Ditch the distribution function and come with a simpled fixed model
    (use high bits).
11. Allocate the necessary stuff on the stack for small commands.
12. Write compatibility mode – use flag instead of get_fs and set_fs
13. Change handlers definitions to get array of group_attributes
14. Remove the priv from handlers
15. Rename unlock_idr to commit_objects
16. Remove the live indication from ib_uboject
17. Bugfix: proper cleanups of IDRs
18. Bugfix: Use of attr in create_qp
19. Remove close_sem

Changes from V4:
1. Rebased over Doug's k.o/for-4.9-fixed branch.
2. Added create_qp and modify_qp commands.
3. Added libibverbs POC code. Started implementing the bits required for
   ibv_rc_pingpong.
4. Added a patch that puts the foundations of a compatibility layer
   between write commands and ioctl commands. This has some limitations
   of which every subset of the old write ABI should be directly mapped
   to an attribute of the new ABI.
5. Implement write's get_context using this compatibility layer.

Changes from V3:
1. Add create_cq and create_comp_channel.
2. Add FD as ib_uobject into the type system.

Changes from V2:
1. Use types declerations in order to declare release order and free function
2. Allow the driver to extend and use existing building blocks in any level:
        a. Add more types
        b. Add actions to exsiting types
        c. Add attributes to existing actions (existed in V2)
   Such a driver will only duplicate structs which it actually changed.
3. Fixed bugs in ucontext teardown and type allocation/locking.
4. Add reg_mr and init_pd

Changes from V1:
1. Refined locking system
a. try_read_lock and write lock to sync exclusive accesssb. SRCU to sync device removal from commands execution
c. Future rwsem to sync close context from commands execution
2. Added temporary udata usage for vendor's data
3. Add query_device and init_ucontext command with mlx5 implementation
4. Fixed bugs in ioctl dispatching
5. Change callbacks to get ib_uverbs_file instead of ucontext
6. Add general types initialization and cleanups

Leon Romanovsky (1):
  IB/core: Refactor IDR to be per-device

Matan Barak (13):
  IB/core: Add support for custom types
  IB/core: Add generic ucontext initialization and teardown
  IB/core: Add macros for declaring types and type groups.
  IB/core: Declare all common IB types
  IB/core: Use the new IDR and locking infrastructure in uverbs_cmd
  IB/core: Add new ioctl interface
  IB/core: Add macros for declaring actions and attributes
  IB/core: Add uverbs types, actions, handlers and attributes
  IB/core: Add uverbs merge trees functionality
  IB/mlx5: Implement common uverb objects
  IB/{core,mlx5}: Support uhw definition per driver
  IB/core: Support getting IOCTL header/SGEs from kernel space
  IB/core: Implement compatibility layer for get context command

 drivers/infiniband/core/Makefile             |    4 +-
 drivers/infiniband/core/core_priv.h          |   14 +
 drivers/infiniband/core/device.c             |   18 +
 drivers/infiniband/core/rdma_core.c          |  527 +++++++++++
 drivers/infiniband/core/rdma_core.h          |   80 ++
 drivers/infiniband/core/uverbs.h             |   43 +-
 drivers/infiniband/core/uverbs_cmd.c         | 1310 +++++++++-----------------
 drivers/infiniband/core/uverbs_ioctl.c       |  369 ++++++++
 drivers/infiniband/core/uverbs_ioctl_cmd.c   | 1072 +++++++++++++++++++++
 drivers/infiniband/core/uverbs_ioctl_merge.c |  672 +++++++++++++
 drivers/infiniband/core/uverbs_main.c        |  263 ++----
 drivers/infiniband/hw/mlx5/Makefile          |    2 +-
 drivers/infiniband/hw/mlx5/main.c            |   20 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |    2 +
 drivers/infiniband/hw/mlx5/uverbs_tree.c     |   68 ++
 include/rdma/ib_verbs.h                      |   37 +-
 include/rdma/uverbs_ioctl.h                  |  380 ++++++++
 include/rdma/uverbs_ioctl_cmd.h              |  210 +++++
 include/uapi/rdma/ib_user_verbs.h            |   39 +
 include/uapi/rdma/rdma_user_ioctl.h          |   28 +
 20 files changed, 4083 insertions(+), 1075 deletions(-)
 create mode 100644 drivers/infiniband/core/rdma_core.c
 create mode 100644 drivers/infiniband/core/rdma_core.h
 create mode 100644 drivers/infiniband/core/uverbs_ioctl.c
 create mode 100644 drivers/infiniband/core/uverbs_ioctl_cmd.c
 create mode 100644 drivers/infiniband/core/uverbs_ioctl_merge.c
 create mode 100644 drivers/infiniband/hw/mlx5/uverbs_tree.c
 create mode 100644 include/rdma/uverbs_ioctl.h
 create mode 100644 include/rdma/uverbs_ioctl_cmd.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
