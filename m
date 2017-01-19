From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/7] IB/mlx5: Return error for unsupported
 signature type
Date: Thu, 19 Jan 2017 08:41:07 +0200
Message-ID: <20170119064107.GK32481@mtr-leonro.local>
References: <20170118121036.32642-1-leon@kernel.org>
 <20170118121036.32642-3-leon@kernel.org>
 <20170118203708.GE17688@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="44sYDrpRTlpaXQDy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170118203708.GE17688@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--44sYDrpRTlpaXQDy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 18, 2017 at 10:37:09PM +0200, Yuval Shaia wrote:
> On Wed, Jan 18, 2017 at 02:10:31PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > In case of unsupported singature, we returned positive
> > value, while the better approach is to return -EINVAL.
> >
> > In addition, in this change, the error print is enriched
> > to provide an actual supplied signature type.
>
> What's the reason for the empty warnings i see in callers of this function?
> ("mlx5_ib_warn(dev, "\n");".

mlx5_ib_warn prints line and function name and in this format it mimics tracepoint.

>
> Can we remove these while we are here?

mlx5 prints deserve complete series, there are a lot of them need to be
revised. I prefer to do it all it once.


>
> >
> > Fixes: e6631814fb3a ("IB/mlx5: Support IB_WR_REG_SIG_MR")
> > Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> > Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/mlx5/qp.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> > index 6a83fb3..9021074 100644
> > --- a/drivers/infiniband/hw/mlx5/qp.c
> > +++ b/drivers/infiniband/hw/mlx5/qp.c
> > @@ -3637,8 +3637,9 @@ static int set_psv_wr(struct ib_sig_domain *domain,
> >  		psv_seg->ref_tag = cpu_to_be32(domain->sig.dif.ref_tag);
> >  		break;
> >  	default:
> > -		pr_err("Bad signature type given.\n");
> > -		return 1;
> > +		pr_err("Bad signature type (%d) is given.\n",
> > +		       domain->sig_type);
> > +		return -EINVAL;
> >  	}
> >
> >  	*seg += sizeof(*psv_seg);
> > --
> > 2.10.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--44sYDrpRTlpaXQDy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliAX4MACgkQ5GN7iDZy
WKexvBAAgryyF0o+xX4wJoNlUunG3+Tu+GslwJud1eH7pR9dnHWahuufzKcj8kuV
8EdEkPX9z8NmeqrDoqtBYug0bntbOahnx4RRUHlVXkStqyb5t4OWndwgX6i/dE2M
Y7viP8/yqG/6xXJbnUNmRj7INhdIQNgWrTKe6Q1MbawXop7tCLRxqQ1Owso6Qdfe
H0rfAsrGF0y4jpWrjgWzVNCxdJ+HWAihrZxzzjp4fq9LlE4XXDcRiGrtRBn/gHIh
Jpot/bBuIqFR6xEZ4ulyz6q+AvWqEY8azlqh0ucPnJskbVWTV8a7yfPbQLrdHWER
PklrKQM/RMBI9kfTgVIntauSQMRTYiYLZpHb4uI/vOUFvvpdlrxpsivDWc2nRjQa
Xh729ayBMzwicddA1b40nugqa5IFPTLOLttKUvqqNWR39Ewi4ls4hy/GgPD8oAJi
aJWp0rbjCFEGqZQx/hs+8Tc3CEsIZXlUBFDokRI4GqEc5khcRr2ZLyHf4QFInnzM
JlnlFiO0FsC2Bp5alKVKVf2VqnyNEESl9FPhre7ttdpaTv3EB28MgrIkIOwKjBOc
+g1SLXI4mu+k/C27yZCoIAYVqVCHUlk6TsXjTQocUkrieQnJW3/1lFAWdWjUUuLs
ecfhKhGcPxb85za9Hxm6RmnQoouK6QzITw+U5gACnThvLQamC2c=
=tXPq
-----END PGP SIGNATURE-----

--44sYDrpRTlpaXQDy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
