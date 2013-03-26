From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ipoib: fix hard_header return value
Date: Tue, 26 Mar 2013 12:52:18 -0400
Message-ID: <5151D242.2040806@redhat.com>
References: <3fde29b99442969e59a7a9cf4f63a26858f00a0a.1364315061.git.dledford@redhat.com> <5151CF60.3010100@acm.org> <CAG4TOxPa+B1=N8DUPf4E1AT-a__Yx=3d83d1xA6H5pPW=9TabA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2ASHPTLKBRDXHWWASTVJV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxPa+B1=N8DUPf4E1AT-a__Yx=3d83d1xA6H5pPW=9TabA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2ASHPTLKBRDXHWWASTVJV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/26/2013 12:46 PM, Roland Dreier wrote:
>> Checkpatch recommends since some time to use sizeof(e) instead of size=
of e,
>> isn't it ?
>=20
> I actually prefer "sizeof e" since sizeof is an operator, not a
> function.  "sizeof(e)" looks just as silly as "return(e)" to me.
>=20
> I'll apply this patch soon, it's a good catch.
>=20

Cool, thanks!

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



------enig2ASHPTLKBRDXHWWASTVJV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRUdJCAAoJELgmozMOVy/dwSAQAIetECMKRlJNzgBEcFjqVOOx
G5YSWD8Aqx0HM5rgnxscB8all4JBfbikBT7/UUOrOm9USJCpZG2GEsn3gs4e7GPC
HkUdAy0JXucEZNux12UWVfJK91yLde7ErFyCU68GTbWZ9CqPkVJQ8o3TqSJVFsuk
bB5Ni2PfOHrpnGiqQYUskk4jsgZrJC34IPYFFIeyiptbnitYfOZAEOZZiYuTqJSm
TCEbZfGiP+zbEbzXYRqqiHE4p4k1aMLfTF06By5r9RMU65sR/PbI6K+zV3/maL7K
uuHRd1aRH+0hxwIBIDhHD+P5vKp6ScnQwF39rpn521A0PwfcYaEEpXYkEZcsOaT1
YnfR5CpjR6hMZNzcLCfzg2p4UvxKU8/I8a1JltqcvBe4IR6CdKjjzrLD31xVhRIg
T/NZjDClU7YpxFco65II5kqLa8jW8yNocjPMMrM6WpCzXGZzEEPDF+yXmtgMqbsN
wuhl9D1DNFUm/9qbLilSuPHNR8GqMtvDwqfwMSwPIEieAcS9X2YWnSnKNnnOEz/y
EeeRG7TYWJRiOVSCYfuBdjjbTrjYJcWwMw+RAPB54xjsxfFL8KN2jQyL4Oizq9z2
i6FUhnatxA0ma9bomRwyzlEUWRjdOiVZivpzqotyrLxexov7b2iRQCYiA6C3zJ/S
z+BTuNgxk0Hmnhl++73x
=41C1
-----END PGP SIGNATURE-----

------enig2ASHPTLKBRDXHWWASTVJV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
