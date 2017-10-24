From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/cxgb4: Remove unnecessary conversion from
 __be32 to cpu format
Date: Tue, 24 Oct 2017 21:59:56 +0300
Message-ID: <20171024185956.GL16127@mtr-leonro.local>
References: <20171024182848.7945-1-leon@kernel.org>
 <067301d34cf7$d0872ff0$71958fd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kaF1vgn83Aa7CiXN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <067301d34cf7$d0872ff0$71958fd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--kaF1vgn83Aa7CiXN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 24, 2017 at 01:42:16PM -0500, Steve Wise wrote:
> >
> > The scqe.stag is actually declared in u32 format and don't need
> > conversion from __be32 to cpu format.
> >
> > Remove the be32_to_cpu() and avoid the following sparse error.
> >   drivers/infiniband/hw/cxgb4/cq.c:754:52: warning: cast to restricted __be32
> >
> > Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/cxgb4/t4.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/cxgb4/t4.h
> b/drivers/infiniband/hw/cxgb4/t4.h
> > index 2b44fa850bbb..a16f3596f5a8 100644
> > --- a/drivers/infiniband/hw/cxgb4/t4.h
> > +++ b/drivers/infiniband/hw/cxgb4/t4.h
> > @@ -234,7 +234,7 @@ struct t4_cqe {
> >
> >  /* used for SQ completion processing */
> >  #define CQE_WRID_SQ_IDX(x)	((x)->u.scqe.cidx)
> > -#define CQE_WRID_FR_STAG(x)     (be32_to_cpu((x)->u.scqe.stag))
> > +#define CQE_WRID_FR_STAG(x)     ((x)->u.scqe.stag)
>
> This is incorrect.  The stag is filled in by HW which is BE.  The declaration of
> scqe.stag needs to be __be32.

So why do you declare stag as u32?

drivers/infiniband/hw/cxgb4/cq.c:
676 static int c4iw_poll_cq_one(struct c4iw_cq *chp, struct ib_wc *wc)
...
679         struct t4_cqe uninitialized_var(cqe), *rd_cqe;
...
753                                 c4iw_invalidate_mr(qhp->rhp,
754                                                    CQE_WRID_FR_STAG(&cqe));

....
drivers/infiniband/hw/cxgb4/t4.h:
162 /*
163  * CQE defs
164  */
165 struct t4_cqe {
166         __be32 header;
167         __be32 len;
168         union {
169                 struct {
170                         __be32 stag;
171                         __be32 msn;
172                 } rcqe;
173                 struct {
174                         u32 stag;
175                         u16 nada2;
176                         u16 cidx;
177                 } scqe;
178                 struct {
179                         __be32 wrid_hi;
180                         __be32 wrid_low;
181                 } gen;
182                 u64 drain_cookie;
183         } u;
184         __be64 reserved;
185         __be64 bits_type_ts;
186 };

Thanks

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--kaF1vgn83Aa7CiXN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnvjawACgkQ5GN7iDZy
WKdLtw//e8GvYVzHH1lU8ONtewx2MLVCjFIhtNOXwDg3LRHFdkMSvxGfWXQQkZiA
RhwYwezET5mWam9AKkroLeU14H6Q35/FRfpJKFXjU7/LhxzPZiqz/x3VhBCRU0GY
1FJVarseafmdUaVPT5O/epk3yWj1c/Ol16Sk4gkOKs+0EE3558vjlIUQy2m9Ft4w
j4Abi0VU1tsuXlHsbZiEveB6EgSbf4aFZ6rmG47VAfClOwbya7ZgOwjLZ/TEkIFZ
VeYfiNq3NAa8WLpDEhK5Z+o7jnLYGWOqtsz8gceQsTJkIj+2jsFIx7p7dQ90uAjy
yhxXGAgQIfdvFHhBDvdR/1W9gcYkMD6KXpMbG2P0Ef0ExgsODBMI58X6UtOKzZNy
5a858LcHY5DK+LG42bpA4FyQCxjamvY1gx8VI81s99sOjnuisfb4HPlHcFwMTFvc
qKj5b8qX+nigm7lFGnuEMvX30HQrF20RoD43bm2rSuykyfcvO8ptGuQe4pWuoA76
bJJTgYVDRAg9z81u2Kb5aA6oxHILAmyf86Sy5iAqDKQUTBnSoRynaCqJKbNzGwLY
FzwO56tpy4+lZ1ljIhOIfCZb26i1vZTsi6zr30+AFc+Ux4E4zk33xiwzMtU+uXXC
qexY6Cl3DCrDbcPmpM4R2GK3lnb32nQatoeohJD/3PP7Kiy2Kbk=
=1YoW
-----END PGP SIGNATURE-----

--kaF1vgn83Aa7CiXN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
