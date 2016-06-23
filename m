From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] ConnectX-4/Connect-IB Port Counters
Date: Thu, 23 Jun 2016 19:17:48 +0300
Message-ID: <20160623161748.GB23995@leon.nu>
References: <1466165456-31857-1-git-send-email-leon@kernel.org>
 <b4dc9bd0-a84c-201a-475a-a9afd9bffb44@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b4dc9bd0-a84c-201a-475a-a9afd9bffb44-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 23, 2016 at 11:41:11AM -0400, Doug Ledford wrote:
> On 06/17/2016 08:10 AM, Leon Romanovsky wrote:
> > This is supplementary part of mlx5 driver to generic IB counters infras=
tructure.
> >=20
> > Mark Bloch (2):
> >   IB/mlx5: Add per port counters
> >   IB/mlx5: Add port protocol stats
> >=20
> >  drivers/infiniband/hw/mlx5/main.c    | 134 +++++++++++++++++++++++++++=
+++++++-
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h |   6 ++
> >  drivers/infiniband/hw/mlx5/qp.c      |   9 +++
> >  3 files changed, 147 insertions(+), 2 deletions(-)
> >=20
>=20
> Took a little work to make it apply, but series applied for 4.8, thanks.

Thanks Doug,

I'm limited in my ability to predict the order of applies, and for
example this patchset applied cleanly for me.

For your reference, I have reference branch (testing/rdma-next) with all
topics in it.

Do you want to see it organized differently?

>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXbAusAAoJEORje4g2clinQ58P/0FV7tItiwD7jFclPjbWywDI
iCkZRMGi5uip1j8pR91WUCJmpmFkmSF75Byvg3Bxr/4D/Y5L6DPWp2/yFGy+hang
Mr7suRJmemXjTO2GRHo545qrCEtddxUcqkgmnRNNf/BioMv6dTUdIAlgNAz1Lbw4
Jpm3dlkrd79jvQ7rbIeO3YN+IlI4mNBsh5UoQ/iO6WefQZTN0+E8L14hjF6MZbY/
J3tAlFzeglFFa5YnvvBEkLSOpJaM+DVjMCIaMjkArZab9U6WT6bsajD7RxxV1QWV
WQM7ju+spuSOuhKwDwEqTAEPoHl4M/4hpykiudggofpuF0zz5BFitM8GD/awEHqs
q8z1slN58D61WjT8+Ef9QqDyWtmCJNoXMGUlOocdlpHAe7pqmD+zkOG39/F3pN8Y
CeBjY8yPYbFEAVdXiX89ag5QzIJEMKtsl8Bm8yaYflC8IFJ1M+jL4JKzJmIuowNF
CvKSemWOG/iibfSvjxuHwK1k+SO/4BgMcEjTFd/xUQAcsmpvNCZkdPy8y9ddFNR5
SMx7HrqBRtwerb8jvr8fLzlfqenRKppzTJGnTlGrVRgRdLeHPiqToHUYPdI3jfGZ
1Pzpql3uFAImrT52QA54eMftxa/LaAdvKN/+AsCFnDhIsRdw9znwZtSmyWZ5Vn/X
T7vXkgQqTBKeJe/7d69z
=CACr
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
