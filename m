From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 09/31] IB/core: Make sure that PSN does not overflow
Date: Tue, 14 Nov 2017 23:23:07 +0200
Message-ID: <CAJ3xEMj+QYJs7cTaP7-Z2WGoPZN2ujh+_2sQhW7ZKg0ZGjQacg@mail.gmail.com>
References: <20171114125218.20477-1-leon@kernel.org> <20171114125218.20477-10-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-10-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 2:51 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> The rq/sq->psn is 24 bits as defined in the IB spec,therefore we mask
> out the 8 most significant bits to avoid overflow in modify qp.
>
> Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/verbs.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 75ebd74f8bbd..584b6029cb44 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1321,6 +1321,7 @@ static int ib_resolve_eth_dmac(struct ib_device *device,
>  int ib_modify_qp_with_udata(struct ib_qp *qp, struct ib_qp_attr *attr,
>                             int attr_mask, struct ib_udata *udata)
>  {
> +       u8 port = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
>         int ret;
>
>         if (attr_mask & IB_QP_AV) {
> @@ -1328,6 +1329,21 @@ int ib_modify_qp_with_udata(struct ib_qp *qp, struct ib_qp_attr *attr,
>                 if (ret)
>                         return ret;
>         }
> +
> +       if (rdma_ib_or_roce(qp->device, port)) {
> +               if (attr_mask & IB_QP_RQ_PSN && attr->rq_psn & ~0xffffff) {
> +                       pr_warn("%s: %s rq_psn overflow, masking to 24 bits\n",
> +                               __func__, qp->device->name);
> +                       attr->rq_psn &= 0xffffff;
> +               }
> +
> +               if (attr_mask & IB_QP_SQ_PSN && attr->sq_psn & ~0xffffff) {
> +                       pr_warn("%s: %s sq_psn overflow, masking to 24 bits\n",
> +                               __func__, qp->device->name);
> +                       attr->sq_psn &= 0xffffff;
> +               }
> +       }
> +

Isn't this what we tried to push in the past and Jason/Sean rejected [1]?

[1] https://marc.info/?l=linux-rdma&m=142309249413868&w=2


>         ret = ib_security_modify_qp(qp, attr, attr_mask, udata);
>         if (!ret && (attr_mask & IB_QP_PORT))
>                 qp->port = attr->port_num;
> --
> 2.15.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
