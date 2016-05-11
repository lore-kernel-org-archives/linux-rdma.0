From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/6] IB/srp: Fix a memory descriptor leak in an error path
Date: Wed, 11 May 2016 10:31:27 +0300
Message-ID: <20160511073127.GC25215@leon.nu>
References: <573278D9.4050908@sandisk.com>
 <57327921.9030306@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="96YOpH+ONegL0A3E"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57327921.9030306-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 10, 2016 at 05:13:21PM -0700, Bart Van Assche wrote:
> If an error occurs after srp_fr_pool_get() succeeded and before the
> descriptor is stored in srp_map_state (*state->fr.next++ =3D desc)
> then srp_unmap_data() won't free the newly allocated memory
> descriptor. Hence free the descriptor explicitly.
>=20
> Fixes: f7f7aab1a5c0 ("IB/srp: Convert to new registration API")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sagi Grimberg <sai-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.4+
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp=
/srp/ib_srp.c
> index e088a49..74e3ec8 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1330,8 +1330,13 @@ static int srp_map_finish_fr(struct srp_map_state =
*state,
>  	ib_update_fast_reg_key(desc->mr, rkey);
> =20
>  	n =3D ib_map_mr_sg(desc->mr, state->sg, sg_nents, 0, dev->mr_page_size);
> -	if (unlikely(n < 0))
> +	if (unlikely(n < 0)) {

The ib_map_mr_sg can return 0 which is not error, but still pretty
useless number of mapped SGE. I didn't look on the srp code close enough, b=
ut will
the code handle this case correctly?

> +		srp_fr_pool_put(ch->fr_pool, &desc, 1);
> +		pr_debug("%s: ib_map_mr_sg(%d) returned %d.\n",
> +			 dev_name(&req->scmnd->device->sdev_gendev), sg_nents,
> +			 n);
>  		return n;
> +	}
> =20
>  	req->reg_cqe.done =3D srp_reg_mr_err_done;
> =20
> --=20
> 2.8.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--96YOpH+ONegL0A3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXMt/PAAoJEORje4g2clinP8UP/3wG9XydLJ7mRe52eoDf8Sjf
fNfAHO4yEhA6M1roIB7H1Jig4K0EjDNAkjKf37cXnl+JOy1VzRDvHPpWntu2k1ro
YHu5ItF4zpVr1tU1qbKXWOIPRb2XeYjGLpeNszZYHgnXmVLycejX6RIACHWS9KwM
fSeOJTzEYMP3W/b23Is/7J8c+mfCvNLlJMg2AjUfp11MvqFhlq2hPfWkLzky8+Hz
wIXI1MTQxo2QodZffpeUfYTL6zHnLp94RHw+HtstBm4UOn1Dif9wwpj7FOWw+vYG
llRCGEC42JjuCONZFyTCnO2mk2oc3CQQFJFgkox4gIDFgQY5VyZs3v8k993U11y6
+DpNAUu9hforOYuxxLcGPLK35y/Fqp2r5Z8OG+c8f6Toh1NqrH+k3j7LGf4T+7vb
7KU6bpwz1HfK4hIuj+jGJB2iTgX0o1ARkeEsgs7/4rtvOeaj/1XMwczhRbimi9Ob
OKXm4vgyNQvEp7cfrCVs5Lkbu6R9gFjrUsCywEnL9x8i07Zeu/XzXsBfh65M6TFM
ewPtRWRIHpqz39/S3FKVzisxgP3bfIzU7gbUq1ZfiyWg3RDwJFSPT45sSKJzx3Za
1ErtuLK5vOz43pFgM0wwTcHL3ei//+XHRqCQWCe4vjfMQmfKLFturcIpmSP6GvO0
LngS7vqU6XaoSUnkwipN
=I1VQ
-----END PGP SIGNATURE-----

--96YOpH+ONegL0A3E--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
