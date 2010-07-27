From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ib/mlx4: add IB_CQ_REPORT_MISSED_EVENTS support
Date: Tue, 27 Jul 2010 11:29:04 +0200
Message-ID: <AANLkTinWi+Dozs2dU=_bmvNhs5dKzkFrJc3oPMLaGj00@mail.gmail.com>
References: <4C4E96F9.4040503@Voltaire.com>
	<AANLkTinPRO6mOnCS-SJynkRXmt6J1uV3w5+8PfF6ubxN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinPRO6mOnCS-SJynkRXmt6J1uV3w5+8PfF6ubxN-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Can I conclude from this that the polling loop (2) from
http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg04907.html
won't trigger a race on a multiprocessor when using mlx4 hardware ?

Bart.

On Tue, Jul 27, 2010 at 11:14 AM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wr=
ote:
>
> I don't think this patch is required for mlx4.
>
> =A0 =A0 =A0 =A0 < 0 =A0 =A0means an error occurred while requesting n=
otification
> =A0 =A0 =A0 =A0=3D=3D 0 =A0 =A0means notification was requested succe=
ssfully, and if
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IB_CQ_REPORT_MISSED_EVENTS was passed =
in, then no
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0events were missed and it is safe to w=
ait for another
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0event.
> =A0 =A0 =A0 =A0 > 0 =A0 =A0is only returned if IB_CQ_REPORT_MISSED_EV=
ENTS was
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0passed in. =A0It means that the consum=
er must poll the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CQ again to make sure it is empty to a=
void the race
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0described above.
>
> returning 1 means that you must poll the CQ to avoid a race condition
> which is not true for mlx4. For example if you return always 0 than
> you don't violate what the changelog says.
>
> On Tue, Jul 27, 2010 at 11:21 AM, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> > enhance the cq arming code to support IB_CQ_REPORT_MISSED_EVENTS
> >
> > Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> >
> > ----
> >
> > I noted that the IB_CQ_REPORT_MISSED_EVENTS flag was added in the s=
ame cycle with mlx4
> > and maybe as of this, mlx4 didn't implement the flag, which is used=
 by IPoIB
> >
> > The patch is compile tested only, if the patch seems okay, I can co=
nduct further testing.
> >
> > diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/h=
w/mlx4/cq.c
> > index 5a219a2..4366811 100644
> > --- a/drivers/infiniband/hw/mlx4/cq.c
> > +++ b/drivers/infiniband/hw/mlx4/cq.c
> > @@ -755,6 +755,13 @@ int mlx4_ib_arm_cq(struct ib_cq *ibcq, enum ib=
_cq_notify_flags flags)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0to_mdev(ibcq->device)->uar_m=
ap,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MLX4_GET_DOORBELL_LOCK(&to_m=
dev(ibcq->device)->uar_lock));
> >
> > + =A0 =A0 =A0 if (flags & IB_CQ_REPORT_MISSED_EVENTS) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mlx4_cqe *cqe;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cqe =3D next_cqe_sw(to_mcq(ibcq));
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cqe)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> > + =A0 =A0 =A0 }
> > +
> > =A0 =A0 =A0 =A0return 0;
> > =A0}
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
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
