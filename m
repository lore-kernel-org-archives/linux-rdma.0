From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [linux-rdma/rdma-core] libqedr various fixes (#27)
Date: Thu, 27 Oct 2016 16:31:17 +0300
Message-ID: <20161027133117.GF3617@leon.nu>
References: <linux-rdma/rdma-core/pull/27@github.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="A9z/3b/E4MkkD+7G"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <linux-rdma/rdma-core/pull/27-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ram Amrani <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--A9z/3b/E4MkkD+7G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 25, 2016 at 05:36:43AM -0700, ramranix wrote:
> Hi Jason/Doug,
> Following your comments I have fixed several issues.
> Thank you for pointing them out,
> Ram

Thanks, applied.

>
> You can view, comment on, or merge this pull request online at:
>
>   https://github.com/linux-rdma/rdma-core/pull/27
>
> -- Commit Summary --
>
>   * libqedr: set the HCA table to static const type
>   * libqedr: consistent verb declarations
>   * libqedr: use PRIx64 for 32-bit compatible debug print
>
> -- File Changes --
>
>     M providers/qedr/qelr_main.c (2)
>     M providers/qedr/qelr_verbs.c (6)
>     M providers/qedr/qelr_verbs.h (58)
>
> -- Patch Links --
>
> https://github.com/linux-rdma/rdma-core/pull/27.patch
> https://github.com/linux-rdma/rdma-core/pull/27.diff
>
> --
> You are receiving this because you are subscribed to this thread.
> Reply to this email directly or view it on GitHub:
> https://github.com/linux-rdma/rdma-core/pull/27

--A9z/3b/E4MkkD+7G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYEgGlAAoJEORje4g2clinXEUQAL8jfvyi0tcZeXVHryuKcvQ+
IRYAh+k+HQi9z8V5BJ0CrMkZ6pJI7i2+zN6MBn+jPz544ERlmgOLqjYxZRlPZX04
NAIIQMaLMdfZ+SIP9o/zpNpB9W2YcfADJ9iIpSb24WTvvy//iw+mRidYVeFnZoSR
oxv3KM6Ud6FRgMdF+djPGlNea4vxj2duMfaaZiJCOS3ItbCK14uN9IuupaCXJe25
GxzrEKLC/QHlclMmRa7RIH1Q8TqCCHoFy6w7Jg64nkyshgLK8TKg+5lCm89EYqt6
X77eP23GvMHrija3kwIBwQGyr9AZniv48J3yGtkNaNMSZAov4/UPqCvCeCeDYaqT
NgBIOCpjGN5drD08DXwIBuMRzrKEwnf3dyUoCBusfo08Dnpr5/qxZM0fyep0C5Ps
Kb1ZXf4N8v7I/35rMmg9ESAabqA4O5UQeFfmtQ/jfgCDbyMAxalpEr9YNVG4WHUN
qUKSVO5z19v4GswD/+CC/ULA1wzBsCxb0cmNi35iZkowfrOylgl2hB8Hk4Op3FVY
Fk7C1ZfGwodkvWHTVn8LeJ9Mku+L6esr3oX+6NSmS+IC3BNmJMnebvbHyTdtXzd2
5oc/c/TrW+J2MBN6aH8gxi21197S7U4AENM0bkv1IQOaLD/X8GQ4DIyXNmK2IXSq
l0WVrjoZFvW2SAk4FIVE
=1g4a
-----END PGP SIGNATURE-----

--A9z/3b/E4MkkD+7G--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
