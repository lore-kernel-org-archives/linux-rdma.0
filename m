From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix net_dev reference leak with failed requests
Date: Thu, 3 Sep 2015 13:56:24 -0400
Message-ID: <55E889C8.8080803@redhat.com>
References: <1440680115-9164-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DvNvPfOURGf6G0NilpEAs5vCLAwOUAauO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440680115-9164-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DvNvPfOURGf6G0NilpEAs5vCLAwOUAauO
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/27/2015 08:55 AM, Haggai Eran wrote:
> When no matching listening ID is found for a given request, the net_dev=

> that was used to find the request isn't released.
>=20
> Fixes: 20c36836ecad ("IB/cma: Use found net_dev for passive connections=
")
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Applied, thanks!

> ---
>  drivers/infiniband/core/cma.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cm=
a.c
> index 9b306d7b5c27..b1ab13f3e182 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1302,6 +1302,10 @@ static struct rdma_id_private *cma_id_from_event=
(struct ib_cm_id *cm_id,
>  	bind_list =3D cma_ps_find(rdma_ps_from_service_id(req.service_id),
>  				cma_port_from_service_id(req.service_id));
>  	id_priv =3D cma_find_listener(bind_list, cm_id, ib_event, &req, *net_=
dev);
> +	if (IS_ERR(id_priv)) {
> +		dev_put(*net_dev);
> +		*net_dev =3D NULL;
> +	}
> =20
>  	return id_priv;
>  }
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--DvNvPfOURGf6G0NilpEAs5vCLAwOUAauO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6InIAAoJELgmozMOVy/dEqQQAJVsZbA7Qa/dzlE0TFvydUro
cmIys2X8HlN29nTHOSNY/MAeVhlBeSZ89O8kKd1WuF7sCch5gL84Y1JF//GA6AKf
h7HuxS73RNDmHEBGk5MjgZv2qqOcV9Z7o8rzgK6yu0ZGaxCkFP+DwkbL1D7jTU2s
ws4nQZjrDJJZ3EB/NOIc+Iq7po2ENzthlVPBk88h/SS/yYT0bXig1iXRYpBKH8nJ
mvgPh4EM+OstAHc78I5gmwtDsfZ5WG+W/iAWM2NsXpP8twm5faKiLx1QVVR2fs/K
B+Ygu4VSJwsNH4dq7V02P7v1uGSoRjdPC5Gk9GMiMseY/1ek1fNm062gC45/xEsa
Mi5W8ZCLKck7BIa4jEKd3AJ8ii85ZxcCZPlJAn3itFODD+072G1mq/onC52crYNj
KeOTkfD/515hMknynAIgLTE4QKfOIxB0nYR8CYIbTAFlio9teyGHA2ebLqOYcHfV
XbP4KyxiB2ROq3ZxN02jBH6JrOiJ6Hw3Qgbd1Fg4h+MdCpUo54UK4DxKCorblw6b
zlEuF7F4ZtA1jtHe0UjStodSgAuAU/Cfn+s78m6c6o4y268XJw2OFUgk1Ru/LRax
A2vkny0glNdn6shzKaq4iv9wbXQvA2c5X+crfYIb4aeXz58zvIF4kAeIB6R0CPkO
5qsdPIQIqJz1fRKBBwFN
=ReSH
-----END PGP SIGNATURE-----

--DvNvPfOURGf6G0NilpEAs5vCLAwOUAauO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
