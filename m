From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] rdma: Autoload netlink client modules
Date: Wed, 16 Aug 2017 18:59:39 +0300
Message-ID: <20170816155939.GS24282@mtr-leonro.local>
References: <1502744259-16966-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1502744259-16966-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170815095651.GQ24282@mtr-leonro.local>
 <20170815153523.GA14623@obsidianresearch.com>
 <20170815155843.GT24282@mtr-leonro.local>
 <20170815165737.GB15171@obsidianresearch.com>
 <20170815174058.GW24282@mtr-leonro.local>
 <20170816153620.GA22584@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ATpkSYPIqF1Y+gtT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170816153620.GA22584-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ATpkSYPIqF1Y+gtT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 16, 2017 at 09:36:20AM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 15, 2017 at 08:40:58PM +0300, Leon Romanovsky wrote:
>
> > Can this be a solution?
> > http://elixir.free-electrons.com/linux/latest/source/include/uapi/linux/in.h#L27
>
> No, that is going the other way - continuing to provide compat
> #defines while using an enum underlying, the preprocessor still cannot
> see the value to build the string.

ok, I see.

Anyway, if we find better solution, we will update it.
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks

--ATpkSYPIqF1Y+gtT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmUa+sACgkQ5GN7iDZy
WKfzWw/+NtDuXhoffzIjaKguJH/Lo7ktJbMHO9m64qEFbBk3feI6tYzBokQr4QRV
mz6HfuesLsppijG1Zuj98HigauA4MENTHX51KogLYo7+MA+oUq+rMDTVuoKfVcuT
8B8/RVrJMk8tL5DBSnsyGEjTp4U2LkF0RZ6yKeeRbO5s4uVUAmKRl7lpPMqmpFfO
1Wlo7RPAerQiZbvDj1H4sP/rbQYwww9i3DsZ8PLsKrU/ohZ4NB6kVdxe3QUGpdfB
qB9azA8iwAfUGlzbHyKsSsJjFEA9jiEKYUaPjB5/AqAXdfPAsfZusvXokOhvhco7
xwfkaTCPpEy/vRJ87qQzjbP7/El/cIOKtLtENRgMvMeKZhLrtadDUEj46jaHagVO
L9NQ3HqlC0tdPFj/x4G3Icgv8OLzzER5E1Ahbe7ElmAXpn+66ronCrd0je2o52yD
NbJ6ZZMpDXfOFn6SyYYO51vqDMMi+HJG22QuQt7MlGcSSH3DN5wJCCawGYpzL0mT
gBbLpzXh0OiD7297tSuyMTfsAnYLRjk0sAMS+CTlV+yjnkAUQfTg+WAgx7s6svyP
Agpnt18/vJxhDi8jGHYXpeHHO9E5roh9BPaBhLRI+TdDi49W09PHFYtn4YzTY0fA
zTdvxImG49tu2kKR/qXw5o/ZanBBRu2m3AMtZTl8HI6QS0baVkY=
=o0K7
-----END PGP SIGNATURE-----

--ATpkSYPIqF1Y+gtT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
