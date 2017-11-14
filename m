From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 11/31] IB/cm: Add debug prints to ib_cm
Date: Tue, 14 Nov 2017 23:10:21 +0200
Message-ID: <CAJ3xEMiz7m=e8NoQd4-GO8rRdeAHFO0eXs0Bm9Zqi7ct9q_spw@mail.gmail.com>
References: <20171114125218.20477-1-leon@kernel.org> <20171114125218.20477-12-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-12-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 2:51 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add debug prints to the error paths in the connection manager control
> flows, to help debug connection management problems.

Sean, the CM author and maintainer since 2.6.12/13 (12 years) is not copied



>
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/cm.c | 51 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index fe7a5e0d79b0..cbb385e02947 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -1841,6 +1841,8 @@ static int cm_req_handler(struct cm_work *work)
>
>         listen_cm_id_priv = cm_match_req(work, cm_id_priv);
>         if (!listen_cm_id_priv) {
> +               pr_debug("%s: local_id %d, no listen_cm_id_priv\n", __func__,
> +                        be32_to_cpu(cm_id->local_id));
>                 ret = -EINVAL;
>                 goto free_timeinfo;
>         }
> @@ -1998,6 +2000,8 @@ int ib_send_cm_rep(struct ib_cm_id *cm_id,
>         spin_lock_irqsave(&cm_id_priv->lock, flags);
>         if (cm_id->state != IB_CM_REQ_RCVD &&
>             cm_id->state != IB_CM_MRA_REQ_SENT) {
> +               pr_debug("%s: local_comm_id %d, cm_id->state: %d\n", __func__,
> +                        be32_to_cpu(cm_id_priv->id.local_id), cm_id->state);
>                 ret = -EINVAL;
>                 goto out;
>         }
> @@ -2064,6 +2068,8 @@ int ib_send_cm_rtu(struct ib_cm_id *cm_id,
>         spin_lock_irqsave(&cm_id_priv->lock, flags);
>         if (cm_id->state != IB_CM_REP_RCVD &&
>             cm_id->state != IB_CM_MRA_REP_SENT) {
> +               pr_debug("%s: local_id %d, cm_id->state %d\n", __func__,
> +                        be32_to_cpu(cm_id->local_id), cm_id->state);
>                 ret = -EINVAL;
>                 goto error;
>         }
> @@ -2171,6 +2177,8 @@ static int cm_rep_handler(struct cm_work *work)
>         cm_id_priv = cm_acquire_id(rep_msg->remote_comm_id, 0);
>         if (!cm_id_priv) {
>                 cm_dup_rep_handler(work);
> +               pr_debug("%s: remote_comm_id %d, no cm_id_priv\n", __func__,
> +                        be32_to_cpu(rep_msg->remote_comm_id));
>                 return -EINVAL;
>         }
>
> @@ -2184,6 +2192,10 @@ static int cm_rep_handler(struct cm_work *work)
>         default:
>                 spin_unlock_irq(&cm_id_priv->lock);
>                 ret = -EINVAL;
> +               pr_debug("%s: cm_id_priv->id.state: %d, local_comm_id %d, remote_comm_id %d\n",
> +                        __func__, cm_id_priv->id.state,
> +                        be32_to_cpu(rep_msg->local_comm_id),
> +                        be32_to_cpu(rep_msg->remote_comm_id));
>                 goto error;
>         }
>
> @@ -2197,6 +2209,8 @@ static int cm_rep_handler(struct cm_work *work)
>                 spin_unlock(&cm.lock);
>                 spin_unlock_irq(&cm_id_priv->lock);
>                 ret = -EINVAL;
> +               pr_debug("%s: Failed to insert remote id %d\n", __func__,
> +                        be32_to_cpu(rep_msg->remote_comm_id));
>                 goto error;
>         }
>         /* Check for a stale connection. */
> @@ -2214,6 +2228,10 @@ static int cm_rep_handler(struct cm_work *work)
>                              IB_CM_REJ_STALE_CONN, CM_MSG_RESPONSE_REP,
>                              NULL, 0);
>                 ret = -EINVAL;
> +               pr_debug("%s: Stale connection. local_comm_id %d, remote_comm_id %d\n",
> +                        __func__, be32_to_cpu(rep_msg->local_comm_id),
> +                        be32_to_cpu(rep_msg->remote_comm_id));
> +
>                 if (cur_cm_id_priv) {
>                         cm_id = &cur_cm_id_priv->id;
>                         ib_send_cm_dreq(cm_id, NULL, 0);
> @@ -2360,6 +2378,8 @@ int ib_send_cm_dreq(struct ib_cm_id *cm_id,
>         cm_id_priv = container_of(cm_id, struct cm_id_private, id);
>         spin_lock_irqsave(&cm_id_priv->lock, flags);
>         if (cm_id->state != IB_CM_ESTABLISHED) {
> +               pr_debug("%s: local_id %d, cm_id->state: %d\n", __func__,
> +                        be32_to_cpu(cm_id->local_id), cm_id->state);
>                 ret = -EINVAL;
>                 goto out;
>         }
> @@ -2429,6 +2449,8 @@ int ib_send_cm_drep(struct ib_cm_id *cm_id,
>         if (cm_id->state != IB_CM_DREQ_RCVD) {
>                 spin_unlock_irqrestore(&cm_id_priv->lock, flags);
>                 kfree(data);
> +               pr_debug("%s: local_id %d, cm_idcm_id->state(%d) != IB_CM_DREQ_RCVD\n",
> +                        __func__, be32_to_cpu(cm_id->local_id), cm_id->state);
>                 return -EINVAL;
>         }
>
> @@ -2494,6 +2516,9 @@ static int cm_dreq_handler(struct cm_work *work)
>                 atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
>                                 counter[CM_DREQ_COUNTER]);
>                 cm_issue_drep(work->port, work->mad_recv_wc);
> +               pr_debug("%s: no cm_id_priv, local_comm_id %d, remote_comm_id %d\n",
> +                        __func__, be32_to_cpu(dreq_msg->local_comm_id),
> +                        be32_to_cpu(dreq_msg->remote_comm_id));
>                 return -EINVAL;
>         }
>
> @@ -2536,6 +2561,9 @@ static int cm_dreq_handler(struct cm_work *work)
>                                 counter[CM_DREQ_COUNTER]);
>                 goto unlock;
>         default:
> +               pr_debug("%s: local_id %d, cm_id_priv->id.state: %d\n",
> +                        __func__, be32_to_cpu(cm_id_priv->id.local_id),
> +                        cm_id_priv->id.state);
>                 goto unlock;
>         }
>         cm_id_priv->id.state = IB_CM_DREQ_RCVD;
> @@ -2639,6 +2667,8 @@ int ib_send_cm_rej(struct ib_cm_id *cm_id,
>                 cm_enter_timewait(cm_id_priv);
>                 break;
>         default:
> +               pr_debug("%s: local_id %d, cm_id->state: %d\n", __func__,
> +                        be32_to_cpu(cm_id_priv->id.local_id), cm_id->state);
>                 ret = -EINVAL;
>                 goto out;
>         }
> @@ -2749,6 +2779,9 @@ static int cm_rej_handler(struct cm_work *work)
>                 /* fall through */
>         default:
>                 spin_unlock_irq(&cm_id_priv->lock);
> +               pr_debug("%s: local_id %d, cm_id_priv->id.state: %d\n",
> +                        __func__, be32_to_cpu(cm_id_priv->id.local_id),
> +                        cm_id_priv->id.state);
>                 ret = -EINVAL;
>                 goto out;
>         }
> @@ -2812,6 +2845,9 @@ int ib_send_cm_mra(struct ib_cm_id *cm_id,
>                 }
>                 /* fall through */
>         default:
> +               pr_debug("%s: local_id %d, cm_id_priv->id.state: %d\n",
> +                        __func__, be32_to_cpu(cm_id_priv->id.local_id),
> +                        cm_id_priv->id.state);
>                 ret = -EINVAL;
>                 goto error1;
>         }
> @@ -2913,6 +2949,9 @@ static int cm_mra_handler(struct cm_work *work)
>                                 counter[CM_MRA_COUNTER]);
>                 /* fall through */
>         default:
> +               pr_debug("%s local_id %d, cm_id_priv->id.state: %d\n",
> +                        __func__, be32_to_cpu(cm_id_priv->id.local_id),
> +                        cm_id_priv->id.state);
>                 goto out;
>         }
>
> @@ -3693,6 +3732,7 @@ static void cm_work_handler(struct work_struct *_work)
>                 ret = cm_timewait_handler(work);
>                 break;
>         default:
> +               pr_debug("cm_event.event: 0x%x\n", work->cm_event.event);
>                 ret = -EINVAL;
>                 break;
>         }
> @@ -3728,6 +3768,8 @@ static int cm_establish(struct ib_cm_id *cm_id)
>                 ret = -EISCONN;
>                 break;
>         default:
> +               pr_debug("%s: local_id %d, cm_id->state: %d\n", __func__,
> +                        be32_to_cpu(cm_id->local_id), cm_id->state);
>                 ret = -EINVAL;
>                 break;
>         }
> @@ -3925,6 +3967,9 @@ static int cm_init_qp_init_attr(struct cm_id_private *cm_id_priv,
>                 ret = 0;
>                 break;
>         default:
> +               pr_debug("%s: local_id %d, cm_id_priv->id.state: %d\n",
> +                        __func__, be32_to_cpu(cm_id_priv->id.local_id),
> +                        cm_id_priv->id.state);
>                 ret = -EINVAL;
>                 break;
>         }
> @@ -3972,6 +4017,9 @@ static int cm_init_qp_rtr_attr(struct cm_id_private *cm_id_priv,
>                 ret = 0;
>                 break;
>         default:
> +               pr_debug("%s: local_id %d, cm_id_priv->id.state: %d\n",
> +                        __func__, be32_to_cpu(cm_id_priv->id.local_id),
> +                        cm_id_priv->id.state);
>                 ret = -EINVAL;
>                 break;
>         }
> @@ -4031,6 +4079,9 @@ static int cm_init_qp_rts_attr(struct cm_id_private *cm_id_priv,
>                 ret = 0;
>                 break;
>         default:
> +               pr_debug("%s: local_id %d, cm_id_priv->id.state: %d\n",
> +                        __func__, be32_to_cpu(cm_id_priv->id.local_id),
> +                        cm_id_priv->id.state);
>                 ret = -EINVAL;
>                 break;
>         }
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
