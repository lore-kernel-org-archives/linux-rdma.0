From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH for-next 0/8] IB/hfi1, core, rdmavt: Driver fixes for
 10/2/2017
Date: Thu, 5 Oct 2017 10:04:17 +0300
Message-ID: <20171005070417.GJ25829@mtr-leonro.local>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
 <1507146261.46071.8.camel@redhat.com>
 <2e195006-92f1-0d6c-1418-5c541f38f8e3@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wRtZRu2mMGBZ6YQ7"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2e195006-92f1-0d6c-1418-5c541f38f8e3@intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Jan Sokolowski <jan.sokolowski@intel.com>, Jakub Byczkowski <jakub.byczkowski@intel.com>, Andrzej Kacprowski <andrzej.kacprowski@intel.com>, linux-rdma@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, Stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Don Hiatt <don.hiatt@intel.com>, Niranjana Vishwanathapura <Niranjana.Vishwanathapura@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>
List-Id: linux-rdma@vger.kernel.org


--wRtZRu2mMGBZ6YQ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 04, 2017 at 09:22:06PM -0400, Dennis Dalessandro wrote:
> On 10/4/2017 3:44 PM, Doug Ledford wrote:
> > On Mon, 2017-10-02 at 11:03 -0700, Dennis Dalessandro wrote:
> > > Hi Doug,
> > > There are a couple fixes in here that would have been nice to get
> > > into the RC
> > > cycle, including one marked stable. However I think you will find
> > > them to be
> > > too many LOC for an rc-4 submission so I have sent them in one series
> > > for-next.
> > > Patches 2,3,4 and 5 are the fixes. Patch 2 is small but it's not
> > > really that
> > > important to the end user.
> > >
> > > There are some clean ups in here from Don from the 16B changes. One
> > > takes care
> > > of some sparse warnings and the other two are from a WARN_ON_ONCE
> > > that needed
> > > special cased for OPA.
> > >
> > > Patches can can also be found in my GitHub repo at:
> > > https://github.com/ddalessa/kernel/tree/for-4.15
> >
> > Hi Denny,
> >
> > I didn't process that you mixed for-rc and for-next stuff in a single
> > thread before I had gone through and looked at the patches and
> > processed them.  So, this time they all went to for-next.  In the
> > future, you really need patches you want in for-rc separate from the
> > patches intended for for-next.
>
> Maybe I wasn't too clear, I didn't intend any of those to go for-rc. So yep
> for-next was the right target.
>
> I would have liked to get the fixes into -rc but they were just too complex
> for this late in the game is all I meant.

IMHO, the number of LOCs shouldn't be the gating factor for -rc, but the
severity of fixes yes.

Thanks

>
> -Denny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--wRtZRu2mMGBZ6YQ7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnV2XEACgkQ5GN7iDZy
WKevlBAAnbCigfjcK35ZhVpDLCe2CQWre9rIuqYIZdy6cQ2zcp8gbjBq4G78hL8+
l5mqJJ5M/4/Ry1ZewsCnQM6o2r+WXzx+iOQODIspYvk+ee6Ry/9vaFfiBwwqgE9P
OqxxikHCE7OQ87G6pFkSIINm8BNy7/RVfiewUbXAOCbOxzhtorjIi5NiCH0txXS6
21T04tDLVBiSctDeMtXt0o4BZ0zLi17Y+TrPEsyC95ElaCWxjHhBnQu0mSv1TKI3
6k9PS4v8urPx/S92ZcbX4YHvUTtHrdl9Lit1ZPLccsq2SgQ4I0FSDeejHzyryUTf
eV/H8zgRh+hDOYUI3dVWqCK0zeTPsbf/w6S4SDSJlLLjFki4gx89f7p3poBt0ZHE
e0TnUmcxrsh0XYmI+fWv5Zp34lxX/8a3PKO7fHdR37Ph7dcI5cWk2OumgCsMrbOX
sJjZJ5QzT86iy3bIYEaZuXgE5Y7IB6lwAvPtlx+dAoauinWYsjapVIk7k+4J5VFS
ZkMoXuncBcsNienzk2XPSqBNRRl1AyoEJzU0dGzEPkYriJ7zUJqmoJ1XLFBADxJT
7hXujlZjwllFQqtsZY1D6wVMNCUG0DC5npEjBOHju+2cIKHiD+OfwXchTep1uQi+
o5G2yOyRmmrux945lVpzHAmjcOV4b8zd1oKd0Y0KfUz53W7XAmw=
=jHIy
-----END PGP SIGNATURE-----

--wRtZRu2mMGBZ6YQ7--
