From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 5/8] IB/core: Use __be32 for LIDs in
 opa_is_extended_lid
Date: Tue, 3 Oct 2017 21:07:35 +0300
Message-ID: <20171003180735.GE25829@mtr-leonro.local>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
 <20171002180431.31117.33069.stgit@scvm10.sc.intel.com>
 <20171003061657.GA13648@mtr-leonro.local>
 <20171003160059.GB30753@obsidianresearch.com>
 <20171003170140.GD25829@mtr-leonro.local>
 <1828884A29C6694DAF28B7E6B8A82373AB19A6C6@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FEz7ebHBGB6b2e8X"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB19A6C6-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hiatt, Don" <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--FEz7ebHBGB6b2e8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 03, 2017 at 05:05:06PM +0000, Hefty, Sean wrote:
> > > > >  	if ((be32_to_cpu(dlid) >=
> > > > >  	     be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
> > > > >  	    (be32_to_cpu(slid) >=
> > > > >  	     be16_to_cpu(IB_MULTICAST_LID_BASE)))
> > > >
> > > > You can drop be32_to_cpu and be16_to_cpu now.
> > > > The dlid is __be32 and IB_MULTICAST_LID_BASE is __be16. The direct
> > > > comparison will work.
> > >
> > > It won't order properly for >=, the swap is still needed...
> >
> > Jason,
> > Do you have reference for that?
> >
> > I tried to find any information about comparison of values from one
> > endianess on machine with another endianess and didn't find anything
> > relevant.
>
> The bytes are out of order, so the comparisons won't work.

I understand it for the "manual" comparison (C-like arrays), but does it apply
for the compiler-aware comparison? Both these variables are marked as
__be32 for the compiler.

Thanks

--FEz7ebHBGB6b2e8X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnT0ecACgkQ5GN7iDZy
WKfS4w//QHDFLij4vC9Me+Y8E+BbeAGIz/ZLhu6li4oTMF6SwkNvZi4heKszzSId
bjtH5UoUprKpf053UqWsfM00v35tgkod68TOuP1TrCnMutixQGi0LBymf6x9/sML
AXjniVsrS02CP7zOjNWMsh1bcvJjLRvTJ0b7dx5TJiG0Nvrq5bAg4OZA1faSbGxk
iYkZ/hDpylqUejWiGmWrrsMX/MgcfR/6duoGYJmJDTtfAlMFIVeXaVWorEPbFACd
AYhuz1kfZcueV0to+M2OILKO8CVnaG7XjxsoHJ5DFAHvCGdM2P6aINRyoDteW6B3
21cKCwoPZ8KynzKobZGRhqWwQ51w1EGHFIOQSYb03synJhhR3vKr/MDn+N/+NivZ
0kfqnh9sEpICeUj0mOuHvx9BmKg6AOLYndKV9k2ATR32KczPAwyqIs7V8wKDrL3o
pdkCfuMWqybOei2Bm2Z41lg2OuuZN8uf/CF+uerWBV94S2JPMGujk9JX2eajw5mM
gTjHYD4TqILH+qI2lauLjg5Ry+3iWRL+ubbCiStk8YlGjosT4SnkWM77uPQo6Alp
RsxeIGPUQGD2VfGhSyiQ4TEaPylJ/e8Dt93KPuAGNLojgbqTB8LUmt/z+k5oxXoR
+SBlajSJRPHmYXBmmLndBLxwOCFGPKWrB06u9DCPROyDzRZ2NbM=
=CVh8
-----END PGP SIGNATURE-----

--FEz7ebHBGB6b2e8X--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
