From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [rdma-next,V2 0/6] IB/core: Add InfiniBand router support
Date: Thu, 19 May 2016 17:12:30 +0300
Message-ID: <1463667156-6518-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

InfiniBand has gone a long way in providing efficient large-scale
high performance connectivity. IB subnets have shown to scale to
tens of thousands of nodes, both in raw capacity and in management.

As demand for computing capacity increases, future clusters sizes might
exceed the number of addressable endpoints in a single IB subnet (around
40K nodes).

To accommodate such clusters, a routing layer with the same latencies
and bandwidth characteristics as switches is required. In addition, as
data center deployments evolve, it becomes beneficial to consolidate
resources across multiple clusters.

There are multiple applications for this technology such as computing
clusters which require access to a common storage infrastructure.
Routers enable such connectivity while reducing management complexity
and isolating intra-subnet faults.

In this patch set the forwarding between the IB subnets is performed
by including a GRH header.
The IB router's basic functionality includes:
 * Removal of current L2 LRH (local routing header)
 * Routing table lookup - using GID from GRH
 * Building new LRH according to the destination based on the routing table

In order to retrieve the destination GID, new resolution method was needed.
There is an assumption that rdmacm is used only between nodes in the same
IB subnet, this is why ARP resolution can be used to turn IP to GID in rdmacm.

When dealing with IB communication between subnets this assumption
is no longer valid. ARP resolution will get us the next hop device
address and not the peer node's device address.

To solve this issue, we will check user space if it can provide the
GID of the peer node, and fail if not. For doing so, we added a new
RDMA local service operation (IP to GID resolution) and a sequence number
to identify each request. The client request would include the ifindex
of the outgoing interface and attributes which indicate the destination IP.
The local service would answer with the requested destination GID.

Changes from V0:
1. Remove the commit that turned netlink into a kernel module.
2. Intergrade ib_addr module into ib_core.
Changes from V1:
1. Remove dynamic ibnl client registration.
2. Intergrade ib_mad module into ib_core module.
3. Intergrade ib_sa module into ib_core module.
4. Move SA ibnl client registration to ib_core.
5. Move ib_addr ibnl registration to ib_core, intergrade
   it with the SA ibnl client to make a single RDMA_NL_LS
   client.
6. Minor code cleanups in the IP to GID netlink offload patch.

Leon Romanovsky (1):
  IB/core: Integrate IB address resolution module into core

Mark Bloch (5):
  IB/MAD: Integrate ib_mad module into ib_core module
  IB/SA: Integrate ib_sa module into ib_core module
  IB/netlink: Add a new local service operation
  IB/core: Register SA ibnl client during ib_core initialization
  IB/core: Add IP to GID netlink offload

 drivers/infiniband/core/Makefile    |  12 +-
 drivers/infiniband/core/addr.c      | 226 +++++++++++++++++++++++++++++++-----
 drivers/infiniband/core/core_priv.h |  16 +++
 drivers/infiniband/core/device.c    |  58 +++++++++
 drivers/infiniband/core/mad.c       |  13 +--
 drivers/infiniband/core/sa_query.c  |  38 ++----
 include/uapi/rdma/rdma_netlink.h    |  10 ++
 7 files changed, 291 insertions(+), 82 deletions(-)

-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
