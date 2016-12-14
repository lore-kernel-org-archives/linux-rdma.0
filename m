From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] IB/srp patches for kernel v4.10
Date: Wed, 14 Dec 2016 13:33:36 -0500
Message-ID: <c7013069-813a-2772-983f-5fb077a54d80@redhat.com>
References: <ba32b251-135f-c57d-44cc-658ae35a49ca@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WpPFEJVG4TXNdRUUjOTMWKlhN7CAu6H8J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ba32b251-135f-c57d-44cc-658ae35a49ca-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WpPFEJVG4TXNdRUUjOTMWKlhN7CAu6H8J
Content-Type: multipart/mixed; boundary="ooI3PmibkXrSifF3S63UtPhHBIVGDx7Ht";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <c7013069-813a-2772-983f-5fb077a54d80-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] IB/srp patches for kernel v4.10
References: <ba32b251-135f-c57d-44cc-658ae35a49ca-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <ba32b251-135f-c57d-44cc-658ae35a49ca-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--ooI3PmibkXrSifF3S63UtPhHBIVGDx7Ht
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/21/2016 4:56 PM, Bart Van Assche wrote:
> Hello Doug,
>=20
> The patches in this series are what I came up with while testing the
> v4.9-rc5 IB/srp driver. Please consider these patches for inclusion in
> kernel v4.10. The individual patches in this series are:
>=20
> 0001-IB-srp-Fix-CONFIG_DYNAMIC_DEBUG-n-build.patch
> 0002-IB-srp-Introduce-a-local-variable-in-srp_add_one.patch
> 0003-IB-srp-Make-login-failures-easier-to-debug.patch
> 0004-IB-srp-Make-mapping-failures-easier-to-debug.patch
> 0005-IB-srp-Make-writing-into-the-add_target-sysfs-attrib.patch
>=20
> Thanks,
>=20
> Bart.

Thanks, series applied.  Although I do wonder about the third patch and
if it might need a follow on patch to only print out the message once.
We just took a patch to stop spamming login failures on the server, I
would hate for this to add a new spam source.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--ooI3PmibkXrSifF3S63UtPhHBIVGDx7Ht--

--WpPFEJVG4TXNdRUUjOTMWKlhN7CAu6H8J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZCAAAoJELgmozMOVy/dYNcP/15tfeARLOK6bF6VY6vxmo7a
hXVeFp6FDSDohOHHlgIRQBGx2u13Ww/mKazEsaSzWAzaRtottNiWy17r9UMFdm3u
wa5qhfKssB4lcWhBp1Ht7gILyXlBuU7Z8B+7hteNqz/fpzfKozae3kpkcIkZlpX2
PFALXEz69VgWwC6byDvcETMT8s0eURRobgGUGG49LHBAXTu1ZirE3+Y5WFkpDgDT
ogTlzSdfGWlpG0XG2VsYl+3Lnka3Tslmv2EvGglNUlVE4PoGPSR1+wPkK9DiSWE5
xWeXDVUNmaHN5M1jCBVf+Ow+2isdD1ILqk8UrBvW1z2mHrV02jomIUxF5yixUoAH
/YWGw1LHq9YvIfQEbSe2I43xEcF49tCuu28fuQaj3zI0avXKabJyo5gvzitdr58+
rqEpUkJl0FShJfw2G62Lb4IX5KtvDxcqz1RPfHNYHqa1++Jf922oNkhksJKW9Uat
zvnq2I6icpNiYfCFHUMK8bZXh0pFP+1j2i/Zx2bU8b0SZn8oF00z2gZgl48cRD1p
6rKpdPMHTJKjemaKOpTHCoZF8i4ij9TWGEL/7NAuTVldl09HOwavwuRDWOBYm428
PM7wjQflFwQ/oY4wPozfMfUlLnD0DWKLG//Z7ChGzwK4/bE3zBFxCZrPccPrqX2f
XzxE0n5OSGbTM0AIYO0r
=ABe8
-----END PGP SIGNATURE-----

--WpPFEJVG4TXNdRUUjOTMWKlhN7CAu6H8J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
