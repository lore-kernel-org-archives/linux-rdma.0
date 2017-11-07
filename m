From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ocrdma_hw: remove unnecessary code in
 ocrdma_mbx_dealloc_lkey
Date: Tue, 7 Nov 2017 16:44:27 +0200
Message-ID: <20171107144427.GI18825@mtr-leonro.local>
References: <20171106143514.GA19786@embeddedor.com>
 <20171107082516.GD18825@mtr-leonro.local>
 <20171107083022.Horde.E7wKXkvErbmdKSHiwomsj7N@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RwxaKO075aXzzOz0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171107083022.Horde.E7wKXkvErbmdKSHiwomsj7N-fU+oOHjIBR1LoJgMfuPDHBfZZeVsHd8q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--RwxaKO075aXzzOz0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 07, 2017 at 08:30:22AM -0600, Gustavo A. R. Silva wrote:
> Hi Leon,
>
> Quoting Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
>
> > On Mon, Nov 06, 2017 at 08:35:14AM -0600, Gustavo A. R. Silva wrote:
> > > Check on return value and goto label mbx_err are unnecessary.
> > >
> > > Addresses-Coverity-ID: 1268780
> > > Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
> > > ---
> > >  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> > > b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> > > index f8c14c7..db02bbb 100644
> > > --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> > > +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> > > @@ -1956,9 +1956,7 @@ int ocrdma_mbx_dealloc_lkey(struct ocrdma_dev
> > > *dev, int fr_mr, u32 lkey)
> > >  	cmd->lkey = lkey;
> > >  	cmd->rsvd_frmr = fr_mr ? 1 : 0;
> > >  	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
> > > -	if (status)
> > > -		goto mbx_err;
> > > -mbx_err:
> > > +
> >
> > Can you please remove assignment from "int status = -ENOMEM"?
> > It produces warning too.
> >
>
> OK. Will do.
>
> By the way, which compiler triggers that warning?

Honestly, I don't remember, one of my building bots complained about it.

Thanks

>
> I'm using GCC 7.2.0 and I don't see it.
>
> Thanks
> --
> Gustavo A. R. Silva
>
>
>
>
>

--RwxaKO075aXzzOz0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloBxssACgkQ5GN7iDZy
WKf18w//WAA5IEwhcXmYFJow4pr4EXcs2UaqzjrmT41p3v7lCjNHCJhFEd2lfDPs
Rplt11pf4B7aCjiajCwVn6FaYSr2x5Wy+2nDZ2ZY4HaVg7rb/h5CbK3Z1xBBOEFX
owQbhim1VA/aUJB4YRy/Qx+C+ZLXfTzK8H5Z0b9zaXROm48SDnFBmh5qDExKFp8V
7UDeWSPijZ/2MJ1pWDwV8TzsnKmC4kDNeYY4wZglvtDwsVTkPLZIi7x8XTNUF/2Y
018sMrxYlRRRLqgIORmOPy2KO1lJvZnZC/IIJEp8CXUBezZAW4PY1wH1JIEqtVXf
OkdpSZk9ezGSXMuU+XXzQ+DuEazIPpObTPrJKepZrkbvUAv+n2fqIWd+mtxCyuo4
nJ9g72QzvoOuY70VzprubL3/ywCaB/JMnUCtDlLz5Uj5i6tq5i9RE67nbscbeTv0
ZZUzHfM+z+Cp0g1wbyepAw+/KCGbLFxCEhd2yv61uGBUrYhlkATCaavzTK2RI/zO
3l28hx2ReMSP/+J9gp7bhDi6ZDArAVCwJp426b3C9ltU56SU0rRf1zIXdyTJ4sY3
3s9OROVZwZzSRQd6MRhCnLR8YGnu41JlmUgxUOLmN4osRbvCcyg9PSQQ6wtL7/Mq
uMtOHPEhVoY9CJHwDdpL99gPjW1QP4pJnCChWF/FxiqOjLRaw64=
=ViU2
-----END PGP SIGNATURE-----

--RwxaKO075aXzzOz0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
