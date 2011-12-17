From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 04/14] ib_srp: Set block layer timeout
Date: Sat, 17 Dec 2011 18:50:45 +0100
Message-ID: <CAO+b5-p9FQVvdVZtUvRJgMW6qhcnUKrp4RhCch1Hnt8JsjS5qQ@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112011959.11956.bvanassche@acm.org>
	<1323977841.16703.57.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323977841.16703.57.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 15, 2011 at 8:37 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote=
:
> > +static int srp_slave_alloc(struct scsi_device *sdev)
> > +{
> > + =A0 =A0 struct Scsi_Host *shost =3D sdev->host;
> > + =A0 =A0 struct srp_target_port *target =3D host_to_target(shost);
> > +
> > + =A0 =A0 if (!WARN_ON(target->rq_tmo_jiffies =3D=3D 0))
> > + =A0 =A0 =A0 =A0 =A0 =A0 blk_queue_rq_timeout(sdev->request_queue,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
target->rq_tmo_jiffies);
>
> What does having a WARN_ON here buy us? We should just set
> target->rq_tmo_jiffies to a default value in srp_create_target(), and
> adjust it as needed based on the CM response.

That WARN_ON() statement is there to verify that rq_tmo_jiffies has
been initialized to a non-zero value - which is the case unless
something bad like memory corruption has happened. I can leave it out
if you want.

> > =A0static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct s=
rp_login_rsp *lrsp,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct s=
rp_target_port *target)
> > @@ -1431,6 +1442,24 @@ static void srp_cm_rep_handler(struct ib_cm_=
id *cm_id,
> > =A0 =A0 =A0 if (ret)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error_free;
> >
> > + =A0 =A0 if (!WARN_ON((attr_mask & (IB_QP_TIMEOUT | IB_QP_RETRY_CN=
T)) =3D=3D 0)) {
>
> Mentally unpacking that to realize the body gets executed if either o=
f
> those is set took a bit of thought... I think you will be better serv=
ed
> setting a default and reducing line that to
>
> =A0 =A0 =A0 =A0if (attr_mask & (IP_QP_TIMEOUT | IB_QP_RETRY_CNT)) {
>
> Also, you need to handle the case where only one of those is set, and
> provide defaults when they aren't -- unless the spec says they both m=
ust
> always be set (I haven't looked), in which case you can modify the
> attr_mask test.

According to table 91 in the IB spec (section 11.2.4.2, Modify Queue
Pair), both the QP timeout and the retry count have to be set for RC
QP's upon the RTR to RTS transition.

> > + =A0 =A0 =A0 =A0 =A0 =A0 uint64_t T_tr_ns, max_compl_time_ms;
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 /*
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0* Set target->rq_tmo_jiffies to one se=
cond more than the
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0* largest time it can take before an e=
rror completion is
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0* generated.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>
> The calculations have a fair number of magic numbers in them; may be
> useful to explain.

All these magic numbers come straight from the IB spec. I can add a
comment mentioning that if you want.

> > + =A0 =A0 =A0 =A0 =A0 =A0 pr_debug("max. IB completion time =3D %ll=
d ms; block layer"
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" timeout =3D %d jiffi=
es\n", max_compl_time_ms,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0target->rq_tmo_jiffies=
);
>
> Is the debug statement really needed? Though I suppose it isn't reall=
y
> hurting anything...

That debug statement was convenient to verify the result of the
computation. But you are right, it's not really necessary. I'll leave
it out.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
