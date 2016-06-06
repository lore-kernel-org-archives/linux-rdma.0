From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/sysfs: fix NULL dereference
Date: Mon, 6 Jun 2016 09:30:59 +0300
Message-ID: <20160606063059.GO7477@leon.nu>
References: <1465157636-10120-1-git-send-email-sudipm.mukherjee@gmail.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hXth9cGL35Nvpk4x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465157636-10120-1-git-send-email-sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--hXth9cGL35Nvpk4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 05, 2016 at 09:13:55PM +0100, Sudip Mukherjee wrote:
> If stats->names is NULL or stats->num_counters <=3D 0 we are jumping to
> the error path where the for loop is freeing hsag->attrs[i]. But as i
> is initialized to 0 so i >=3D 0 will be true and the loop will execute
> once trying to free hsag->attrs[0]. But hsag is NULL still now leading
> to a NULL pointer dereference.
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
> index 5e573bb..fcf6f9c 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -891,7 +891,7 @@ static void setup_hw_stats(struct ib_device *device, =
struct ib_port *port,
>  {
>  	struct attribute_group *hsag =3D NULL;
>  	struct rdma_hw_stats *stats;
> -	int i =3D 0, ret;
> +	int i =3D -1, ret;
> =20
>  	stats =3D device->alloc_hw_stats(device, port_num);
> =20
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--hXth9cGL35Nvpk4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXVRijAAoJEORje4g2clinZVcP/Rz6d7o/62wkjgbmm2fo39jl
DmUSM07+BoJQM4zBkur2hPMa8/zGxsocZFxhBeLlLZZnfkxV0MDAgHN9u8xD3xW3
AAA2shiEoHYK1ru8Vh6HKUO4pUyC6C95OY8ayvu1tPyo3fZOe3KX7dmXcU3IecMW
JkVwe4h0aKdjNpJGsrF3406yWF5lY84dpFsq9u3YzUB8w913j2APd+HpVQj28hxd
IA42kGQHBCzI9YEHXAd3518XNCoZiazuf6IMBEG3YUc7f1s9JNHl7vnWJIJN0AjP
c4K/QwdY4mPppIfScySLjJM6eGJUSKuG83WAqWADpu3Ous/7JQNWAO7PuVMBPyjH
EDIZoYAo798laINpDpcQszNalolXdvYgYgZJ4fTxUAkth8eEGvkoYsuEaQ9zqWTs
bVF28XuvEnjT8GlumEW1qqwP0c0DTHlA5l3hNLTyBfUdbE/MYqBMWjRDzuN32yh0
zFQmBjpjTDS1zTxHZJfNClh1OovOhRe7RHy67o0uI3aw7L/U14QkOM6nq3pD5O64
iXDe+vKO5Kc50yhP+861lte5+10zUM2VXEpSH80s62bXcqWhVguxXMuopc8M7vbh
e8XAuMD+/IVSUEslKaHGINh/TWhJVFx9mIdM6iQxkt2OstVr1Qgty6YeCqTnSoO7
1TAvpyNpta+ho/2ZKHEt
=i2rs
-----END PGP SIGNATURE-----

--hXth9cGL35Nvpk4x--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
