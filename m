From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 6/6] RDMA/core: Unify style of IOCTL commands
Date: Thu, 8 Sep 2016 16:48:30 +0300
Message-ID: <20160908134830.GM18398@leon.nu>
References: <20160901165552.GE21847@leon.nu>
 <20160901170742.GA20098@obsidianresearch.com>
 <1472749767.16467.25.camel@intel.com>
 <20160901171129.GB19982@obsidianresearch.com>
 <1472750241.16467.29.camel@intel.com>
 <20160901173320.GB20472@obsidianresearch.com>
 <20160901175222.GF21847@leon.nu>
 <20160906210313.GA24527@phlsvsds.ph.intel.com>
 <20160907055519.GT21847@leon.nu>
 <20160907235508.GB4515@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Zbynv6TNPa9FrOf6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160907235508.GB4515-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Zbynv6TNPa9FrOf6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 07, 2016 at 07:55:09PM -0400, ira.weiny wrote:
> >
> > 2. In new ABI, you will define your special objects, mark them as a
> > vendor specific and the driver will be called immediately. IMHO, there
> > is no need in special ioctl.
>
> Well I'm still trying to get time to comment on that series.  One thing which
> we are a bit worried about are the number of objects which may be tracked by
> for a device and the performance to get to a special driver object (like a PSM
> context).  Right now PSM opens a FD and associates a single context with that
> FD so the access of that context is O(1).  The addition of special objects and
> looking them up adds overhead which _MAY_ be ok but until we get a chance to
> evaluate better I can't commit that what you say here is true.

Good to know.

--Zbynv6TNPa9FrOf6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX0WwuAAoJEORje4g2clinPF4P/0HGdE7Y9VSlnPafajmoMp8X
vhoLT3nHV9gpB/a2RdZChphpQWj8bkpVN/zOz6SII8F+Bs2P5qKQI1WHcJqlHqQ5
2px4+LAbXGkYNwhfH+1iVpbLT3pmUbcRXFwdDz1D7a4iLW5Xwnm6yitAzekuZCPa
ViYx/ZVH2S2Z7QfAe9KFaCIZborDZ3pxeN4lnDTYOka+sOYxdUeFge08QIdOxLzW
hgBJpxKaxx/4FJcq3CG5/lcvjU6QycgZJaBKh2y61ELDNMOjBCVXZYwf8rU/PPx+
RZLrCdmF+vdN14DwH90QPJaFGyoDsK/zNOrY6rgK2sdzbo0S1mZjsBuHfP6YfD2n
xubkdyg1XRei8F+IlsiQp3xFZpUZkp3SQ3hzOJ8Lz6j2kweOPKMp0ks/ZqJshcGz
j1npCr6QYtYSCcWhAtvF3UIxwn3kl5VwkrUnxyRMfYfWCpYkp5qW6WU3MAUciIc8
oXf72dqb4YBcv6gcQZmSJegG/as6cw9o93cUTJ9ddiVEhR6v7t7KXLYGoQGf/UqM
nnRY+OSJaqoF1D4RP/kV3rHRBJ/OgjygZkz5EWqPvVE1y/QSuVH+WQK9eAR38Ah/
A13a7Pq1SyJu8+jsRc9I0krPEbA6Q56fKuoPq4T81YmvFzy1+S1PmibDibqpGrUC
8F32m2LsPB7VJ85pBH3b
=Y9XD
-----END PGP SIGNATURE-----

--Zbynv6TNPa9FrOf6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
