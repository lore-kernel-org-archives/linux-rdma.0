From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V3 0/7] SG-based RDMA ABI Proposal
Date: Tue,  9 Aug 2016 19:39:28 +0300
Message-ID: <1470760775-6813-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch set comes to enrich security model as a follow up
to commit e6bd18f57aad ('IB/security: Restrict use of the write() interface').

DISCLAIMER:
These patches are far from being completed. They present working init_ucontext
and query_device (both regular and extended version). In addition, they are
given as a basis of discussions.

NOT ALL COMMENTS GIVEN ON V1/V2 ARE HANDLED IN THIS SERIES, SOME OF THEM WILL
BE HANDLED IN THE FUTURE.

The ideas presented here are based on our V1/V2 series in addition to some ideas
presented in OFVWG and Sean's series.

This patch series add ioctl() interface to the existing write() interface and
provide an easy route to backport this change to legacy supported systems.
Analyzing the current uverbs role in dispatching and parsing commands, we find
that:
(a) uverbs validates the basic properties of the command
(b) uverbs is responsible of doing all the IDR and uobject management and
    locking.
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

Further uverbs related subsystem (such as RDMA-CM) may use other fds or use
other ioctl codes.

Note, we might switch to submitting one task (i.e - change locking schema) once
the concepts are more mature.

Regards,
Liran, Haggai, Leon and Matan

TODO:
1. Address Jason's comments

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
	a. try_read_lock and write lock to sync exclusive access
	b. SRCU to sync device removal from commands execution
	c. Future rwsem to sync close context from commands execution
2. Added temporary udata usage for vendor's data
3. Add query_device and init_ucontext command with mlx5 implementation
4. Fixed bugs in ioctl dispatching
5. Change callbacks to get ib_uverbs_file instead of ucontext
6. Add general types initialization and cleanups

Leon Romanovsky (2):
  RDMA/core: Export RDMA IOCTL declarations
  RDMA/core: Refactor IDR to be per-device

Matan Barak (5):
  RDMA/core: Add support for custom types
  RDMA/core: Add new ioctl interface
  RDMA/core: Add initialize and cleanup of common types
  RDMA/core: Add uverbs types, actions, handlers and attributes
  IB/mlx5: Implement common uverb objects

 drivers/infiniband/core/Makefile           |   3 +-
 drivers/infiniband/core/device.c           |  18 +
 drivers/infiniband/core/rdma_core.c        | 331 +++++++++++++++++
 drivers/infiniband/core/rdma_core.h        |  72 ++++
 drivers/infiniband/core/user_mad.c         |   2 +-
 drivers/infiniband/core/uverbs.h           |  29 +-
 drivers/infiniband/core/uverbs_cmd.c       | 157 ++++----
 drivers/infiniband/core/uverbs_ioctl.c     | 292 +++++++++++++++
 drivers/infiniband/core/uverbs_ioctl_cmd.c | 551 +++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c      | 126 +------
 drivers/infiniband/hw/mlx5/main.c          |   3 +
 include/rdma/ib_verbs.h                    |  28 +-
 include/rdma/rdma_ioctl.h                  |  38 ++
 include/rdma/uverbs_ioctl.h                | 312 ++++++++++++++++
 include/rdma/uverbs_ioctl_cmd.h            | 203 +++++++++++
 include/uapi/rdma/Kbuild                   |   1 +
 include/uapi/rdma/ib_user_mad.h            |  12 -
 include/uapi/rdma/ib_user_verbs.h          |  13 +
 include/uapi/rdma/rdma_user_ioctl.h        |  82 +++++
 19 files changed, 2047 insertions(+), 226 deletions(-)
 create mode 100644 drivers/infiniband/core/rdma_core.c
 create mode 100644 drivers/infiniband/core/rdma_core.h
 create mode 100644 drivers/infiniband/core/uverbs_ioctl.c
 create mode 100644 drivers/infiniband/core/uverbs_ioctl_cmd.c
 create mode 100644 include/rdma/rdma_ioctl.h
 create mode 100644 include/rdma/uverbs_ioctl.h
 create mode 100644 include/rdma/uverbs_ioctl_cmd.h
 create mode 100644 include/uapi/rdma/rdma_user_ioctl.h

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
