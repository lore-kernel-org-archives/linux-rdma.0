From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Tue, 30 Jan 2018 11:16:54 +0200
Message-ID: <20180130091654.GD2055@mtr-leonro.local>
References: <20180128091725.13103-1-leon@kernel.org>
 <20180128210520.GK23869@ziepe.ca>
 <1517256713.27592.241.camel@redhat.com>
 <20180130033436.GA17053@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180130033436.GA17053-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 29, 2018 at 08:34:36PM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 29, 2018 at 03:11:53PM -0500, Doug Ledford wrote:
> > On Sun, 2018-01-28 at 14:05 -0700, Jason Gunthorpe wrote:
> > > On Sun, Jan 28, 2018 at 11:17:17AM +0200, Leon Romanovsky wrote:
> > >
> > > > The original goal of this series was to allow ability to view conne=
ction
> > > > (QP) information about running processes, however I used this oppor=
tunity and
> > > > created common infrastructure to track and report various resources=
=2E The report
> > > > part is implemented in netlink (nldev), but smart ULPs can now crea=
te
> > > > advanced usage models based on device utilization.
> > > >
> > > > The current implementation relies on one lock per-object per-device=
, so
> > > > creation/destroying of various objects (CQ, PD, e.t.c) on various o=
r the
> > > > same devices doesn't interfere each with another.
> > > >
> > > > The data protection is performed with SRCU and its reader-writer mo=
del
> > > > ensures that resource won't be destroyed till readers will finish t=
heir
> > > > work.
> > >
> > > Well, this cover letter isn't quite right anymore.. but no matter.
> > >
> > > My small comments aside it looks OK to me.
> >
> > Likewise.  I'm happy with it at this point.
>
> Okay, I fixed up the small things and applied the patches to for-next
>
> Leon: Please validate I didn't screw it up. Here is the diff against
> what you sent:
>
> - Success path on the main execution flow, not under an if
> - constify static structure
> - Remove confusing comment about locking, ib_enum_all_devs
>   obtains locks to iterate its list and rdma_restrack_count holds
>   res->rwsem so everything is accounted for directly without
>   trickyness
> - Speeling
> - Remove extra lock in rdma_restrack_del
> - Restore pd =3D NULL in ib_create_xrc_qp. This scraed me a bit, xrc is
>   wonky. But ib_create_xrc_q is only called in cases where
>   rdma_restrack_add is not added, so keeping things as-they-are should
>   not impact restrack. If restrack needs the pd for a XRC someday it
>   should get it from qp->real_qp
> - Remove SET/NEW/DEL cargo cult, please send a patch for rest?
>
> Branch is here:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=3Dwi=
p/jgg-for-next
>
> Still unhappy with the kref-as-not-a-kref.

Thanks Doug and Jason for accepting it.

The "qp->pd =3D NULL" assignment is not needed. PD is NULL
for the XRCD and you are setting "qp->pd =3D pd" before returning
=66rom _ib_create_qp() call, so it is actually the same.

Everything works as expected, it passed my tests with ud/rc/xsrq
pingpongs and shutdowns during traffic.

Steve, I created the stable tag for you: rdma-next-2018-01-30

Thanks

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpwOAYACgkQ5GN7iDZy
WKeVvA/+I69vbpZMqdFVocBfdCrcShyV0jMHFE91jNCFJOI7I1uBG/pmkzAnojFG
57R4WkChmDzVJRtQq0P10L3YovMDYZnLI61dNYhqLhuIyNJd13ufz7Ob1sQ3TQLq
3/OfqMny1+Sg3nNzdGdf4j3FYcc1MqAX7zmRPbBowmM8adT+BrG1h0oNCMR4WwF/
JTa6CHJzChBKrqzxD+FPIiK/rMk5aV/DWSvIlWc2VkVAW87643Xs9G/LwHOHF6Id
4Rf7yQtgdOcP/7gKT1sGkPF3Npsn9D9R15vmWoE41LenRcsRg8haU31UfvUIgFfP
DqXCxJNCm41+0NTaCxSH4E9DKGFuYFOEVz4BDThm6fTWm0LeHPjU9OGRqHmDYn/f
hJmxOiMEjGUdg03ldtsLnr+uhViwYbxd71UrJBqMIFqvI40wc+vZpMV4+ThSalvx
Pac2QKZ2A9X0L+EYMNvEuBuK7kLqRPfGe/XrcOUdFaSiAc1bCrlhMouXKYWZElio
HWCs8Bp7dde+sbUQov7OQgNLpA9NrbuIvb3hi4a4TnEkQ4AdY40lnZD9TG15Yd0n
43l/Xo+fEbeAd6259elcgBILaD5FtzfdvPkRmdSFlMW0g8m9SdG1/IgqZJFO43E5
OOHUbSgb2lySqeBm7aPntMOMRiah0INrEzQ0HtFcyXQHDENzfjA=
=9+eP
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
