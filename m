From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/4] IB/core: Add InfiniBand router support
Date: Wed,  4 May 2016 18:41:54 +0300
Message-ID: <1462376518-6725-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

InfiniBand has gone a long way in providing efficient large-scale
high performance connectivity. IB subnets have shown to scale to
tens of thousands of nodes, both in raw capacity and in management.

As demand for computing capacity increases, future clusters sizes might
exceed the number of addressable endpoints in a single IB subnet (aroun=
d
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
The IB router=E2=80=99s basic functionality includes:
 * Removal of current L2 LRH (local routing header)
 * Routing table lookup =E2=80=93 using GID from GRH
 * Building new LRH according to the destination based on the routing t=
able

In order to retrieve the destination GID, new resolution method was nee=
ded.
There is an assumption that rdmacm is used only between nodes in the sa=
me
IB subnet, this is why ARP resolution can be used to turn IP to GID in =
rdmacm.

When dealing with IB communication between subnets this assumption
is no longer valid. ARP resolution will get us the next hop device
address and not the peer node's device address.

To solve this issue, we will check user space if it can provide the
GID of the peer node, and fail if not. For doing so, we added a new
RDMA local service operation (IP to GID resolution) and a sequence numb=
er
to identify each request. The client request would include the ifindex
of the outgoing interface and attributes which indicate the destination=
 IP.
The local service would answer with the requested destination GID.

Available in the "topic/ib-router" topic branch of this git repo:

git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:

https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/ib-router

It is tested after applying topic/fix-core and topic/ipoib-device-addre=
ss.

Thanks

Mark Bloch (4):
  IB/netlink: Make ib_netlink a standalone module
  IB/netlink: Allow multiple clients to register under the same family
  IB/netlink: Add new local service operation
  IB/core: Add IP to GID netlink offload

 drivers/infiniband/core/Makefile   |   6 +-
 drivers/infiniband/core/addr.c     | 225 +++++++++++++++++++++++++++++=
++++----
 drivers/infiniband/core/cma.c      |   3 +-
 drivers/infiniband/core/device.c   |   9 --
 drivers/infiniband/core/iwcm.c     |   3 +-
 drivers/infiniband/core/netlink.c  |  46 ++++++--
 drivers/infiniband/core/sa_query.c |   2 +-
 include/rdma/rdma_netlink.h        |   7 +-
 include/uapi/rdma/rdma_netlink.h   |  10 ++
 9 files changed, 259 insertions(+), 52 deletions(-)

--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
