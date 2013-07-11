From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 0/8] IP based RoCE GID Addressing
Date: Thu, 11 Jul 2013 18:40:41 +0300
Message-ID: <1373557249-20374-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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

The 1st patch adds explicit handling of Ethernet L2 attributes, source/dest 
mac and vlan_id to the kernel IB core, in data-structures and CMA/CM code. 
Previously, with MAC/VLAN based addressing, they were encoded in the GIDs, 
where now they have to be resolved and placed separately from the IP based GIDs.

The 2nd patch modifies the CMA to cope with IP based GIDs, the 3rd/4th ones do 
that for the mlx4_ib driver.  

The 5th patch sets the foundation for extending uverbs to the new scheme which 
was introduced lately, and the 6th/7th patches add two extended uverbs and 
respectively two extended ucma commands which are now exported to user space.
The last patch denotes mlx4 support for the uverbs extended modify qp command.

These extended verbs will allow to enhance user space libraries such that they work 
OK over the modified scheme. All RC applications using librdmacm will not need to be 
modified at all, since the change will be encapsulated into that library.

Or.

changes from V1:

 - rebased the series against the latest kernel bits, which include Sean's 
   AF_IB changes to the rdma-cm
 
 - fixed bug in mlx4_ib where reset of the gid table was done for IB ports too
 
 - fixed build warnings and issues pointed by sparse

 - introduced patch #1 which does the explicit handling of Ethernet L2 attributes, 
   source/dest mac and vlan_id in the kernel data-structures and CMA/CM code. 

 - use smac when modifying a QP --> find smac in passive side + additional fields 
   to adress structures

 - add support to new QP atrr in ib_modify_qp_is_ok() special for ll = ETH
  and modified all low-level drivers to keep working after that change

 -- changes around uverbs:
 - use ah_ext as pointer in qp_attr passed from user space, so this 
   field by itself can be extended in the future
 - for kernel to user command respnses comp_mask is moved into the 
   right place which is after the non-extended command respond fields
 - fixed bug in copy_qp_attr_ex under which some fields were copied to
   wrong locations
 - use new structure rdma_ucm_init_qp_attr_ex which is extendable (ucma)

changes from V0:

 - enhanced documentation of the mlx4_ib, uverbs and ucma patches
 - broke the mlx4_ib patch to two
 - broke the extended user space commands patch to two

Igor Ivanov (1):
  IB/core: Infra-structure to support verbs extensions through uverbs

Matan Barak (4):
  IB/core: Ethernet L2 attributes in verbs/cm structures
  IB/core: Add RoCE IP based addressing extensions for uverbs
  IB/core: Add RoCE IP based addressing extensions for rdma_ucm
  IB/mlx4: Enable mlx4_ib support for MODIFY_QP_EX

Moni Shoua (3):
  IB/CMA: RoCE IP based GID addressing
  IB/mlx4: Use RoCE IP based GIDs in the port GID table
  IB/mlx4: Handle Ethernet L2 parameters for IP based GID addressing

 drivers/infiniband/core/cm.c                |   58 ++++
 drivers/infiniband/core/cma.c               |   85 ++++-
 drivers/infiniband/core/sa_query.c          |    8 +-
 drivers/infiniband/core/ucma.c              |  193 ++++++++++-
 drivers/infiniband/core/uverbs.h            |    2 +
 drivers/infiniband/core/uverbs_cmd.c        |  359 ++++++++++++++++-----
 drivers/infiniband/core/uverbs_main.c       |   33 ++-
 drivers/infiniband/core/uverbs_marshall.c   |  128 +++++++-
 drivers/infiniband/core/verbs.c             |   29 ++-
 drivers/infiniband/hw/ehca/ehca_qp.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_qp.c      |    2 +-
 drivers/infiniband/hw/mlx4/ah.c             |   24 +-
 drivers/infiniband/hw/mlx4/cq.c             |    6 +
 drivers/infiniband/hw/mlx4/main.c           |  479 +++++++++++++++++++--------
 drivers/infiniband/hw/mlx4/mlx4_ib.h        |    3 +
 drivers/infiniband/hw/mlx4/qp.c             |   98 +++++-
 drivers/infiniband/hw/mlx5/qp.c             |    3 +-
 drivers/infiniband/hw/mthca/mthca_qp.c      |    3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    3 +-
 drivers/infiniband/hw/qib/qib_qp.c          |    2 +-
 drivers/net/ethernet/mellanox/mlx4/port.c   |   20 ++
 include/linux/mlx4/cq.h                     |   15 +-
 include/linux/mlx4/device.h                 |    1 +
 include/rdma/ib_addr.h                      |   61 +++-
 include/rdma/ib_cm.h                        |    1 +
 include/rdma/ib_marshall.h                  |   12 +
 include/rdma/ib_pack.h                      |    1 +
 include/rdma/ib_sa.h                        |    3 +
 include/rdma/ib_verbs.h                     |   20 +-
 include/uapi/rdma/ib_user_sa.h              |   34 ++-
 include/uapi/rdma/ib_user_verbs.h           |  170 ++++++++++-
 include/uapi/rdma/rdma_user_cm.h            |   29 ++-
 32 files changed, 1546 insertions(+), 341 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
