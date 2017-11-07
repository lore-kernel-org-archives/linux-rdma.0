From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core v1 0/3] Perform package tests in Travis CI
Date: Tue, 7 Nov 2017 10:30:13 +0200
Message-ID: <20171107083012.GE18825@mtr-leonro.local>
References: <20171105144503.32709-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h56sxpGKRmy85csR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171105144503.32709-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--h56sxpGKRmy85csR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 05, 2017 at 04:44:59PM +0200, Leon Romanovsky wrote:
> Changelog: v0->v1:
>  * The "cbuild: Properly create tarball for SuSE" patch was abandoned as
>    no one is interested by scripts behavior when being ran by root.
>  * Patch "travis: Add RedHat and SuSE rpmbuild support"
>    "buildlib/package-build-test" script to skip build tests when being ran
>    outside travis (the actual check is whether we are already running inside
>    a container or not).
>  * In the patch "travis: Test Debian packaging under artful container"
>    removed as no longer needed installations: debhelper, dh-systemd, fakeroot
>
> -----------------------------------------------------------------------------
>
> This patchset comes from Alaa and he adds to Travis CI ability
> to reuse our cbuild script to build various packages.
>
> The PR is https://github.com/linux-rdma/rdma-core/pull/241
>
> The change to SuSE Tumbleweed wasn't straightforward and can be done as
> a followup patch.
>
> Thanks
>
> Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
>
> Alaa Hleihel (3):
>   travis: Add RedHat and SuSE rpmbuild support
>   buildlib/cbuild: Add Ubuntu artful

I will take the two patches above, because they are not controversial
and resend the third one.

Thanks


>   travis: Test Debian packaging under artful container
>
>  .travis.yml                 |  7 ++++---
>  buildlib/cbuild             |  7 +++++++
>  buildlib/package-build-test | 21 +++++++++++++++++++++
>  buildlib/travis-build       | 14 --------------
>  4 files changed, 32 insertions(+), 17 deletions(-)
>  create mode 100755 buildlib/package-build-test
>
> --
> 2.15.0
>

--h56sxpGKRmy85csR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloBbxQACgkQ5GN7iDZy
WKd0QhAAx+jEfMSVLF0GVAbm0epVdrMoG9miuok1ox85rgtInNhcQLUwGH56acA/
t+blZvmYScLu4DpUsVLxcM5cO3Ae31Q7rUEJD/B3hQgaALzAQDSUCbRvM3L0oiIw
cbL0wPi7emaZtQap3u2t1qeOV1wmxjKBJLBU4yX/mGjYvjnL64z3tNqEDI9cf6z4
z+bhrJt3TfiE7yGqHvErO2Ph1GZ3a97jlN+dtxvZ99Gueaaph/VPPZmW/APn6CBa
mEZkVgp9DQ08kfGuxcIn7MPNV7/VvuJDloNf4Mn9XE/v7jOVoamdH21vHPSIetC/
OLWgguPmi1QoOMR0HtbVwOu4LGhKFoMUJEQGI/W/NMQOt1ukIEXqRTe3pEVNA+P1
xyD/49fuILfiVGBnDp9q7BFZPxID3r1TRUTLWspNVo2e0z0fR4eY2Kw7MsEChN3d
CRTifauQ+YWw8Yx0Bzx1VtscMLlaRezro6XcSp+/KcrCMhOPQfikm6kQ3l4UkWcW
pibgc9YiCYAtirrbvbrOvZiHyWuwmPSualxnQjxPGoYdTAfifl3c8U69tg0wcZWe
ll+5SfVc0Vezbp3H6zxltI0yUhqbguTCjRco29+3j5cFQP9nByk/7Ux0oStTLJk0
k+8Bu/bf+tE9NS9hFs+2l19G+181lnJavj9a6/yeoHagmBDDlPU=
=6EVW
-----END PGP SIGNATURE-----

--h56sxpGKRmy85csR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
