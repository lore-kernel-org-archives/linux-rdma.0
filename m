From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] IB/core: missing curly braces in ib_find_gid()
Date: Thu, 3 Sep 2015 13:39:28 -0400
Message-ID: <55E885D0.7070105@redhat.com>
References: <20150818092210.GE3965@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C5W5CvjpgfV0KTDRnGqQUS4dW2XlPEK3b"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150818092210.GE3965@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C5W5CvjpgfV0KTDRnGqQUS4dW2XlPEK3b
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/18/2015 05:22 AM, Dan Carpenter wrote:
> Smatch says that, based on the indenting, we should probably add curly
> braces here.
>=20
> Fixes: 230145ff8124 ('IB/core: Add RoCE GID table management')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks, applied.

> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core=
/device.c
> index 258b3f7..5d5bbae 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -807,9 +807,10 @@ int ib_find_gid(struct ib_device *device, union ib=
_gid *gid,
>  	for (port =3D rdma_start_port(device); port <=3D rdma_end_port(device=
); ++port) {
>  		if (rdma_cap_roce_gid_table(device, port)) {
>  			if (!ib_cache_gid_find_by_port(device, gid, port,
> -						       NULL, index))
> +						       NULL, index)) {
>  				*port_num =3D port;
>  				return 0;
> +			}
>  		}
> =20
>  		for (i =3D 0; i < device->port_immutable[port].gid_tbl_len; ++i) {
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--C5W5CvjpgfV0KTDRnGqQUS4dW2XlPEK3b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6IXQAAoJELgmozMOVy/dVo0P/isQ7idlh6gz6xUX0earbj+3
HFRrrwOuuZrV1+4xfr0APvY5X6a+J4brZ/W6jErss5SjguJz4cwR32GFALrAE+QT
BN2kSlSUT/eDDzn/tiFqU0jcctNr6yVVuPTngsAEfD6weh3Dg4iCxHAIg+rQdwss
zeD6wdKBkruSbaqW+JPsUcgyn8QXhIaRERosY099DkuxKCLee0sjLiaAd48381jB
iDxRv6ao5l1poNKHCKqH54gMUZzf0BvUAy9WT99sxwdRi1e0AulcGeu4D25mxQVZ
9OXiGEQiO/LOdmZJZ2OP7kKkW0j3OIx4rBD0r0lVTrGTUiO6SnNVNPLumNhEYuR8
H1vpbhhP+CpQovWgiPiSX9ZIZdmWp1yCi+QMLqUeOjEGDe6DgI0CnbdLxDvfJooH
4q7ZAZS63fFfxNpn8psTESm3r6XIeK+tcQ1hSExAfwrfc2VbhU6mRoyRGRGS1+BC
qN98LK32givUvfQGJWNxxnkewVgLXhZBwvPnfCzPHzhUJvBgP06tWd+WURt8qJKR
VhQ47U7A24Y7l0iyd8OU3Wm3hY6qUrH6lyhgb22qJFxfcqWPYy/j++u8pViqrfo9
W+ES/Vqs0RtiJ/IONMpJa7ZWjbQ2D/RWBtnbDrGOaC8ZMEmGypmebKELNXuqf+pV
M/EeD8OF7yiHwAlmI1DV
=w0+L
-----END PGP SIGNATURE-----

--C5W5CvjpgfV0KTDRnGqQUS4dW2XlPEK3b--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
