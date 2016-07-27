From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: IB/mlx4: Use EAGAIN error code instead or EINVAL in function
 mlx4_ib_poll_one
Date: Wed, 27 Jul 2016 14:23:29 +0300
Message-ID: <20160727112329.GG4628@leon.nu>
References: <1469607893-10657-1-git-send-email-yuval.shaia@oracle.com>
 <20160727085800.GF4628@leon.nu>
 <20160727102640.GA3549@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EDJsL2R9iCFAt7IV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160727102640.GA3549-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--EDJsL2R9iCFAt7IV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 27, 2016 at 01:26:41PM +0300, Yuval Shaia wrote:
> On Wed, Jul 27, 2016 at 11:58:00AM +0300, Leon Romanovsky wrote:
> > On Wed, Jul 27, 2016 at 01:24:51AM -0700, Yuval Shaia wrote:
> > > Please review the following two patches.
> > > First patch makes int-return function to a void one as it anyway retu=
rns 0.
> > > Second patch replace all EINVAL error codes returned from mlx4_ib_pol=
l_one
> > > to EAGAIN.
> >=20
> > Thanks Yuval for taking time to do it.
> > After your's IPoIB patches, we prepared patch similar to these and
> > planned to send it after merge window will close.
>=20
> Great new!
> So, will you also take care of making the function use_tunnel_data void?

No problem, I'll resubmit your use_tunnel_data patch.
Thanks

>=20
> >=20
> > >=20
> > > [PATCH 1/2] IB/mlx4: Make function use_tunnel_data return void
> > > [PATCH 2/2] IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20

--EDJsL2R9iCFAt7IV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmJmwAAoJEORje4g2clinimwP/i2JTSEguqHGKJ4lkZBl8eag
MTPPEhgWxl9esTT3g8OovJSMLKSIiVycUJ8QgF6dDs/ZML6ibKhvXg/5Buyjl46K
0bExZu8Hy9bYZ5jbahQZOJ24976brDTAaJ30tXsYBCIp36iMlhcLGh9PbjqfAcJM
eOzG8bHMA2xh9WscLAWdl5P9jMUxCAtHy5zukSv9P56LGa0v1k9MLVGdmYSdQDtR
4EKnk6mZaVfoUCkevWM3bnMyObmaEzw8rVIpVLYzDtCe02lKGFHwp4BnKDvA8+LT
TqwXkvVpp1oJxGPlfJLL4iN2WhsuWEfW6tWcPmueVtHDQB+dPMZpZN5ytc3k27tN
PwQbQLksZFylWrJ/DpicGSirIxES3eqrhVp9A/1L49dfquX84/EZ3En4Cr7SOtNf
+cJaBqQ1jea8qgyUiZDvj0Qswx4pgLJ92iu7Kgu91sleHrQvCYKQuXqFWMDS6uqr
m8b20V/zVM1KG7KWLKFdOmN+tWMwuwk124is1D+vhIhwJzLMfmSII6gAX2/k/vnc
Jonsq3iM3sJGnpdigSvT+n73fZxJ9lDkhlUbXL1YlmcdnEzBFJ8ZNGjHRYWbTRWD
m+En0ZFOHw8VJLp3pcyWDzfxNjNiE1py4cwS9VB+YtueGrY7STTISPmqeYHRby9u
z/oDIrmwVf9DLUsEindZ
=2JET
-----END PGP SIGNATURE-----

--EDJsL2R9iCFAt7IV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
