From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core User RMPP patch
Date: Thu, 27 May 2010 11:12:45 -0400
Message-ID: <AANLkTin1hUVSEkbAFMhmhH4Iy--PdMyS1FrVWcZU_ndS@mail.gmail.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D528@MNEXMB1.qlogic.org>
	<AANLkTikpYJXj9MjCwGUlK1SisooL_etjbE3BdwHtQjTj@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488D5AF@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D5AF-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 27, 2010 at 10:32 AM, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>=
 wrote:
> There are QLogic customers who have requested the ability to perform =
RMPP transaction handling in user space. =C2=A0This was an option in ou=
r old proprietary stack and there are a few customers still using it wh=
ich need a way to forward migrate to OFED while containing the scope of=
 their application changes. =C2=A0While we have developed appropriate "=
shim" libraries to allow their applications to migrate, we can't simula=
te/shim rmpp processing without some kernel support.
>
> We also have some management applications which also need these capab=
ilities. =C2=A0For those applications, the use of application RMPP cont=
rol allows the application to perform some pacing of the RMPP transacti=
ons, permits some parts of the RMPP response to be built on the fly and=
 also permits a degree of sharing of the response data between multiple=
 requestors.
>
> The use of OFED kernel based RMPP transaction handling was unable to =
meet all these requirements. =C2=A0So this simple option provides a min=
imal change to OFED while permitting the application to have the contro=
l it needs.

The API would need to be extended for this mode (in some backward
compatible manner) rather than supplanting the rmpp_version 0
behavior. Changing that behavior breaks backward compatibility/some
existing apps.

>
> -----Original Message-----
> From: Hal Rosenstock [mailto:hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Thursday, May 27, 2010 9:07 AM
> To: Mike Heinz
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Roland Dreier
> Subject: Re: [PATCH] IB/core User RMPP patch
>
> On Wed, May 26, 2010 at 4:14 PM, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org=
> wrote:
>> Currently, if a user application calls umad_register() or umad_regis=
ter_oui() with an rmpp_version of zero, incoming rmpp messages are disc=
arded.
>
> Actually, it's the underlying ib_register_mad_agent call and this dro=
p
> behavior is intentional.
>
>> This patch changes this behavior so that rmpp_version of zero causes=
 incoming rmpp packets to be passed through without alteration, instead=
=2E
>
> What's the motivation to make such a behavioral change ?
>
> -- Hal
>
>>
>> Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
>> ----
>>
>> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core=
/mad.c
>> index 80282f1..b3457ae 100644
>> --- a/drivers/infiniband/core/mad.c
>> +++ b/drivers/infiniband/core/mad.c
>> @@ -1830,25 +1830,39 @@ static void ib_mad_complete_recv(struct ib_m=
ad_agent_private *mad_agent_priv,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ib_response_mad(mad_recv_wc->recv_buf=
=2Emad)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irq=
save(&mad_agent_priv->lock, flags);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mad_send_wr =3D=
 ib_find_send_mad(mad_agent_priv, mad_recv_wc);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!mad_send_wr)=
 {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mad_send_wr) =
{
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ib_mark_mad_done(mad_send_wr);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ib_free_recv_mad(mad_recv_wc);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 deref_mad_agent(mad_agent_priv);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_mark_mad_done(=
mad_send_wr);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqre=
store(&mad_agent_priv->lock, flags);
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Defined behavi=
or is to complete response before request */
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mad_recv_wc->wc->=
wr_id =3D (unsigned long) &mad_send_wr->send_buf;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mad_agent_priv->a=
gent.recv_handler(&mad_agent_priv->agent,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mad_recv_wc);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_dec(&mad_a=
gent_priv->refcount);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* Defined behavior is to complete response before request *=
/
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 mad_recv_wc->wc->wr_id =3D (unsigned long) &mad_send_wr->sen=
d_buf;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 mad_agent_priv->agent.recv_handler(&mad_agent_priv->agent,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mad_recv=
_wc);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 atomic_dec(&mad_agent_priv->refcount);
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mad_send_wc.statu=
s =3D IB_WC_SUCCESS;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mad_send_wc.vendo=
r_err =3D 0;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mad_send_wc.send_=
buf =3D &mad_send_wr->send_buf;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_mad_complete_s=
end_wr(mad_send_wr, &mad_send_wc);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 mad_send_wc.status =3D IB_WC_SUCCESS;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 mad_send_wc.vendor_err =3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 mad_send_wc.send_buf =3D &mad_send_wr->send_buf;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ib_mad_complete_send_wr(mad_send_wr, &mad_send_wc);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if ( =C2=A0!mad_agent_priv->agent.rmpp_version
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0&& ib_is_mad_class_rmpp(mad_recv_wc->recv_buf.m=
ad->mad_hdr.mgmt_class)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0&& (ib_get_rmpp_flags(&((struct ib_rmpp_mad *)m=
ad_recv_wc->recv_buf.mad)->rmpp_hdr) & IB_MGMT_RMPP_FLAG_ACTIVE)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 // user rmpp is in effect
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&mad_agen=
t_priv->lock, flags);
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mad_recv_wc->wc->wr_id =3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mad_agent_priv->agent.recv_handl=
er(&mad_agent_priv->agent,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0mad_recv_wc);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_dec(&mad_agent_priv->refc=
ount);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 } else {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 // not user rmpp, revert to norm=
al behavior and drop the mad
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&mad_agen=
t_priv->lock, flags);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_free_recv_mad(mad_recv_wc);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 deref_mad_agent(mad_agent_priv);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mad_agent_pri=
v->agent.recv_handler(&mad_agent_priv->agent,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mad_recv_wc);
>> diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband=
/core/user_mad.c
>> index 36f815c..f9cacbc 100644
>> --- a/drivers/infiniband/core/user_mad.c
>> +++ b/drivers/infiniband/core/user_mad.c
>> @@ -508,7 +508,7 @@ static ssize_t ib_umad_write(struct file *filp, =
const char __user *buf,
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0rmpp_mad =3D (struct ib_rmpp_mad *) packe=
t->mad.data;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0hdr_len =3D ib_get_mad_data_offset(rmpp_m=
ad->mad_hdr.mgmt_class);
>> - =C2=A0 =C2=A0 =C2=A0 if (!ib_is_mad_class_rmpp(rmpp_mad->mad_hdr.m=
gmt_class)) {
>> + =C2=A0 =C2=A0 =C2=A0 if (!agent->rmpp_version || !ib_is_mad_class_=
rmpp(rmpp_mad->mad_hdr.mgmt_class)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0copy_offset =3D=
 IB_MGMT_MAD_HDR;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmpp_active =3D=
 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
>> @@ -560,14 +560,22 @@ static ssize_t ib_umad_write(struct file *filp=
, const char __user *buf,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmpp_mad->mad=
_hdr.tid =3D *tid;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>
>> - =C2=A0 =C2=A0 =C2=A0 spin_lock_irq(&file->send_lock);
>> - =C2=A0 =C2=A0 =C2=A0 ret =3D is_duplicate(file, packet);
>> - =C2=A0 =C2=A0 =C2=A0 if (!ret)
>> + =C2=A0 =C2=A0 =C2=A0 if ( =C2=A0!agent->rmpp_version
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&& ib_is_mad_class_rmpp(rmpp_mad=
->mad_hdr.mgmt_class)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&& (ib_get_rmpp_flags(&rmpp_mad-=
>rmpp_hdr) & IB_MGMT_RMPP_FLAG_ACTIVE)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_irq(&fi=
le->send_lock);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_add_tail=
(&packet->list, &file->send_list);
>> - =C2=A0 =C2=A0 =C2=A0 spin_unlock_irq(&file->send_lock);
>> - =C2=A0 =C2=A0 =C2=A0 if (ret) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -EINVAL;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err_msg;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irq(&=
file->send_lock);
>> + =C2=A0 =C2=A0 =C2=A0 } else {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_irq(&fi=
le->send_lock);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D is_duplic=
ate(file, packet);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ret)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 list_add_tail(&packet->list, &file->send_list);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irq(&=
file->send_lock);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ret =3D -EINVAL;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto err_msg;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ib_post_send_mad(packet->msg, NUL=
L);
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
