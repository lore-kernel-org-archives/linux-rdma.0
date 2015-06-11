From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: LINUX RDMA MAILING LIST MONITOR ALERT - RE: [PATCH for-next V5
 00/12] Move RoCE GID management to IB/Core
Date: Wed, 10 Jun 2015 22:19:30 -0400
Message-ID: <1433989170.71666.106.camel@redhat.com>
References: <AM2PR05MB0866392FDB15F32719EE692DC5BD0@AM2PR05MB0866.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-k7/X6maUJHS7Eox2lE5k"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM2PR05MB0866392FDB15F32719EE692DC5BD0-Wc3DjHnhGid0Y6zYyX2GR9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Diego Crupnicoff <Diego-goXnUAHYgFxWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-goXnUAHYgFxWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-goXnUAHYgFxWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-goXnUAHYgFxWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-k7/X6maUJHS7Eox2lE5k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-06-10 at 23:17 +0000, Diego Crupnicoff wrote:
> Here Sean reacts to our RoCEv2 patches (same thread as the one I sent bef=
ore with Jason's feedback).
> Sean is not even making technical statements to dismiss our patches. He h=
as been rejecting all our previous revs of this set with loose FUD comments=
. In this case he chose to count the lines of code.=20

Sean made a observation: the code was claimed to be a cleanup while it
is significantly larger in size than the code it is cleaning up.  A
cleanup usually doesn't increase size count significantly.  This is
especially true when the cleanup also included deduplication.  It's a
valid assessment.  As I pointed out in the thread, the problem here is
as much as anything else calling the patch set a cleanup.  It is more
than that.  It replaces two partial implementations of RoCE GID
management with one more complete, standardized one.  Once you get past
the improper use of the term cleanup for this patchset, you can review
it more productively.

Sean, while the code is more than a cleanup, it does not include RoCEv2
code and they did do as Jason requested in removing it.  You're under no
obligation to review the code, but your stated reason for ignoring it is
only partially correct.

This isn't the first email to have a less than constructive tone.  I
would appreciate it if people took a moment to breath before hitting
send and remember that we built up quite a backlog of work that needs to
be reviewed and everyone may be a bit frustrated as they try to get
their own projects approved, so please be considerate and constructive.

>=20
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
> > Sent: Wednesday, June 10, 2015 12:10 PM
> > To: Or Gerlitz; Doug Ledford; Jason Gunthorpe
> > Cc: Matan Barak; Moni Shoua; Somnath Kotur; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: RE: [PATCH for-next V5 00/12] Move RoCE GID management to
> > IB/Core
> >=20
> > > Sean, this change is needed b/c two drivers have (mlx4 and ocrda) and
> > > more two to come soon (mlx5 and soft-Roce) would have the very same
> > > logic of constructing the port GID table according to netdev events
> > > and such, no point in repeating this logic/code over and over.
> > >
> > > Matan explained why we don't have 2 x Y deletions and 1 x Y insertion=
s.
> >=20
> > It more than doubles the amount of code.  That's not a cleanup.  It int=
roduces
> > a bunch of new functionality.  Jason has asked repeatedly to remove the
> > RoCEv2 code, and that has been ignored repeatedly.  As far as I'm conce=
rned,
> > this patch is not worth my time, and I will no longer even bother follo=
wing
> > this series.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n the
> > body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-k7/X6maUJHS7Eox2lE5k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAABCAAGBQJVePAyAAoJELgmozMOVy/dcskP9Raa86CHXjp+YDNsurdpQmoR
7kWh90UAxydrnUB9IBJpNMO2uh1DXstA/z1DdxxpFgXDEGTLULwCHR90Qi2c0cAm
GzT1spNd+/6yyr/Q9vqAjYmfvw4WksIGH3g7UFiggCz2b6pBUzEfJTHH9khIrEu3
LunouYg55mmSSnQT/INYlVDFQg2CCtLlnpfUp0QRAooF9QB8qHrCPxNvYpPpUG6P
qOmkOhJPPF39hzrUbr7nLtECxi+MNqldEZbHnVLLI/VHKntFEl4D5qPGtvh5r8Sa
eBrz3H6cn8s3us1OXHfky8Kq81na3n72UAWOtttw/5TzeDTv1kDVYrD+dSnLLJQq
RVh4WhPbgdUKMgp26SwOtN7ztXx+BNCHPwK0Rkss9zjkIkIzMxVrOTRANDLF4S3e
bEgg5rNcnBWKeiqXm4OwYarYIReqQIQ41YNQBZGw+U/KkQwVTvDAgQ6gqrVkpZSg
DoA1LmiKJy6Xz8o95OQMUFZmzr1rqE1YZ/VRVvOq/TjjtyndqW9u7R/AaL+8WuEc
NuKCwmqEVCJ023ii+uIDKmctvXDXGuAqg3i7XF5g8GvMYQHUQSprJzRdRrGmtB2t
GweY+fLr+xtMjVOXXbqkit47a0xm9p4XIwVQw1k9hG6At0a+8e/DqTvVzKKRxV0z
/cxhnkiSMSgbB90Xwl8=
=zNls
-----END PGP SIGNATURE-----

--=-k7/X6maUJHS7Eox2lE5k--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
