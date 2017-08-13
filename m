From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 19/22] IB/mlx4: Remove redundant attribute in
 mlx4_ib_create_qp_rss struct
Date: Sun, 13 Aug 2017 12:43:07 +0300
Message-ID: <20170813094307.GT24282@mtr-leonro.local>
References: <20170811105003.7661-1-leon@kernel.org>
 <20170811105003.7661-20-leon@kernel.org>
 <20170813090745.GE3924@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hXth9cGL35Nvpk4x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170813090745.GE3924@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--hXth9cGL35Nvpk4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 13, 2017 at 12:07:46PM +0300, Yuval Shaia wrote:
> On Fri, Aug 11, 2017 at 01:50:00PM +0300, Leon Romanovsky wrote:
> > From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > rss_key_len is not in use and need to be removed.
> >
> > Fixes: 3078f5f1bd8b ("IB/mlx4: Add support for RSS QP")
> > Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  include/uapi/rdma/mlx4-abi.h | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/rdma/mlx4-abi.h b/include/uapi/rdma/mlx4-abi.h
> > index 0e10102861b5..c55f60e05f86 100644
> > --- a/include/uapi/rdma/mlx4-abi.h
> > +++ b/include/uapi/rdma/mlx4-abi.h
> > @@ -98,8 +98,7 @@ struct mlx4_ib_create_srq_resp {
> >  struct mlx4_ib_create_qp_rss {
> >  	__u64   rx_hash_fields_mask;
> >  	__u8    rx_hash_function;
> > -	__u8    rx_key_len;
> > -	__u8    reserved[6];
> > +	__u8    reserved[7];
>
> Looks like this change is not explained in commit message.

It is exactly the change from commit message, we can't simply remove
fields from this structure because it should be properly aligned.

Thanks

>
> >  	__u8    rx_hash_key[40];
> >  	__u32   comp_mask;
> >  	__u32   reserved1;
> > --
> > 2.14.0
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--hXth9cGL35Nvpk4x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmQHysACgkQ5GN7iDZy
WKcQ7A/+KteJXgwBKYc7tAy8pwFNbW4sjvdVTiC3SbneU1Pnk6E1W0YoRQsIIU38
02ezRwB5y/euDjfVecrkLo9NboxkIRL+9sY/xEHV0/e2EcmZH94QqrGgn11j+r16
bArQ3Q/dvg6148u4wvMw2ss0iYlkFKDwCyDTC1dVlNF4qUAujLYdQ2KSbib323a6
rKYBl3Tp5bZUUOgu9Hew9V6UE5ZSuLUhKcLEk8cOrXxdvWXesGSg29aHBVBjwjM5
e2Ez3NRGwueAxcjlBxDQm5RfUMGRghJtgoDmKYDsSig8OKNooKypTTTaJcKVv1/U
0O9GVEciZdWP1bHGWHEgesj1GEbdFW4U1pGf5PnTolPvAK/7hA4dpdYNyOpfkxgD
PelSSTHboHhLct0Y96ZcP0B1SKzEqsHvCbDcej9uLBjScQF63Bg3wzrdPSZMnS5h
aBa6z4jszifv/DMRyM2NB9PM4C6gM4KGKXtdLqC36G+l3bXgpdJmB3blLYux4Q2x
4mgE8gHNFHHTT1EPbIUC9s58c7gv2YpXHHQNhIV8vo+QHxRPEc2g0k1qAIAT9qhr
T7P4bltBNXunvHvfyo34dagGJk9F+rQYaG/wXP9Qq+bQHxEpdpUWHIzAuZzWKtuD
rl+/SE9trlphCuu0TAXZtcjbfw5ikd+YmElTSJmhUJorC9Wtcco=
=NRzz
-----END PGP SIGNATURE-----

--hXth9cGL35Nvpk4x--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
