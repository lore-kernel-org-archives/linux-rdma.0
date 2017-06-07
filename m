From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] util: Fix mmio_flush_writes for SPARC and S390x
Date: Wed, 7 Jun 2017 19:31:26 +0300
Message-ID: <20170607163126.GE1127@mtr-leonro.local>
References: <88cef736-88c3-08d9-4042-fd73b2d4cb97@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UnaWdueM1EBWVRzC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <88cef736-88c3-08d9-4042-fd73b2d4cb97-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--UnaWdueM1EBWVRzC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 07, 2017 at 02:58:39PM +0200, Nicolas Morey-Chaisemartin wrote:
> Due to a missing #else, udma_barrier.h failed on sparc and s390x
>
> Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
> ---
>  util/udma_barrier.h | 1 +
>  1 file changed, 1 insertion(+)
>

Thanks, applied.

--UnaWdueM1EBWVRzC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk4Kl0ACgkQ5GN7iDZy
WKcRzxAAzXlOo/2U9HKBMlmrkTMxqjpJ6IDvUAeSDKpHewrI7SJImcqQMgeUPWv9
iRFq8vO6nO0SEzzRHOIne97kxFkbyr1coRIa0PiwNHqMwMCUFfcMoCZoWeROoVKM
h/Tbu7w+MG6Yr2lx5UKvefKTdJA8N205utsDbA/6PebJ0eiJePninRbiS1DdbfQU
X8HAEZkW3BsDKDM2x1DJzisIJ8U0IlW+WuSwtigA3MbDODW6AOt0LqQao3DdFCrY
/LJDVuq9E4N9yaAm7Qh9DtKsKQCy1e2FTdZ3vcyGB9f+4avCYwOe9JHUC7NY9VOx
WdQvlJEnF976zxF4vutPpMbtR4wqHRWvYd+rLFQ+ggI6nyij7kEHm5SyL5uBUiGP
WxH0roXx2tkG4XgtvDmUCiZjz/BvFR+gO9Y5PE37fGfN5PPFzNZNxZhe6/ixiyoC
+fKOVcZSdvmn/dBw4ncDMUoqm+N5VMaKXwgO6iD5YrfaNOMXH8pLrHlg7mVbG9/f
IcOmcFQ7X0a4g0hipmctZaxRPrD25sbrttZNREw4oaizm2BfPtix4pCZlgYOIE2h
szPLyiahYZEDgFpeBercLMakPEZTrxFcd56w6KoMXEpbRf9VEskdRz4kifop0Sze
7+bFqykW4hp86U68BmHoYtoCjxAPHEc1xFgdA2knid63BY178xM=
=r7Ij
-----END PGP SIGNATURE-----

--UnaWdueM1EBWVRzC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
