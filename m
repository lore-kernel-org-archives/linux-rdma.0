From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-4.14] IB: Avoid ib_modify_port() failure for RoCE
 devices
Date: Wed, 23 Aug 2017 11:57:12 +0300
Message-ID: <20170823085712.GM1724@mtr-leonro.local>
References: <1503475687-5227-1-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dZMKKfncsnDOeEps"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503475687-5227-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--dZMKKfncsnDOeEps
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 23, 2017 at 01:08:07AM -0700, Selvin Xavier wrote:
> IB CM calls ib_modify_port() irrespective of link layer. If the
> failure is returned, the mad agent gets unregistered for those
> devices. Recently, modify_port() hook was removed from some of the
> low level drivers as it was always returning success. This breaks
> rdma connection establishment over those devices.
> For ethernet devices, Qkey violation and port capabilities are not
> applicable. So returning success for RoCE when modify_port hook is
> is not implemented.
>
> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/device.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--dZMKKfncsnDOeEps
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdQ2gACgkQ5GN7iDZy
WKefExAAnlE4Pf0NdD2O+qxeW4RxyspO5uPa6vVgLqWN6WNwVC//xE2RuWhsLILz
PgkpFdcvRQ4+4mb/GmVDvIKjjm/Np+kpDAspTQntFRcVusQUnET5XaiQzUtssuAd
djsU6ZofqWsQEm8jhQoXoH4cbSqmAbQtBoRoQOd0QsNlOUat332K7084JYQYcL/U
W1hhG9sQh9tt2NfYhrcu718NE+1+2KmFZ0CAiMQmmD80G1ydpNgjMKMxeSF9oKbT
OoXZr0nXCT02dY0JOb3EfS/zPcCWoWxVnwMzlAWjC59FJclmMoH65SxaLLLgmqmy
k/A23ogZkHkguBuljon5kjiKqXcNhlZq8r2/lsaMnZfHFB6EgzSaDRfgJOdigL+g
vTM0jnTbRil+0WZQi0eYJsPgK+PeaTt7AUaOdRi+VwYhXBKO+YlWIy9GQwJtoEwY
qxhz4eXuGdA7oCpuc5oXMcN5dQ68l2LY+nML1mHxHly+UDnhpmxev5EOad9Cbjvp
gbDU5J2SBpVZWjF+RuomK7OwXcLz4yaZwkIUhvPV4hyQ2LtHn/RZqccXmb+pkpYy
8kZ8JUCaZyz+H/KCCacuJkHyURt81F4uPCN/vkIptzLOeNTO5+qIrD1is14HtySi
Po4eZXcpxs697iZrpO+8xjpjNOy10i5Ej25XDrHH5rzI8FwFDls=
=AbLV
-----END PGP SIGNATURE-----

--dZMKKfncsnDOeEps--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
