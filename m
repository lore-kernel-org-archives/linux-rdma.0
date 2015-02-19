From: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 00/30] IB/Core: Adding support for RoCEV2 Specification
Date: Thu, 19 Feb 2015 05:36:20 +0000
Message-ID: <8fac36c8-c131-4c4d-8139-59f6c5f12f61@CMEXHTCAS2.ad.emulex.com>
References: <e49e0e12-e53d-4a90-b9aa-d7f05e2dfbc5@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e49e0e12-e53d-4a90-b9aa-d7f05e2dfbc5-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,
	Missed out one bug fix in patch 14/30 for the `ocrdma` driver.  
Resubmitting the series again with this patch fixed

Apologies for any inconvenience.

Thanks
Som

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Somnath Kotur
> Sent: Thursday, February 19, 2015 3:44 PM
> To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Somnath Kotur
> Subject: [PATCH 00/30] IB/Core: Adding support for RoCEV2 Specification
> 
> Hi Roland,
> 
> This patch series was created out of collaboration between Emulex and
> Mellanox.
> While Emulex sent out the RoCEV2 patch first to the community, Mellanox
> which was also working on some core infrastructure changes from the
> ground-up towards
> RoCEV2 felt that the RoCEV2 patch would be better served if done on top of
> their basic infrastructure changes to associate entities like MAC, VLAN, IP
> Address with GIDs and thereby move GID Table Management from HW
> Vendor drivers to IB/Core.
> This patchset is the result of joint development effort between the two
> teams.
> 
> Patch 0001 creates a new infrastructure for storing GIDs and their attributes
> in IB/core. This infrastructure support lock-less read of GIDs using a sequence
> number.  The data structure is initialized only for RoCE ports.
> Every gid has meta information describes its related net device and its type.
> 
> Patches 0002, 0004 and 0005 add population of this table for various cases
> based on net device events. We always enable default gids for an active
> device (an active device is defined here as a device that doesn't have a
> bonding master or is the current active slave). This is done in order to allow
> loopback traffic
> 
> Patch 0005 adds proper bonding support - only the active slaves retain their
> master's IP based gids and default gids.
> 
> This whole concept needs to fit the existing sysfs model, thus patch 0006
> adds sysfs entries that represent the net device and gid type related to each
> gid.
> 
> Patches 0002, 0007, 0008 and 0009 changes the rest of IB/core to fit the new
> model.
> Instead of storing smac and vlan, we store either if_index, gid and gid_type
> or sgid_index. Either set suffices in order to resolve all the required Ethernet
> parameters. ib_init_ah_from_wc was changed, such as that when a wc is
> arrived, we query all the net devices in all namespaces trying to find a match.
> This match is later used to find an appropriate sgid_index.
> 
> Patch 0010 is used in order to configure the default mode of the cma.
> In order to avoid changing existing rdma-cm applications, we adds a configfs
> that states for each ib device what's the default RoCE mode.
> 
> Patch 0011 mainly corrects the hop limit value and adds a hint about RoCE
> type according to whether we have a gateway. This is the patch that makes it
> possible for applications to seamlessly interop between RoCE V1 and V2
> without undergoing any changes themselves.
> 
> The rest of the patches add support for ocrdma and mlx4 devices.
> 
> This series depends on RoCE LAG series (already accepted in net-next tree)
> 
> Thanks,
> Somnath, Devesh, Moni and Matan
> 
> Devesh Sharma (3):
>   RDMA/ocrdma: changes to support RoCE-v2 in UD path
>   RDMA/ocrdma: changes to support RoCE-v2 in RC path
>   RDMA/ocrdma: changes to support user AH creation
> 
> Matan Barak (12):
>   IB/core: Add RoCE GID cache
>   IB/core: Add kref to IB devices
>   IB/core: Add RoCE GID population
>   IB/core: Add default GID for RoCE GID Cache
>   IB/core: Add RoCE cache bonding support
>   IB/core: GID attribute should be returned from verbs API and cache
>     API
>   IB/core: Report gid_type and gid_ndev through sysfs
>   IB/core: Support find sgid index using a filter function
>   IB/core: Modify ib_verbs and cma in order to use roce_gid_cache
>   IB/core: Add gid_type to path and rdma_id_private
>   IB/core: Add rdma_network_type to wc
>   IB/cma: Add configfs for rdma_cm
> 
> Moni Shoua (13):
>   IB/mlx4: Remove gid table management for RoCE
>   IB/mlx4: Replace spin_lock with rw_semaphore
>   IB/mlx4: Lock with RCU instead of RTNL
>   net/mlx4: Postpone the registration of net_device
>   IB/mlx4: Advertise RoCE support in port capabilities
>   IB/mlx4: Implement ib_device callback - get_netdev
>   IB/mlx4: Implement ib_device callback - modify_gid
>   IB/mlx4: Configure device to work in RoCEv2
>   IB/mlx4: Translate cache gid index to real index
>   IB/core: Initialize UD header structure with IP and UDP headers
>   IB/mlx4: Enable send of RoCE QP1 packets with IP/UDP headers
>   IB/mlx4: Create and use another QP1 for RoCEv2
>   IB/cma: Join and leave multicast groups with IGMP
> 
> Somnath Kotur (2):
>   IB/Core: Changes to the IB Core infrastructure for RoCEv2 support
>   RDMA/ocrdma: Changes in driver to incorporate the moving of GID Table
>     mgmt to IB/Core.
> 
>  drivers/infiniband/core/Makefile               |    5 +-
>  drivers/infiniband/core/addr.c                 |   11 +-
>  drivers/infiniband/core/cache.c                |  249 +++++++--
>  drivers/infiniband/core/cm.c                   |   49 +--
>  drivers/infiniband/core/cma.c                  |  229 ++++++--
>  drivers/infiniband/core/cma_configfs.c         |  222 +++++++
>  drivers/infiniband/core/core_priv.h            |   88 +++-
>  drivers/infiniband/core/device.c               |  150 +++++-
>  drivers/infiniband/core/mad.c                  |    2 +-
>  drivers/infiniband/core/multicast.c            |    3 +-
>  drivers/infiniband/core/roce_gid_cache.c       |  755
> ++++++++++++++++++++++++
>  drivers/infiniband/core/roce_gid_mgmt.c        |  703
> ++++++++++++++++++++++
>  drivers/infiniband/core/sa_query.c             |   12 +-
>  drivers/infiniband/core/sysfs.c                |  187 ++++++-
>  drivers/infiniband/core/ucma.c                 |    1 -
>  drivers/infiniband/core/ud_header.c            |  153 +++++-
>  drivers/infiniband/core/uverbs_cmd.c           |    6 +-
>  drivers/infiniband/core/uverbs_marshall.c      |    5 +-
>  drivers/infiniband/core/verbs.c                |  264 ++++++---
>  drivers/infiniband/hw/mlx4/ah.c                |   15 +-
>  drivers/infiniband/hw/mlx4/mad.c               |   12 +-
>  drivers/infiniband/hw/mlx4/main.c              |  744 ++++++++---------------
>  drivers/infiniband/hw/mlx4/mcg.c               |    2 +-
>  drivers/infiniband/hw/mlx4/mlx4_ib.h           |   33 +-
>  drivers/infiniband/hw/mlx4/qp.c                |  331 +++++++++--
>  drivers/infiniband/hw/mthca/mthca_av.c         |    2 +-
>  drivers/infiniband/hw/mthca/mthca_qp.c         |    2 +-
>  drivers/infiniband/hw/ocrdma/ocrdma.h          |   12 +
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c       |   93 +++-
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.h       |    5 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c       |   48 ++-
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c     |  233 +-------
>  drivers/infiniband/hw/ocrdma/ocrdma_sli.h      |   18 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |   52 ++-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h    |    4 +
>  drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2 +-
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    2 +-
>  drivers/infiniband/ulp/srp/ib_srp.c            |    2 +-
>  drivers/infiniband/ulp/srpt/ib_srpt.c          |    3 +-
>  drivers/net/bonding/bond_options.c             |   13 -
>  drivers/net/ethernet/mellanox/mlx4/en_main.c   |   36 +-
>  drivers/net/ethernet/mellanox/mlx4/fw.c        |   21 +-
>  drivers/net/ethernet/mellanox/mlx4/intf.c      |    3 +
>  drivers/net/ethernet/mellanox/mlx4/main.c      |   18 +
>  drivers/net/ethernet/mellanox/mlx4/mlx4.h      |    3 +-
>  drivers/net/ethernet/mellanox/mlx4/port.c      |    9 +-
>  drivers/net/ethernet/mellanox/mlx4/qp.c        |   27 +
>  include/linux/mlx4/cmd.h                       |    3 +-
>  include/linux/mlx4/device.h                    |   17 +-
>  include/linux/mlx4/driver.h                    |    2 +
>  include/linux/mlx4/qp.h                        |   15 +-
>  include/net/addrconf.h                         |   31 +
>  include/net/bonding.h                          |    7 +
>  include/rdma/ib_addr.h                         |    5 +-
>  include/rdma/ib_cache.h                        |   71 +++-
>  include/rdma/ib_pack.h                         |   44 ++-
>  include/rdma/ib_sa.h                           |    5 +-
>  include/rdma/ib_verbs.h                        |  120 ++++-
>  net/ipv6/addrconf.c                            |   31 -
>  59 files changed, 4056 insertions(+), 1134 deletions(-)  create mode 100644
> drivers/infiniband/core/cma_configfs.c
>  create mode 100644 drivers/infiniband/core/roce_gid_cache.c
>  create mode 100644 drivers/infiniband/core/roce_gid_mgmt.c
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
