From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 20/22] IB/mlx4: Check that reserved fields in
 mlx4_ib_create_qp_rss are zero
Date: Sun, 13 Aug 2017 12:58:32 +0300
Message-ID: <20170813095832.GU24282@mtr-leonro.local>
References: <20170811105003.7661-1-leon@kernel.org>
 <20170811105003.7661-21-leon@kernel.org>
 <20170813091752.GF3924@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/DkgDsqJFFamjKX0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170813091752.GF3924@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/DkgDsqJFFamjKX0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 13, 2017 at 12:17:54PM +0300, Yuval Shaia wrote:
> On Fri, Aug 11, 2017 at 01:50:01PM +0300, Leon Romanovsky wrote:
> > From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > According to mlx4 convention, need to fail the command due to a non-zero
> > value in the user data which is expected to be zero.
> >
> > Fixes: 3078f5f1bd8b ("IB/mlx4: Add support for RSS QP")
> > Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/mlx4/qp.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> > index 44d2d0a2d5e0..e992251b4ef1 100644
> > --- a/drivers/infiniband/hw/mlx4/qp.c
> > +++ b/drivers/infiniband/hw/mlx4/qp.c
> > @@ -792,6 +792,7 @@ static struct ib_qp *_mlx4_ib_create_qp_rss(struct ib_pd *pd,
> >  	struct mlx4_ib_create_qp_rss ucmd = {};
> >  	size_t required_cmd_sz;
> >  	int err;
> > +	int i;
> >
> >  	if (!udata) {
> >  		pr_debug("RSS QP with NULL udata\n");
> > @@ -813,6 +814,10 @@ static struct ib_qp *_mlx4_ib_create_qp_rss(struct ib_pd *pd,
> >  		return ERR_PTR(-EFAULT);
> >  	}
> >
> > +	for (i = 0; i < sizeof(ucmd.reserved); i++)
> > +		if (ucmd.reserved[i])
> > +			return ERR_PTR(-EOPNOTSUPP);
> > +
>
> Found this interesting function you might want to consider using:
> /**
> * memchr_inv - Find an unmatching character in an area of memory.
> * @start: The memory area
> * @c: Find a character other than c
> * @bytes: The size of the area.
> *
> * returns the address of the first character other than @c, or %NULL
> * if the whole buffer contains just @c.
> */
> void *memchr_inv(const void *start, int c, size_t bytes)
>

Thanks, I reuse this function and will submit new version.

--/DkgDsqJFFamjKX0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmQIsgACgkQ5GN7iDZy
WKdsuBAAooq7VC6nL0S+3ZIdSEzyra47AjDZgtbDBHG0e3f0swongUbPL6gkFm9F
P1HeYX5R1hxLj67aa1oXl5LV5LDkGG+MX6SzY264MXWEJx4hCuczi22sbBqAoT4H
sMItF3BU0scPzU8NcKq4Fo9BDiMNRTDDl6C48muHUhsTGLYNCVIP5+fMa4T3zq9S
QDHJUAMh53lUtN8omQzHLXqZsFW9ib1rKrA9+uz0Qxr7I+VcKYFPcZtLBsiogokj
kCndFTMmvOmB5gozZ/Fx33GrLFcNlIA0RUn4h62gVNpVxKILGfSvzD+Cd1y0ibcI
q4TshkIbjAXyfj/eEbhyfigjHwvPBadA2n2vF/LYxq+zqfXbP+VezFRRKVE5oPEb
aJkdmkjbF0CVnYKBD/LCPuB3Aqrq4x38ucx83wR8CI2oR7AilvQOYf8sgTWGwh4G
9E1tkLtC6co7AIctg7OF6T3KOhW2MCBx/fAedKcmz0LFI1ZltCB/jAIABG0wZYNH
8p39bAhNUPMUG4KdxR1E7kKolLmQQhcoxJaLO/duQjxSaKveP3rGTwnQCKwxbE2Y
2SNtuV/WFCEaV1Y91Ref9a7eAH+mZuupZd1okd591Y7c51jaJ0LqJtrgE3bBNqcx
SRLErc8IHnM4HR8qZISEHAk18iNjAKPfyM54W8wnz3283Ccyn1o=
=85hn
-----END PGP SIGNATURE-----

--/DkgDsqJFFamjKX0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
