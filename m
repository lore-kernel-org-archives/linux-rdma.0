From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 00/13] IB/core: SG IOCTL based RDMA ABI
Date: Wed,  7 Jun 2017 15:22:39 +0300
Message-ID: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch series adds ioctl() interface to the existing write() interface and
provide an easy route to backport this change to legacy supported systems.
Analyzing the current uverbs role in dispatching and parsing commands, we find
that:
(a) uverbs validates the basic properties of the command.
(b) uverbs is responsible of doing all the IDR and uobject management and
    locking. It's also responsible for handling completion FDs.
(c) uverbs transforms the user<-->kernel ABI to kernel API.

(a) and (b) are valid for every kABI. Although the nature of commands could
change, they still have to be validated and transform to kernel pointers.
In order to avoid duplications between the various drivers, we would like to
keep (a) and (b) as shared code.

In addition, this is a good time to expand the ABI to be more scalable, so we
added a few goals:
(1) Command's attributes shall be extensible in an easy way. Either by allowing
    drivers to have their own extensible set of attributes or core code
    extensible attributes.
(2) Each driver may have specific type system (i.e QP, CQ, ....). It could extend
    this type system in the future. Try to avoid duplicating existing types or
    actions.

Thus, in order to allow this flexibility, we decide giving (a) and (b) as a
common infrastructure, but use per-driver guidelines in order to do that
parsing and uobject management. Handlers are also set by the drivers
themselves (though they can point to either shared common code) or
driver specific code.

We introduce a hierarchal object-method-attributes structure. Adding an
entity to this hierarchy doesn't affect the rest of the interface.
Such a hierarchy could be rooted in a specific device and describes both the
common features and features which are unique to this specific device.
This hierarchy is actually a per-device parsing tree, composed of three
layers - objects, actions and attributes. Each such layer contains two
groups - common entities and hardware specific entities. This way, a
device could add hardware specific actions to a common object, it could
add hardware specific objects, etc. Abstractions which really make sense,
should go to the common section. This means that we still need to be able to
pass optional parameters. In order to enable optional parameters, each command
is composed of a header and a bunch of TLVs to pass the attributes of this
command. The supported attribute classes are:
* PTR_IN (command) [in case of a small buffer, we could pass the data inlined]
* PTR_OUT (response)
* IDR_OBJECT
* FD_OBJECT
We differentiate between blobs and objects in order to allow a generic piece of
code in the kernel to do some syntactic validations and translate the given
user object id to a kernel structure. This could really help in sharing code
between different handlers.

Scatter gather was chosen in order to allow us not to recompile user space
drivers. By using pointers to driver specific data, we could just use it
without introduce copying data and without changing the user-space driver at
all.

We elevate the locking and IDR changes accepted to linux-rdma in this series.
Since types are no longer enforced by the common infrastructure, there is no
point of pre-allocating common IDR types in the common code. Instead, we
provide an API for driver to add new types. We use one IDR per context
for all its IDR types. The driver declared all its supported types, their
free function and release order. After that, all uboject, exclusive access
and types are handled automatically for the driver by the infrastructure.

When putting the pieces together, we have per-device parsing tree, that actually
describes all the objects, actions and attributes a device supports by using a
descriptive language. A command is given by the user-space, as a header plus an
array of Type-Length-Pointer/Object attributes. The ioctl callback executes a
generic code that shares as much logic between the various verbs handlers as
possible. This generic code gets the command input from the user-space and by
reading the device's parsing tree, it could syntactically validate it, grab all
required objects, lock them, call the right handler and then
commit/unlock/rollback the result, depending on the handler's result. Having
such a flexible extensible mechanism, that allows introducing new common and
hardware-specific to existing common attributes, but also allows adding new
hardware-specific entities, enhances the support for device diversity quite
vastly.

This series lays the foundations of such an infrastructure. It demonstrate the
CREATE_CQ and DESTROY_CQ handlers that use this new infrastructure with most of
its features. We still use a common parsing tree for all devices, but this will
be changed in the future, when we introduce a parse tree that is tailored for
devices. We still don't share code between the regular write() interface handlers
and the new ioctl(), but it should be done in the future too. An enhanced query
mechanism, based on the parse tree, is planned in the future as well.

After this infrastructure is merged, we could continue enhancing and build the
require functionality on top of it.

This is rebased over Doug's latest k.o/for-4.13 branch.

The series (with some extra untested/un-reviewed extra handlers) is available
here:
https://github.com/matanb10/linux         branch: kabi_ioctl_v0

rdma-core code for testing:
https://github.com/matanb10/rdma-core     branch: kabi_ioctl_testing

Regards,
Matan

Matan Barak (13):
  IB/core: Add a generic way to execute an operation on a uobject
  IB/core: Add support to finalize objects in one transaction
  IB/core: Add new ioctl interface
  IB/core: Declare a type instead of declaring only type attributes
  IB/core: Add DEVICE type and root types structure
  IB/core: Initialize uverbs types specification
  IB/core: Add macros for declaring actions and attributes
  IB/core: Explicitly destroy an object while keeping uobject
  IB/core: Export ioctl enum types to user-space
  IB/core: Add legacy driver's user-data
  IB/core: Add completion queue (cq) object actions
  IB/core: Assign root to all drivers
  IB/core: Expose ioctl interface through experimental Kconfig

 drivers/infiniband/Kconfig                     |   7 +
 drivers/infiniband/core/Makefile               |   2 +-
 drivers/infiniband/core/rdma_core.c            | 178 +++++++++++
 drivers/infiniband/core/rdma_core.h            |  42 +++
 drivers/infiniband/core/uverbs.h               |   5 +
 drivers/infiniband/core/uverbs_ioctl.c         | 418 +++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c          |   9 +
 drivers/infiniband/core/uverbs_std_types.c     | 288 ++++++++++++++---
 drivers/infiniband/hw/bnxt_re/main.c           |   5 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |   5 +
 drivers/infiniband/hw/cxgb4/provider.c         |   5 +
 drivers/infiniband/hw/hns/hns_roce_main.c      |   5 +
 drivers/infiniband/hw/i40iw/i40iw_verbs.c      |   5 +
 drivers/infiniband/hw/mlx4/main.c              |   5 +
 drivers/infiniband/hw/mlx5/main.c              |   5 +
 drivers/infiniband/hw/mthca/mthca_provider.c   |   5 +
 drivers/infiniband/hw/nes/nes_verbs.c          |   5 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c     |   5 +
 drivers/infiniband/hw/qedr/main.c              |   5 +
 drivers/infiniband/hw/usnic/usnic_ib_main.c    |   5 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c |   5 +
 drivers/infiniband/sw/rdmavt/vt.c              |   5 +
 drivers/infiniband/sw/rxe/rxe_verbs.c          |   5 +
 include/rdma/ib_verbs.h                        |   2 +
 include/rdma/uverbs_ioctl.h                    | 305 ++++++++++++++++++
 include/rdma/uverbs_std_types.h                |  45 +--
 include/rdma/uverbs_types.h                    |  39 ++-
 include/uapi/rdma/ib_user_ioctl_verbs.h        |  84 +++++
 include/uapi/rdma/rdma_user_ioctl.h            |  24 ++
 29 files changed, 1435 insertions(+), 88 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_ioctl.c
 create mode 100644 include/rdma/uverbs_ioctl.h
 create mode 100644 include/uapi/rdma/ib_user_ioctl_verbs.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
