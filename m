From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git (tag for-linus)
Date: Sun, 9 Oct 2016 23:07:47 -0400
Message-ID: <7cde7be3-4391-7d65-521f-16d9c9d74e8f@redhat.com>
References: <00af6acf-ec90-ea0e-68d6-f9e962c89bd3@redhat.com>
 <CA+55aFw5tftp1Da5Hs8ks+=hiodZ_NTCH3Z9efPxDVo7h75RAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OK53jSRKIdUi8xfdPeKGNf9hGueJsdBc8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFw5tftp1Da5Hs8ks+=hiodZ_NTCH3Z9efPxDVo7h75RAw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OK53jSRKIdUi8xfdPeKGNf9hGueJsdBc8
Content-Type: multipart/mixed; boundary="VkNED1eV3tNsBL0d4x8Fsx3aKKEGgq1TL";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <7cde7be3-4391-7d65-521f-16d9c9d74e8f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git (tag for-linus)
References: <00af6acf-ec90-ea0e-68d6-f9e962c89bd3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CA+55aFw5tftp1Da5Hs8ks+=hiodZ_NTCH3Z9efPxDVo7h75RAw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CA+55aFw5tftp1Da5Hs8ks+=hiodZ_NTCH3Z9efPxDVo7h75RAw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--VkNED1eV3tNsBL0d4x8Fsx3aKKEGgq1TL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/9/2016 8:14 PM, Linus Torvalds wrote:
> On Fri, Oct 7, 2016 at 3:24 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>>
>> 1) cxgb4 - keep the head version in your tree, my tree and the common
>> ancestor were prior to a refactoring in your tree that moved uld_attac=
h
>> from cxgb4_main.c to cxgb4_uld.c
>=20
> Hmm. As far as I can tell, a proper merge also involves adding the line=

>=20
>         lld->fr_nsmr_tpte_wr_support =3D adap->params.fr_nsmr_tpte_wr_s=
upport;
>=20
> to uld_init() in cxgb4_uld.c.
>=20
> I did so, and it all seems to build find for me, but I obviously
> cannot do any testing. Somebody with the proper cxgb4 hardware should
> verify.

Thanks for that catch, we'll get it tested.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--VkNED1eV3tNsBL0d4x8Fsx3aKKEGgq1TL--

--OK53jSRKIdUi8xfdPeKGNf9hGueJsdBc8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX+wYKAAoJELgmozMOVy/djtQP/36pFDK/2vzRpz1nJUFoPzPZ
2vgPSdI+/0r6fR4/gZ+NFLBYcpYvGrArfBD39NVqFxhdR0G03kTA3B3Nirfyj349
0j9+CYx/be7ehEAR31FHJWdyUcxpZE4FEnAvzHwhZvlpM9+UUdKR5Qvz8d+AW3eM
FrvnY1I1PDSrUuFQuJ6mQCtbRp8eE034lvxjs9fRRXhNyuQJZlZ+Oi8STOCu5Kyd
10VdVwr9gc2kN0SqsVxBElySQ52+7nvz/garQtWI3hJ5NuksLtHmvcmQaPEBQJb8
5NXno8iVuiEKn792vt1zBYb1DGadFhdeoXLE0QLMESDaUOkcdgrhhhh1rmskPg/t
BD1PR9n5FMOpnq6vAPMTRfk6O1tlUgMpJnyvQEPIO/V0KOYllelK2yHgeq1MXYPn
mK6BRgT/h3ugPzXhG657i7txu2jv4fVjUUJXXfNZYRdvK39LJMaZZ4E7nQBGByWT
zVAxYhBo6SnkHgkauqG5IBXlAugiLOgNYBieliSyshLMATZ/1GmUjG1wVTBTGaup
MZgoThfMMDmJk6ECyd74rQpZbP4ZmLuoxSkReAXgJ4SqhjqfCI0uCGPbnL5VQYRn
D5+Xdb9LWWP2j2fpVvDp9wrgMI7LVPsZCTJNutRiSzMBMwo+BBs/Xjg2j6Zezls3
nxIxCTAd1ZjXdQr9F5E6
=xj4r
-----END PGP SIGNATURE-----

--OK53jSRKIdUi8xfdPeKGNf9hGueJsdBc8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
