From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Fri, 29 Sep 2017 17:59:50 +0300
Message-ID: <20170929145950.GC2965@mtr-leonro.local>
References: <20170926175524.GA2297@mtr-leonro.local>
 <20170926181214.GA41364@knc-06.sc.intel.com>
 <1506525977.33755.3.camel@redhat.com>
 <20170928184727.GA33282@knc-06.sc.intel.com>
 <20170928185753.GG2297@mtr-leonro.local>
 <20170928190502.GA33289@knc-06.sc.intel.com>
 <20170928193740.GH2297@mtr-leonro.local>
 <20170928200258.GA27343@obsidianresearch.com>
 <20170929054959.GJ2297@mtr-leonro.local>
 <cbb65789-2d1e-779e-77f8-55b435511069@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xesSdrSSBC0PokLI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cbb65789-2d1e-779e-77f8-55b435511069-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xesSdrSSBC0PokLI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 29, 2017 at 10:46:51AM -0400, Dennis Dalessandro wrote:
>
> All of this vnic stuff is a work in progress and we are incrementally
> pushing things out. Iterative development, involving the community and all.

Can we get OPA-VNIC specification? Can we get OPA specification?

The Documentation/infiniband/opa_vnic.txt is not enough to really
implement anything on top of that or communicate with that.

For example, what are the values and relations for routing control? How
is entropy calculated?

Thanks

--xesSdrSSBC0PokLI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnOX+YACgkQ5GN7iDZy
WKdIUBAAxKRy3ZQZ3vSqgZjJvB2mEXPZkLsG160t4lzy0pewrTcQGkUx9ZtnyPt3
wpxwtA8O9FkJuyrwUWoX5wqf3tpI24fw45xHfH5XPfRc7PEFFEXGkdVJyLQFnQ2/
WtC4q9k5sIr1I7Wp4KFNMvyRAHDMi3Kg11Y8xhNH+c8Qg7PTz20X8XXDLN3s+Dr4
LCHrB1JXbqrW2eiJceRMztfvyXrO4/EaAwXHYpkeaNXONxq5gfmn04LGmLNTQ/oB
oumWAMQqI9KmVl0hKln7jD1YubwAPxBA+1qxeexiFnAFQbLR60VOcTjfiiZsWihi
nFcimsA3xtpZaQf382U/EgmcmiRSrwpHD+XwCK/S365LsB7HTUrDRMKGsRb8tO3Q
kuQ5Jm+AK8nzrP+9t37gsAYk4UAmDylNny/NW1iBaHi7lPAueYrVDcqADqRLHXkn
KJntfFjZdeot1Hl6pM4CQ3FFXfOLlIniFTsFcTirUTCXHORPk7BweHfkDzj01+g6
n7Ivfny4dOtwrKvnx77CrgteCKmThVwVcso5kVakIL9cDFJYm+ZQf6uLAfTjrCDf
yq54ZYjDJUk2sSBx5UOfXqtT0TV5JySwOmlpk0p3JET7sXDDBkPPA6wlv63PSiHA
bRjl04IZpp2XCmNU/5Q1aYFdNQFTf/YVcUpcwhBBTsg/8XKMxgI=
=/xiq
-----END PGP SIGNATURE-----

--xesSdrSSBC0PokLI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
