From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 1/3 v5] IB/srp: Preparation for transmit ring response allocation
Date: Thu, 19 Aug 2010 18:53:59 +0200
Message-ID: <AANLkTikNUWtw5fHR44HEWK=ceXQ+mxKSKKS1=qrgudXB@mail.gmail.com>
References: <201008162054.06416.bvanassche@acm.org>
	<1282175086.25848.17.camel@obelisk.thedillows.org>
	<AANLkTim=ESAvKNCocpCKGuqaGVnO4FMhBck9+NaoRBZB@mail.gmail.com>
	<1282214698.25848.35.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282214698.25848.35.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 19, 2010 at 12:44 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wr=
ote:
> On Thu, 2010-08-19 at 08:04 +0200, Bart Van Assche wrote:
>> On Thu, Aug 19, 2010 at 1:44 AM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> =
wrote:
>> >
>> > On Mon, 2010-08-16 at 20:54 +0200, Bart Van Assche wrote:
>> > > @@ -989,19 +989,21 @@ static void srp_send_completion(struct ib_=
cq *cq, void *target_ptr)
>> > > =A0static struct srp_iu *__srp_get_tx_iu(struct srp_target_port =
*target,
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 enum srp_request_type req_type)
>> > > =A0{
>> > > - =A0 =A0 s32 min =3D (req_type =3D=3D SRP_REQ_TASK_MGMT) ? 1 : =
2;
>> > > + =A0 =A0 s32 rsv;
>> > > +
>> > > + =A0 =A0 rsv =3D (req_type =3D=3D SRP_REQ_TASK_MGMT) ? 0 : SRP_=
TASK_MGMT_SQ_SIZE;
>> > >
>> > > =A0 =A0 =A0 srp_send_completion(target->send_cq, target);
>> > >
>> > > =A0 =A0 =A0 if (target->tx_head - target->tx_tail >=3D SRP_SQ_SI=
ZE)
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> > >
>> > > - =A0 =A0 if (target->req_lim < min) {
>> > > + =A0 =A0 if (target->req_lim <=3D rsv) {
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++target->zero_req_lim;
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> > > =A0 =A0 =A0 }
>> > >
>> > > - =A0 =A0 return target->tx_ring[target->tx_head & SRP_SQ_SIZE];
>> > > + =A0 =A0 return target->tx_ring[target->tx_head & SRP_SQ_MASK];
>> > > =A0}
>> >
>> > Did you forget to remove the rest of the changes? The only change =
to
>> > this function should be s/SRP_SQ_SIZE/SRP_SQ_MASK/
>>
>> What are your objections against the above changes ? No functionalit=
y
>> has been changed - all the above changes do is to introduce the
>> symbolic constants SRP_TASK_MGMT_SQ_SIZE and SRP_SQ_MASK
>> __srp_get_tx_iu().
>
> Style. Aesthetics. I was fine with SRP_SQ_MASK, but I didn't like the
> rest of the changes. Mainly, I seriously dislike the name
> SRP_TASK_MGMT_SQ_SIZE. But I've given up on the naming issue for now
> since I don't have a better suggestion, and you do remove a magic
> constant, which is good.
>
> Put the assignment on the same line as the declaration and I'll deal
> with the name.

Putting the rsv assignment on the same line as its declaration would
make that line exceed 80 columns and hence would trigger a checkpatch
complaint, so it's better to keep it as it is now.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
