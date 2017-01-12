From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: can't build ibumad on 32-bit arm
Date: Thu, 12 Jan 2017 15:06:40 +0200
Message-ID: <20170112130640.GG20392@mtr-leonro.local>
References: <20170109213944.31970-1-jarod@redhat.com>
 <20170109223108.GA10850@obsidianresearch.com>
 <0e01bfc8-333d-99dd-f7d1-024422923021@redhat.com>
 <20170110161031.GB15493@obsidianresearch.com>
 <SN1PR07MB220756D06EA23CE46DEC11A2F8790@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s5/bjXLgkIwAv6Hi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB220756D06EA23CE46DEC11A2F8790-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--s5/bjXLgkIwAv6Hi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 12, 2017 at 12:32:37PM +0000, Amrani, Ram wrote:
> > RDMA hardware doesn't work in ARM so that is OK. Cross compiling is fine,
> > ideal would be to test RXE on an arbitary ARM system, but I wouldn't call
> > that critical.
> >
> > I just don't want to setup a cross compiler for this :\
> >
> > Jason
> > --
>
> Hi Jason, Doug, All,
>
> I wanted to bring to your attention that our RDMA solution *is* working in an ARM based environment:
> the Cavium ThunderX platform. This is a 64bit ARMv8 *with* cache coherency. Please keep that in mind
> when considering RDMA-relevant platforms.

They are referring to 32bit ARM in their discussion. AFAIK all devices in RDMA
are working and supported in 64bit ARM environment.

>
> Thanks,
> Ram
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--s5/bjXLgkIwAv6Hi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh3f18ACgkQ5GN7iDZy
WKeDrA/+OnQ+KofSn+D9ZxUWVnxSfoNb6ZWAJfcsyXdaCYz0PZudyO07zD6hAbuF
nIk0JAR36bVjkEFBjJCWmMJSHYXP+pdTQ1VVxzwq59M5+YxPs1iJTc3DsdzpvY8W
87D0g+7MxelYrWMCLq15Kovo80zpaYjNzewxNc3cA67oKpvwl4SfG7Kc9ULX1eux
njdA6OW9YJlgOg/r/JORf5myMIwjCJ9Yqu3wKNUKPaYNYMkkY2SkN5hDF0eKu975
6WVYZiMAHC0rGO0qwSxRX62sRBcm0WO4zjudhFvJwYD7nT/g6dURZkeZfolqDzTI
uRSfcM5vTg76kylU+i1KMPwZELxwmNsXkabGW57iJYbZhvAWkJcPOAA/sVf+hhVl
O5L606kChGigZThcpzxnyRUz6j+8gPauBIbKWZ696VrnNOVQR8J+dLJ+Nm4XKYam
2tVkQKaHAXl3XFiINi/EMsMYVSaFhg+LmtgE/BGU8/NGg69H0htTwgcZPIEDAELk
Zpm/LqRZOZ2WScVhx+Ga81029NrJSlECZqTV4+SEhrm8GG58E2u/W93TtoDz4u4T
PaYQ2Lb3MHKwLEpn0lC0PJ+yiUC5LJsVD90e+XYZSotHbkVqL1fFZfGl57qlLKOw
uDF+UZdG0ix2m3HWCNEYExMjfrQAlWDppCDdznjCeIK9S5tXs7Q=
=AeSH
-----END PGP SIGNATURE-----

--s5/bjXLgkIwAv6Hi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
