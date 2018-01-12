From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/rxe: Fix a race condition related to the QP error
 state
Date: Fri, 12 Jan 2018 08:38:28 +0200
Message-ID: <20180112063828.GI15760@mtr-leonro.local>
References: <20180109192340.25702-1-bart.vanassche@wdc.com>
 <1515620434.3403.169.camel@redhat.com>
 <1515621700.3403.174.camel@redhat.com>
 <20180111062252.GP7368@mtr-leonro.local>
 <1515686552.2752.2.camel@wdc.com>
 <20180111190045.GE15760@mtr-leonro.local>
 <1515697625.2752.46.camel@wdc.com>
 <20180112062359.GG15760@mtr-leonro.local>
 <1515738766.10329.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UTZ8bGhNySVQ9LYl"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515738766.10329.3.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jgg@mellanox.com" <jgg@mellanox.com>, "monis@mellanox.com" <monis@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org


--UTZ8bGhNySVQ9LYl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 12, 2018 at 06:32:47AM +0000, Bart Van Assche wrote:
> On Fri, 2018-01-12 at 08:23 +0200, Leon Romanovsky wrote:
> > On Thu, Jan 11, 2018 at 07:07:06PM +0000, Bart Van Assche wrote:
> > > On Thu, 2018-01-11 at 21:00 +0200, Leon Romanovsky wrote:
> > > > On Thu, Jan 11, 2018 at 04:02:33PM +0000, Bart Van Assche wrote:
> > > > > On Thu, 2018-01-11 at 08:22 +0200, Leon Romanovsky wrote:
> > > > > > The proposed patch definitely decreases the chance of races, but it is not fixing them.
> > > > > > There is a chance to have change in qp state immediately after your "if ..." check.
> > > > >
> > > > > Hello Leon,
> > > > >
> > > > > Please have a look at rxe_qp_error() and you will see that the patch I posted
> > > > > is a proper fix. In the scenario you described rxe_qp_error() will trigger a
> > > > > run of rxe_completer().
> > > >
> > > > Bart,
> > > >
> > > > What am I missing?
> > > >
> > > > CPU1							CPU2
> > > > 							if (unlikely....
> > > > 						<---
> > > > /* move the qp to the error state */
> > > > void rxe_qp_error(struct rxe_qp *qp)
> > > > {
> > > >         qp->req.state = QP_STATE_ERROR;
> > > >         qp->resp.state = QP_STATE_ERROR;
> > > >         qp->attr.qp_state = IB_QPS_ERR;
> > > > 						--->
> > > > 							rxe_run_task(&qp->req.task, must_sched);
> > > >
> > > >
> > > >
> > > > It is more or less the same as without "if (unlikely..."
> > >
> > > Hello Leon,
> > >
> > > In the above the part of rxe_qp_error() that I was referring to in my e-mail
> > > is missing:
> > >
> > > 	if (qp_type(qp) == IB_QPT_RC)
> > > 		rxe_run_task(&qp->comp.task, 1);
> >
> >
> > But it is exactly where race exists, as long QP isn't protected, it can
> > switch CPUs and create race.
>
> Hello Leon,
>
> Can you clarify which race you are referring to? rxe_run_task() uses the
> tasklet mechanism and tasklets are guaranteed to run on at most one CPU at a
> time. See also the "Top and Bottom Halves" chapter in Linux Device Drivers,
> 3rd edition. See also the tasklet_schedule() implementation in
> <linux/interrupt.h> and in kernel/softirq.c.

Ahh, Bart, Sorry.

I found the cause of my misunderstanding, it is "comp" in the rxe_run_task
call and not "req".

Thanks

>
> Thanks,
>
> Bart.

--UTZ8bGhNySVQ9LYl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpYV+MACgkQ5GN7iDZy
WKcfVg//X6bF9IBbCpOLqxbF06XqXtGEqcid0tY2GCG+6gMXUYpyHg4Mhez3HUZq
o/zp+Ax15cRKYKyspEMSbCwub3mSRrHs0Eicuk1P510TYYGyTS3W3ipt3B+CUMx4
Ali4hZcfFN+eg3aGf2dbPsdRYvrnMfSd6zobjscMNWsCz7RscArk1e3BcLPRp2mr
CyEvlawACxLY1ky4mQuUfGVEFd1QH8SjCd7T8/5IKySoEMTipj0phrr+5mGBDCF5
q/N4IXM5feYeYVW6KF5ENpdp9qnrMUc0bcUtLc3rVhqjUxKjqROm0cg88rz31slW
oJSWomwP+xvwmQEPFkTskfY6qIMjvutCvFVOe5NxrvWNVooWlf4mUdyAbnrnY7Yn
YFOSoz73WayyBBFzKsmpNuMCAb/T0G+So520yqEvR4Bc4UyFFlwsBwbBlqykw3iP
WGDp/805HJEHQSacXPefMlBSFJ+J4yNwlVcW3FMOCHNft1+EybOVpW9gyxqukhqA
TBvAlg5MMQv85ofuAtJxMHk57ccJdD8dXiWZ6sJaYCXb8o2fjBFZTsZnv/L8XMyj
FkiNRcO1h3H474djbtuDSFipf6/5KsC5CS8sDP7l9cjnuKvZtyJaTSVPDJOScFU1
49LKCmpQ291wjTsrlwtRwj0lEqYQ1puCWNZLi/Ou556XuvKdYRQ=
=S2xp
-----END PGP SIGNATURE-----

--UTZ8bGhNySVQ9LYl--
