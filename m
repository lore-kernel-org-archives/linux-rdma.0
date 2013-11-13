From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V5 0/8] IP based RoCE GID Addressing
Date: Thu, 14 Nov 2013 00:29:44 +0200
Message-ID: <1384381792-2023-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

changes from V4:

 - addressed feedback re the need to be compatible with non modified user
   space applications/libraries, by adding code in uverbs which does address
   resolution when dealing with Ethernet ports. This is patch #7  

 - removed the patches that deal with uverbs extended commands, they will
   added later on, such that new applications/libraries can be coded to them.
  
 - added patch fixing mlx4_en to have correct IPv6 link local address.

See below full listing of change-history.

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
that for the mlx4_ib driver, and the 5th/6th patches to the ocrdma driver. 

The 7th patch adds address resolution to user space applications for RoCE 
ports such that these application keep working unmodified.

The 8th/last patch fixes the mlx4_en driver such that it has correct IPv6 link local address.

Or.

Full listing of change-history:

changes from V4:

 - addressed feedback re the need to be compatible with non modified user
   space applications/libraries, by adding code in uverbs which does address
   resolution when dealing with Ethernet ports.  

 - removed the patches that deal with uverbs extended commands, they will
   added later on, such that new applications/libraries can be coded to them.
  
changes from V3:

  - dropped the uverbs Infrastructure patch for extensions which is now upstream
    400dbc9 "IB/core: Infrastructure for extensible uverbs commands"

  - added ocrdma patch to handle Ethernet L2 parameters, similar to the mlx4 patch.
   
  - removed the assumption that the low level driver can provide the source mac
    and vlan in the struct ib_wc returned by ib_poll_cq, and adjusted the 
    ib_init_ah_from_wc helper of the IB core accordingly.

  - fixed some vlan related issues in the mlx4 driver

changes from V2:

  - added handling of IP based GIDs in the ocrdma driver - patch #5, 
    as a result patches #5-8 of V1 became patches #6-9
  
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

Matan Barak (1):
  IB/core: Ethernet L2 attributes in verbs/cm structures

Moni Shoua (7):
  IB/CMA: IBoE (RoCE) IP based GID addressing
  IB/mlx4: Use IBoE (RoCE) IP based GIDs in the port GID table
  IB/mlx4: Handle Ethernet L2 parameters for IP based GID addressing
  IB/ocrdma: Handle Ethernet L2 parameters for IP based GID addressing
  IB/ocrdma: Populate GID table with IP based gids
  IB/uverbs: Resolve Ethernet L2 addresses when modifying QP
  mlx4_en: Avoid setting netdevice dev_id to port number

 drivers/infiniband/core/addr.c                 |   97 +++++-
 drivers/infiniband/core/cm.c                   |   50 +++
 drivers/infiniband/core/cma.c                  |   74 +++-
 drivers/infiniband/core/sa_query.c             |   12 +-
 drivers/infiniband/core/ucma.c                 |   18 +-
 drivers/infiniband/core/uverbs_cmd.c           |   27 ++
 drivers/infiniband/core/verbs.c                |   43 ++-
 drivers/infiniband/hw/ehca/ehca_qp.c           |    2 +-
 drivers/infiniband/hw/ipath/ipath_qp.c         |    2 +-
 drivers/infiniband/hw/mlx4/ah.c                |   40 +--
 drivers/infiniband/hw/mlx4/cq.c                |    9 +
 drivers/infiniband/hw/mlx4/main.c              |  474 +++++++++++++++++-------
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |    6 +-
 drivers/infiniband/hw/mlx4/qp.c                |  104 ++++-
 drivers/infiniband/hw/mlx5/qp.c                |    3 +-
 drivers/infiniband/hw/mthca/mthca_qp.c         |    3 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h          |   12 +
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c       |    5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c       |   21 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h       |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_main.c     |  138 ++-----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |    3 +-
 drivers/infiniband/hw/qib/qib_qp.c             |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    1 -
 drivers/net/ethernet/mellanox/mlx4/port.c      |   20 +
 include/linux/mlx4/cq.h                        |   15 +-
 include/linux/mlx4/device.h                    |    1 +
 include/rdma/ib_addr.h                         |   69 +++-
 include/rdma/ib_cm.h                           |    1 +
 include/rdma/ib_pack.h                         |    1 +
 include/rdma/ib_sa.h                           |    3 +
 include/rdma/ib_verbs.h                        |   21 +-
 32 files changed, 894 insertions(+), 384 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
