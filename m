From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv8 0/11] IBoE support to Infiniband
Date: Thu, 18 Feb 2010 19:23:24 +0200
Message-ID: <20100218172324.GA12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IBoE allows running the IB transport protocol using Ethernet frames, enabling
the deployment of IB semantics on lossless Ethernet fabrics.

IBoE packets are standard Ethernet frames with an IEEE assigned Ethertype, a
GRH, unmodified IB transport headers and payload.  IB subnet management and SA
services are not required for IBoE operation; Ethernet management practices are
used instead. IBoE encodes IP addresses into its GIDs and resolves MAC
addresses using the host IP stack. For multicast GIDs, standard IP to MAC
mappings apply.

The OFA RDMA Verbs API is syntactically unmodified. The CMA is adapted to
support IBoE ports allowing existing RDMA applications to run over IBoE with no
changes.

Address handles for IBoE are required to contain valid L3 addresses (GIDs) and
the IB L2 address fields become reserved. The complementary Ethernet L2 address
information is subsequently resolved below the API.

As there is no SA in IBoE, the CMA code is adapted to locally fill-in
corresponding path record attributes for IBoE address handles. Also, the CMA
provides the required address handle attributes for SIDR requests and joining
of multicast groups.

With this patch set, each IBoE port is assigned a GID equal to the link local
address of its corresponding net device, and one more GID for each one of the
VLAN devices which are derived from it. iboe packets are tagged with the VLAN
ID of the corresponding netdevice through which they are generated.

The priority field in the 802.1q header of IBoE packets is derived from the SL
field in the address vector. rdma_cm applications can set the TOS value of the
rdma_cm_id object through the rdma_set_option() API which then maps to SL.

With these patches, IBoE multicast frames may be broadcast as there is
currently no use of a L2 multicast group membership protocol.

To enable IBoE with the mlx4 driver stack, both the mlx4_en and mlx4_ib drivers
must be loaded, and the netdevice for the corresponding IBoE port must be
running. Individual ports of a multi port HCA can be independently configured
as Ethernet (with support for IBoE) or as IB, as it was already the case.

We have successfully tested MPI, SDP, RDS, and native Verbs applications over
IBoE.

Following is a series of 11 patches based on Roland's for-next branch.  This
new series reflects changes based on feedback from the community on the
previous patch set.

Changes from v7
1. Rebase on 2.6.33-rc3
2. Add VLAN support
3. Bug fixes and improvements (see in the patches changelog).

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---


 drivers/infiniband/core/agent.c           |   37 +
 drivers/infiniband/core/cm.c              |    5 
 drivers/infiniband/core/cma.c             |  287 ++++++++++++++-
 drivers/infiniband/core/mad.c             |   27 +
 drivers/infiniband/core/multicast.c       |   25 +
 drivers/infiniband/core/sa_query.c        |   46 +-
 drivers/infiniband/core/ucma.c            |   54 ++
 drivers/infiniband/core/ud_header.c       |  129 +++++-
 drivers/infiniband/core/user_mad.c        |   11 
 drivers/infiniband/core/uverbs.h          |    1 
 drivers/infiniband/core/uverbs_cmd.c      |   33 +
 drivers/infiniband/core/uverbs_main.c     |    1 
 drivers/infiniband/core/verbs.c           |   26 +
 drivers/infiniband/hw/mlx4/ah.c           |  196 ++++++++--
 drivers/infiniband/hw/mlx4/mad.c          |   32 +
 drivers/infiniband/hw/mlx4/main.c         |  557 ++++++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |   35 +
 drivers/infiniband/hw/mlx4/qp.c           |  180 +++++++--
 drivers/infiniband/hw/mthca/mthca_qp.c    |    2 
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    7 
 drivers/net/mlx4/en_main.c                |   15 
 drivers/net/mlx4/en_netdev.c              |   10 
 drivers/net/mlx4/en_port.c                |    4 
 drivers/net/mlx4/en_port.h                |    3 
 drivers/net/mlx4/fw.c                     |    3 
 drivers/net/mlx4/intf.c                   |   20 +
 drivers/net/mlx4/main.c                   |    6 
 drivers/net/mlx4/mlx4.h                   |    1 
 drivers/net/mlx4/mlx4_en.h                |    1 
 drivers/net/mlx4/port.c                   |   19 +
 include/linux/mlx4/cmd.h                  |    1 
 include/linux/mlx4/device.h               |   32 +
 include/linux/mlx4/driver.h               |   16 
 include/linux/mlx4/qp.h                   |    9 
 include/rdma/ib_addr.h                    |  139 +++++++
 include/rdma/ib_pack.h                    |   28 +
 include/rdma/ib_sa.h                      |    3 
 include/rdma/ib_user_verbs.h              |   22 +
 include/rdma/ib_verbs.h                   |   29 +
 39 files changed, 1813 insertions(+), 239 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
