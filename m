From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 0/6] IP based RoCE GID Addressing
Date: Wed, 19 Jun 2013 10:47:05 +0300
Message-ID: <1371628031-17546-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, the IB stack (core + drivers) handle RoCE (IBoE) gids as
they encode related Ethernet net-device interface MAC address and 
possibly VLAN id.

This series changes RoCE GIDs to encode IP addresses (IPv4 + IPv6)
of the that Ethernet interface, under the following reasoning:

1. There are environments where the compute entity that runs the RoCE 
stack is not aware that its traffic is vlan-tagged. This results with that 
node to create/assume wrong GIDs from the view point of a peer node which 
is aware to vlans. 

Note that "node" here can be physical node connected to Ethernet switch acting in 
access mode talking to another node which does vlan insertion/stripping by itself.

Or another example is SRIOV Virtual Function which is configured to work in "VST" 
mode (Virtual-Switch-Tagging) such that the hypervisor configures the HW eSWitch 
to do vlan insertion for the vPORT representing that function.

2. When RoCE traffic is inspected (mirrored/trapped) in Ethernet switches for 
monitoring and security purposes. It is much more natural for both humans and 
automated utilities (...) to observe IP addresses in a certain offset into RoCE 
frames L3 header vs. MAC/VLANs (which are there anyway in the L2 header of that 
frame, so they are not gone by this change).

3. Some Bonding/Teaming advanced mode such as balance-alb and balance-tlb 
are using multiple underlying devices in parallel, and hence packets always 
carry the bond IP address but different streams have different source MACs.
The approach brought by this series is part from what would allow to 
support that for RoCE traffic too.

The 1st patch modified the IB core to cope with the new scheme, and the 2nd/3rd ones
do that for the mlx4_ib driver. The 4th patch sets the foundation for extending uverbs to
the new scheme which was introduced lately, and the 5th/6th patches add two extended
uCMA commands and two extended uVERBS commands which are now exported to user space.

These extended verbs will allow to enhance user space libraries such that they work 
OK over the modified scheme. All RC applications using librdmacm will not need to be 
modified at all, since the change will be encapsulated into that library.

The ocrdma driver needs to go through a similar patch as the mlx4_ib one, we can
surely do that patch, just need to dig there a little further. 

Or.

changes from V0:

 - enhanced docuementation of the mlx4_ib, uverbs and ucma patches
 - broke the mlx4_ib patch to two
 - broke the extended user space commands patch to two


Igor Ivanov (1):
  IB/core: Infra-structure to support verbs extensions through uverbs

Matan Barak (2):
  IB/core: Add RoCE IP based addressing extensions for uverbs
  IB/core: Add RoCE IP based addressing extensions for rdma_ucm

Moni Shoua (3):
  IB/core: RoCE IP based GID addressing
  IB/mlx4: Use RoCE IP based GIDs in the port GID table
  IB/mlx4: Handle Ethernet L2 parameters for IP based GID addressing

 drivers/infiniband/core/cm.c              |    3 +
 drivers/infiniband/core/cma.c             |   39 ++-
 drivers/infiniband/core/sa_query.c        |    5 +
 drivers/infiniband/core/ucma.c            |  190 +++++++++++--
 drivers/infiniband/core/uverbs.h          |    2 +
 drivers/infiniband/core/uverbs_cmd.c      |  330 ++++++++++++++++-----
 drivers/infiniband/core/uverbs_main.c     |   33 ++-
 drivers/infiniband/core/uverbs_marshall.c |   94 ++++++-
 drivers/infiniband/core/verbs.c           |    7 +
 drivers/infiniband/hw/mlx4/ah.c           |   21 +-
 drivers/infiniband/hw/mlx4/cq.c           |    5 +
 drivers/infiniband/hw/mlx4/main.c         |  461 ++++++++++++++++++++---------
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |    3 +
 drivers/infiniband/hw/mlx4/qp.c           |   19 +-
 include/linux/mlx4/cq.h                   |   14 +-
 include/rdma/ib_addr.h                    |   45 ++--
 include/rdma/ib_marshall.h                |   12 +
 include/rdma/ib_sa.h                      |    3 +
 include/rdma/ib_verbs.h                   |    4 +
 include/uapi/rdma/ib_user_sa.h            |   34 ++-
 include/uapi/rdma/ib_user_verbs.h         |  130 ++++++++-
 include/uapi/rdma/rdma_user_cm.h          |   21 ++-
 22 files changed, 1157 insertions(+), 318 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
