From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 1/3 v4] IB/srp: Preparation for transmit ring response allocation
Date: Sat, 14 Aug 2010 09:35:56 +0200
Message-ID: <AANLkTikY4V6FULZX_LDMP6BFf6CE_L6KLm73LhtE-HKD@mail.gmail.com>
References: <201008102033.29588.bvanassche@acm.org>
	<1281723889.2437.52.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1281723889.2437.52.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 13, 2010 at 8:24 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wro=
te:
>
> > +
> > + =A0 =A0 rsv =3D (req_type =3D=3D SRP_REQ_NORMAL) ? SRP_TSK_MGMT_R=
SV : 0;
> >
> > =A0 =A0 =A0 srp_send_completion(target->send_cq, target);
> >
> > - =A0 =A0 if (target->tx_head - target->tx_tail >=3D SRP_SQ_SIZE)
> > + =A0 =A0 if (target->tx_head - target->tx_tail >=3D SRP_SQ_SIZE - =
rsv)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>
> This isn't needed per my previous message. It is just a guard to make
> sure we don't use more buffers than are on the ring. The real limiter=
 is
> the number of credits. Perhaps swapping it with the req_limit check
> below and adding a WARN_ONCE() may be a good idea, since I don't thin=
k
> we should ever hit it.

Replacing the above if-statement by a WARN_ON_ONCE() statement would
make sense if the value of tx_head - tx_tail did only depend on the
implementation of ib_srp. That is not the case however -- it also
depends on the rate at which a target sends target-to-initiator
requests. At least in theory, if a (not completely conforming) target
sends requests fast enough, and if the above if-statement would be
removed, it becomes possible that tx_head - tx_tail is larger than
SRP_SQ_SIZE. This means that it becomes possible that
__srp_get_tx_iu() returns a pointer to an information unit that is
still in use and hence that data corruption is caused. Since the above
if-statement does not cause a measurable performance penalty and
because of the risks of removing that if-statement, I prefer to keep
it.

> > - =A0 =A0 if (target->req_lim < min) {
> > + =A0 =A0 if (target->req_lim <=3D rsv) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++target->zero_req_lim;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> > =A0 =A0 =A0 }
>
>
> > @@ -1626,9 +1632,9 @@ static struct scsi_host_template srp_template=
 =3D {
> > =A0 =A0 =A0 .eh_abort_handler =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D srp_a=
bort,
> > =A0 =A0 =A0 .eh_device_reset_handler =A0 =A0 =A0 =A0=3D srp_reset_d=
evice,
> > =A0 =A0 =A0 .eh_host_reset_handler =A0 =A0 =A0 =A0 =A0=3D srp_reset=
_host,
> > - =A0 =A0 .can_queue =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 SRP_SQ_SIZE,
> > + =A0 =A0 .can_queue =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 SRP_REQ_SQ_SIZE - SRP_TSK_MGMT_RSV,
>
> I don't like the naming here and the duplicate math in several places=
=2E
> Pick a name for this and use it. Since this is just the template and =
is
> overridden when we actually connect to a host, I'm not sure there is =
a
> much of a reason to change things here anyways. Same for the next two=
=2E..

I do not agree that the can_queue value filled in in the template is
thrown away later on. As you can see in the ib_srp login code, the
can_queue value is preserved when target->req_lim is larger than the
can_queue value from the template:

        target->scsi_host->can_queue =3D min(target->req_lim,
target->scsi_host->can_queue);

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
