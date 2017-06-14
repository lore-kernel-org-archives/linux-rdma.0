From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] IB/core: Add generic function to extract IB speed
 from netdev
Date: Wed, 14 Jun 2017 20:45:12 +0530
Message-ID: <CA+sbYW07k=UoFvJVLvjfTcuUosoJJk34mSZJAfXRaUJuHwS3cA@mail.gmail.com>
References: <20170611054450.7221-1-yuval.shaia@oracle.com> <20170611054450.7221-3-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170611054450.7221-3-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 11, 2017 at 11:14 AM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 7ba9e69..d0e0f90 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -181,50 +181,6 @@ int bnxt_re_modify_device(struct ib_device *ibdev,
>         return 0;
>  }
>
> -static void __to_ib_speed_width(struct net_device *netdev, u8 *speed, u8 *width)
> -{
> -       struct ethtool_link_ksettings lksettings;
> -       u32 espeed;
> -
> -       if (netdev->ethtool_ops && netdev->ethtool_ops->get_link_ksettings) {
> -               memset(&lksettings, 0, sizeof(lksettings));
> -               rtnl_lock();
> -               netdev->ethtool_ops->get_link_ksettings(netdev, &lksettings);
> -               rtnl_unlock();
> -               espeed = lksettings.base.speed;
> -       } else {
> -               espeed = SPEED_UNKNOWN;
> -       }
> -       switch (espeed) {
> -       case SPEED_1000:
> -               *speed = IB_SPEED_SDR;
> -               *width = IB_WIDTH_1X;
> -               break;
> -       case SPEED_10000:
> -               *speed = IB_SPEED_QDR;
> -               *width = IB_WIDTH_1X;
> -               break;
> -       case SPEED_20000:
> -               *speed = IB_SPEED_DDR;
> -               *width = IB_WIDTH_4X;
> -               break;
> -       case SPEED_25000:
> -               *speed = IB_SPEED_EDR;
> -               *width = IB_WIDTH_1X;
> -               break;
> -       case SPEED_40000:
> -               *speed = IB_SPEED_QDR;
> -               *width = IB_WIDTH_4X;
> -               break;
> -       case SPEED_50000:
> -               break;
> -       default:
> -               *speed = IB_SPEED_SDR;
> -               *width = IB_WIDTH_1X;
> -               break;
> -       }
> -}
> -
>  /* Port */
>  int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
>                        struct ib_port_attr *port_attr)
> @@ -266,8 +222,9 @@ int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
>          * IB stack to avoid race in the NETDEV_UNREG path
>          */
>         if (test_bit(BNXT_RE_FLAG_IBDEV_REGISTERED, &rdev->flags))
> -               __to_ib_speed_width(rdev->netdev, &port_attr->active_speed,
> -                                   &port_attr->active_width);
> +               if (!ib_get_eth_speed(ibdev, port_num, &port_attr->active_speed,
> +                                     &port_attr->active_width))
> +                       return -EINVAL;
>         return 0;
>  }

The bnxt_re changes looks good to me.

But this change conflicts with one of the patches i submitted as a
part of the bug fix series.

https://patchwork.kernel.org/patch/9786057/

Depending on the order in which Doug pulls these patches, one of us
might have to
re-spin the patch.

Thanks,
Selvin Xavier
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
