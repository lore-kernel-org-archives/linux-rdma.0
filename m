From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Allow for non-double word multiple message
 sizes for user SDMA
Date: Thu, 28 Jul 2016 10:58:40 +0300
Message-ID: <20160728075840.GN4628@leon.nu>
References: <20160728010842.GC3158@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O27Gs9jTTFWz3gAR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160728010842.GC3158-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--O27Gs9jTTFWz3gAR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 27, 2016 at 09:08:42PM -0400, ira.weiny wrote:
>=20
> The driver pads non-double word multiple message sizes but it doesn't
> account for this padding when the packet length is calculated. Also, the
> data length is miscalculated for message sizes less than 4 bytes due to
> the bit representation in LRH. And there's a check for non-double word
> multiple message sizes that prevents these messages from being sent.
> This patch fixes length miscalculations and enables the functionality to
> send non-double word multiple message sizes.
>=20
> Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---

Ira,
Is this sizeof(u32) really necessary? It is always the same 4 bytes in
all architectures.

--O27Gs9jTTFWz3gAR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmbswAAoJEORje4g2clinNEsP/1tlxOocnveeP+8vfmKakpET
qRLlBhiW0cbuCfycCvHKFeN7feAQDZIXoLB6r8gf9hLs+FetffiBm2oj7UdGx0oj
wRIpM90FdYMYCtwcBe75ziLUJRlwRAY+KvtUV2Eqcnm0DYRWBUgfvRLaQ8HXZfG0
VqAuwTFvzJELJC28MQ2JabDY7cGfHbQE6/Z6yRiXjIyKDndZkz4gjynK7rxOQXaq
YtJBik95QafXLf/h2jMv2ZxZ/SkeLcRSC8a4cg2lUplJM1cuQDVAn99JY7X5DiXh
x7VKOTBwfrSBnEjfjJNvDVExSDJ7rgH2aPugkaEMu1uulW6As8tla7Kb14pTR/d8
lWFS02p9FRwPHxrk4UrZxD0zloTs7ts4zBkhu6vYg0P69tikay7ma6e9RE184Gge
QptPaVhVg7gKcHhzy/YYe1OdgvEAymc8lxt1vY8kSZT6nM6OR+lusLehflv4hTkE
Z66NihlY3V+2XMyvvzItMp7+c3c6Lrf26MwML6O04QDamUN1I2VjF2+cnnd6N5TS
0c3gda8mP2B7dvnOQFfdGejwHkKc4tx2AuxVnuPkW7HQd8daIRpNpFPnoj6IZ+Cj
5mcKs8S1loRg9NNPv0E6veaIaUcaQJqep/R0JGrD4kaYMML1igJTF/yWi2JXhNb+
5kMZz4AQFdksjmnWN3Sj
=CpQz
-----END PGP SIGNATURE-----

--O27Gs9jTTFWz3gAR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
