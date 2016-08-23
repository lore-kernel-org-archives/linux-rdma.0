From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband/mlx5: Remove superfluous include of
 io-mapping.h
Date: Wed, 24 Aug 2016 00:15:50 +0300
Message-ID: <20160823211550.GQ15065@leon.nu>
References: <20160823201626.13926-1-chris@chris-wilson.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5KxTQ9fdN6Op3ksq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160823201626.13926-1-chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--5KxTQ9fdN6Op3ksq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 23, 2016 at 09:16:26PM +0100, Chris Wilson wrote:
> This file does not use any structs or functions defined by io-mapping.h
> (nor does it directly use iomap, ioremap, iounamp or friends). Remove it
> to simplify verification of changes to io-mapping.h
>=20
> The include existed since its inception in
>=20
> commit e126ba97dba9edeb6fafa3665b5f8497fc9cdf8c
> Author: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Sun Jul 7 17:25:49 2013 +0300
>=20
>     mlx5: Add driver for Mellanox Connect-IB adapters
>=20
> which looks like a copy across from the Mellanox ethernet driver.
>=20
> Signed-off-by: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>

I assume that it passed 0-day builds.

Except the commit message, which doesn't follow SubmittingPatches guide,
it looks good.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks

--5KxTQ9fdN6Op3ksq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXvL0GAAoJEORje4g2clinc8IQAJZVu/u09AeK7VM9oOJAEzb1
ByrC1IElZ9ur9LYqQ5pdIIIshjCL2uNzm0xwsjDz65kt6+RoLdyk41OKiHjePb1F
H++PXhCAH5i/N0UzuXpcSRhb3kBpxShmpTgz5AWvz0TqT2P6s+PcAaSeBia18D7c
jO3PL62DAvy4xQbeEios8PV/wib5SM2jPIxQ4Ve/WNRIygUSKqYuqu0qFK+VXrJ3
3edlONcqowP3RvLN8P+m1eJKlGHZ1Jj2fNSQMZcfLzum73vmfr6XMPGiYs032mik
zPeQamR4OqI3NwPzJM85q5/Fn+0rQzeMkGzeOLr2vO5lVLq5m5sXEB/JIc/orMx9
vZTLxOMsEDKaV955o8QlP3kAz5db9DF6TPtuOlR+kCmqFhrAAfibD2pWj7nCklcC
gyYzXp1U6btUTXb+pjfTj4KpGnkYLwIQr0QbKHzHkrg7AH3ZWWtrfczBW8/TUd3h
fruWnpYBMLz6ivv/xpmZKoUzDKi4J9kDXgX4738Rq3O8+unL/xyhrPn1Hw/llVFO
35LiwXNxsEtleGXNOqxR13JKRRt3WDo8O2twMTxmCQtoJdl2tNvEVDyoCDDNUNtu
rFMhtpflHj0gnBf8VxV3dp/VZ2j6AloN3pOIaLFiuvzdqbYxVoZeLWVdvWmehF2R
b7WwN5qFBX90fLeqFE+2
=E2qG
-----END PGP SIGNATURE-----

--5KxTQ9fdN6Op3ksq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
