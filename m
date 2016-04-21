From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/rdmavt,hfi1,qib: Fix memory leak
Date: Thu, 21 Apr 2016 12:38:27 +0300
Message-ID: <20160421093827.GA26951@leon.nu>
References: <20160420125205.28231.86818.stgit@scvm10.sc.intel.com>
 <20160420130523.28231.90454.stgit@scvm10.sc.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160420130523.28231.90454.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 20, 2016 at 06:05:24AM -0700, Dennis Dalessandro wrote:
> From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> rdi->ports has memory allocated in rvt_alloc_device(), but does not get
> freed because the hfi1 and qib drivers drivers call ib_dealloc_device()
> directly instead of going through rdmavt. Add a rvt_dealloc_device()
> that frees rdi->ports and then calls ib_dealloc_device(). Switch hfi1
> and qib drivers to calling rvt_dealloc_device() instead of
> ib_dealloc_device() directly.
>=20
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Dennis,
You posted Fixes line in two other patches, please do in this one two.
It is needed for proper tracking.

Except this,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXGJ+TAAoJEORje4g2clinvDEP/iKxD64a8mzM0YOs0YRte/Bl
6qxPGKok6U4jlRfA9m9SW4DyabVRWakPU9l5opkmWUKoFJvZf6OYZ8/YEmJoUe0Q
yh294tHo6XAoKqSUJbk5x5WlL5WFhLZLcdHN6MQJbkQ42kasliSTZbwVYO9VRgiO
kYjg0V/gU+u9XZ9h8RBKk7w1Ft6LLs76w30lvQcD7sAN2vRA6EOUvWaBhe/A6Cz3
d2x1LwD/K5EGrSrxB+js54t0nlHP/f9aGeqCD1cXldmQIzjab53OPv5SMoUHJ0Iw
09eb0KC3bJZS5tYHYIxPJdh54fVIZjIsVROvNRRhtRagAGrybImGdogAl4PYNd2b
IjX70DTeaTsHT7fiC+UR6iE4N3lr5vVyZYFdCbUwMVkUlt7ncUnKWji2as91sObx
6y+nR4PabTvzTU1wqshL3K1JucOaedCnAsAxnkawVeTDKIY8isTNEsYtbWdxWxWN
eKrtcX0uEpws1L13Vyb+mqUnQ6FwTcAXN4ZfQjKYzUrb4rip8Hr9XR0O9M5hGMGG
v79tcu8bTHIMZNYa0e4ptE9Y/rq1UjsNy+TadX92+nsyOZpQDDHKmcvetjnVhUa4
Q2cZ5xH4YWCwTIcYL6rj5JNgFMHC4DM6wAo1AOpTGcXibIwN072fM+iN/1JbwSoT
VONyKj4Txjbzl5kYlNuT
=FX3A
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
