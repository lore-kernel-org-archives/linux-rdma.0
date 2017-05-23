From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4 for-next 08/14] RDMA/bnxt_re: Add vlan tag for
 untagged RoCE traffic when PFC is configured
Date: Tue, 23 May 2017 10:21:59 +0300
Message-ID: <20170523072159.GH17751@mtr-leonro.local>
References: <1495448144-18966-1-git-send-email-selvin.xavier@broadcom.com>
 <1495448144-18966-9-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9ADF8FXzFeE7X4jE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1495448144-18966-9-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9ADF8FXzFeE7X4jE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 22, 2017 at 03:15:38AM -0700, Selvin Xavier wrote:
> From: Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>
> Current implementation does not program vlan header insertion
> in RoCE packet if no vlan is configured. Firmware does not add
> prority when there is no vlan tag in the packet. Modify the code
> to insert vlan header when PFC is enabled on the interface.
>
> Signed-off-by: Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
> v2 -> v3:
> 	Avoid temp variables while populating smac and gid
> v1 -> v2:
> 	Avoid unnecessary memcpy while populating smac and gid
>
>  drivers/infiniband/hw/bnxt_re/main.c      | 53 ++++++++++++++++++---
>  drivers/infiniband/hw/bnxt_re/qplib_res.c | 10 ++++
>  drivers/infiniband/hw/bnxt_re/qplib_res.h |  2 +
>  drivers/infiniband/hw/bnxt_re/qplib_sp.c  | 77 ++++++++++++++++++++++++-------
>  drivers/infiniband/hw/bnxt_re/qplib_sp.h  |  2 +
>  drivers/infiniband/hw/bnxt_re/roce_hsi.h  |  4 +-
>  6 files changed, 124 insertions(+), 24 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--9ADF8FXzFeE7X4jE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkj4xcACgkQ5GN7iDZy
WKd0mA/9EMnPlS0wpS2YJA3+jYWkI2HKToCap/JvRz7lcxu4Z0nIPV6U1glc/pmf
nmHuMTey9IUBXbg/9S8XEqRYXHc8uiKeuTggz5UU+I/87uPXX9XcPLfCKW0OFhJN
f7MWq5vkK96x+eEZtqgVdyBguoELfdfuy4qwlN2Yi6CyG6fh7WhmIcHZ3xu2f0Tl
Vy0aUhggtRgTD9+QrWaKdZ2Jz/PXTsB0eo/2vTBJUhpYIkJKR5gNsv7ds3SA89ho
EIoPPXz9Lin0MLA6Jc9CDmmFR5Bg41dsQHZS7ad/5Ts0MGphHJYO0TVnTwpM0B1u
4NTO775HVh/Nidt2Ot/Ad9DsratiApHbv6KrRWMsZNWp+UYJGWI96Nw3GD9r4KaA
ijYVihgxa73earLQ09bWvNLULoXxh6Y0ZEpTIGf34bvyrbOeWJCbAWn7MtKHXirW
Tyzqc2pd6Svlxv6+WM3++U2glzWLIWlqZN9oN0pqgN/PrwBIcVlVcvl1BoaDIycH
KqgnBHgiyaOSgICWFY03pkyLm6VlE+NE9DG8F8bo2xIeSK6VFvqRJ358t0B3qYbc
+1ph5bWUtViYm52rqQH4WAZWAJHolVQJLJEssFZKTKZ3EZtlZ1w6YIAxk/q3NyOf
3eD6BrV6rVrGR5c+6gu6ZpPVEb2dBt86sjEX8lWWToFiYDy2CKw=
=k6Vx
-----END PGP SIGNATURE-----

--9ADF8FXzFeE7X4jE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
