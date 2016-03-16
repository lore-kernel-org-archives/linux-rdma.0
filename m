From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 00/10] IB SR-IOV support
Date: Wed, 16 Mar 2016 18:33:56 +0200
Message-ID: <20160316163355.GF66645@x-vnc01.mtx.labs.mlnx>
References: <1457729923-4526-1-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457729923-4526-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Now that there are no pending issues, are you going to merge this series?

On Fri, Mar 11, 2016 at 10:58:33PM +0200, Eli Cohen wrote:
> Hi Doug, Dave
> 
> The following series adds support for managing SRIOV IB VFs in a standard
> way (rtnetlink, iproute2) through IPoIB ndo entries which translate to
> corresponding verbs calls.
> 
> In IB networks, 64 bit GUIDs are used as the primary means of identification.
> To support that for VFs, we added a set_vf_guid ndo which is used to program
> the VF node and port GUID from the PF.
> 
> Those verbs are implemented by the mlx5 driver along with some more changes
> needed in the driver, IPoIB and the IB core to support IB virtualization.
> 
> We've copied netdev only on the 1st patch of the series, as the rest of it just
> uses the patch along with the existing ndos in IPoIB plus add things which
> are internal to the IB stack.
> 
> The series is rebased against Doug's mlx5 branch and Leon's patch that extends
> the kernel ib device attr caps field to u64:
> https://patchwork.kernel.org/patch/8388931/
> 
> Eli
> 
> Changes from V2:
> 1. Change the well known SA GUID to locally administered
> 2. Fix alignment issue with subnet_prefix
> 
> Eli Cohen (10):
>   net/core: Add support for configuring VF GUIDs
>   IB/mlx5: Fix decision on using MAD_IFC
>   IB/core: Add subnet prefix to port info
>   IB/core: Support accessing SA in virtualized environment
>   IB/core: Add interfaces to control VF attributes
>   IB/ipoib: Add ndo operations for configuring VFs
>   net/mlx5_core: Add VF param when querying vport counter
>   net/mlx5_core: Implement modify HCA vport command
>   IB/mlx5: Implement callbacks for manipulating VFs
>   IB/ipoib: Allow mcast packets from other VFs
> 
>  drivers/infiniband/core/device.c                |  15 +-
>  drivers/infiniband/core/sa_query.c              |   5 +
>  drivers/infiniband/core/verbs.c                 |  40 +++++
>  drivers/infiniband/hw/mlx5/Makefile             |   2 +-
>  drivers/infiniband/hw/mlx5/ib_virt.c            | 194 ++++++++++++++++++++++++
>  drivers/infiniband/hw/mlx5/mad.c                |   2 +-
>  drivers/infiniband/hw/mlx5/main.c               |  12 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h            |   8 +
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c         |  27 +++-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c       |  65 +++++++-
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c   |   6 +
>  drivers/net/ethernet/mellanox/mlx5/core/vport.c |  72 ++++++++-
>  include/linux/mlx5/driver.h                     |   5 +-
>  include/linux/mlx5/mlx5_ifc.h                   |   6 +
>  include/linux/mlx5/vport.h                      |   7 +-
>  include/linux/netdevice.h                       |   3 +
>  include/rdma/ib_verbs.h                         |  26 ++++
>  include/uapi/linux/if_link.h                    |   7 +
>  net/core/rtnetlink.c                            |  36 +++++
>  19 files changed, 521 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/infiniband/hw/mlx5/ib_virt.c
> 
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
