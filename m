From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
Date: Sun, 27 Oct 2013 22:02:13 +0000
Message-ID: <1382911333.2994.55.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
	 <1382910645.2994.45.camel@deadeye.wl.decadent.org.uk>
	 <1382911111.30941.2.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-X4deC6X0m98Gy3zpky34"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382911111.30941.2.camel@joe-AO722>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-X4deC6X0m98Gy3zpky34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-10-27 at 14:58 -0700, Joe Perches wrote:
> On Sun, 2013-10-27 at 21:50 +0000, Ben Hutchings wrote:
> > Physical addresses may be wider than virtual addresses (e.g. on i386
> > with PAE) and must not be formatted with %p.
>=20
> %pa works.  %pa also prefixes with 0x.

Only as long as pci_resource_start() happens to be an lvalue.  I'd
rather not introduce that assumption.

Ben.

> > diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/=
hw/cxgb4/device.c
> []
> > @@ -602,10 +602,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
> >  	     rdev->lldi.vr->qp.size,
> >  	     rdev->lldi.vr->cq.start,
> >  	     rdev->lldi.vr->cq.size);
> > -	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
> > +	PDBG("udb len 0x%x udb base %llx db_reg %p gts_reg %p qpshift %lu "
> >  	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
> >  	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
> > -	     (void *)(unsigned long)pci_resource_start(rdev->lldi.pdev, 2),
> > +	     (u64)pci_resource_start(rdev->lldi.pdev, 2),
> >  	     rdev->lldi.db_reg,
> >  	     rdev->lldi.gts_reg,
> >  	     rdev->qpshift, rdev->qpmask,
> >=20
> >=20
>=20
>=20
>=20

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-X4deC6X0m98Gy3zpky34
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2NZee/yOyVhhEJAQoBPA/+LjoCC6UW1oO/UXV8if43fJnqvwJTYwiA
F33UTLvCRKJA+ogaKCFGZAjc14Art72RW61nUfHjQpM03JzOefSL2fHTGJwT5Oo3
pBK/tGdW3gB2wLj2p82DVdQe+sWsXye1K0MjF7LzzgvK402aWcFUqzXzmSOQaF/X
E9PdvMO4wxVJ+Bx3fIsym9CbaeLcAkf4xpfssh37eRDK04w+vCahA+o5rTs/NCLn
GKscOTBsCSIR5hWTpmLSUKWQTqVUJRIZquze9z0FOpDNwlF0rTwDJ+Bb8jHiJ1VQ
JuPBWAKi2+sr1P+XlzUXdvsZUUNZi4QGR+uy6i2pg+Dt0RAdjAvBkoHyte0JCinn
tTKxBUMZOwBz8fO0uJVAqMS6ZJnDRdx7dt3P4uUdXqfr4WC7td0bJklx5NqlZRt9
PyFnRWwcjTePNk4LOQpVF4kdFoaXsVtanrULDLy3b7HrA51k+hltvgR89FD+On+e
MkAk59lLrkrIXaJ43uP3VPjSUHjTTzu4fuOWsI6AJ8yQDAI7Xa2i/GgpUkxmTaBv
MW0qeATOOlv9NiIYxdAP4KzLZO+HXgwzMGvx4pMLZrFApL3ZSzkLHXLG1mpwTcEO
0oRYMi8h3YcY0R7ewFe6PZhBNg6Io4P7ysLn26EVhqEr2AvcXokuZOjr8QGNWnS1
R04bi5CqmMI=
=SRRF
-----END PGP SIGNATURE-----

--=-X4deC6X0m98Gy3zpky34--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
