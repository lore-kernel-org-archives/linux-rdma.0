From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: get_maintainer.pl bug?
Date: Wed, 24 Jan 2018 13:54:45 +0200
Message-ID: <20180124115445.GH1393@mtr-leonro.local>
References: <20180124112323.GA8265@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6nSyB+bcl/pT7+kx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180124112323.GA8265@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--6nSyB+bcl/pT7+kx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 24, 2018 at 01:23:24PM +0200, Yuval Shaia wrote:
> Hi,
> This is what i get when running scripts/get_maintainer.pl drivers/infiniband/:
>
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
> Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:INFINIBAND SUBSYSTEM)
> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list)
>
> However section "INFINIBAND SUBSYSTEM" pointed out a different address for
> Jason:
>
> INFINIBAND SUBSYSTEM
> M:      Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> M:      Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> L:      linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> W:      http://www.openfabrics.org/
> Q:      http://patchwork.kernel.org/project/linux-rdma/list/
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
> S:      Supported
> F:      Documentation/devicetree/bindings/infiniband/
> F:      Documentation/infiniband/
> F:      drivers/infiniband/
> F:      include/uapi/linux/if_infiniband.h
> F:      include/uapi/rdma/
> F:      include/rdma/
>
> So
> - Which one is the correct one?
> - What am i doing wrong when using scripts/get_maintainer.pl?
>

Both are correct, and the jgg-uk2M96/98Pc@public.gmane.org email is taken from .mailmap
file.

> Thanks,
> Yuval
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--6nSyB+bcl/pT7+kx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpodAUACgkQ5GN7iDZy
WKdVjA//QI493haouh3WG59mUgy0FwxqWD+0pgbeV+KQ7QiiuBUJcXUDnEj7qpvt
wNG73skrpo/ZLjnrqEqovDtSmc4kOMUcASsIKrYruNeJddDmLYmOdL79qmytCqp0
gsEwiZee5mnC1bYijfYQqyazxD50SuSQhDhO0eCqYLtoQI/3bL9zNnMMexhWuNH6
wcN0KjRv8RylBH2KUILwV5+DbsP4MLD4raFADHS0quxDhE9oJ97AMZAFfxhAG2Wl
0/hQu30UH2qjs1BAzmvwd/sHQXKQivi6r56APfrvDNfjPJpgiH5xSdSKzJAy8GmI
dBM6VO8VY/LdliPtfb8nvOKvVGonhqYfGd5FzOxpmYFA+poY3lgPtS3y/81Hdizr
zMGXimsg2xLDcoV3+caK7SLAvHnMxAurREpAB+xZd8NSOP96rsC1/ZIXGtREAUS6
eWmU8I6BHk+ggASeL5PHOpN0S4ucp9LDO6aErlYO9SFVwWjzp9baG5lfUyV74Vge
FFAzYmiQKWVCwkfx9ynRDCEevFL6PQoW6ejGE4k/fQdxyLii2tiFiRWHkKMnZOFD
vtlpxyh2hG2MO7pCo6FVH874/W0FVoDmz1K7Df2fJxyaRNsR8RPx65nYkBUtqNZn
DZouyxVFhqyDAIttu+2OJqRRS1e0CNqKNdzFf00vglaT21dAlwc=
=eTsc
-----END PGP SIGNATURE-----

--6nSyB+bcl/pT7+kx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
