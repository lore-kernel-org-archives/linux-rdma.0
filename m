From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Wed, 25 Oct 2017 22:32:43 +0300
Message-ID: <20171025193243.GZ16127@mtr-leonro.local>
References: <20171024123957.32207.70888.stgit@phlsvslse11.ph.intel.com>
 <20171024144152.GH16127@mtr-leonro.local>
 <14063C7AD467DE4B82DEDB5C278E8663875E153D@FMSMSX108.amr.corp.intel.com>
 <20171024151958.GI16127@mtr-leonro.local>
 <14063C7AD467DE4B82DEDB5C278E8663875E15AD@FMSMSX108.amr.corp.intel.com>
 <1508957840.3325.54.camel@redhat.com>
 <20171025190608.GX16127@mtr-leonro.local>
 <1508959048.3325.58.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="z3PcgjD2qOzdkXVS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508959048.3325.58.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--z3PcgjD2qOzdkXVS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 25, 2017 at 03:17:28PM -0400, Doug Ledford wrote:
> On Wed, 2017-10-25 at 22:06 +0300, Leon Romanovsky wrote:
> > > I agree with Michael that tweaking this code to be optimal versus
> > > plainly failsafe is a patch for another day.  I've taken this one.
> > > Thanks Michael.
> >
> > Too bad, you actually suggested very good solution, it is unclear who
> > will now implement it.
>
> I may do it myself.  I've been looking at the code and I don't like the
> if construct because I don't feel it conveys the purpose of the code
> clearly.  Implicit in the if construct is embedded knowledge about
> which providers do what.  I'd rather have a switch construct on the
> index with the flow split to those that have only .dump, those that
> have only .doit, and those that have both.  The current if doesn't make
> it clear that this is how the netlink services are structured.

Most probably you are right, I just need to see the code to be sure.

The original "if" was outcome of my wrong expectation that someone will
help me to modernize IWCM. Such modernization was supposed to remove
nasty "|| index .. " checks.

So my final goal is to see the following code:
if(dump_flag)
	return do_dump

return do_doit

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--z3PcgjD2qOzdkXVS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnw5tsACgkQ5GN7iDZy
WKdeXxAAyBjs4/kTWMrpIrehgKsF1EU+aWmorOA1NP7lFEPznyChFS8j8iSxiuma
x6hRgFEoxlIF3N7ap8cx3RoOs+TxB0eu16PCROZg8RT/zC4AeDXu8DVB6YKac+eD
vXf3pHyEYQUPThlUh9tnqXeNSTofT4aUZ7qcnjfnUlkaxutSNuwvfRiHB2gQ+OnH
GOdzRmoBxoZJYwvWFhhZwLOBMTs7p4rvFY2lEBrvfNKiwxSuovtpxv9beEaf+G2q
dvZKLBVP6hUcCr9mP2FQvXRz6582kGeqdaqkOdNCVnsoZxUykqAjy8J6z4rRNysy
jJVwchhD/oXwtVZ8rhBV2JKp3vZJj8cE22T6KD7u10/h16pvf2fMDeINI+2tnRjw
qHyT8VP641wxWnYSdbCcKxyMs69PEDzWn1riCJpIOSf/2E+sCq4o3krs5mELEo6g
Nt5BC3vdlQQuU+hp1kaWK8LUjdmBCyWl28RK3nJuoUSZy35Mzx01ZI1ppP8xHBpH
EI6kAGoWLUDRCVSn1zFsLwLziLqEBcCUj3hVWRcOhr/behlRgMZFjLz9Umom4WRm
UN2U/6F8A90DyXmLOBb5Lmu5ruLhBknaAGaGu9TFZegoUsO4yiZ2m5VZfOyA5nf5
jHvzv4Toxmlw/pWAAANRKRCGW/QbmDHEXsnDOOoQ43Lr99dQwcA=
=cjX9
-----END PGP SIGNATURE-----

--z3PcgjD2qOzdkXVS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
