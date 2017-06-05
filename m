From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/bnxt_re: Check return value from get_link_ksettings
Date: Mon, 5 Jun 2017 13:42:37 +0300
Message-ID: <CAG9sBKODJaecc2m-GTqU8H=jttPAr+iCcZK0wknEfXerz6TL+A@mail.gmail.com>
References: <20170605091429.16232-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605091429.16232-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 5, 2017 at 12:14 PM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> The function get_link_ksettings might return bad status indicating a
> failure to retrieve interface atttibutes.
> Check return value to cover this case.
>
> While there, change the zero-initialization to "compiler-helper" instead
> of an expensive call to memcpy.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 7ba9e69..10c7189 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -183,17 +183,19 @@ int bnxt_re_modify_device(struct ib_device *ibdev,
>
>  static void __to_ib_speed_width(struct net_device *netdev, u8 *speed, u8 *width)
>  {
> -       struct ethtool_link_ksettings lksettings;
> -       u32 espeed;
> +       u32 espeed = SPEED_UNKNOWN;
>
>         if (netdev->ethtool_ops && netdev->ethtool_ops->get_link_ksettings) {
> -               memset(&lksettings, 0, sizeof(lksettings));
> +               struct ethtool_link_ksettings lksettings = {0};
> +               int rc;
> +
>                 rtnl_lock();
> -               netdev->ethtool_ops->get_link_ksettings(netdev, &lksettings);
> +               rc = netdev->ethtool_ops->get_link_ksettings(netdev,
> +                                                            &lksettings);
>                 rtnl_unlock();
> -               espeed = lksettings.base.speed;
> -       } else {
> -               espeed = SPEED_UNKNOWN;
> +
> +               if (!rc)
> +                       espeed = lksettings.base.speed;
>         }
>         switch (espeed) {
>         case SPEED_1000:
> --
> 2.9.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

It looks like that bnxt driver also has similar code (function
__to_ib_speed_width() in drivers/infiniband/hw/bnxt_re/ib_verbs.c)
Maybe you can move this function to IB/core and use it in both places (or more)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
