From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH for-next v2 08/10] IB/cm: Remove the usage of smac and vid
 of qp_attr and cm_av
Date: Sun, 18 Oct 2015 22:52:57 +0530
Message-ID: <CANjDDBhn4MMr7Ou91YS+z3+vGhrBbS_FoCVW=E8V1TxXagM7YA@mail.gmail.com>
References: <1444923534-10882-1-git-send-email-matanb@mellanox.com> <1444923534-10882-9-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444923534-10882-9-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks Good
Reviewed-By: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

On Thu, Oct 15, 2015 at 9:08 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> The cm and cma don't need to explicitly handle vlan and smac,
> as they are resolved from the GID index now. Removing this
> portion of code.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cm.c  | 30 ------------------------------
>  drivers/infiniband/core/cma.c |  6 ------
>  2 files changed, 36 deletions(-)
>
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index ea7f3c5..6dd24a5 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -179,8 +179,6 @@ struct cm_av {
>         struct ib_ah_attr ah_attr;
>         u16 pkey_index;
>         u8 timeout;
> -       u8  valid;
> -       u8  smac[ETH_ALEN];
>  };
>
>  struct cm_work {
> @@ -389,7 +387,6 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
>                              &av->ah_attr);
>         av->timeout = path->packet_life_time + 1;
>
> -       av->valid = 1;
>         return 0;
>  }
>
> @@ -1637,7 +1634,6 @@ static int cm_req_handler(struct cm_work *work)
>         cm_format_paths_from_req(req_msg, &work->path[0], &work->path[1]);
>
>         memcpy(work->path[0].dmac, cm_id_priv->av.ah_attr.dmac, ETH_ALEN);
> -       work->path[0].vlan_id = cm_id_priv->av.ah_attr.vlan_id;
>         ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
>         if (ret) {
>                 ib_get_cached_gid(work->port->cm_dev->ib_device,
> @@ -3614,32 +3610,6 @@ static int cm_init_qp_rtr_attr(struct cm_id_private *cm_id_priv,
>                 *qp_attr_mask = IB_QP_STATE | IB_QP_AV | IB_QP_PATH_MTU |
>                                 IB_QP_DEST_QPN | IB_QP_RQ_PSN;
>                 qp_attr->ah_attr = cm_id_priv->av.ah_attr;
> -               if (!cm_id_priv->av.valid) {
> -                       spin_unlock_irqrestore(&cm_id_priv->lock, flags);
> -                       return -EINVAL;
> -               }
> -               if (cm_id_priv->av.ah_attr.vlan_id != 0xffff) {
> -                       qp_attr->vlan_id = cm_id_priv->av.ah_attr.vlan_id;
> -                       *qp_attr_mask |= IB_QP_VID;
> -               }
> -               if (!is_zero_ether_addr(cm_id_priv->av.smac)) {
> -                       memcpy(qp_attr->smac, cm_id_priv->av.smac,
> -                              sizeof(qp_attr->smac));
> -                       *qp_attr_mask |= IB_QP_SMAC;
> -               }
> -               if (cm_id_priv->alt_av.valid) {
> -                       if (cm_id_priv->alt_av.ah_attr.vlan_id != 0xffff) {
> -                               qp_attr->alt_vlan_id =
> -                                       cm_id_priv->alt_av.ah_attr.vlan_id;
> -                               *qp_attr_mask |= IB_QP_ALT_VID;
> -                       }
> -                       if (!is_zero_ether_addr(cm_id_priv->alt_av.smac)) {
> -                               memcpy(qp_attr->alt_smac,
> -                                      cm_id_priv->alt_av.smac,
> -                                      sizeof(qp_attr->alt_smac));
> -                               *qp_attr_mask |= IB_QP_ALT_SMAC;
> -                       }
> -               }
>                 qp_attr->path_mtu = cm_id_priv->path_mtu;
>                 qp_attr->dest_qp_num = be32_to_cpu(cm_id_priv->remote_qpn);
>                 qp_attr->rq_psn = be32_to_cpu(cm_id_priv->rq_psn);
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 849c280..bc11ea4 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -733,12 +733,6 @@ static int cma_modify_qp_rtr(struct rdma_id_private *id_priv,
>
>         BUG_ON(id_priv->cma_dev->device != id_priv->id.device);
>
> -       if (rdma_protocol_roce(id_priv->id.device, id_priv->id.port_num)) {
> -               ret = rdma_addr_find_smac_by_sgid(&sgid, qp_attr.smac, NULL);
> -
> -               if (ret)
> -                       goto out;
> -       }
>         if (conn_param)
>                 qp_attr.max_dest_rd_atomic = conn_param->responder_resources;
>         ret = ib_modify_qp(id_priv->id.qp, &qp_attr, qp_attr_mask);
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
