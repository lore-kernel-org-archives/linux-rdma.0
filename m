From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 00/10] IB SR-IOV support
Date: Mon,  7 Mar 2016 23:08:50 +0200
Message-ID: <1457384940-11951-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug, Dave

The following series adds support for managing SRIOV IB VFs in a standard
way (rtnetlink, iproute2) through IPoIB ndo entries which translate to
corresponding verbs calls.

In IB networks, 64 bit GUIDs are used as the primary means of identification.
To support that for VFs, we added a set_vf_guid ndo which is used to program
the VF node and port GUID from the PF.

Those verbs are implemented by the mlx5 driver along with some more changes
needed in the driver, IPoIB and the IB core to support IB virtualization.

We've copied netdev only on the 1st patch of the series, as the rest of it just
uses the patch along with the existing ndos in IPoIB plus add things which
are internal to the IB stack.

The series is rebased against Doug's mlx5 branch and Leon's patch that extends
the kernel ib device attr caps field to u64:
https://patchwork.kernel.org/patch/8388931/

Eli

Changes from V0:
1. Remove the option to configure GUIDs through setting VF MAC.
2. Added a subnet_prefix field to struct ib_port_attr and implement for all
   hardware drivers.
3. Fixed SA AH creation to use queried subnet prefix
4. Modified conditional on interface_id from memcpy to plain comparison.
5. Removed "IB/core: Use GRH when the path hop-limit > 0" from the series as it
   was already accepted.
6. Rebased the series on Doug's mlx5 branch on top of 318d311e8f01 "(origin/mlx5)
   iser: Accept arbitrary sg lists mapping if the device supports it"


Eli Cohen (10):
  net/core: Add support for configuring VF GUIDs
  IB/mlx5: Fix decision on using MAD_IFC
  IB/core: Add subnet prefix to port info
  IB/core: Support accessing SA in virtualized environment
  IB/core: Add interfaces to control VF attributes
  IB/ipoib: Add ndo operations for configuring VFs
  net/mlx5_core: Add VF param when querying vport counter
  net/mlx5_core: Implement modify HCA vport command
  IB/mlx5: Implement callbacks for manipulating VFs
  IB/ipoib: Allow mcast packets from other VFs

 drivers/infiniband/core/device.c                |   1 +
 drivers/infiniband/core/sa_query.c              |   5 +
 drivers/infiniband/core/verbs.c                 |  40 +++++
 drivers/infiniband/hw/cxgb3/iwch_provider.c     |   7 +
 drivers/infiniband/hw/cxgb4/provider.c          |   7 +
 drivers/infiniband/hw/mlx4/main.c               |   1 +
 drivers/infiniband/hw/mlx5/Makefile             |   2 +-
 drivers/infiniband/hw/mlx5/ib_virt.c            | 194 ++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mad.c                |   3 +-
 drivers/infiniband/hw/mlx5/main.c               |  21 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h            |   8 +
 drivers/infiniband/hw/mthca/mthca_provider.c    |   1 +
 drivers/infiniband/hw/nes/nes_verbs.c           |   7 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c     |   7 +
 drivers/infiniband/hw/qib/qib_verbs.c           |   7 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c    |   7 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c         |  27 +++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c       |  65 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c   |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/vport.c |  72 ++++++++-
 include/linux/mlx5/driver.h                     |   5 +-
 include/linux/mlx5/mlx5_ifc.h                   |   6 +
 include/linux/mlx5/vport.h                      |   7 +-
 include/linux/netdevice.h                       |   3 +
 include/rdma/ib_verbs.h                         |  25 +++
 include/uapi/linux/if_link.h                    |   7 +
 net/core/rtnetlink.c                            |  36 +++++
 27 files changed, 561 insertions(+), 16 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/ib_virt.c

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
