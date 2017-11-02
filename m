From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next] RDMA/vmw_pvrdma: Add shared receive queue
 support
Date: Thu, 2 Nov 2017 20:29:32 +0200
Message-ID: <20171102182932.GH16127@mtr-leonro.local>
References: <20171030022037.GA20100@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171030060317.GS16127@mtr-leonro.local>
 <20171102175225.GB24375@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171102180247.GF16127@mtr-leonro.local>
 <20171102182325.GC24375@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1PhPE3kzXS7rBT0C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102182325.GC24375-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--1PhPE3kzXS7rBT0C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 02, 2017 at 11:23:25AM -0700, Bryan Tan wrote:
> On Thu, Nov 02, 2017 at 08:02:47PM +0200, Leon Romanovsky wrote:
> > > Here we assumed that the verbs layer will only call down to us to
> > > destroy a valid SRQ. If an SRQ has been created, then the srq_tbl
> > > should exist. I can add a check here if that's not behaviour we
> > > should rely on.
> >
> > By saying "verbs layer", are you referring to libibverbs or IB/core?
> >
>
> IB/core. Looking at core/verbs.c, it seems like the parameters are
> assumed to be good. I'm unclear on who is responsible for ensuring
> or checking for good inputs, kernel clients, IB/core, or the driver.

The first one who can recognize the wrong parameters - fail early.
So if IB/core provides to you clean input, there is no need to check it
again.

>
> > > > > +int pvrdma_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
> > > > > +		      enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
> > > > > +{
> > > > > +	struct pvrdma_srq *vsrq = to_vsrq(ibsrq);
> > > > > +	union pvrdma_cmd_req req;
> > > > > +	struct pvrdma_cmd_modify_srq *cmd = &req.modify_srq;
> > > > > +	struct pvrdma_dev *dev = to_vdev(ibsrq->device);
> > > > > +	int ret;
> > > > > +
> > > > > +	/* No support for resizing SRQs. */
> > > >
> > > > Better to write that you support, so future additions to ib_srq_attr_mask
> > > > won't need to change your code.
> > > >
> > >
> > > I'm a little unclear on what you mean here. Do you mean that we
> > > should explicitly check for the only attribute we support
> > > (IB_SRQ_LIMIT) and fail otherwise?
> >
> > Yes, it will ensure that your driver doesn't get untested input.
> >
>
> Sure, I will do that then.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--1PhPE3kzXS7rBT0C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln7ZAwACgkQ5GN7iDZy
WKcuyA//d6qFckS56BIxd7TQNQt1jSx5/l/WBeWJ/MlCF4ebv78+D63wrxRtSyCC
AQzQCgNEH522RE3jfy0oTOe4iQ0jY/KN0+JJtCHfpGTo5kyn/7T02h1tFkp9BbpW
IR4FQ5AwLPDgHZU0+45WcDXpZJ4UIcw9vlcl6cW9q9I1fQMex+gBjhBjzEWyOeiu
TFL3oDszuSzj7Yht5XEXr+WlwP38cw/p+jyjnt/yfefZOI+G8R7GifYv6zYACZWT
i0XnuKdQcrAd9yBaUSxo++ujEPdguSW+Y+Bmoi015kpQi+ytrUUQxrkSPWO8ZNhS
BVBA5uXrfraaBfnxxwLmz3o32UAI15xnvD4A7QB1J0xgZQZLAYj60tJvyPBMH4Ft
8WRuRBk5d0HqyfE492cng30p6Qg5lfJ3q7AFJ+QEJFKugTatfJLgwOERR6zoFCBg
lAbM21ToScUfiMLwmn6z2rcpntP+H8gjTWClNfbRHZoY1mMD+IwCP4IxPLCkt7Td
XHujE6Gvo6PyfqYqf0poCQs22NCYXqKEoMGPUaO3H/DCwwbzPV55F8tiwF2c50Hl
Ss+8qtAqMUQpNE7nernMzMcuEGRKb9ldzTM3E2XqHL6me1/Y3Ebz/8sR97jc19JS
h79JfXG80N2NgAUm5Loke23/aHFT0vpGAwf6EdLOSlOuCBsaBQo=
=bI5x
-----END PGP SIGNATURE-----

--1PhPE3kzXS7rBT0C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
