From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 1/1] RDMA/nes: replace custom print_hex_dump()
Date: Fri, 13 May 2016 15:21:16 -0400
Message-ID: <4cf20aec-dc75-85f4-674c-fffc7fbc4054@redhat.com>
References: <1462555182-49917-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="x1CC835ROe91mvXLcrsxppI9D0c44wnkC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462555182-49917-1-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x1CC835ROe91mvXLcrsxppI9D0c44wnkC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/06/2016 01:19 PM, Andy Shevchenko wrote:
> There is no need to duplicate a lot of code that is in the kernel libra=
ry for ages.
> Replace duplicating code by calling to print_hex_dump() directly.
>=20
> Note that output is slightly changed:
> - hex and ascii parts have just two spaces delimeter
> - there is no delimeter for ascii portions
> - file and line removed from prefix (they were redundant anyway since p=
revious
>   output shows same closer enough)
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--x1CC835ROe91mvXLcrsxppI9D0c44wnkC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNiksAAoJELgmozMOVy/dyioP/0siU4NrQaqiMh28EH4AMLDj
Tp4mg0ck7zej5keBO9zGT8B4ETl1MI+SCMt1WgIg1ZDcwhuiF33yOme/qtFauF54
IyLb1OaWD3hi/10esPLmK3GqyZ3b/L10os+EPUQItEICXkd75zp3yNehE/v8i11N
XB98wl+fRC6WyAK+PjCYRn06I1Hfqdchq5Ab5Ge/Qy2RL7DmoIRGcQH1xrSJXAgg
ks6+Buvs85rzhkPW4kSEpSNsmLkNF344kccAShTV4RXG8ViBQbsMyRl9dfMVg6lZ
xP/AXBX/g/DsMsuJ2X5ino5vjXE12R2UYq0un5nicTi5s28+3RVi3DxF0R219MBs
COzh2CrHFuWSCcpRHLqZ6BHGTPUoZFy2GrSo6Pgs3qB9X+2B1t1eg/GvtU1C1MEi
fxN/Cy0ni+6ykvgyWEIqnS8xI2wRXTj7dvf98qM31Yqu4/cm10E2ZQ3iNS4Ig/D/
SdWEkBh7O8mt2Tw1CHOYcHV3VKWoN31zr363dmbRYXahR9KoG/BXdF7VKn9a8v/Q
j0hwjiaprWcv1EGhhqWJxb5/DqABuNMGyzS9qTEy6bw4RIAvPllUZXZcSi0gKKCW
m76bs/YwS8NjyKS3/s9JugbkzYyFDkDLQfmZkhXrIaqFaKotcqOqI7+Mz1pTF8O8
1YM0C18XuiEvYDKQG2Iz
=10w3
-----END PGP SIGNATURE-----

--x1CC835ROe91mvXLcrsxppI9D0c44wnkC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
