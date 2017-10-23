From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Expose CQ moderation to user space
Date: Mon, 23 Oct 2017 19:57:47 +0300
Message-ID: <20171023165747.GJ2106@mtr-leonro.local>
References: <20171019053524.11135-1-leon@kernel.org>
 <20171023094744.GH2106@mtr-leonro.local>
 <20171023152638.GB11952@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o1Pxsi7EGdPPGBHz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171023152638.GB11952-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--o1Pxsi7EGdPPGBHz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 23, 2017 at 09:26:38AM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 23, 2017 at 12:47:44PM +0300, Leon Romanovsky wrote:
>
> > Mellanox,
> > I would like to use this opportunity and to ask publicly, please submit kernel
> > and user spaces altogether.
>
> +1
>
> I was looking at the flow counters patches and they make no sense
> without also seeing the man pages that describe what the heck this
> stuff is.

+ kernel and user are one package, it makes no sense to split submission
and to cause artificial delays between them.

>
> At the very least put a rdma-core branch someplace and reference it in
> your kernel patch series, and it better have really good man pages for
> the verbs features being added.
>
> Jason

--o1Pxsi7EGdPPGBHz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuH4sACgkQ5GN7iDZy
WKdISA//XFFVZR6MC7YQGu5+oQgKeGSa5C2SGkQThvBnp6aBAmrbIl7MQjMEhbMd
3dtKFr4WFr7uuwg5JtxHVSmu0l+olMD1W+xMfdF3Wrxmifc0y7vFw79N0JpVerbI
8rHcvTjHtq4K3a2jQ7Ag6XoJGD7H0z8YpNTkYYaXqtKg9gIWmWgGzquFhnWI6VMh
u4mR3YmosEfGXyXrVyhK1Ls28jeuE+VXHymxGf0BXL8J2foLTvLaM3DsFzZh93h1
glceBpTi8FIWhGDES1F7ll7iPlzhzGQRWQu26CfndXKpq+/xggpsN3Khcw6u/8xx
ER7GBp3t6tAAtY8fmXB4nWIUeJ2QveGpVwITrwrwjveDWtlus+f69MfgoFhDFyNf
/eZ8/zqysLDkkPZt7Osgz/x/kwf8+rtfbi26TNhEidKsTMQqBM3ZC43EkcCN3X5D
8395K+/HrdK7+gGnYdIRTlCTG428kH2TYzl8wT0AMlF1A/itzBVsFiW8AKgrvlmT
PlO8qehcKbGJsM9KDwfkD4QTcXJDDumFlqBz2BNoTmp14oxr1c4RaA16enRIhhXT
JjMyP93pXV/WsECfl/QwUkWLLFPQUztkyhZXCP6g2av6YC1jL4JcPriI8phrRhwU
y1OhzWCmWdHTprijMzY+PUe4uVnoaHzwj9WHDvovr/REVptryzw=
=HeC4
-----END PGP SIGNATURE-----

--o1Pxsi7EGdPPGBHz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
