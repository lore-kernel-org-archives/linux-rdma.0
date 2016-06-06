From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/sysfs: fix memory leak
Date: Mon, 6 Jun 2016 09:34:54 +0300
Message-ID: <20160606063454.GP7477@leon.nu>
References: <1465157636-10120-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1465157636-10120-2-git-send-email-sudipm.mukherjee@gmail.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/DkgDsqJFFamjKX0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465157636-10120-2-git-send-email-sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--/DkgDsqJFFamjKX0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 05, 2016 at 09:13:56PM +0100, Sudip Mukherjee wrote:
> If the allocation of hsag fails we were just returning but stats was
> not released.
>=20
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
>  drivers/infiniband/core/sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sy=
sfs.c
> index fcf6f9c..8d8732c 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -906,7 +906,7 @@ static void setup_hw_stats(struct ib_device *device, =
struct ib_port *port,
>  		       sizeof(void *) * (stats->num_counters + 1),
>  		       GFP_KERNEL);
>  	if (!hsag)
> -		return;
> +		goto err;
> =20
>  	ret =3D device->get_hw_stats(device, stats, port_num,
>  				   stats->num_counters);
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--/DkgDsqJFFamjKX0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXVRmOAAoJEORje4g2clin4jMP/R8fYn3B7BeRV52NOuk3qiiL
dt6+DYzBjrxdDetLwLWe8M0j7funxk+5H8dBtS6UPrqXO1v0Vlx73up0YsO/NYhd
JTqovQo6/3HrPkbEiSo8en0PIw2UuMFbqlmAqQWmLZSBTNvsoc8NnKzmN0oHEC9t
/BruLkyasN3mDKtjpUDaL8leBTUF7NPLfpqXkbCaKF4eh+eR7KihZoACus8AcT/d
Ak4j6gOiNGRQCQFva9d5FrtYCRx4Selqis8sFiVubZouTBW0YW9ggR0mIpi84Ei/
WhnneMe5iHCTVfLGZqYjJ1V0twQwi0NSBcSTWCSYFkewkgVu6hqYV4LaaiCREdeU
y9ls2cNDh38uaG03BvVjlBvn/ieGTSrvVFSqINiKBxBaGm1cHhh0bTGBeZWGyUym
KibN9InhwmGIpP7umTztIqNHUoU+J3OygoDmHgvm6QbeNhVhtWffk5Ow9Y/tdG4R
FyjtmyURnIbHwtuX9But2vhsG/DzK9Pphq0BQNz66+9i/KAiX1pxRnenPB1Q7is2
ezhB35miEuK5upXPN7Fj/QH32+ZTbTzNgPyqktNFlvyDbUeBzue5BLvrf+uw1W2Q
cssYr1yungGRNfsEE2I1qZArA40iqwXf/MhZxLKLllkSVyIMvjIiFuRHzLkBlq/7
eK4xF74XyQUBbDRvpbSS
=/M3I
-----END PGP SIGNATURE-----

--/DkgDsqJFFamjKX0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
