From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Mon, 29 Jan 2018 07:39:02 +0200
Message-ID: <20180129053902.GD1393@mtr-leonro.local>
References: <20180128091725.13103-1-leon@kernel.org>
 <20180128210520.GK23869@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FclElvQKoGCylS3A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180128210520.GK23869-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--FclElvQKoGCylS3A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 28, 2018 at 02:05:20PM -0700, Jason Gunthorpe wrote:
> On Sun, Jan 28, 2018 at 11:17:17AM +0200, Leon Romanovsky wrote:
>
> > The original goal of this series was to allow ability to view connection
> > (QP) information about running processes, however I used this opportunity and
> > created common infrastructure to track and report various resources. The report
> > part is implemented in netlink (nldev), but smart ULPs can now create
> > advanced usage models based on device utilization.
> >
> > The current implementation relies on one lock per-object per-device, so
> > creation/destroying of various objects (CQ, PD, e.t.c) on various or the
> > same devices doesn't interfere each with another.
> >
> > The data protection is performed with SRCU and its reader-writer model
> > ensures that resource won't be destroyed till readers will finish their
> > work.
>
> Well, this cover letter isn't quite right anymore.. but no matter.

So, what is next? Are we ready to merge it?

>
> My small comments aside it looks OK to me.
>
> Jason

--FclElvQKoGCylS3A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpus3YACgkQ5GN7iDZy
WKeXcBAAuvEQMJj4JBFxNhFAMXEKy9vyd6H4WSio1a6lHgLf412z3TcEGdNCOuaj
+J2pwLQ1sUWqVrY7N+xCfgW4otxKW9NeiuT7fXOAU2EN1hy3MtovKKkMRG6CHAJY
Y5HnzldnypiMwBmeG7O1jSAKqWZaEUyl6ZGEhJZtATbwPW5A84uveoPU9fRXsSM/
R/jlm69Y2JTOudK/PwxAL0UKBrXI3BqW0XxZSuQDSapjpnu90byJyL5JjSE00OmB
Or/RrMr6AGEn5eKhV8vxSfdVoYTwqKXCGt0rli7cZz1Wom0P6oivAuxYVLBVcS0B
pXhwlGJNOhNUJ9XRRFWG0q1tE8d0LHxWMoX4KmjUopOtAKymsHCAvmpQypuZ/luS
w/Bwx+kwK7pshNH7yF9STuwty18TmjNyBxoiyyrzVoknm9vbX53o/vaADJbl21yx
FoaEyYJZYeZyIsC0OdKKmAHRfKDbw3Fc9ie94MNbPi+b0bwsX58bWV/FuUq8cTOI
vHzczhRq7HZGv/RWQZxQcUWgaICne4R2aIQUnJgL7r/m6uHjNrxC1mcQxDy/5Bti
3CkL0pE+SVYS4T1zR+4hfnvBPFQ7JFMNYO9pzC6oTIl8nKfw6x8DruOXExkGP0sI
tv4zyFF/Yd7C4HiT4GhxIRCMzUrbNIbxZAjYe8rSfdyaYNLlcU0=
=2Pyj
-----END PGP SIGNATURE-----

--FclElvQKoGCylS3A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
