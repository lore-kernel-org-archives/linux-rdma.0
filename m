From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 for-next 00/14] RoCE GID management
Date: Tue, 19 May 2015 17:27:03 +0300
Message-ID: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

RoCE type per GID patch-set aims to add a mechanism that supports
multiple GID types simultaneously while freeing the vendor from
managing its own GID table.
Previously, every vendor implemented its net device notifiers in its own
driver. This introduces a huge code duplication as figuring
whether an event is related to the vendor's net device in the
various cases (bonding, vlan or any other upper device) is
similar for all vendors. In the future, when multiple GID types will
be supported, this code duplication would have gotten even worse.

Therefore, we decided moving this into a common core core.
roce_gid_table and roce_gid_mgmt were created in order to store and
manage the new GID table, by filling it when getting the related events.
Vendors now only have to implement modify_gid and get_netdev IB
device calls, which are truly unique for each vendor.
roce_gid_table is implemented as IB client that manages the GID
table of the IB device. Each GID is associated with a GID type and a
network device (which is mandatory for management of the GID table).
The GID table is populated by using roce_gid_mgmt. roce_gid_mgmt
registers to net device/inet/inet events and calls roce_gid_table
in order to populate the GID table accordingly.

Patch 0001 creates a new infrastructure for storing GIDs and their attributes
in IB/core. This infrastructure support lock-less read of GIDs using a
seqcounter. The data structure is initialized only for RoCE ports.
Every gid has meta information describes its related net device and its
type.

Patch 0002 replaces the locking schema for IB devices. Previously, device_mutex
was used in order to lock the devices/clients list against every modification.
However, downstream patches add new functions which iterate over the device
list. Those functions could be executed for a workqueue contexts on behalf
of IB clients. Thus, when a client is removed, we need to wait for all works
to be finished. Since a client removal was done in device_mutex lock, we'll
be in fact waiting for a work which requires to lock the device_mutex itself
(=DEADLOCK). In order to mitigate this problem, we use rw semaphore to allow
multiple readers. We use modify_mutex in order to solve races between adding
(or removing) a client and a device simultaneously, which could have resulted
in calling client->add (or client->remove) twice for the same device and client.

Patches 0003, 0004 and 0006 add population of this table for various cases
based on net device events. We always enable default gids for an active
device (an active device is defined here as a device that doesn't have
a bonding master or is the current active slave). This is done in order
to allow loopback traffic. Patch 0006 adds proper bonding support -
only the active slaves retain their master's IP based gids and default gids.
Patch 0005 adds the required information for the bonding case.

This whole concept needs to fit the existing sysfs model, thus patch 0008
adds sysfs entries that represent the net device and gid type related to
each gid.

Patch 0009 adds a new API for RoCE gid table lookup. Since users might
want to find a GID which matches a net device with a specific attributes,
the new API allows them to pass a filter function. This function is a bit
slower than the "regular" find by gid, gid_type, if_index and namespace -
thus it should be used only when necessary.

Patches 0007 and 0010 changes the rest of IB/core to fit the new
model. Instead of storing smac and vlan, we store either if_index, net and
gid or sgid_index. Either set suffices in order to resolve all
the required Ethernet parameters. ib_init_ah_from_wc was changed, such
that when a wc is arrived, we search our RoCE gid table in order to
find a suitable sgid_index that matches the net device. Matching is
done based on GID and VLAN.

The rest of the patches add support for ocrdma and mlx4 devices.

Thanks,
Devesh, Somnath, Moni and Matan

Changes from V3:
(1) Remove RoCE V2 functionality (it will be sent at later patchset).
(2) Instead of removing qp_attr_mask flags, reserve them.
(3) Remove the kref from IB devices in favor of rwsem.
(4) Change the name of roce_gid_cache to roce_gid_table.
(5) Fix a race when roce_gid_table is free'd while getting events.
(6) Remove the roce_gid_cache active/inactive flag/API.

Changes from V2:
(1) When creating multiple vlans over an interface,
    only the last created vlan's GID was populated in the table
    (regression from V2).
(2) Inactive slave of bonding sometimes lost GIDs related to IPs
    that were directly applied to it.
(3) Memory leak in mlx4
(4) roce_gid_cache now calls modify_gid with zgid in order to cause
    the provider to delete all the information it allocated for those
    GIDs.
(4) A mlx4 patch didn't compile and a downstream patch fixed it.
(5) cma_configfs should depend on both address translation and configfs.
(6) ocrdma driver redefined zgid.
(7) Added event information for NETDEV_CHANGEUPPER event.

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

Matan Barak (10):
  IB/core: Add RoCE GID table
  IB/core: Replace device_mutex with rwsem
  IB/core: Add RoCE GID population
  IB/core: Add default GID for RoCE GID table
  net: Add info for NETDEV_CHANGEUPPER event
  IB/core: Add RoCE table bonding support
  IB/core: GID attribute should be returned from verbs API and cache API
  IB/core: Report gid_type and gid_ndev through sysfs
  IB/core: Support find sgid index using a filter function
  IB/core: Modify ib_verbs and cma in order to use roce_gid_table

Moni Shoua (3):
  net/mlx4: Postpone the registration of net_device
  IB/mlx4: Implement ib_device callbacks
  IB/mlx4: Replace mechanism for RoCE GID management

Somnath Kotur (1):
  RDMA/ocrdma: Changes in driver to incorporate the moving of GID Table
    mgmt to IB/Core.

 drivers/infiniband/core/Makefile               |   3 +-
 drivers/infiniband/core/addr.c                 |   3 +-
 drivers/infiniband/core/cache.c                | 313 ++++++++--
 drivers/infiniband/core/cm.c                   |  36 +-
 drivers/infiniband/core/cma.c                  |  93 +--
 drivers/infiniband/core/core_priv.h            |  75 ++-
 drivers/infiniband/core/device.c               | 162 ++++-
 drivers/infiniband/core/mad.c                  |   2 +-
 drivers/infiniband/core/multicast.c            |   3 +-
 drivers/infiniband/core/roce_gid_mgmt.c        | 782 +++++++++++++++++++++++++
 drivers/infiniband/core/roce_gid_table.c       | 771 ++++++++++++++++++++++++
 drivers/infiniband/core/sa_query.c             |  11 +-
 drivers/infiniband/core/sysfs.c                | 186 +++++-
 drivers/infiniband/core/ucma.c                 |   1 -
 drivers/infiniband/core/uverbs_cmd.c           |   3 +-
 drivers/infiniband/core/uverbs_marshall.c      |   4 +-
 drivers/infiniband/core/verbs.c                | 161 +++--
 drivers/infiniband/hw/mlx4/ah.c                |  17 +-
 drivers/infiniband/hw/mlx4/mad.c               |  12 +-
 drivers/infiniband/hw/mlx4/main.c              | 711 +++++++---------------
 drivers/infiniband/hw/mlx4/mcg.c               |   2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |  24 +-
 drivers/infiniband/hw/mlx4/qp.c                |  63 +-
 drivers/infiniband/hw/mthca/mthca_av.c         |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h          |  11 +
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c       |  20 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c       |  22 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c     | 233 +-------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h      |  13 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |  31 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h    |   4 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c          |   3 +-
 drivers/net/bonding/bond_options.c             |  13 -
 drivers/net/ethernet/mellanox/mlx4/en_main.c   |  36 +-
 drivers/net/ethernet/mellanox/mlx4/intf.c      |   3 +
 include/linux/mlx4/device.h                    |   3 +-
 include/linux/mlx4/driver.h                    |   1 +
 include/linux/netdevice.h                      |  14 +
 include/net/addrconf.h                         |  31 +
 include/net/bonding.h                          |   7 +
 include/rdma/ib_addr.h                         |   4 +-
 include/rdma/ib_cache.h                        |  71 ++-
 include/rdma/ib_sa.h                           |   4 +-
 include/rdma/ib_verbs.h                        |  85 ++-
 net/core/dev.c                                 |  12 +-
 net/ipv6/addrconf.c                            |  31 -
 49 files changed, 3030 insertions(+), 1068 deletions(-)
 create mode 100644 drivers/infiniband/core/roce_gid_mgmt.c
 create mode 100644 drivers/infiniband/core/roce_gid_table.c

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
