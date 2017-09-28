From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 rdma-next] RDMA/qedr: Fix rdma_type initialization
Date: Thu, 28 Sep 2017 09:49:55 +0300
Message-ID: <20170928064955.GP2297@mtr-leonro.local>
References: <1505885986-5873-1-git-send-email-Michal.Kalderon@cavium.com>
 <1506518845.82712.15.camel@redhat.com>
 <CY1PR0701MB20126E3E86A45619079DFCAC88780@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20170927165339.GI2297@mtr-leonro.local>
 <20170927165610.GJ2297@mtr-leonro.local>
 <CY1PR0701MB2012A41A0744D17AD3CD10DB88780@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20170928032725.GO2297@mtr-leonro.local>
 <CY1PR0701MB20122CDD0A73BB963A43755288790@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="68uOmRXIw+u8y5pO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CY1PR0701MB20122CDD0A73BB963A43755288790-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--68uOmRXIw+u8y5pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2017 at 06:22:59AM +0000, Kalderon, Michal wrote:
> > >
> > > When running git log on the k.o/for-next I see the patch (last in list
> > > below), applying this patch on top of  rdma-next works for me and
> > compiles cleanly.
> > >
> > > 2e2f2d0 RDMA/qedr: Fix rdma_type initialization
> > > 1848757 Merge branches 'hns' and 'misc' into k.o/for-next 931bc0d IB:
> > > Move PCI dependency from root KConfig to HW's KConfigs 7ae6f2a Merge
> > > branch 'qedr' into k.o/for-next
> > > bd491d2 RDMA/qedr: fix build error without ipv6
> > > 89fd257 RDMA/qedr: Missing error code in qedr_init_user_queue()
> > > 847cb1a RDMA/qedr: fix spelling mistake: "invlaid" -> "invalid"
> > > 69ad0e7 RDMA/qedr: Add support for iWARP in user space
> > > e411e05 RDMA/qedr: Add iWARP connection management functions
> > de0089e
> > > RDMA/qedr: Add iWARP connection management qp related callbacks
> > > fb1a22b RDMA/qedr: Add support for read with invalidate, supported in
> > > iWARP
> > > f5b1b17 RDMA/qedr: Add iWARP support in existing verbs
> > > e6a38c5 RDMA/qedr: Add support for registering an iWARP device
> > >
> > > am i missing something ?
> >
> > I refreshed my branches now and it worked, but your git log history looks
> > strange. Where did you see the commit 1848757 and 931bc0d?
>
> git://github.com/dledford/linux.git
> git log --oneline -- drivers/infiniband/hw/qedr
> https://github.com/dledford/linux/commit/1848757c3d8bff3addf881c8bcc2b85e25ccf25e
>
> I was under the assumption a patch goes to github before k.o - is this not the case ?

Repo on github is Doug's private repository, while it is much safer to stick
with one official on kernel.org.

Thanks

--68uOmRXIw+u8y5pO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnMm5MACgkQ5GN7iDZy
WKdHSRAAiyc+S0lItw0nj6fn1kfoTxVi35KX47ZBYKpDFB5V/fw/cPhUlZsMwHvc
HctzmzhGRTNHfoMJ1koaacdxdgbhGLguH96rPkRg0LFJg7PnNIiCumNcsOmxN/ln
dJYGbp+12XY68B9Bs8DzuzgWH5hRSKaVCWudR5jRqwgDQJDbkHahUOOl68hDGR09
c3q6UYYbzU8GZiVsJPaBHwqe85BzwXcaQE42YSwbdohk95q2MsJHu9gE2wf+DW8p
PSLCiapQgHUZZcEnFEBo+jfbPsMISLqtqayhseF162ttyXE29EE6DsPFNuZtGx5x
vfJ0HGC9fAZ+3rqdH7G2Nger0HGGDNlYgBaZfnrKG54vHdyu9t8tnczYNq5kn7av
/2/+Vx368h6Q/gLADVwmM3okLRjhwt4o4U24nXndsLaB1MulJPTQ4Fp/1Pv3pCYJ
InrYL0yrJuFyjm814f1rO5CvnojxfLe2y7vtscKCFTiX9b2vLscc/5X8txcezw6C
3rvdMr0Ri2Pbo9geRJA09F8ea7sVs5XX8FaOq5yw5cpjHiReRoPKeZz+0On3kZOb
CtVmR5DMqG6PR4u3f4khv837Zrs7PYSQiNgNgo+lel+XPTHAfu4ApcJicPfCAAYV
r7Divb5wjYzSAU2Cc6DeTxcoESsEQgQ8IXIunsvrp7zZe3KALaQ=
=cskl
-----END PGP SIGNATURE-----

--68uOmRXIw+u8y5pO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
