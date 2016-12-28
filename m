From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: max_inline_data in ibv_rc_pingpong
Date: Wed, 28 Dec 2016 14:37:11 +0200
Message-ID: <20161228123711.GF26885@mtr-leonro.local>
References: <SN1PR07MB22079DB9A8D87699539DBB01F8970@SN1PR07MB2207.namprd07.prod.outlook.com>
 <a412a47f-74ad-cc09-4003-11b93e59f5f8@dev.mellanox.co.il>
 <SN1PR07MB220732025C454D5E5EF69527F8680@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NQTVMVnDVuULnIzU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB220732025C454D5E5EF69527F8680-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--NQTVMVnDVuULnIzU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 28, 2016 at 09:45:08AM +0000, Amrani, Ram wrote:
> > Based on man page cap is an in/out structure
> > "..the values will be greater than or equal to the values requested".
> >
> > The below example demonstrates a case that there is enough space for
> > using inline data for the given input size. It may happen as of some
> > alignment on the WQE calculated size and is based on vendor
> > implementation.
> >
> > In a real application usually an explicit value is set before calling
> > ibv_create_qp to achieve a size that is required by the application for
> > its needs.
>
>
> I would prefer it to use an explicit value instead of per-driver residual value.
> This allows for better understanding of what is actually going on.
> One of our customers used it for latency comparisons between devices and got different values, not knowing that with one driver he was using inline and with the other he isn't.
> Will you be OK with a "-I" parameter as in perftest?

Why not? this is example application.
If the user doesn't supply "-I xxx", you will fallback to legacy mode.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--NQTVMVnDVuULnIzU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhjsfcACgkQ5GN7iDZy
WKfbBRAAljP03PB04KEi23WplCPbHavhtoCd2ku5n4RLSNL1ct3W3heWq2vC2vyx
Kj1E40wSD+OI4OlZp3HYeN/lbTmfG3jTGVS19y83xAxy91/zFOvPAmStWc0YQVEf
Mq7A9oI+7sgIiKrlM+hhHVy3IinQlWI97X0MILyYFMBX2TdVP4QkD5wy+8am+e2P
DEcDWVMRerZGLFdWD3e3NG4iBsWI/V7qGA6Q/uvKbsaUlLwOh+lK/OqnkEqv+wvK
8oz9nmj7eluVFPfS9EPxh1fMDj7bNT4Wzd8puZ4Cd0ahhzmIneHAWcqCNd8+ciEw
VYL8iHbQ8CiQE6a+auSGy5co5a84ibQ7DCfCrVlE1XSsT/arQFlpdN1BetiyccQl
2s6qYa3krkeXd1Z1CPAaSO1VQU7A5LwTjY/aX7QzpFp+mF6t5C/5utqr/sQ/MXrt
TkO7NYpJLfVFv6Tc1ybvtPMJL3adsxcMDjgtNbSxct2Z1rUrYjIEvd416bLGVtpp
0vI54G7HfuZ9JDf3i5YoeUOBLaviAi0qqXC6FosH/e/ykbU0iex4b+scqM5viX5L
KFZOI+lkZMiduZalkVCtvTvom9iZ8uRQ724nKVdgXJvLi4+yz8VCXrWcjNafMFOE
4JRXYgZibM2+ekii+kck78ZxsSfjLuOFnh/NleiV6PG/k2kG0eY=
=KAQM
-----END PGP SIGNATURE-----

--NQTVMVnDVuULnIzU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
