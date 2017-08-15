From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] rdma: Autoload netlink client modules
Date: Tue, 15 Aug 2017 20:40:58 +0300
Message-ID: <20170815174058.GW24282@mtr-leonro.local>
References: <1502744259-16966-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1502744259-16966-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170815095651.GQ24282@mtr-leonro.local>
 <20170815153523.GA14623@obsidianresearch.com>
 <20170815155843.GT24282@mtr-leonro.local>
 <20170815165737.GB15171@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gVeFDRGtAQ0W7qcm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170815165737.GB15171-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--gVeFDRGtAQ0W7qcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 15, 2017 at 10:57:37AM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 15, 2017 at 06:58:43PM +0300, Leon Romanovsky wrote:
> > On Tue, Aug 15, 2017 at 09:35:23AM -0600, Jason Gunthorpe wrote:
> > > On Tue, Aug 15, 2017 at 12:56:51PM +0300, Leon Romanovsky wrote:
> > >
> > > > Can it be something like that (untested)?
> > > > #define MODULE_ALIAS_RDMA_NETLINK(_index)
> > >
> > > No, MODULE_ALIAS does something like
> > >
> > > static const char __UNIQUE_ID(name)[]
> > >   __used __attribute__((section(".modinfo"), unused, aligned(1))) = __stringify(tag) "=" info;
> > >
> > > So it must accept a string produced by the pre-processor, not by code.
> >
> > But the netlink indexes were defined as anonymous enum, can we safely
> > convert them to be defines?
>
> Technically no, we shouldn't, the difference could break things.. But
> due to the limited use of the header we probably could change to
> defines.
>
> Either way doesn't really matter..

Can this be a solution?
http://elixir.free-electrons.com/linux/latest/source/include/uapi/linux/in.h#L27

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--gVeFDRGtAQ0W7qcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmTMikACgkQ5GN7iDZy
WKcq3w//UKmr0gqF4osJ06xuNZdWEov9MiOWAdzI839VysSSgr0UnMUKe6KOVrnm
AiAkfZjVdauUZg4xraIyo3FBAhUBf7ZQtmAJM0ylHZ3+HmmMhNFNw2CHgMcF/GL+
LURH7ANnQInk4axHuOMwd5ua3gnnK4FVxs2HHrxBjf6Z/tHDeYQyTivgdBpFS3ST
L0QMY2ROgJzbphCeMZWiIJwQJ0Nc400/fflke/8GtmpMDjki98fQMRwtTH0QrV7w
FAoOk+37Thhy5z6KPgIJZP1usQLnUCcqCl3iwwEiP9Rry2e4NY8NSYeaX1zXKZ/2
i3v5lEYLyg9Z2GZbQsM9o31x0rByLI4gt4+U6CxUk6zuQAuTe74CKko/IqceZnto
R1M0r0oetvsk/GUo+AJtgIi0vWuH/gV3qgjUS4N+SrcsRjLktVgFhF2eYM90POpt
/KckfjTDt2phBBHV8ghGknBEqHzTwlYDaIxBvd7frTKaXNRY54NJjs9+d9ZUQkK8
JKCFuiBw+5642ixL0QvaHI2B6uiG30ps/g2QQI3rTuICx6Fcb/76uFBs3BgqUArv
1TcSWI9p7NBUrDTSb94EFh+EHX2H6gzW4Xb5KdC8oPOGxkQ3ZR5Ynp0Mc8c24uby
4PTDC34judQoQhw0LpBaSrWNiwz3VdVXurlzxyGWHMG4jQ0fF6I=
=HCqA
-----END PGP SIGNATURE-----

--gVeFDRGtAQ0W7qcm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
