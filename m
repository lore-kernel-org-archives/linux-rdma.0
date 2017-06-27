From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: NFS/RDMA RoCE with mlx4_en
Date: Tue, 27 Jun 2017 09:22:31 +0300
Message-ID: <20170627062231.GO1248@mtr-leonro.local>
References: <5E2BFC42-DDA1-4666-BA45-2E33A47C0ED5@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UIkw8Cc2/Xz5YwHB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5E2BFC42-DDA1-4666-BA45-2E33A47C0ED5-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--UIkw8Cc2/Xz5YwHB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 26, 2017 at 01:24:11PM -0400, Chuck Lever wrote:
> Running various I/O stress workloads with iozone on an
> NFSv3 mount using RDMA on RoCEv1 (FRWR).
>
> Jun 26 12:50:21 morisot kernel: mlx4_core 0000:01:00.0: command 0x49 timed out (go bit not cleared)

It means that device had internal error before and/or pci channel is offline and is restarting now.

> Jun 26 12:50:21 morisot kernel: mlx4_core 0000:01:00.0: device is going to be reset
> Jun 26 12:50:22 morisot kernel: mlx4_core 0000:01:00.0: device was reset successfully
> Jun 26 12:50:22 morisot kernel: mlx4_en 0000:01:00.0: Internal error detected, restarting device
> Jun 26 12:50:22 morisot kernel: <mlx4_ib> mlx4_ib_handle_catas_error: mlx4_ib_handle_catas_error was started
> Jun 26 12:50:22 morisot kernel: <mlx4_ib> mlx4_ib_handle_catas_error: mlx4_ib_handle_catas_error ended
> Jun 26 12:50:22 morisot kernel: ib_srpt received unrecognized IB event 8

Thanks

--UIkw8Cc2/Xz5YwHB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllR+acACgkQ5GN7iDZy
WKd9fxAAoJYXwqzLGylkqp8g20Xe+Qw14gG8CcP8RykDYht9u6e1QOoMb0NF/sP6
xf0+91Oml6NHKRbAnlSC2W4/ZVa/UbDI3uM0WcIYPISviCofaEwUeA/mQ58BEWZ/
AEV9twO4jggWbNnbvSrI6dYLw3iCyv++mjNt5BmtaXqMFtZaAUtshnyhulA5TYjb
vZ3VAIPHWeHSmxbj7RY33yuonpqGe5eaGfbarTHhiEoqtWAesOL3vxCC+Efgi8R7
SY5MvSe14WHLLmP2qwoEtT4IIqdVyfT3V+cCYcaDa456fRzC2+A9ADqlLs+6DAED
HlG2mjisfTppthThkEK/LT5peRF9jhsA78XYq7PjgEyAc3SDnNpJF71nUgQOXiT5
TZtZaIHADt5c/QKJlq28o3qhSBxVqpBMvM6t57KgSX+S5n1321STcxqRA+2xyJvK
cDxdIrnwZzp/i+2IjAR99O5zXmw09+JtvtmLwlHE+MGtsGFzW4zlxdXOPTNPqxUO
TwDtmoxWF4988VR9yNMyxfuRGlIfq1CXNPhtBVt/LfvkPO77T8yIYYLJCUGkJBsG
oLgAUzJblEgl2wHbC4g03uj1zY1Ok6FMS8CLjM2QOdMFTRo4sX5aXZB457/I0QUw
NHCTb5WRg8xZjoELhqc8cBPr17vkTvcRVCYg+bi0gX95PbPeKU0=
=X57+
-----END PGP SIGNATURE-----

--UIkw8Cc2/Xz5YwHB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
