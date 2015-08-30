From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix net_dev reference leak with failed requests
Date: Sat, 29 Aug 2015 23:12:50 -0700
Message-ID: <CAJ3xEMhtnzHu23wnpsHex5_xt3MV=z3ERoX6T5d=RoTVdOVrpw@mail.gmail.com>
References: <1440680115-9164-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440680115-9164-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 27, 2015 at 5:55 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> When no matching listening ID is found for a given request, the net_dev
> that was used to find the request isn't released.
>
> Fixes: 20c36836ecad ("IB/cma: Use found net_dev for passive connections")

same here, Doug, if this ID isn't the one that is actually going to
show off in Linus tree, please either squash this there prior to
getting the bits upstream or hold off till we have  a proper ID

> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 9b306d7b5c27..b1ab13f3e182 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1302,6 +1302,10 @@ static struct rdma_id_private *cma_id_from_event(struct ib_cm_id *cm_id,
>         bind_list = cma_ps_find(rdma_ps_from_service_id(req.service_id),
>                                 cma_port_from_service_id(req.service_id));
>         id_priv = cma_find_listener(bind_list, cm_id, ib_event, &req, *net_dev);
> +       if (IS_ERR(id_priv)) {
> +               dev_put(*net_dev);
> +               *net_dev = NULL;
> +       }
>
>         return id_priv;
>  }
> --
> 1.7.11.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
