From: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/CM: cancel pending lap message when destroying an ID
Date: Wed, 2 Mar 2011 17:50:39 +0200
Message-ID: <AANLkTikD-2VkuLDZBQiBcrY2xovt53DS02Oqx=u8qdJG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sorry. The patch is to the CM. Subject was changed


On Wed, Mar 2, 2011 at 5:45 PM, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
>
> When destroying a cm_id from a context of a work queue and if the lap=
_state of
> this cm_id is IB_CM_LAP_SENT, we need to release the reference of thi=
s id that
> was taken upon the send of the lap message. =A0Otherwise, if the expe=
cted apr
> message gets lost, it is only after a long time that the reference wi=
ll be
> released, while during that the work handler thread is not available =
to process
> other things.
> Also, a sigle variable 'msg' was used to hold the last snet mad. Howe=
ver, this
> variable serves 2 state machines (CM and LAP) which can cause to memo=
ry leaks or
> to unexpected behavior. This patch adds another variable to hold the =
lap mad.
>
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> --
> =A0drivers/infiniband/core/cm.c | =A0 25 ++++++++++++++++++++++---
> =A01 file changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/c=
m.c
> index 64e0903..3c00646 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -210,6 +210,7 @@ struct cm_id_private {
> =A0 =A0 =A0 =A0atomic_t refcount;
>
> =A0 =A0 =A0 =A0struct ib_mad_send_buf *msg;
> + =A0 =A0 =A0 struct ib_mad_send_buf *lap_msg;
> =A0 =A0 =A0 =A0struct cm_timewait_info *timewait_info;
> =A0 =A0 =A0 =A0/* todo: use alternate port on send failure */
> =A0 =A0 =A0 =A0struct cm_av av;
> @@ -839,6 +840,24 @@ static void cm_destroy_id(struct ib_cm_id *cm_id=
, int err)
> =A0 =A0 =A0 =A0cm_id_priv =3D container_of(cm_id, struct cm_id_privat=
e, id);
> =A0retest:
> =A0 =A0 =A0 =A0spin_lock_irq(&cm_id_priv->lock);
> +
> + =A0 =A0 =A0 /* handle lap states first */
> + =A0 =A0 =A0 switch (cm_id->lap_state) {
> + =A0 =A0 =A0 case IB_CM_LAP_UNINIT:
> + =A0 =A0 =A0 case IB_CM_LAP_IDLE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case IB_CM_LAP_SENT:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cm_id_priv->id.lap_state =3D IB_CM_LAP_=
IDLE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ib_cancel_mad(cm_id_priv->av.port->mad_=
agent, cm_id_priv->lap_msg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cm_id_priv->lap_msg =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case IB_CM_LAP_RCVD:
> + =A0 =A0 =A0 case IB_CM_MRA_LAP_SENT:
> + =A0 =A0 =A0 case IB_CM_MRA_LAP_RCVD:
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0switch (cm_id->state) {
> =A0 =A0 =A0 =A0case IB_CM_LISTEN:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cm_id->state =3D IB_CM_IDLE;
> @@ -2615,7 +2634,7 @@ int ib_send_cm_lap(struct ib_cm_id *cm_id,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0cm_id->lap_state =3D IB_CM_LAP_SENT;
> - =A0 =A0 =A0 cm_id_priv->msg =3D msg;
> + =A0 =A0 =A0 cm_id_priv->lap_msg =3D msg;
>
> =A0out: =A0 spin_unlock_irqrestore(&cm_id_priv->lock, flags);
> =A0 =A0 =A0 =A0return ret;
> @@ -2811,8 +2830,8 @@ static int cm_apr_handler(struct cm_work *work)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0cm_id_priv->id.lap_state =3D IB_CM_LAP_IDLE;
> - =A0 =A0 =A0 ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_pri=
v->msg);
> - =A0 =A0 =A0 cm_id_priv->msg =3D NULL;
> + =A0 =A0 =A0 ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_pri=
v->lap_msg);
> + =A0 =A0 =A0 cm_id_priv->lap_msg =3D NULL;
>
> =A0 =A0 =A0 =A0ret =3D atomic_inc_and_test(&cm_id_priv->work_count);
> =A0 =A0 =A0 =A0if (!ret)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
