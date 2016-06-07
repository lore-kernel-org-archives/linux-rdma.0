From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: remove dead code
Date: Tue, 7 Jun 2016 10:33:09 +0300
Message-ID: <20160607073309.GE3663@leon.nu>
References: <1465247706-4418-1-git-send-email-sudipm.mukherjee@gmail.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KlAEzMkarCnErv5Q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465247706-4418-1-git-send-email-sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--KlAEzMkarCnErv5Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2016 at 10:15:06PM +0100, Sudip Mukherjee wrote:
> prot_sg_cnt has been assigned with the value of ret which we have
> already checked to be non-zero so prot_sg_cnt can never be zero at this
> point of the code and hence the else part can never execute.
> And since we know prot_sg_cnt is non zero there is no use for the
> if condition also.
>=20
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>

And what about other places?

428         if (prot_sg_cnt)
429                 ctx->sig->sig_wr.prot =3D &ctx->sig->prot.sge;

=2E...


455         if (prot_sg_cnt)
456                 ib_mr_pool_put(qp, &qp->rdma_mrs, ctx->sig->prot.mr);

=2E...


> ---
>  drivers/infiniband/core/rw.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> index 1eb9b12..a829a14 100644
> --- a/drivers/infiniband/core/rw.c
> +++ b/drivers/infiniband/core/rw.c
> @@ -386,21 +386,17 @@ int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *=
ctx, struct ib_qp *qp,
>  	count +=3D ret;
>  	prev_wr =3D &ctx->sig->data.reg_wr.wr;
> =20
> -	if (prot_sg_cnt) {
> -		ret =3D rdma_rw_init_one_mr(qp, port_num, &ctx->sig->prot,
> -				prot_sg, prot_sg_cnt, 0);
> -		if (ret < 0)
> -			goto out_destroy_data_mr;
> -		count +=3D ret;
> +	ret =3D rdma_rw_init_one_mr(qp, port_num, &ctx->sig->prot,
> +				  prot_sg, prot_sg_cnt, 0);
> +	if (ret < 0)
> +		goto out_destroy_data_mr;
> +	count +=3D ret;
> =20
> -		if (ctx->sig->prot.inv_wr.next)
> -			prev_wr->next =3D &ctx->sig->prot.inv_wr;
> -		else
> -			prev_wr->next =3D &ctx->sig->prot.reg_wr.wr;
> -		prev_wr =3D &ctx->sig->prot.reg_wr.wr;
> -	} else {
> -		ctx->sig->prot.mr =3D NULL;
> -	}
> +	if (ctx->sig->prot.inv_wr.next)
> +		prev_wr->next =3D &ctx->sig->prot.inv_wr;
> +	else
> +		prev_wr->next =3D &ctx->sig->prot.reg_wr.wr;
> +	prev_wr =3D &ctx->sig->prot.reg_wr.wr;
> =20
>  	ctx->sig->sig_mr =3D ib_mr_pool_get(qp, &qp->sig_mrs);
>  	if (!ctx->sig->sig_mr) {
> --=20
> 1.9.1
>=20

--KlAEzMkarCnErv5Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXVni1AAoJEORje4g2clinVHgQAJRkMD6ezXgyhYCykxU/AViH
kp2NvHc6fHcRQNKmuLNupI3KahoUewhNzWB/PuRrZfc/1PbcWMSx8BXcA5Kzl373
RT/hpyNIZUs3byP6gJCPVLVVp/z1JYaTDdJ4ShI9dePfBM+iTZYOy2j5UdBeXPfH
v4pQ6lSY3t4nVQTMm9hzZu5C7zc4E+OnJGFSDiDVYfnwMwgzhojsJvtlh6Esha/J
hVtRPHn7glMVwzPpBwtGX5TGAcPrv3jDc5aWpzi8u7ulfKHXCpZr7cjozrJalI5W
8OoK8+8JhWe2t/whSP9WqHi/D8v29FoiZJH3aUYvydW6RltM5Bg/y2tpfCdrAcAw
KHp5ggJCemXUfA7J9r0UadfT1mdHGRhsUR0GoWxT4fOgL2LZx3npoXZw9x74T4Z5
BQOo2ID3pkBEi3yI78B634+mW7KrZZAS/oHPywztz+R+nTKZGJEGBN3+3ZlYHjWR
8ucYXtRqaZCLPKzrBBpf8Rcp6lCzKjrubyv5SFwPQ8QbRQZfqbGGcQoF7WQ5hAug
5pbE2QChvFzxzswv9PY1macM3OsO/KVNrklPTYtrgnsxJ039UpKWcJXZLJdzSS9I
fbrGCVP/6Txa/SPaeGajIOAYVKJy8X7icX3Udv35tS/WdvMVga2qA5EZDvR14XY2
yFSxCIykx+EVQcYT2ObB
=VagP
-----END PGP SIGNATURE-----

--KlAEzMkarCnErv5Q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
