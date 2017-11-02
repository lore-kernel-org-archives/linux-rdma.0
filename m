From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] librdmacm: Remove unneeded condition
Date: Thu, 2 Nov 2017 17:12:52 +0200
Message-ID: <20171102151252.GY16127@mtr-leonro.local>
References: <20171102135134.5728-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QoSTjIIX+pox8TBQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102135134.5728-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--QoSTjIIX+pox8TBQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 02, 2017 at 03:51:34PM +0200, Yuval Shaia wrote:
> The check makes no difference - remove it.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  librdmacm/cma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/librdmacm/cma.c b/librdmacm/cma.c
> index 7aaf45f2..6eebe71b 100644
> --- a/librdmacm/cma.c
> +++ b/librdmacm/cma.c
> @@ -880,8 +880,8 @@ static int rdma_resolve_addr2(struct rdma_cm_id *id, struct sockaddr *src_addr,
>  	CMA_INIT_CMD(&cmd, sizeof cmd, RESOLVE_ADDR);
>  	id_priv = container_of(id, struct cma_id_private, id);
>  	cmd.id = id_priv->handle;
> -	if ((cmd.src_size = src_len))

Isn't this "=" should be "=="?

> -		memcpy(&cmd.src_addr, src_addr, src_len);
> +	cmd.src_size = src_len;
> +	memcpy(&cmd.src_addr, src_addr, src_len);
>  	memcpy(&cmd.dst_addr, dst_addr, dst_len);
>  	cmd.dst_size = dst_len;
>  	cmd.timeout_ms = timeout_ms;
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--QoSTjIIX+pox8TBQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln7NfQACgkQ5GN7iDZy
WKfA1hAAm5i/3aEjdBpCVdDbtCHIwZELTMYRFlCxg6dCJqdsxZjxxuAy+o+xwMat
A3KCmOcAG3zxYgAeomVcVxlmtOzZQmz7uFJCNwqh4YKtlHL1dMBNCqNDp3B53Hl4
ClVf+ycQ5RUzcJojYkWQXcOu5gYcmyK5zCd58b2IhaKgHz6xtb5IrZGHxlWJSRwl
5FKb4Uf8Hkl8GC/DnsCeEASt/VH8YxN0y7pJJJNyPRqU37cGPkcYgW88MHmJUfkX
Zswv/2yoNNkShu5O65L1twsmhoDYahzzoMp5VCVrZKBlO+wh7eVI7LjNyrnAtGmB
N5SjcX0qR56hGI+XZFAgYgQExk1zsHX18vSMn+e0WdstRSQgstT4/7Ek4j7cTrHd
Ni2Hwl8Z1B/poQmo+9Lbs3p6WkNhtXral+zJWO9DhNMdN54Sa1VqMq+5q7wauDii
cRPmg3zR2Qw9yfcWM1vxSBC39U7FZO//VZX0g3Bufl0DZ53uSLktEfSp1nd/29Vg
SZNQwTSi5RPr6AsorsSuqIr2NN+uVeWQz191IIIOUb1ns2pBbJvTmmchujOd/pvW
22hnQ/I7aqH8dzNy7ChcjX0MFDc/aRW+5lYEQEkt1aQcdzvE2v2QRgYx2Zi5xeTi
6n3LY3yF22qRqlLQy4NDLmBD77YzraI9BDzojZvJPJPe28WOO3o=
=lysB
-----END PGP SIGNATURE-----

--QoSTjIIX+pox8TBQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
