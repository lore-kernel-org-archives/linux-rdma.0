From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 10/10] verbs: Add a compatibility arch.h
Date: Mon, 13 Feb 2017 20:17:20 +0200
Message-ID: <20170213181720.GC6989@mtr-leonro.local>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1486677212-3188-11-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170212090531.GC14015@mtr-leonro.local>
 <20170213163910.GA25430@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170213163910.GA25430-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2017 at 09:39:10AM -0700, Jason Gunthorpe wrote:
> On Sun, Feb 12, 2017 at 11:05:31AM +0200, Leon Romanovsky wrote:
>
> > > +/* Barrier macros are no longer provided by libibverbs */
> > > +
> > > +#endif /* INFINIBAND_ARCH_H */
> >
> > Is it possible to drop this file anyway?
>
> It looks like there is enough stuff out there that uses it to get
> htonll that it isn't a good idea at this time. This provides build
> warning motivation for those people to move away and we can check
> progress again in a year.. No harm to us in carrying an obsolete
> header.

I can bet that they will still use it.

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlih+DAACgkQ5GN7iDZy
WKcQIhAAlqfuJva6fkUVrRj1HWc0/Z3Ss+EVAq4UvB9BBN/ISTF9PMHct7ZXDCsw
xq8AnVJ2uzkZTNHwiDV2SvP6ECKrsuWKXTvzZXREAyCaP5UFKXgcT6eGW152zxlP
qheAmbPXlMRj8rAJhOIT0LPemv++74vaBmQiHzu9c6z6G+ecBhsyoMU89XCOZUO8
GQ+0vaPI6V+wq9qxCrqNJJUHCyBUNQHY2gEYKY765IBIZ/C+Ct2tU73RiIYhxjnf
ARkKVzTyZBpYXK52oMsaOwK9UGs0+k5YbF0nFnrFHHcIlLSRPMXC2/2y6z6MGVcv
wQWLgn28Xr7bjVwDytRF2NjAYU64hCKu7za3lXkvLbt65TntkoWo19+6MTax3Ax9
XV7rP3+EfMhSlri1zw+5bZxGjJo5cEr6S9tkajsFyQbvbyrAdUEgHdn8BYiQgQYN
mRHo5pOk1THMPDJQ8OM70r97CxvadFnl5ZGHv7aJeu6qGUVXF0M2xLVtpMV1eYZt
2+UFRUWG9Mg2m0cLq/1s4xzNS+gbMCINcQdmUffl03dy5hxzRj0iz5Ght4q5UcTw
fzx9Pv4J/OUUsiJZZUI/RvT778AYsSVNhSKdHf+NEsYnHhILMgtkFCamU1lFNf+g
ZSe5ry33ux13K5NrFyon3fDNMEE+UeG8MevvNgdMJiPi/Uhun4I=
=mzp2
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
