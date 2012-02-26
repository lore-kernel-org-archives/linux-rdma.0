From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 03/18] ib_srp: Enlarge block layer timeout
Date: Sun, 26 Feb 2012 19:25:57 +0000
Message-ID: <CAO+b5-orKx3VSWBke+opgc81TwE9y7=pekOwGQPUAB09gkCxnA@mail.gmail.com>
References: <3109536.qySrY1Ts3e@asus>
	<2007426.PROb5t3CLZ@asus>
	<1330237921.1026.81.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330237921.1026.81.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 26, 2012 at 6:32 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote=
:
> On Sat, 2012-01-14 at 12:41 +0000, Bart Van Assche wrote:
> > Enlarge the block layer timeout such that it is above the
> > InfiniBand transport layer timeout. This is necessary to avoid
> > that an SRP response is received after the SCSI layer has
> > already killed the associated SCSI command. Note: the timeout is
> > only set for SCSI disk devices but not for any other type of
> > SCSI device (M/O disk, tape, CD-ROM, ...).
>
> Why disk only? Different default timeouts? If so, there's a better
> solution.

If you have a look at the sd, sr and st source code, you will see that
the timeout set in slave_configure() will be honored only for regular
and MO disks but not for any other type of SCSI device. The default
timeout for MO disks is already more than large enough. By the way, if
you have a look at drivers/scsi/ibmvscsi/ibmvscsi.c, you will see that
in that driver a similar approach is taken for setting the timeout.

> > +static uint32_t srp_compute_rq_tmo(struct ib_qp_attr *qp_attr, int=
 attr_mask)
> > +{
> > +     uint64_t T_tr_ns, max_compl_time_ms;
> > +     uint32_t rq_tmo_jiffies;
> > +
> > +     /*
> > +      * According to section 11.2.4.2 in the IBTA spec (Modify Que=
ue Pair,
> > +      * table 91), both the QP timeout and the retry count have to=
 be set
> > +      * for RC QP's during the RTR to RTS transition.
> > +      */
> > +     WARN_ON((attr_mask & (IB_QP_TIMEOUT | IB_QP_RETRY_CNT)) !=3D
> > +             (IB_QP_TIMEOUT | IB_QP_RETRY_CNT));
>
> Are you guaranteed to get those attributes set if they aren't changed
> from the default?

Yes. ib_cm_init_qp_attr() has to set these for the RTR to RTS
transition, otherwise it would violate the IBTA spec.

>> +static int srp_slave_configure(struct scsi_device *sdev)
>> +{
>> + =A0 =A0 struct Scsi_Host *shost =3D sdev->host;
>> + =A0 =A0 struct srp_target_port *target =3D host_to_target(shost);
>> + =A0 =A0 struct request_queue *q =3D sdev->request_queue;
>> + =A0 =A0 unsigned long timeout;
>> +
>> + =A0 =A0 WARN_ON(target->rq_tmo_jiffies =3D=3D 0);
>> + =A0 =A0 if (sdev->type =3D=3D TYPE_DISK) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D max_t(unsigned, 30 * HZ, targe=
t->rq_tmo_jiffies);
>> + =A0 =A0 =A0 =A0 =A0 =A0 blk_queue_rq_timeout(q, timeout);
>> + =A0 =A0 }
>
> I think you can get rid of any dependency on the default values by ju=
st
> doing
>
> =A0 =A0 =A0 =A0if (q->rq_timeout < target->rq_tmo_jiffies)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk_queue_rq_timeout(q, timeout);

That might cause the timeout to become smaller than 30s. I'm not sure
using smaller timeouts than the current default would be wise.

> This -- or the changes to srp_compute_rq_tmo() -- would also avoid th=
e
> need for the WARN_ON().

The only reason that WARN_ON() is present is to verify that no timeout
has been set yet by sd, just in case the timeout computation code in
sd would ever be moved. I can leave out that WARN_ON() statement if
you want.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
