From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v2 07/23] RDMA/core: Remove unimplemented node_types
 and node transport
Date: Wed, 16 Aug 2017 08:37:44 +0300
Message-ID: <20170816053744.GD24282@mtr-leonro.local>
References: <20170815085452.3546-1-leon@kernel.org>
 <20170815085452.3546-8-leon@kernel.org>
 <SN1PR0301MB2127376FC9B3D170C878A47BDE8D0@SN1PR0301MB2127.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CxSUI8jTRJ26tNoZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR0301MB2127376FC9B3D170C878A47BDE8D0-VLIetriUNob/KlJXleiaIJwN6zqB+hSMnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suri Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--CxSUI8jTRJ26tNoZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 15, 2017 at 06:25:54PM +0000, Suri Shelvapille wrote:
> Leon:
>
> We do have IB_SWITCH and IB_ROUTER functionality and we do use the SWITCH capability provided by the "core" in our product. The "core" has a wrapper function which Identifies the device as a switch to direct smp packets. I am glad that has not been removed. And I hope it won't be removed as it would be a burden to us. Although we prefer to have the IB_SWITCH/IB_ROUTER definitions in the core as well, it is not a big deal to move these definitions inside our driver.
>

Can you please point me to IN-KERNEL hardware/driver where these values are being set? Because I didn't find any.

Thanks

--CxSUI8jTRJ26tNoZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmT2igACgkQ5GN7iDZy
WKfxmxAAwRRLwhgXjNLeqO0rwh4pj9ieyeoj3c1bB3DhireLSRXOvHwED4mUtVhu
atAhST6h9dAetv0A0kRk2MLNiTQ9g7w7rvlnbGB39eO3t/GGHX9GZRA7QR+yoZCW
ez5O00PdKS3ZMCz/vkeVOwPSXJuDM5LN1v9dAxyy2RO3A7avRQRKThiepJKwXRNh
+Y4imCufEcFCVV/azayglrD+FWsusxRZfK8Ol23I42Ie/Ji8DcSq9tzoq8KCZT4t
lA3KHnK3WXckOqaSHzYK+5gUU978/ygIIL4dzPiKuSU9ROh+80lN05Jrgmvn6dIl
NdWc11x3X7cHk8FkJc+SrDBiywufsU8ER6UR0X5hw3a8Ft56bQcSBH5UMluIPDLk
Dho3hC0HQWBKeP+8l8V51mrLdYIFtGrJ+Gju0bdL/R/2j2xtgC759aAoeRxNbYUH
hALixcly1ybHpnGr2wqL4QPOkhcroCT8soKRJOs7tFteZ75UzZoOYsyn0IpHp56f
+iD0MbLOSbwMViYVsoj1myTVI+vKb0DwlytfqDoIuLJerfX9Rfd01VJ2uxqYH9ck
/i3bf5mXRMIXbdeyFllGG6V+9mD1jWLBGliEJImnKGmACJMnTprMNSH9vmMekPRI
KoOq4902sdtl0ABctMOuWAqaRyvyKbUjm3DNbOt95gZlVmgWA7E=
=EBsp
-----END PGP SIGNATURE-----

--CxSUI8jTRJ26tNoZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
