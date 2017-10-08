From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 44/47] RDMA/rxe: Suppress gcc 7 fall-through complaints
Date: Sun, 8 Oct 2017 16:45:51 +0300
Message-ID: <20171008134551.GD25829@mtr-leonro.local>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-45-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+OcHDfVcPO70+1iC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006213333.6721-45-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--+OcHDfVcPO70+1iC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 02:33:30PM -0700, Bart Van Assche wrote:
> Avoid that gcc 7 reports the following warning when building with W=1:
>
> warning: this statement may fall through [-Wimplicit-fallthrough=]
>
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_comp.c  | 4 ++--
>  drivers/infiniband/sw/rxe/rxe_task.c  | 2 +-
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 1 +
>  3 files changed, 4 insertions(+), 3 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--+OcHDfVcPO70+1iC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnaLA8ACgkQ5GN7iDZy
WKevYw//SIqSyXEH/U/QVgfs23QemUZyZ11wVY3OAb2CKCx6vnCIXJo3pfEvQfBh
4RxqPNB3lhyLXnbpMnyjlW5cTRqsxNjx0s44ChMTPANWoZAS9MLZ1UvnUQU+p/Bz
+s/hJEftUxkjHzdiUBgfGELbVxObO4vs/KJWt4Q5+mAx1ElCZWll2s87RHBSC2NE
+kFzUibi77HZxmgC3eLk+jr3Y+IydyRkLN9bKGNrEWYE+l9mqWGOqCF3ukkYrVuU
pzUbcAs/9NcH6MqtksiWQ7PQ+46AdfZuaQWChXIvGLHyAm3p0XuPB/UIzRrQ74PE
MhPz/fxbyehkqoCzTCB9v+XCZpn9+WOcXOhQK9vaHqkQb0PRamdJ2SefAHVXnnIU
i5xYaSxUOB+QtrN3rTl1J6bIzEdwzQfdkRjBXR3yGZ4uFLya/UCxJ/tjUhlfWVaI
b0hxCLf/ExvICvhvA5x2pCOkNUxP3a0WG7pjCjY5jqf1WFXP/C9WwdkgG0IKDUvX
VmUvtb8YlWhYFM1u7qNGyCFAr3hZTZvspHPsFHcXjcGxy9u54AONM9BRs8bton0o
73QMGoFV63SKyRnWWPVC5Oq1USJ/mJ5H+uWsIj00SZYei1AERYAY1CvlSciLaM5f
hMQvVXQRMAmOgTtK1SwhmDZatZBXnRVKwl8YGt/MwcstDzeLm0Y=
=pey8
-----END PGP SIGNATURE-----

--+OcHDfVcPO70+1iC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
