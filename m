From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] rdma: Autoload netlink client modules
Date: Tue, 15 Aug 2017 18:58:43 +0300
Message-ID: <20170815155843.GT24282@mtr-leonro.local>
References: <1502744259-16966-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1502744259-16966-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170815095651.GQ24282@mtr-leonro.local>
 <20170815153523.GA14623@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wZwWzkkm73dI25u3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170815153523.GA14623-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--wZwWzkkm73dI25u3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 15, 2017 at 09:35:23AM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 15, 2017 at 12:56:51PM +0300, Leon Romanovsky wrote:
>
> > Can it be something like that (untested)?
> > #define MODULE_ALIAS_RDMA_NETLINK(_index)
>
> No, MODULE_ALIAS does something like
>
> static const char __UNIQUE_ID(name)[]
>   __used __attribute__((section(".modinfo"), unused, aligned(1))) = __stringify(tag) "=" info;
>
> So it must accept a string produced by the pre-processor, not by code.

But the netlink indexes were defined as anonymous enum, can we safely
convert them to be defines?

>
> Jason

--wZwWzkkm73dI25u3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmTGjMACgkQ5GN7iDZy
WKePFA/9FDiNAnbPe045XymXkKHCDuGil+I3khYxQQ2SB38yX+VXonvPECNX+ZE0
Z+mxXrLB+LQP5heXGNPgE5dsAtAyLoaxJobrfTdwf/p4OsGSrjVLTUSlm1CCB2tN
cNukYZUDX9/g+Z1PWnU5PWo1tcLSwdlKuQKQzW2e7cwKBli0eAowWToD67RJD606
O23Cwmt3xdAg59FRYtjeZ3RP2SgUi3PbBrGx+Q+PkGoqYIqp1oXeX48tvzm3459p
eICq19Ai20RR/hiKRf3iDxSP6SHqxHZcEwi1PTIBCANumfYgjT5yf1IUuUJekXJk
jVhelv0eP4xuNjws1I81ov6B0gp/ky+7tdM5/p0Ki9l9enMhAqi8cAxVFGbkVa+7
0lCIkMuJk9LMCzL8S4wP2vW8irHoMcA5NaHUzxHIhHNcYPo9RzW3FbsFSYPhRR4c
8h29moawFFLDLAsuH9AuRIXTvS0ct/Kax0Bm763TEyDdKFROY3V4OUMPRTXHrieB
OLyHDTSO/q2jFwOiGzg3p38QFJ3Ks1/4efSLu0FkQ5Q4d81MIqLrGmrsbtxmVauJ
RZlqqisANLUaGhESsvHMgLLCVkugIXLUMd1T57cg4OgeuKCpwAauGgSLRR1PGKAi
TskzJgfTxBfFBLr++gJU337tgN4VMWK6kbJislr8XTPNasloeJg=
=JFgO
-----END PGP SIGNATURE-----

--wZwWzkkm73dI25u3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
