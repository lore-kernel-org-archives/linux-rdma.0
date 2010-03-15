From: Thadeu Lima de Souza Cascardo <cascardo-DmMZpsCg3uxeGPcbtGPokg@public.gmane.org>
Subject: Re: [patch] infiniband:  remove dead code
Date: Mon, 15 Mar 2010 11:18:47 -0300
Message-ID: <20100315141846.GA1477@holoscopio.com>
References: <20100315082332.GF18181@bicker>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100315082332.GF18181@bicker>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 15, 2010 at 11:23:32AM +0300, Dan Carpenter wrote:
> "ret" is initialized to -ENOMEM so we don't need to set it here.
>=20
> Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniban=
d/ulp/iser/iser_verbs.c
> index 308d17b..8fa6997 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -148,10 +148,8 @@ static int iser_create_ib_conn_res(struct iser_conn =
*ib_conn)
>  	device =3D ib_conn->device;
> =20
>  	ib_conn->login_buf =3D kmalloc(ISER_RX_LOGIN_SIZE, GFP_KERNEL);
> -	if (!ib_conn->login_buf) {
> +	if (!ib_conn->login_buf)
>  		goto alloc_err;
> -		ret =3D -ENOMEM;
> -	}
> =20
>  	ib_conn->login_dma =3D ib_dma_map_single(ib_conn->device->ib_device,
>  				(void *)ib_conn->login_buf, ISER_RX_LOGIN_SIZE,
> @@ -160,10 +158,9 @@ static int iser_create_ib_conn_res(struct iser_conn =
*ib_conn)
>  	ib_conn->page_vec =3D kmalloc(sizeof(struct iser_page_vec) +
>  				    (sizeof(u64) * (ISCSI_ISER_SG_TABLESIZE +1)),
>  				    GFP_KERNEL);
> -	if (!ib_conn->page_vec) {
> -		ret =3D -ENOMEM;
> +	if (!ib_conn->page_vec)
>  		goto alloc_err;
> -	}
> +
>  	ib_conn->page_vec->pages =3D (u64 *) (ib_conn->page_vec + 1);
> =20
>  	params.page_shift        =3D SHIFT_4K;

If there's a failure while allocating page_vec, login_buf will not be
released. A single extra label should solve this.

Regards,
Cascardo.

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkueQcYACgkQyTpryRcqtS0vnwCdHXimT2LSatvTFMlRZioTrRC7
hVkAnR6tSJBc/m8CuJslRRMuQc53Vv/O
=1rr0
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
