From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv7 0/9] RoCEE support to Infiniband
Date: Tue, 5 Jan 2010 12:32:13 +0200
Message-ID: <20100105103213.GB31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RoCEE (pronounced =E2=80=98rocky=E2=80=99) allows running the IB transp=
ort protocol
using Ethernet frames, enabling the deployment of IB semantics on
lossless Ethernet fabrics.

RoCEE packets are standard Ethernet frames with an IEEE assigned
Ethertype, a GRH, unmodified IB transport headers and payload.  IB
subnet management and SA services are not required for RoCEE
operation; Ethernet management practices are used instead. RoCEE
encodes IP addresses into its GIDs and resolves MAC addresses using
the host IP stack. For multicast GIDs, standard IP to MAC mappings
apply.

The OFA RDMA Verbs API is syntactically unmodified. The CMA is adapted
to support RoCEE ports allowing existing RDMA applications to run over
RoCEE with no changes.

Address handles for RoCEE are required to contain valid L3 addresses
(GIDs) and the IB L2 address fields become reserved. The complementary
Ethernet L2 address information is subsequently resolved below the
API.=20

As there is no SA in RoCEE, the CMA code is adapted to locally fill-in
corresponding path record attributes for RoCEE address handles. Also,
the CMA provides the required address handle attributes for SIDR
requests and joining of multicast groups.=20

With this patch set, a RoCEE port is currently assigned a single GID,
encoding the IPv6 link-local address of the corresponding netdev; the
CMA RoCEE code temporarily uses these IPv6 link-local addresses as
GIDs instead of the IP address provided by the user.=20

Support for host VLAN tagged packets and setting of the user prio on
RoCEE frames will be added in the near future. Also, with these
patches, RoCEE multicast frames may be broadcast as there is currently
no use of a L2 multicast group membership protocol.

To enable RoCEE with the mlx4 driver stack, both the mlx4_en and
mlx4_ib drivers must be loaded, and the netdevice for the
corresponding RoCEE port must be running. Individual ports of a multi
port HCA can be independently configured as Ethernet (with support for
RoCEE) or IB, as is already the case.

We have successfully tested MPI, SDP, RDS, and native Verbs
applications over RoCEE.

=46ollowing is a series of 9 patches based on Roland's for-next branch.
This new series reflects changes based on feedback from the community
on the previous patch set.

Changes from v6:
1. Rebase on 2.6.32-rc6.
2. Fix loopback support.
3. Undo ABI version bumping.
4. Use the notion of 'link layer' attribute for ports instead of 'port
transport'.


Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---

 drivers/infiniband/core/agent.c           |   37 +-
 drivers/infiniband/core/cma.c             |  261 +++++++++++++++
 drivers/infiniband/core/mad.c             |   66 ++-
 drivers/infiniband/core/multicast.c       |   25 +
 drivers/infiniband/core/sa_query.c        |   39 +-
 drivers/infiniband/core/ucma.c            |   45 ++
 drivers/infiniband/core/ud_header.c       |  111 ++++++
 drivers/infiniband/core/user_mad.c        |   11=20
 drivers/infiniband/core/uverbs.h          |    1=20
 drivers/infiniband/core/uverbs_cmd.c      |   32 +
 drivers/infiniband/core/uverbs_main.c     |    1=20
 drivers/infiniband/core/verbs.c           |   25 +
 drivers/infiniband/hw/mlx4/ah.c           |  178 ++++++++--
 drivers/infiniband/hw/mlx4/mad.c          |   32 +
 drivers/infiniband/hw/mlx4/main.c         |  497 +++++++++++++++++++++=
++++++---
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |   34 +-
 drivers/infiniband/hw/mlx4/qp.c           |  194 ++++++++---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    5=20
 drivers/net/mlx4/en_main.c                |   15=20
 drivers/net/mlx4/en_port.c                |    4=20
 drivers/net/mlx4/en_port.h                |    3=20
 drivers/net/mlx4/fw.c                     |    3=20
 drivers/net/mlx4/intf.c                   |   20 +
 drivers/net/mlx4/main.c                   |    6=20
 drivers/net/mlx4/mlx4.h                   |    1=20
 include/linux/mlx4/cmd.h                  |    1=20
 include/linux/mlx4/device.h               |   31 +
 include/linux/mlx4/driver.h               |   16=20
 include/linux/mlx4/qp.h                   |    6=20
 include/rdma/ib_addr.h                    |   98 +++++
 include/rdma/ib_pack.h                    |   26 +
 include/rdma/ib_user_verbs.h              |   19 +
 include/rdma/ib_verbs.h                   |   24 +
 33 files changed, 1639 insertions(+), 228 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
