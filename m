From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Sat, 11 Nov 2017 09:46:25 +0200
Message-ID: <20171111074625.GR18825@mtr-leonro.local>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
 <20171110211448.GF17451@ziepe.ca>
 <9C6B67F36DCAFC479B1CF6A967258A8CA951013D@ORSMSX115.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lBUySHvE0PL2msxU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9C6B67F36DCAFC479B1CF6A967258A8CA951013D-8oqHQFITsIFqS6EAlXoojrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--lBUySHvE0PL2msxU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 10, 2017 at 09:21:24PM +0000, Woodruff, Robert J wrote:
> Jason wrote,
>
> >There should also be absolutely no ABI changes in the -stable branchs.
>
> I agree and stable branch should be for bug fixes only, new features should be only included in the master branch that is for the next major release of rdma-core.
>
> >Ultimately I think people will settle on a couple of revisions that ended up being used in distros, OFED, MOFED, etc.
>
> I also agree, most likely not every new rdma-core release will also need to have a stable branch. Probably just the ones that are ending up in distros. I think this is what the kernel does too,
> Right ?

I'm not sure about it.
For example LTS trees are created primarily for Android [1].

Various distros take new kernel every year or two, so it limits number of stable branches.
In our case, MOFED has 6-months cycle. I don't know anything about OFED cycles.

Thanks

[1] https://lwn.net/Articles/738225/

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--lBUySHvE0PL2msxU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloGqtEACgkQ5GN7iDZy
WKdX9Q/9EY9vcRQL55UkiKQtO1B//l6yoMxF/j8WlXjxdu42bsLUPpZNmGfiWknj
csl16GxuN/R+GCkdyQx+oYCuwPUxS7Ajozl1xUE/dVVNu7kQ1x+rnbv9SC9PGnEa
GXk4Gh7P/toSeOKICd+rUjonICP/AY0s2prj41cVCTSZxIrc9rzIQ+oHGiS36qyu
UnT9Z+0YxDgfaDn/bwKCyUZIqGsN6lUFBR0PF9bYZfaNgRQMcIjTSU0diAqFVAld
LgUUtQ9ex95tEnkX00DaETmXWxm+iMTU+hseByhmOdq4BT97uYd4JPcDwrIznL4H
ifzahxT0ASYjG5NuT1Bk0/pA5Qbu+J+pXzdr5fzDSvvm/2/OIh7icZ+8shnuAcDA
vL12BQY2PEAzKfax/mDyNY6kn2/AHEZ7Yc/FSIkuhuUrNLA9iy4sllecqG8JE0CQ
88YZdN6oOPEF8xWNod7TAZiaLMfg0hmWSIA2XbKiJHxjPV/3nOgHecYgJ9YjX05K
OjZfBjXRadNgdJsAZ5nrp5dHh0fac9grZdPfSmZ3eYJOyTSpnEjpB22Y+5BbeHqC
14U3cMurQXf0ufiXB344VzvPxbNL47KjLGIoG92ysV/Z/SHeGdIfiyN7dsxlAmYJ
NW4DZLPTc6chw7yauXq7FpQwmoUbls5RFQG7BswWPcwZekD65mQ=
=EJng
-----END PGP SIGNATURE-----

--lBUySHvE0PL2msxU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
