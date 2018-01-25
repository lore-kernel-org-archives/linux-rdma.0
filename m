From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v6 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Thu, 25 Jan 2018 21:35:27 +0200
Message-ID: <20180125193527.GQ1393@mtr-leonro.local>
References: <20180125151227.28202-1-leon@kernel.org>
 <20180125151227.28202-4-leon@kernel.org>
 <1516898399.27592.139.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HdZAANC5GEQnh8Bp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516898399.27592.139.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--HdZAANC5GEQnh8Bp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 25, 2018 at 11:39:59AM -0500, Doug Ledford wrote:
> On Thu, 2018-01-25 at 17:12 +0200, Leon Romanovsky wrote:
> > +       if (rdma_restrack_init(&device->res)) {
> > +               kfree(device);
> > +               return NULL;
> > +       }
> > +
>
> [ snip ]
>
> > +int rdma_restrack_init(struct rdma_restrack_root *res)
> > +{
> > +       init_rwsem(&res->rwsem);
> > +       return 0;
> > +}
> > +
>
> Is there a reason you are doing it this way?  Right now, the init can't
> fail and the test for failure is a no-op.  I looked through the
> remaining patches and nothing in this patchset changes that (at least
> that I caught).  Is there a future intent here?  If so, I can see
> leaving this as is (although if there is a respin, fixing it and then
> changing it back when you add the actual failure opportunity would make
> sense).  But, if not, the init function should be void and there should
> be no failure test when calling it.

I don't use the returned value, it is leftover.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--HdZAANC5GEQnh8Bp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpqMX8ACgkQ5GN7iDZy
WKfVdhAAySLkwZQIDTyyoqIUhQhAecPBMFseZLPWX/B4p0DQkPE6el0UzbyNsC58
Sc/z8C7MIS3p2AdWsBO982Zv0Uy4t1m4OfEQU9BbqS8elbdY4vB1q80ihdjd8fcE
ABgG2C4F7fijwwCsnpdra63Ni08y2UPegRt5TNDZFSagKDW/5fTrqadcQ2ub2SRq
N/VEq+teJgEbB/G6kGUOuRVTFl7awMHdW8FMduTCiJ7T3nrgymwJsEJBW3tvoanO
NdEanLWUjv2m8iuDrPpiIulK1DN15mNLIoLkPNF6kWmpLzLnc4UHFlfZRiDD4npH
u4T9hQrk4LvngcS9Q7ptPEARyXGwfSVzdwivBMZ9HLjELO4MxOWfCULjbRQrOY4b
UflH7DORAWld8egX4ezRzxAW/gKENQh0Q+qqrZ0pWvivDt6E2aC2vxwmERTOuDqa
8TyITxA6dl8s1cAhwQODUsB22HxIPxz4ZzEEbRmXLMRQ2Pz+Rq1Mg3SPdkGyaAG7
mzm/PbLBD1PxkwCalB4dWCphxdZql7CIzPIazAjCvHUW7VjbazaSCK+8fsCETB3t
dI6KpU2PnVa9WX4ZGnfsEYTufySZm6WMl9jbGE6+/QrFRn2ynxD2MVtrprtCnMF/
M9XEGSS+xy0+YSotXV6q3O9ObhoUmpFLjIjNR7AA6wBcM2bMrSc=
=WGjO
-----END PGP SIGNATURE-----

--HdZAANC5GEQnh8Bp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
