From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 7/7] IB/hfi1: Take advantage of kvzalloc_node in
 sdma initialization
Date: Mon, 23 Oct 2017 21:47:38 +0300
Message-ID: <20171023184738.GD16127@mtr-leonro.local>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
 <20171023130629.21191.43615.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vni90+aGYgRvsTuO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171023130629.21191.43615.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 23, 2017 at 06:06:32AM -0700, Dennis Dalessandro wrote:
> From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> The code that allocates the tx ring in the sdma code fails to take
> advantage of kvzalloc variations.
>
> Fix by converting to use kvzalloc_node.
>
> Reported-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/sdma.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
>

Thanks, it fixed missed GFP_NOWARN flag too.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--vni90+aGYgRvsTuO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuOUoACgkQ5GN7iDZy
WKctNA//ePrZjYsKkq1A65G5iGAlwSQ7QpEClmLntd44/EyaC6S+e9O3J7Y9nteY
I7kkc8+j1FpIYALaY24bke5KDX5wOYAy2Wxqm2yc1c/y6CtNwx9v27xcCR76vyw8
TCkGYSj+6Wl2Tot2Ud4Yj+T8IcWnkYx3S2FdJDYRwygZUb5ZxBaDFOg5Vv4BNugy
9LC7ZI4yg/6r3f5lQfciIsL1YbyHRiBe4m2vNrPkW7nYUQprAUD5EHrQ0eskWRni
myubhFm1EX5CQkiOiCs9FMttn0zPHYt+VuAH1yaVTwJ+MQeG2XjCvIEFk9IU+lHj
LILiS64NB7Uu2QWfZdMG6LBDgVTO+a8jvM0FIQWm3oRUKagpAZRMlsw6HLCouKZa
sE7rCvrtkWiCrjLan7A5yeLC4St+vn+PGAdmsxfVvXOmlwRC04BnQf7Jn2AnD/hp
HsyvEp8b/waPf3T2c2Mf/UggGw7HvDm6v2a7oHUCXdoTEN8bN+SLP2YfniVEV2QX
FG0bslLZsgsWXSHMPrBPcEXGBZsNQxBEHxbynD6uQqBwgwdEigdiLQWlMOFa0S0r
ZiWpZA0kyUQD+aHaLfpVYHwtCSCtDHCJh5VBr2gsQD768NXt5e1v0xTQonz2AMLF
R9cSQ/dDP9TpNTWFqyJcuSlx9wGU3CWk2FRBBF4pOqn7jerIA4g=
=aimO
-----END PGP SIGNATURE-----

--vni90+aGYgRvsTuO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
