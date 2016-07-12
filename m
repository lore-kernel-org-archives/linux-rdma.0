From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/rxe: Trivial coding style fix
Date: Tue, 12 Jul 2016 10:55:06 -0400
Message-ID: <b65d5fef-c6de-1c7f-2685-357ff6c014ed@redhat.com>
References: <1467734999-21389-1-git-send-email-monis@mellanox.com>
 <CAJ3xEMggNphYbmSRE_Ffdjmnqf2rDnVZF8k+7vhP3RqeR2EEbg@mail.gmail.com>
 <CAG9sBKO64o-Ynjvy5PqRhDeUmeXonLXH9mHE+_0SmBu2GpE0-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tqU8xohJ9GTigQQhWpB3RdcEgu5Ejb5Si"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKO64o-Ynjvy5PqRhDeUmeXonLXH9mHE+_0SmBu2GpE0-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tqU8xohJ9GTigQQhWpB3RdcEgu5Ejb5Si
Content-Type: multipart/mixed; boundary="ECaxEl4OaMvD2ekuq11xnK46d8A4UDhwn"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org"
 <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <b65d5fef-c6de-1c7f-2685-357ff6c014ed-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/rxe: Trivial coding style fix
References: <1467734999-21389-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <CAJ3xEMggNphYbmSRE_Ffdjmnqf2rDnVZF8k+7vhP3RqeR2EEbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <CAG9sBKO64o-Ynjvy5PqRhDeUmeXonLXH9mHE+_0SmBu2GpE0-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAG9sBKO64o-Ynjvy5PqRhDeUmeXonLXH9mHE+_0SmBu2GpE0-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--ECaxEl4OaMvD2ekuq11xnK46d8A4UDhwn
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 7/6/2016 3:16 AM, Moni Shoua wrote:
> On Wed, Jul 6, 2016 at 12:52 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
>> On Tue, Jul 5, 2016 at 7:09 PM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:=

>>> A line was unnecessarily broken and with bad indentation.
>>> Also, unnecessary braces were removed.
>>>
>>> Fixes: 99c483da1a82 ('IB/rxe: QP request handling')
>>
>> Doug, is this commit ID gonna persist when you merge RXE to your
>> for-4.8 branch and later when Linus pulls this? if not, no point to
>> use it here, in that case, Moni, please remove it.
>>
>=20
> You are right Or.
> I added the "Fixes" line to help Doug decide which patch to squash to
> in case he decides to do that.
>=20


Applied and squashed.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--ECaxEl4OaMvD2ekuq11xnK46d8A4UDhwn--

--tqU8xohJ9GTigQQhWpB3RdcEgu5Ejb5Si
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXhQTKAAoJELgmozMOVy/djIMQAKQ8DnVov/dhYzinVDoRfgLQ
mjwml51O/4AcLDKgnRv1EkfUMYFG3UceN0lYUv3CYiNOkbHIgHWXEWV+J/EPBDLj
25hg9oW00KpupniZoiU3uwQqpvnMp5SzoJEVG7ETwcg6U2UTEoJXjonse5+vzCEE
R/GluT0vcta8rptDbX8w5R5blkL3+82yy/+lhM0JkqcDu1lph5pUV3WkABBP0lqd
LBMcptly74FBbi7yw4NAQ6/4oeMCJkoXrDLECzpxl3jmpC4QZrOQEghBFCSWlX2i
3z7pwoLLERRpfm+CB8Z8JDFxeZSWECyvTCz8ZKmDqdo9WSUGwlI73E9+f4VGg67L
zztkUVEc920XYX2+lhpyMIA8v83j+CCUwVQ5aBnzi4zM6Knvm29KyueWo7oRNuRG
BNkpmGFPi5BF12tkiIn9SjIydGyRxYPTMbD+hHr5qiVrz/GdHvy8Z+rPrVpQxnDE
JcizTEGYB17ygNY3bmboxm40xV+f6XWjZ1XHlvQgieDHyEzrVNJ2d/v+OxYK+rEI
L1Ikkd5kyXYN88NZenQgEb1Uu40KId+7FsDRu/md0sM1P5jKNK7y0IeBfDQo5Ea8
L5dXnElE4ksHFkRZLnAVgtXXBRqyju++9NUeXnhlK6NRD21+IEsWHWaMCpCu0ktm
dNshPM7Nh7k2lNlzovk2
=75us
-----END PGP SIGNATURE-----

--tqU8xohJ9GTigQQhWpB3RdcEgu5Ejb5Si--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
