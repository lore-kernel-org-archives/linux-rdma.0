From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH rdma-RC] IB/cm: Fix sleeping while atomic when creating AH
 from WC
Date: Mon, 12 Oct 2015 18:29:47 +0530
Message-ID: <CANjDDBjGe9a_gg-51=ysxMyDPjuD6rQg4FLyfZH8E1TCoEYLKQ@mail.gmail.com>
References: <1444568298-17289-1-git-send-email-matanb@mellanox.com> <1444568298-17289-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444568298-17289-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks good, just one doubt inline:

On Sun, Oct 11, 2015 at 6:28 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> When IP based addressing was introduced, ib_create_ah_from_wc was
> changed in order to support a suitable AH. Since this AH should
> now contains the DMAC (which isn't a simple derivative of the GID).
> In order to find the DMAC, an ARP should sometime be sent. This ARP
> is a sleeping context.
>
> ib_create_ah_from_wc is called from cm_alloc_response_msg, which is
> sometimes called from an atomic context. This caused a
> sleeping-while-atomic bug. Fixing this by splitting
> cm_alloc_response_msg to an atomic and sleep-able part. When
> cm_alloc_response_msg is used in an atomic context, we try to create
> the AH before entering the atomic context.
>
> Fixes: 66bd20a72d2f ('IB/core: Ethernet L2 attributes in verbs/cm structures')
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>
> Hi Doug,
> This patch fixes an old bug in the CM. IP based addressing requires
> ARP resolution which isn't sleep-able by its nature. This resolution
> was sometimes done in non sleep-able context. Our regression tests
> picked up this bug and verified this fix.
>
> Thanks,
> Matan
>
>  drivers/infiniband/core/cm.c | 60 ++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 49 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index ea4db9c..f5cf1c4 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -287,17 +287,12 @@ static int cm_alloc_msg(struct cm_id_private *cm_id_priv,
>         return 0;
>  }
>
> -static int cm_alloc_response_msg(struct cm_port *port,
> -                                struct ib_mad_recv_wc *mad_recv_wc,
> -                                struct ib_mad_send_buf **msg)
> +static int _cm_alloc_response_msg(struct cm_port *port,
> +                                 struct ib_mad_recv_wc *mad_recv_wc,
> +                                 struct ib_ah *ah,
> +                                 struct ib_mad_send_buf **msg)
>  {
>         struct ib_mad_send_buf *m;
> -       struct ib_ah *ah;
> -
> -       ah = ib_create_ah_from_wc(port->mad_agent->qp->pd, mad_recv_wc->wc,
> -                                 mad_recv_wc->recv_buf.grh, port->port_num);
> -       if (IS_ERR(ah))
> -               return PTR_ERR(ah);
>
>         m = ib_create_send_mad(port->mad_agent, 1, mad_recv_wc->wc->pkey_index,
>                                0, IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
> @@ -312,6 +307,20 @@ static int cm_alloc_response_msg(struct cm_port *port,
>         return 0;
>  }
>
> +static int cm_alloc_response_msg(struct cm_port *port,
> +                                struct ib_mad_recv_wc *mad_recv_wc,
> +                                struct ib_mad_send_buf **msg)
> +{
> +       struct ib_ah *ah;
> +
> +       ah = ib_create_ah_from_wc(port->mad_agent->qp->pd, mad_recv_wc->wc,
> +                                 mad_recv_wc->recv_buf.grh, port->port_num);
> +       if (IS_ERR(ah))
> +               return PTR_ERR(ah);
> +
> +       return _cm_alloc_response_msg(port, mad_recv_wc, ah, msg);
> +}
> +
>  static void cm_free_msg(struct ib_mad_send_buf *msg)
>  {
>         ib_destroy_ah(msg->ah);
> @@ -2201,6 +2210,7 @@ static int cm_dreq_handler(struct cm_work *work)
>         struct cm_id_private *cm_id_priv;
>         struct cm_dreq_msg *dreq_msg;
>         struct ib_mad_send_buf *msg = NULL;
> +       struct ib_ah *ah;
>         int ret;
>
>         dreq_msg = (struct cm_dreq_msg *)work->mad_recv_wc->recv_buf.mad;
> @@ -2213,6 +2223,11 @@ static int cm_dreq_handler(struct cm_work *work)
>                 return -EINVAL;
>         }
>
> +       ah = ib_create_ah_from_wc(work->port->mad_agent->qp->pd,
> +                                 work->mad_recv_wc->wc,
> +                                 work->mad_recv_wc->recv_buf.grh,
> +                                 work->port->port_num);
> +

Shouldn't below IS_ERR(ah) on ah be here, instead of there?

>         work->cm_event.private_data = &dreq_msg->private_data;
>
>         spin_lock_irq(&cm_id_priv->lock);
> @@ -2234,9 +2249,13 @@ static int cm_dreq_handler(struct cm_work *work)
>         case IB_CM_TIMEWAIT:
>                 atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
>                                 counter[CM_DREQ_COUNTER]);
> -               if (cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg))
> +               if (IS_ERR(ah))
> +                       goto unlock;
> +               if (_cm_alloc_response_msg(work->port, work->mad_recv_wc, ah,
> +                                          &msg))
>                         goto unlock;
>
> +               ah = NULL;
>                 cm_format_drep((struct cm_drep_msg *) msg->mad, cm_id_priv,
>                                cm_id_priv->private_data,
>                                cm_id_priv->private_data_len);
> @@ -2259,6 +2278,8 @@ static int cm_dreq_handler(struct cm_work *work)
>                 list_add_tail(&work->list, &cm_id_priv->work_list);
>         spin_unlock_irq(&cm_id_priv->lock);
>
> +       if (!IS_ERR_OR_NULL(ah))
> +               ib_destroy_ah(ah);
>         if (ret)
>                 cm_process_work(cm_id_priv, work);
>         else
> @@ -2266,6 +2287,8 @@ static int cm_dreq_handler(struct cm_work *work)
>         return 0;
>
>  unlock:        spin_unlock_irq(&cm_id_priv->lock);
> +       if (!IS_ERR_OR_NULL(ah))
> +               ib_destroy_ah(ah);
>  deref: cm_deref_id(cm_id_priv);
>         return -EINVAL;
>  }
> @@ -2761,6 +2784,7 @@ static int cm_lap_handler(struct cm_work *work)
>         struct cm_lap_msg *lap_msg;
>         struct ib_cm_lap_event_param *param;
>         struct ib_mad_send_buf *msg = NULL;
> +       struct ib_ah *ah;
>         int ret;
>
>         /* todo: verify LAP request and send reject APR if invalid. */
> @@ -2770,6 +2794,12 @@ static int cm_lap_handler(struct cm_work *work)
>         if (!cm_id_priv)
>                 return -EINVAL;
>
> +
> +       ah = ib_create_ah_from_wc(work->port->mad_agent->qp->pd,
> +                                 work->mad_recv_wc->wc,
> +                                 work->mad_recv_wc->recv_buf.grh,
> +                                 work->port->port_num);
> +
>         param = &work->cm_event.param.lap_rcvd;
>         param->alternate_path = &work->path[0];
>         cm_format_path_from_lap(cm_id_priv, param->alternate_path, lap_msg);
> @@ -2786,9 +2816,13 @@ static int cm_lap_handler(struct cm_work *work)
>         case IB_CM_MRA_LAP_SENT:
>                 atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
>                                 counter[CM_LAP_COUNTER]);
> -               if (cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg))
> +               if (IS_ERR(ah))
> +                       goto unlock;
> +               if (_cm_alloc_response_msg(work->port, work->mad_recv_wc, ah,
> +                                          &msg))
>                         goto unlock;
>
> +               ah = NULL;
>                 cm_format_mra((struct cm_mra_msg *) msg->mad, cm_id_priv,
>                               CM_MSG_RESPONSE_OTHER,
>                               cm_id_priv->service_timeout,
> @@ -2818,6 +2852,8 @@ static int cm_lap_handler(struct cm_work *work)
>                 list_add_tail(&work->list, &cm_id_priv->work_list);
>         spin_unlock_irq(&cm_id_priv->lock);
>
> +       if (!IS_ERR_OR_NULL(ah))
> +               ib_destroy_ah(ah);
>         if (ret)
>                 cm_process_work(cm_id_priv, work);
>         else
> @@ -2825,6 +2861,8 @@ static int cm_lap_handler(struct cm_work *work)
>         return 0;
>
>  unlock:        spin_unlock_irq(&cm_id_priv->lock);
> +       if (!IS_ERR_OR_NULL(ah))
> +               ib_destroy_ah(ah);
>  deref: cm_deref_id(cm_id_priv);
>         return -EINVAL;
>  }
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
