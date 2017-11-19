From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Please update the linux-next location for the RDMA subsystem
Date: Sun, 19 Nov 2017 08:46:40 +0200
Message-ID: <20171119064640.GV18825@mtr-leonro.local>
References: <1510948060.3973.29.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3vuPqocktzL7+mDR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510948060.3973.29.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3vuPqocktzL7+mDR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 17, 2017 at 02:47:40PM -0500, Doug Ledford wrote:
> Hi Stephen,
>
> Jason Gunthorpe is now co-maintaining the RDMA subsystem with me.  We
> have a shared repo that we can both write into.  I would like you to re-
> aim the RDMA linux-next pull point to:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-
> next

Doug,

Does it make sense to get rid of "k.o" notation for for-next and for-rc branches?
It is already on kernel.org and seems to me as a redundant.


Thanks

>
> Thanks!
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--3vuPqocktzL7+mDR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloRKNAACgkQ5GN7iDZy
WKc+GQ/5AVjtnQaugioLykICsQdvsY7i8XGRVlQI3X+P3UjOIIoc1MYm5Rxfg04E
6LMY2JaJwRVqEZ7pLQON9Yu0gadC8zx+ujatksWeQThw04vqjkgVaq7AACe8rU9d
jiwWk892KB4H3UsFlm9uU7MTBLKVK7K4IeUkbrD1mPmGiW8179SWbnK7WExZle/b
RMONduf5C2XnaJQaKNLCwXHTE8lAsSY9j6gtMeZ4+AxGQ7/KsC9tMkb83vKdl21H
McydmO2HopPZPX+f7bfHHh9nHzr+z0MHEXHZLDfRxJNy5BuqKoodwLHoMEsOAZer
VZ5iEnR1FgsPgoB6idAiTLZ248wsfssE+2VlLQTfIiiYVScGRdbBiCHX+IYcvsFv
pIzAC78L9SlDmqxY7/uRPH+7h5atCRCEjX3FyMNnOfbfdVp+AQzLvciN6WtTbimH
fRXKYHgsjDQ9eDO8xNfM9536RzfCea4/SOJkKHMpJyxxAnHC7LMAnw7fpIXbIwcA
8l78nrjuDfprJ+QZbjZs7N6kgD2AcrC/AxwFv0O7IIEmFvy7NZTaYY9+QwmwslFZ
D1/W8eXK5rj1eS9HnTgMs0PdnuVrClIfuYV2cNGVHhHQEb4teDBKam0jj/kBiarp
4diz3AApSkh3zYWiu2A6EQdx8wp7heZIcS+aXi7mINCNgRE1ijo=
=jGpH
-----END PGP SIGNATURE-----

--3vuPqocktzL7+mDR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
