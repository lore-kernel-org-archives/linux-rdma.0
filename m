From: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v2 for-next 00/32] RoCE V1/v2 per GID
Date: Fri, 20 Mar 2015 04:00:04 +0000
Message-ID: <7F44EA5110810A40B7DAFB605C41975D58F881AC@CMEXMB1.ad.emulex.com>
References: <ff2e835e-e74f-4093-a7a5-cf3d7ce523a6@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ff2e835e-e74f-4093-a7a5-cf3d7ce523a6-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,
                Could you please chime in on this patch series? Its been more than a week since we sent out V2?
Thanks 
Som

________________________________________
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] on behalf of Somnath Kotur [somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org]
Sent: Wednesday, March 11, 2015 10:25 AM
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Somnath Kotur
Subject: [PATCH v2 for-next 00/32] RoCE V1/v2 per GID

Hi Roland,

This patch series was created out of collaboration between Emulex and Mellanox.
While Emulex sent out the RoCEV2 patch first to the community, Mellanox which
was also working on some core infrastructure changes from the ground-up towards
RoCEV2 felt that the RoCEV2 patch would be better served if done on top of
their basic infrastructure changes to associate entities like MAC, VLAN,
IP Address with GIDs and thereby move GID Table Management from HW Vendor
drivers to IB/Core.
This patchset is the result of joint development effort between the two teams.

RoCE per GID patch-set aims to introduce RoCE V2 GID type while
maintaining compatibility with RoCE V1. This is done by adding
a type attribute for every GID type in addition to the required
extra net device attribute required for RoCE V2. Previously,
every vendor implemented its net device notifiers in its own
driver. This introduces a huge code duplication as figuring
whether the event is related to the vendor's net device in the
various cases (bonding, vlan or any other upper device) is
similar for all vendors. Introducing multiple GID types and other
attributes would have made this code duplication even worse. Therefore,
we decided moving this into a common core core. roce_gid_cache and
roce_gid_mgmt were created in order to store and manage
the new GID table, by filling it when getting the related events.
Vendors now only have to implement modify_gid and get_netdev IB
device calls, which are truly unique for each vendor.
Patch 0001 creates a new infrastructure for storing GIDs and their attributes
in IB/core. This infrastructure support lock-less read of GIDs using a
sequence number. The data structure is initialized only for RoCE ports.
Every gid has meta information describes its related net device and its
type.

Patch 0002 adds a reference count mechanism to IB devices. This mechanism
is similar to dev_hold and dev_put available for net devices. This is
mandatory for later patches as IB clients might want to wait for its
work to complete in the device removal function, but a work might
traverse the device list. This might cause a dead lock, as the removal
function grabbed the device lock and in turn it waits for the client's work
which wants to grab the device mutex as well.

Patches 0003, 0004 and 0006 add population of this table for various cases
based on net device events. We always enable default gids for an active
device (an active device is defined here as a device that doesn't have
a bonding master or is the current active slave). This is done in order
to allow loopback traffic. Patch 0005 adds proper bonding support -
only the active slaves retain their master's IP based gids and default gids.

This whole concept needs to fit the existing sysfs model, thus patch 0008
adds sysfs entries that represent the net device and gid type related to
each gid.

Patch 0009 adds a new API for RoCE gid cache lookup. Since users might
want to find a GID which matches a net device with a specific attributes,
the new API allows them to pass a filter function. This function is a bit
slower than the "regular" find by gid, gid_type, if_index and namespace -
thus it should be used only when necessary.

Patches 0007, 0010, 0011 and 0012 changes the rest of IB/core to fit the new
model. Instead of storing smac and vlan, we store either if_index, gid
and gid_type or sgid_index. Either set suffices in order to resolve all
the required Ethernet parameters. ib_init_ah_from_wc was changed, such
that when a wc is arrived, we search our RoCE gid cache in order to
find a suitable sgid_index that matches the net device. Matching is
done based on GID and VLAN.

Patch 0013 is used in order to configure the default mode of the cma.
In order to avoid changing existing rdma-cm applications, we adds a
configfs that states for each ib device what's the default RoCE mode.

Patch 0014 is the post refactored version of the original RoCE V2 patch from Emulex
that now mainly corrects the hop limit value and adds a hint about
RoCE type based on whether we have a gateway. This is the patch that
makes it possible for applications to seamlessly interop between RoCE V1
and V2 without undergoing any changes themselves.

Patch 0029 deals with serializing QP1 packets for software based
QP1 and the last patch handles joining and leaving IGMP groups
for RoCE V2 multicast functionality.

The rest of the patches add support for ocrdma and mlx4 devices.

This series depends on RoCE LAG series (already accepted in net-next tree).

Thanks,
Devesh, Somnath, Moni and Matan

Changes from V1:
(1) Addressed Shachar and Haggai's comments
(2) Fixed multicast support
(3) Generalized bonding support
(4) Added default GID after the IB device's net device was removed from bonding
(5) Fixed bugs in mlx4 implementation regarding multicast
(6) Fixed bugs in mlx4 when using XRC QPs after this patchset was applied
(7) Fixed bug when the RoCE gid cache didn't exist
(8) Moved the bonding's DRV macros to a private header
(9) Support non-configfs configurations

Devesh Sharma (3):
  RDMA/ocrdma: changes to support RoCE-v2 in UD path
  RDMA/ocrdma: changes to support RoCE-v2 in RC path
  RDMA/ocrdma: changes to support user AH creation

Maor Gottlieb (1):
  net/mlx4_core: Add handlning of R-RoCE over IPV4 in qp attach flow

Matan Barak (13):
  IB/core: Add RoCE GID cache
  IB/core: Add kref to IB devices
  IB/core: Add RoCE GID population
  IB/core: Add default GID for RoCE GID Cache
  net/bonding: make DRV macros private
  IB/core: Add RoCE cache bonding support
  IB/core: GID attribute should be returned from verbs API and cache API
  IB/core: Report gid_type and gid_ndev through sysfs
  IB/core: Support find sgid index using a filter function
  IB/core: Modify ib_verbs and cma in order to use roce_gid_cache
  IB/core: Add gid_type to path and rdma_id_private
  IB/core: Add rdma_network_type to wc
  IB/cma: Add configfs for rdma_cm

Moni Shoua (13):
  IB/mlx4: Remove gid table management for RoCE
  IB/mlx4: Replace spin_lock with rw_semaphore
  IB/mlx4: Lock with RCU instead of RTNL
  net/mlx4: Postpone the registration of net_device
  IB/mlx4: Advertise RoCE support in port capabilities
  IB/mlx4: Implement ib_device callback - get_netdev
  IB/mlx4: Implement ib_device callback - modify_gid
  IB/mlx4: Configure device to work in RoCEv2
  IB/mlx4: Translate cache gid index to real index
  IB/core: Initialize UD header structure with IP and UDP headers
  IB/mlx4: Enable send of RoCE QP1 packets with IP/UDP headers
  IB/mlx4: Create and use another QP1 for RoCEv2
  IB/cma: Join and leave multicast groups with IGMP

Somnath Kotur (2):
  IB/Core: Changes to the IB Core infrastructure for RoCEv2 support
  RDMA/ocrdma: Changes in driver to incorporate the moving of GID Table
    mgmt to IB/Core.

 drivers/infiniband/core/Makefile               |   5 +-
 drivers/infiniband/core/addr.c                 |  11 +-
 drivers/infiniband/core/cache.c                | 249 ++++++--
 drivers/infiniband/core/cm.c                   |  49 +-
 drivers/infiniband/core/cma.c                  | 233 ++++++--
 drivers/infiniband/core/cma_configfs.c         | 222 ++++++++
 drivers/infiniband/core/core_priv.h            |  88 ++-
 drivers/infiniband/core/device.c               | 150 ++++-
 drivers/infiniband/core/mad.c                  |   2 +-
 drivers/infiniband/core/multicast.c            |  17 +-
 drivers/infiniband/core/roce_gid_cache.c       | 755 ++++++++++++++++++++++++
 drivers/infiniband/core/roce_gid_mgmt.c        | 757 +++++++++++++++++++++++++
 drivers/infiniband/core/sa_query.c             |  12 +-
 drivers/infiniband/core/sysfs.c                | 186 +++++-
 drivers/infiniband/core/ucma.c                 |   1 -
 drivers/infiniband/core/ud_header.c            | 153 ++++-
 drivers/infiniband/core/uverbs_cmd.c           |   3 +-
 drivers/infiniband/core/uverbs_marshall.c      |   5 +-
 drivers/infiniband/core/verbs.c                | 266 ++++++---
 drivers/infiniband/hw/mlx4/ah.c                |  15 +-
 drivers/infiniband/hw/mlx4/mad.c               |  12 +-
 drivers/infiniband/hw/mlx4/main.c              | 756 +++++++++---------------
 drivers/infiniband/hw/mlx4/mcg.c               |   2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |  33 +-
 drivers/infiniband/hw/mlx4/qp.c                | 337 ++++++++---
 drivers/infiniband/hw/mthca/mthca_av.c         |   2 +-
 drivers/infiniband/hw/mthca/mthca_qp.c         |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h          |  12 +
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c       |  94 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h       |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c       |  50 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c     | 233 +-------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h      |  18 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |  55 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h    |   4 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c          |   3 +-
 drivers/net/bonding/bond_main.c                |   2 +
 drivers/net/bonding/bond_options.c             |  13 -
 drivers/net/bonding/bond_procfs.c              |   1 +
 drivers/net/bonding/bonding_priv.h             |  26 +
 drivers/net/ethernet/mellanox/mlx4/en_main.c   |  36 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c        |  21 +-
 drivers/net/ethernet/mellanox/mlx4/intf.c      |   3 +
 drivers/net/ethernet/mellanox/mlx4/main.c      |  18 +
 drivers/net/ethernet/mellanox/mlx4/mcg.c       |  14 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h      |   3 +-
 drivers/net/ethernet/mellanox/mlx4/port.c      |   9 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c        |  27 +
 include/linux/mlx4/cmd.h                       |   3 +-
 include/linux/mlx4/device.h                    |  23 +-
 include/linux/mlx4/driver.h                    |   2 +
 include/linux/mlx4/qp.h                        |  15 +-
 include/net/addrconf.h                         |  31 +
 include/net/bonding.h                          |  14 +-
 include/rdma/ib_addr.h                         |   5 +-
 include/rdma/ib_cache.h                        |  71 ++-
 include/rdma/ib_pack.h                         |  44 +-
 include/rdma/ib_sa.h                           |   8 +-
 include/rdma/ib_verbs.h                        | 127 ++++-
 net/ipv6/addrconf.c                            |  31 -
 63 files changed, 4202 insertions(+), 1148 deletions(-)
 create mode 100644 drivers/infiniband/core/cma_configfs.c
 create mode 100644 drivers/infiniband/core/roce_gid_cache.c
 create mode 100644 drivers/infiniband/core/roce_gid_mgmt.c
 create mode 100644 drivers/net/bonding/bonding_priv.h

--
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
