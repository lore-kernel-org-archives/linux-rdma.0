From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/6] Add flow steering support for IPoIB
Date: Sat, 16 Nov 2013 21:35:26 +0200
Message-ID: <CAJZOPZK=mRXakostsuFt3XzP3ZF5FW+4YurTSRz1JbPBgzurCg@mail.gmail.com>
References: <1383830717-17312-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383830717-17312-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 7,Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> This series adds on the flow-steering patches that were merged in 3.12
> Now flow steering rules can be set such that they steer UD
> traffic targeted to IPoIB netdevice into applications IB UD QP.
> For that end, IPoIB provides hint to the low-level device through
> a QP creation flag that this QP may be subject to flow-steering.
> FWIW, this patch set has nothing to do with the uverbs extensions series.

Any comment?! is this going in for 3.13?

Note that without this series which enables flow-steering also on IB
ports, folks that have VPI environments, e.g dual ported HCA with one
port playing Ethernet and the 2nd port IB, can't enjoy flow-steering
since we have only one dev cap bit and the flow-steering patches that
went into 3.12 only implemented the feature for raw qps, so the driver
(mlx4) could enable the device capability when both ports are IB.


Or.

>
> Matan and Or.
>
> Matan Barak (6):
>   IB/core: Add flow-steering support for IPoIB UD traffic
>   IB/core: Add support for IB L2 device managed steering
>   net/mlx4_core: Add support for steer-able IB UD QPs
>   IB/mlx4_ib: Enable device managed steering support for IB ports too
>   IB/mlx4_ib: Add mechanism to support flow-steering over IB links
>   IB/mlx4_ib: Add support for steer-able IB UD QPs
>
>  drivers/infiniband/hw/mlx4/main.c                  |  272 +++++++++++++++++++-
>  drivers/infiniband/hw/mlx4/mlx4_ib.h               |   12 +
>  drivers/infiniband/hw/mlx4/qp.c                    |   53 ++++-
>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    3 +
>  drivers/net/ethernet/mellanox/mlx4/cmd.c           |    9 +
>  drivers/net/ethernet/mellanox/mlx4/fw.c            |   10 +
>  drivers/net/ethernet/mellanox/mlx4/mcg.c           |   17 ++
>  drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    5 +
>  .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   10 +
>  include/linux/mlx4/cmd.h                           |    1 +
>  include/linux/mlx4/device.h                        |    6 +-
>  include/rdma/ib_verbs.h                            |   17 ++-
>  12 files changed, 393 insertions(+), 22 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
