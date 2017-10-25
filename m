From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Endianess in cxgb4
Date: Wed, 25 Oct 2017 18:38:56 +0300
Message-ID: <20171025153856.GT16127@mtr-leonro.local>
References: <20171024183759.GK16127@mtr-leonro.local>
 <069401d34cf8$5171f6e0$f455e4a0$@opengridcomputing.com>
 <20171024190142.GM16127@mtr-leonro.local>
 <021401d34da0$45afeda0$d10fc8e0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zu8lIfFVzXMVnfzp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <021401d34da0$45afeda0$d10fc8e0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--zu8lIfFVzXMVnfzp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 25, 2017 at 09:48:08AM -0500, Steve Wise wrote:
> > On Tue, Oct 24, 2017 at 01:45:52PM -0500, Steve Wise wrote:
> > > >
> > > > Hi Steve,
> > > >
> > > > I reviewed my reports from various static checkers and saw strange code
> > > > in build_tpte_memreg() function that in drivers/infiniband/hw/cxgb4/qp.c.
> > > >
> > > > That function has following code:
> > > >  614         fr->r2 = cpu_to_be32(0);
> > > >  615         fr->stag = cpu_to_be32(mhp->ibmr.rkey);
> > > >
> > > > The r2, stag and rkey are u32, why do you need cpu_to_be32() conversion?
> > > >
> > >
> > > Hey Leon,
> > >
> > > The r2 and stag fields in struct fw_ri_fr_nsmr_tpte_wr should be __be32.
> >
> > it is not how it is declared in drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
> >
> > 672 struct fw_ri_fr_nsmr_tpte_wr {
> > 673         __u8    opcode;
> > 674         __u8   flags;
> > 675         __u16  wrid;
> > 676         __u8   r1[3];
> > 677         __u8   len16;
> > 678         __u32  r2;
> > 679         __u32  stag;
> > 680         struct fw_ri_tpte tpte;
> > 681         __u64  pbl[2];
> > 682 };
> >
> > Thanks
> >
>
> I'm not communicating effectively.  Sorry.
>
> This is a bug in t4fw_ri_api.h.  You need create a patch to change
> fw_ri_fr_nsmr_tpte_wr to make the stag and r2 fields to be __be32.

Thanks, I'll send a fix.

>
> Steve.
>
>
>

--zu8lIfFVzXMVnfzp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnwsBAACgkQ5GN7iDZy
WKee6BAAqWtBJ7CeY1bSWeNn1j9jTkR+PugD1qzl7+uwnvACmBHA/84ipL0eO6+/
UnLeEzB76izGZXF6v9jj0Rqq61zhuaomTbTb8b+483a2xHvGF/JleDz8tzeAs+5I
q+4GEXnoVGbI4TiZ1XCMtjImCG/vv4mCltJFtBIs4zajP5ztISBW1XqvY/nNZY/d
gLVZE2sUSf7I+TgA7MiaGArHfKP9n7sWuO0s7keYLYnBQo32l1oAUad4Owjyqefx
LDOz+4KFWgJs4ekg33OHN+55pVdFJ3JA9batGNGb0vdEweekA8uE4sGAi376uTXc
QatINLeTMwTVm0QJCfbqsKmb2vXorpnIJ5F45RikkjKVK/r5nWcPg0dCSFNc699m
iv2QUjYkrWDer2bn0SuUpSMpMi6svgXC7fp0/xbIpj+CRBOZGGPsEj/nJfrlFoF5
0rH2VPAlfyFyc48M2mIOd6PtS6Mf7QYGJNLX7V4Q9tnUAT8dL95WH16g63FQCti4
78y5A35L7LeO6jmEFCyQlLXqghiVsDjOLC1xuWuDqJUp8xaTea5M6vDxX40EXnwl
hYpToKWoyfJl+vW/eHDXFhRR+3jQ5yThBMnKahdiMyznMaJrkhxOOI4xwxpJ6Sgr
wSRrKDcn9l3Vxn8S4Vel2hLag/SC8ITZEpZPCRV+xRoZK5lYkEE=
=2MSV
-----END PGP SIGNATURE-----

--zu8lIfFVzXMVnfzp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
