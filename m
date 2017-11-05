From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Perform package tests in Travis CI
Date: Sun, 5 Nov 2017 09:17:27 +0200
Message-ID: <20171105071727.GD31774@mtr-leonro.local>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102211851.GV18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102211851.GV18874-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 02, 2017 at 03:18:51PM -0600, Jason Gunthorpe wrote:
> On Thu, Nov 02, 2017 at 06:55:51PM +0200, Leon Romanovsky wrote:
> > This patchset comes from Alaa and he adds to Travis CI ability
> > to reuse our cbuild script to build various packages.
> >
> > The PR is https://github.com/linux-rdma/rdma-core/pull/241
>
> Not to say we shouldn't apply this PR, but if we go down this road
> then we should also ultimately switch to circleci since it has actual
> native support for docker and crucially support for docker image
> caching.

I think that we are pushing the rdma-core into that direction and it
is a matter of time when we will be there. As a first step we need to
polish this PR and merge it, after that we should convert all our tests
to run in containers, so the transition will be smooth.

>
> With that each of the docker images could be run in parallel instead
> of sequentially and it would resolve our general issues with having to
> use the ancient trusty baseline that travis uses.
>
> AFAIK the sticking point is that we need to have a public docker
> container registry, preferably co-located with circle ci's build
> workers..
>
> Jason

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln+uwYACgkQ5GN7iDZy
WKeyAw//dhtrNg4EzLaP8cJLN6GW38DdS/f+tzbedC06oilat5u6p/imJylaVNE6
wsd9Ii4ndJiHv9B+l9Icvj04VD56on3SIF1B9/3xeAszEhcUWvfeeXuW6qoc0fH1
ZzJix5/9V96OC+BTBxvueAZiXIsTnrFcVvk6nwG6kWFyY4Fk6LAxg5xwyysC0P6c
7hY192fwanh0dwx63HPpnfWr2BEiM1FU1Y/MbRzefmQWsW+dIHgPRRJVXaiE1q+H
2Eo5y+1FTMVNp8lZTPNOur9Qza6ERpRS1kzhGDlBYh+HT7BWeXjLzRwv56rxEvrj
HTJKMO0YKCEajbvD4oIt7YsTZsfKwYrZtgUc10sWIeqET6Flb6iqcONYvdlDJjqB
Ko+VnvsCHAccafDa3pPdaBhST2ZCk2JMMbnbFPMQbQDwf4OfDRZGl5Y0eruCuPOI
223sAsU1HyXuGVY4v9OyGnaSB03UnGDhTeFmtO+ALYw1DH+PfBuXFX4HqCi8RGnX
V78eVMnSD/pCfavBbtRTWnmIzzOY4XYjK1+FhwVOWnjX+hKsI2mhUStTwNxA2ec/
03+A2yvuFeSaFrkBrkUT4BX9+61A2DUnbflr9STlT6RzPMTyZJhMswJZeQuJvxjl
GoeDswmxdKUK5B0OvG2q5wP0EnYA6mptst03AZjw/Yos91vt0w0=
=yAY1
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
