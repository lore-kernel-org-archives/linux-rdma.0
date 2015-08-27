From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v6 0/4] Add network namespace support in the RDMA-CM
Date: Thu, 27 Aug 2015 17:29:28 +0300
Message-ID: <1440685772-14076-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Now that the code for demuxing requests is inside rdma_cm, here are the patches
to add InfiniBand network namespace again.

Changes from v5:
- removed patches that got in as part of the cleanup series.

RDMA-CM uses IP based addressing and routing to setup RDMA connections between
hosts. Currently, all of the IP interfaces and addresses used by the RDMA-CM
must reside in the init_net namespace. This restricts the usage of containers
with RDMA to only work with host network namespace (aka the kernel init_net NS
instance).

This patchset allows using network namespaces with the RDMA-CM.

Each RDMA-CM id keeps a reference to a network namespace.

This reference is based on the process network namespace at the time of the
creation of the object or inherited from the listener.

This network namespace is used to perform all IP and network related
operations. Specifically, the local device lookup, as well as the remote GID
address resolution are done in the context of the RDMA-CM object's namespace.
This allows outgoing connections to reach the right target, even if the same
IP address exists in multiple network namespaces. This can happen if each
network namespace resides on a different P_Key.

Additionally, the network namespace is used to split the listener port space
tables. From the user point of view, each network namespace has a unique,
completely independent tables for its port spaces. This allows running multiple
instances of a single service on the same machine, using containers. 

The functionality introduced by this series would come into play when the
transport is InfiniBand and IPoIB interfaces are assigned to each namespace.
Multiple IPoIB interfaces can be created and assigned to different RDMA-CM
capable containers, for example using pipework [1].

The patches apply against Doug's to-be-rebased tree for v4.3.

The patchset is structured as follows:

Patch 1 is a relatively trivial API extension, requiring the callers
of certain ib_addr functions to provide a network namespace, as needed.

Patches 2-4 add proper namespace support to the RDMA-CM module. This
includes adding multiple port space tables, adding a network namespace
parameter, and finally retrieving the namespace from the creating process.

[1] https://github.com/jpetazzo/pipework/pull/108

Guy Shapiro (3):
  IB/addr: Pass network namespace as a parameter
  IB/cma: Add support for network namespaces
  IB/ucma: Take the network namespace from the process

Haggai Eran (1):
  IB/cma: Separate port allocation to network namespaces

 drivers/infiniband/core/addr.c                     |  17 +--
 drivers/infiniband/core/cma.c                      | 129 +++++++++++++++------
 drivers/infiniband/core/ucma.c                     |   4 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |   2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   2 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |   4 +-
 include/rdma/ib_addr.h                             |  16 ++-
 include/rdma/rdma_cm.h                             |   6 +-
 net/9p/trans_rdma.c                                |   4 +-
 net/rds/ib.c                                       |   2 +-
 net/rds/ib_cm.c                                    |   2 +-
 net/rds/iw.c                                       |   2 +-
 net/rds/iw_cm.c                                    |   2 +-
 net/rds/rdma_transport.c                           |   4 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   4 +-
 net/sunrpc/xprtrdma/verbs.c                        |   3 +-
 16 files changed, 142 insertions(+), 61 deletions(-)

-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
