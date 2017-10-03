From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Tue, 3 Oct 2017 08:15:21 +0300
Message-ID: <20171003051521.GA26055@mtr-leonro.local>
References: <20170928185753.GG2297@mtr-leonro.local>
 <20170928190502.GA33289@knc-06.sc.intel.com>
 <20170928193740.GH2297@mtr-leonro.local>
 <20170928200258.GA27343@obsidianresearch.com>
 <20170929054959.GJ2297@mtr-leonro.local>
 <cbb65789-2d1e-779e-77f8-55b435511069@intel.com>
 <20170929145950.GC2965@mtr-leonro.local>
 <20170929152707.GA34521@knc-06.sc.intel.com>
 <20171002042323.GG2031@mtr-leonro.local>
 <68a08a10-5b8d-4fd7-ad06-8add423bd3cd@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <68a08a10-5b8d-4fd7-ad06-8add423bd3cd-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 02, 2017 at 08:47:08PM -0400, Dennis Dalessandro wrote:
> On 10/2/2017 12:23 AM, Leon Romanovsky wrote:
> > Upstream is not a development playground and you should submit your code once
> > you think that it is ready. So we are assuming that VNIC is working and
> > you are interested to debug your EM and such code doesn't belong to the kernel.
>
> This patch aside, I do have to take some issue with this statement. While
> upstream is not a "playground" we should be submitting code early. I keep
> harping on iterative development, show your work. Granted that doesn't mean
> write broken code and toss it over the fence to kernel.org, but pieces that
> can be broken up and tested on their own are best.

We are talking about the same. Large feature (VNIC) was divided to
sub-tasks like patches and maybe sub-features. Those sub-features were
submitted early (iterative development), which is good and sounds right
for me too.

But the expectation is that these building blocks are tested and working
and you don't need to debug them.

For sure, there are always exceptions to the statements above and
various counters, states, dumps e.t.c are good examples for
such exceptions, because they add visibility to the system, but they
don't change the system.

>
> > If you still insist on 2.a, the solution should be in your company: add
> > debugfs locally, write tests, find and fix bugs and submit them to
> > upstream.
>
> Now back to this patch series. debugfs vs NetLink, I don't think it really
> matters if the rationale for having the patch in the first place is wrong.
> In other words you would have still opposed this even if it were NetLink I
> assume? We are discussing internally but for now I think this series can be
> dropped.

I am more than happy to see OPA-VNIC configurations in NetLink, but
don't forget that it will be part of ABI and users will use it, so you
need to ensure that the OPA-VNIC network won't die after one of the
nodes will change vport value.

Before you are rushing to implement it via netlink, you should ask
yourself WHY this functionality is needed for the users.

>
> > There is no need to add "one-time" interface to clean the code.
>
> That I would agree to.
>
> -Denny

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnTHOkACgkQ5GN7iDZy
WKcO5A//YeIAqM3NFXK0LIV75g5nq0KUg84JWhafKeV4ZqcX7UOuWZUK5AXaHk2N
VgR6a7hVULgY196G2wLUrJcf54tie5ZO53YRxUX1WGS9gfPfIDgWfX+cAhrlAGli
6k6wRF/uL7pvf12wHRW6qlMd+oEsiptyGYvuZLPDi6Lw/pd8IndoGBad6MAChDWM
pU7e5/FiGVFBWQH2W+CuLfufbYqhQ5nvtJocuD0k56ilbDNZt8TyKDO/fnHINvlW
iO2xsQdysZ71qRn5Q4QBUXtDIXeDYEIWIr2ks5pLkiWd2v8ynWsOfHdh2DreBBQP
/gDGVASq7uMOkjNBZojPg4oq2Ffw/nXLsNea0rM7h9tmj7a2NWm8Dpuy0qVOVfCf
GWdOX3hDq3FBLdDOG84l4qbaUQwvaAJVtAojwv1zFZzaIIy7mSk7G/tKtvIrRWQn
NaZyM60cIBpr/aD5omVJPenHgOdXVcHsoIr29+SR58HZ3uKZgdPlUF6hyaT43A/B
jZTXb0/DQ/Cd9pCgSXNkFy2fYlMhAvfROUVFPhjSKFTYtGVezYO1eBwxGgr55pJd
AVPVpWJTZXrTOAIa4os0X4x/Yft0inzMRIwJJPjNM8d35nJD6hSvx3hNngTjCfH7
2dHt5Vjh4McTap1OfyInT+7f/LUVjVlBRCSHOwIQD48peo8I16g=
=gb8W
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
