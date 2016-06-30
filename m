From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V1 0/8] SG-based RDMA ABI Proposal
Date: Thu, 30 Jun 2016 16:39:23 +0300
Message-ID: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch set comes to enrich security model as a follow up
to commit e6bd18f57aad ('IB/security: Restrict use of the write() interface').

DISCLAIMER:
These patches don't work and are far from being completed. They only present
the fundamental concepts and are sent in order to be a basis of discussions.

The ideas presented here are based on our V0 series in addition to some ideas
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
    vendors to have their own extensible set of attributes or core code
    extensible attributes. Moreover, vendor's specific attributes could some
    day become core's standard attributes. We would like to still support
    old user-space while avoid duplicating the code in kernel.
(2) Each driver may have specific type system (i.e QP, CQ, ....). It may
    or may not even implement the standard type system. It could extend this
    type system in the future.
(3) Do not change or recompile vendor libraries and don't copy their data.
(4) Efficient dispatching.

Thus, in order to allow this flexibility, we decide giving (a) and (b) as a
common infrastructure, but use per-driver guidelines in order to do that
parsing and uobject management. Handlers are also set by the drivers
themselves (though they can point to either shared common code) or
vendor specific code.

Since types are no longer enforced by the common infrastructure, there is no
point of pre-allocating common IDR types in the common code. Instead, we
provide an API for driver to add new types. We use one IDR per vendor
for all its types. The driver should add all its usable types before
any application runs. The order of which the driver adds its types (and the
common types it uses) dictates the process release order. After that,
all uboject, reference counts and types are handled automatically for the
driver by the infrastructure.

Scatter gather was chosen in order to allow us not to recompile user space
drivers. By using pointers to vendor specific data, we could just use it
without introduce copying data and without changing the user-space driver at
all.

We chose to go with lockless uobjects. When exclusive (WRITE or DESTROY) access
is required, we dispatch the action if and only if no other action needs
this object as well. Otherwise, -EBUSY is returned to the user-space.
Device removal is synced with the commands by using a rwsem that is present
on the ib_uverbs_file struct.
If we were using locks, we would have need to sort the given user-space handles.
Otherwise, a user-space application may result in causing a deadlock.
Moving to a lockless based behaviour, the dispatching in kernel becomes more
efficient.

Further uverbs related subsystem (such as RDMA-CM) may use other fds or use
other ioctl codes.

Haggai Eran (1):
  RDMA/core: Add support for custom types

Leon Romanovsky (3):
  RDMA/core: Export RDMA IOCTL declarations
  RDMA/core: Move uobject code to separate files
  RDMA/core: Refactor IDR to be per-device

Matan Barak (4):
  RDMA/core: Introduce add/remove uobj from types
  RDMA/core: Add new ioctl interface
  RDMA/core: Change locking of ib_uobject
  RDMA/{hw, core}: Provide simple skeleton to IOCTL interface

 drivers/infiniband/core/Makefile           |   3 +-
 drivers/infiniband/core/device.c           |  22 ++
 drivers/infiniband/core/uidr.c             | 287 +++++++++++++++++++++
 drivers/infiniband/core/uidr.h             |  68 +++++
 drivers/infiniband/core/uobject.c          | 208 ++++++++++++++++
 drivers/infiniband/core/uobject.h          | 108 ++++++++
 drivers/infiniband/core/user_mad.c         |   2 +-
 drivers/infiniband/core/uverbs.h           |  17 +-
 drivers/infiniband/core/uverbs_cmd.c       | 385 ++++++-----------------------
 drivers/infiniband/core/uverbs_ioctl.c     | 279 +++++++++++++++++++++
 drivers/infiniband/core/uverbs_ioctl_cmd.c |  97 ++++++++
 drivers/infiniband/core/uverbs_main.c      |  43 ++--
 drivers/infiniband/hw/ioctl-skel.c         | 119 +++++++++
 include/rdma/ib_ioctl.h                    |  38 +++
 include/rdma/ib_verbs.h                    |  17 +-
 include/rdma/uverbs_ioctl.h                | 202 +++++++++++++++
 include/rdma/uverbs_ioctl_cmd.h            |  88 +++++++
 include/uapi/rdma/Kbuild                   |   1 +
 include/uapi/rdma/ib_user_ioctl.h          |  78 ++++++
 include/uapi/rdma/ib_user_mad.h            |  12 -
 include/uapi/rdma/ib_user_verbs.h          |  19 ++
 21 files changed, 1725 insertions(+), 368 deletions(-)
 create mode 100644 drivers/infiniband/core/uidr.c
 create mode 100644 drivers/infiniband/core/uidr.h
 create mode 100644 drivers/infiniband/core/uobject.c
 create mode 100644 drivers/infiniband/core/uobject.h
 create mode 100644 drivers/infiniband/core/uverbs_ioctl.c
 create mode 100644 drivers/infiniband/core/uverbs_ioctl_cmd.c
 create mode 100644 drivers/infiniband/hw/ioctl-skel.c
 create mode 100644 include/rdma/ib_ioctl.h
 create mode 100644 include/rdma/uverbs_ioctl.h
 create mode 100644 include/rdma/uverbs_ioctl_cmd.h
 create mode 100644 include/uapi/rdma/ib_user_ioctl.h

-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
