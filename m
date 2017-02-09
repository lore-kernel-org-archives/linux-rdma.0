From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Thu, 9 Feb 2017 14:32:06 +0200
Message-ID: <20170209123206.GN6005@mtr-leonro.local>
References: <20170207194759.GU6005@mtr-leonro.local>
 <20170207201428.GV6005@mtr-leonro.local>
 <20170207205930.GA28922@obsidianresearch.com>
 <20170208063758.GZ6005@mtr-leonro.local>
 <20170208173335.GB30720@obsidianresearch.com>
 <20170208180104.GG6005@mtr-leonro.local>
 <20170208181820.GA31664@obsidianresearch.com>
 <20170208185446.GH6005@mtr-leonro.local>
 <20170208205622.GA32427@obsidianresearch.com>
 <1486634006.3632.5.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3568104349494943537=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <1486634006.3632.5.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/mailman/options/ewg>,
 <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg/>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/mailman/listinfo/ewg>,
 <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Sender: "ewg" <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--===============3568104349494943537==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4Up7Hd2V9iwVc2My"
Content-Disposition: inline


--4Up7Hd2V9iwVc2My
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 09, 2017 at 10:53:26AM +0100, Benjamin Drung wrote:
> Am Mittwoch, den 08.02.2017, 13:56 -0700 schrieb Jason Gunthorpe:
> > On Wed, Feb 08, 2017 at 08:54:46PM +0200, Leon Romanovsky wrote:
> >
> > > > Hmm. Can you update your github? I'll look for you.
> > >
> > > I pushed latest code to m/dv-1 branch, it is not for inclusion yet.
> > > https://github.com/rleon/rdma-core/commits/m/dv-v1
> > > Updated cover letter with changelog:
> > > https://github.com/rleon/rdma-core/commit/a332669511d5bbbd3dcdd977f
> > > bf95aa7ee47a69e
> > > And all cmake/packages stuff in the patch:
> > > https://github.com/rleon/rdma-core/commit/fcc4996c7fa5169fe599c2d56
> > > 8476314c1f65ddc
> >
> > This should take care of most things
> >
> > https://github.com/jgunthorpe/rdma-plumbing/commit/490b7fb184c414ab16
> > b7056f1effa9136e8afe46
> >
> > The debian packaging still needs some adjusting.
> >
> > I suspect it is against Debian policy to include libmlx.so in the
> > providers package, it probably needs to have its own package and its
> > own -dev package.
>
> When other packages should be able to link against libmlx.so and need
> header files for that, it is better to have separate binary packages
> (libmlx and libmlx-dev) for it.

This libmlx is dependent on ibverbs-provider and libibverbs. It is useless
without them and will be always installed together, so why do we need to
complicate users life by adding new library?

And we can always spin-off it as a separate package once someone will need =
it.

Thanks

>
> --
> Benjamin Drung
> System Developer
> Debian & Ubuntu Developer
>
> ProfitBricks GmbH
> Greifswalder Str. 207
> D - 10405 Berlin
>
> Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> URL:  http://www.profitbricks.com
>
> Sitz der Gesellschaft: Berlin.
> Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss.

--4Up7Hd2V9iwVc2My
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlicYUUACgkQ5GN7iDZy
WKcJLg/+LXelfa6fvGotTCpZarm4h14MOhDp+XpcyIxXJSr2rgt27e5ZDx4OXulG
W8lnfC+i4MxQ7MIhZNbaTtO9BiI+3MLk1j71zf6ujEmGKwfCLUZwp69vK7+YveP5
wG9AWAaWwdujmedKWMONiMz9aWmxmM7WeDyZ32lG1iYOSRGPDmMnpLNF1TU5W+KT
ZsVufjwSv4Um/ocWw5RBYSDNLr75lvx5jPQKgo4i1RKI50Oa2S5w12/b3tVR60cU
nzkLOHpIqs7JujIPMXuVmNs+H8Tk2mMaSZBVdR/2sVTyTsMz6T1bXvGZE82Dpa1y
LHdhMwJYU9ii/ounMC7P3DterTUOrxuF1p+zqDMmv+CPOcmSR6d9RpmjzNM4BsP9
aSn3Dyh1KTJilxcFyp8Jltle9jlotqQtrL+Wm470/wts5rqPIJrewT71o86gmO8k
DeHBJLKON9ttA3pEWkOQJOELxgJ26Ffpb1JoKXc/g0gvUET34Etf6xoLL6bh9pTy
mE9/nFBPKPfPx1J18YIkPuMbrSm9XDpI14ZHlCqmDA/L68nc66jflhK5ND3XiSOA
fW5bq1Ct0U3yUqzSDVx9DRnv7cndf08jYeKgvWbpKOoy7qewfCV4msYCp12pngSY
UnHc7z9rLv7DHpSEDAGbp4/tRHV2ydmXbF+t9tElhv5poQqomBw=
=WvTf
-----END PGP SIGNATURE-----

--4Up7Hd2V9iwVc2My--

--===============3568104349494943537==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZXdnIG1haWxp
bmcgbGlzdApld2dAbGlzdHMub3BlbmZhYnJpY3Mub3JnCmh0dHA6Ly9saXN0cy5vcGVuZmFicmlj
cy5vcmcvbWFpbG1hbi9saXN0aW5mby9ld2c=

--===============3568104349494943537==--
