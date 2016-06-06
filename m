From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] IB/core: fix an error code in ib_core_init()
Date: Mon, 6 Jun 2016 19:19:24 -0400
Message-ID: <4a0988dd-157d-e2da-397d-0401d8692b7c@redhat.com>
References: <20160531160556.GA23959@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L3UQCMLGkn4AwXDDBMRLNAgvP2HPfHLvo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160531160556.GA23959@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L3UQCMLGkn4AwXDDBMRLNAgvP2HPfHLvo
Content-Type: multipart/mixed; boundary="FXL4w5GFRkd0JFdlwKo9GgBDG7WcpEGLW"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak
 <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <4a0988dd-157d-e2da-397d-0401d8692b7c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] IB/core: fix an error code in ib_core_init()
References: <20160531160556.GA23959@mwanda>
In-Reply-To: <20160531160556.GA23959@mwanda>

--FXL4w5GFRkd0JFdlwKo9GgBDG7WcpEGLW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 5/31/2016 12:05 PM, Dan Carpenter wrote:
> We should return the error code if ib_add_ibnl_clients() fails.  The
> current code returns success.
>=20
> Fixes: 735c631ae99d ('IB/core: Register SA ibnl client during ib_core i=
nitialization')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core=
/device.c
> index 5516fb0..8b8a8d9 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -1024,7 +1024,8 @@ static int __init ib_core_init(void)
>  		goto err_mad;
>  	}
> =20
> -	if (ib_add_ibnl_clients()) {
> +	ret =3D ib_add_ibnl_clients();
> +	if (ret) {
>  		pr_warn("Couldn't register ibnl clients\n");
>  		goto err_sa;
>  	}
>=20

Thanks, applied.


--FXL4w5GFRkd0JFdlwKo9GgBDG7WcpEGLW--

--L3UQCMLGkn4AwXDDBMRLNAgvP2HPfHLvo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVgT8AAoJELgmozMOVy/dQ3EQAIFcdpCPj7pvan6JjEPqhF1L
deMF4xXza7Oo8FHfhd0sESiQSDDSPZQygP/RI1f2GMHOsN2bJ43FI+LV2vXFTnPe
A5wOkCSBT+K/JspOk2uKriF0agGK5k/4LYqEbmaKnVsrSurWe8yBgVwO0rxduU3q
+Y1OOxRdqVPDrTgW6fT+yy1KL7KtaYAf/3P1uMLXPuYJcCWRxq9ZcP8hhzd6EBG6
hn092cE34/JRDDQVIYdW5Lq1AKkv0hO7SapHN1wDhCst/RxtJOVKdLALchPO3xJT
weW/vkgF13NyGLEtI0gDXQGbi1QMcrLfDTBkuvXw9Smfpv+lY+MoA+K/vZl/WHD4
sSzpQ33rPrEUo2OKGrwtAdY7DKeadvnmcFlXxeE/P7TWagkP0mkkLOwRVSBL89z/
cPFXqUYXUGWx1qpvfFHWRYGhMIWOU2VLR9k5WVxBJASkMJQ3/1Moa4AWzP4h1a2w
b2ClfG4U5y2pL4vJ5/AfkMNuiD7UbH0IZ81eXxz4fY0K5sRL1e3FK8f7C8RtxiE2
ktRGguGXwwlWGdsg2Lr4aMgd0kEGfTrtSOv2AwwjegHCec33e4p5ZNw6MUTn0ZVk
mhQCC8xRj3kboaRMTCcqQSC4as0LeAUorHW9rdxNjSaNIlJbXrJPAHehjDDsCbIT
EqL8dwnHN4ruFr/eEuPd
=J5NX
-----END PGP SIGNATURE-----

--L3UQCMLGkn4AwXDDBMRLNAgvP2HPfHLvo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
