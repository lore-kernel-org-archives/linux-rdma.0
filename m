From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs] Makefile.am: Fix "make distcheck"
Date: Wed, 28 Oct 2015 11:58:12 -0400
Message-ID: <5630F094.1020109@redhat.com>
References: <1446047319-22887-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="R4O0pcIDBXFjxgbRCIoXuQrg9QhJ9qdRO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446047319-22887-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R4O0pcIDBXFjxgbRCIoXuQrg9QhJ9qdRO
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/28/2015 11:48 AM, Matan Barak wrote:
> From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> make distcheck failed because it searched for headers
> in the src directory.
> Added noinst_HEADERS to fix that.
>=20
> Change-Id: Ibc0949286a97ac8775156df6465e31fe301d27db
> Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Hi Doug,
>=20
> This fixes a "make distcheck" issue. make distcheck
> was broken because it tried to use src/neigh.h and
> src/nl1_compat.h header files.
>=20
> Regards,
> Alaa and Matan

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--R4O0pcIDBXFjxgbRCIoXuQrg9QhJ9qdRO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWMPCUAAoJELgmozMOVy/dRhUP/1inweuFu0+ZzVFet0eowJHo
nwmzIpOKo22pACa1EATVJ4KioQp2C6PUNa6bXdALcEfxV5hoZSjtJY8woBs9+vE3
q0RfwVvKen7sggGpb3gYs9cSbX5D04tuXlJKaVr4shumxVbCRpEhlrS0eP+BInHF
JSz0kOgSzu+Aoe744/gzgCO81vCT4mzS9xDNdnN6YFNd+QvthVEc8N2QM4aquPKW
tLyeGtyLdIjqA+U+61CzZlgbyPU+VTxQuBIC4RS/W6LsBlRQuO/ET/HMWNdFB71A
Ky0jpdOwGJPuON6kBAmG/HRg+EkcLDQSHnc75U2EpG57YYVrG3wdj3u8QK42PRns
9pv+butRoVPhbwozPk1x3sFglxNfOO7nIc6mnJq4BH/M94K5jS24+WsDPDUMBrzL
MoycCtjbzPACphBTn1bMyPkHPcuWLAfRD5B9fo4ZD1FViemN+3kos15dhnU3calt
VHPkxaYF4MLzvjsM54GFovuh3NrHxX1Ssw3SJlUfTXamOGlOO6qvg6Ta9oQzFbTs
EAysVyEgJio+29qMzV37WvyZY7EAoPqxq0Lh88ak/5mOFWO6SQ2LrdrZU6t70s4N
GJrhYEawGfu85GIn93hi+ttVs8BkHSG/wdLdGCuwlsQXNYvcSl9s9bE2EEnxnGQL
hVkblk8owVG0BvFvEKsO
=KDVp
-----END PGP SIGNATURE-----

--R4O0pcIDBXFjxgbRCIoXuQrg9QhJ9qdRO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
