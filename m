From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: FW: [PATCH for-next v1 0/2] Advertise atomic operations support
 in mlx5
Date: Thu, 24 Dec 2015 00:21:04 -0500
Message-ID: <567B80C0.6090103@redhat.com>
References: <1450103650-16857-1-git-send-email-eranbe@mellanox.com>
 <567AC682.1020601@redhat.com>
 <AM3PR05MB1331CF3889813C3975A62A6CBAE60@AM3PR05MB1331.eurprd05.prod.outlook.com>
 <CAKHjkjkcr5pH5+HeBSVq0c5Vp8xypNeSvWSAjnw1_joPj4Tx6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SgHeM5lp4vxaKEa85j7FNHM8t6xnBPgsm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKHjkjkcr5pH5+HeBSVq0c5Vp8xypNeSvWSAjnw1_joPj4Tx6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eran ben elisha <eranlinuxmellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SgHeM5lp4vxaKEa85j7FNHM8t6xnBPgsm
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/23/2015 12:05 PM, eran ben elisha wrote:
>>>
>>> If the firmware supports host endianness, try to configure the
>>> hardware to work this way, and on success propagate this capability t=
o
>>> the upper layers, otherwise advertise that atomic operations aren't s=
upported.
>>
>> If you are not going to allow any support except for host endian, then=
 why bother with all of the BE stuff, can't you just list it as supported=
 or not?
>=20
> The HW default state is BE reply, need to change it's mode internally.
> The user will never know about this, it do listed as supported/not.

Ok, I've pulled this in.

>>
>>> Thanks, Eran
>>>
>>> Changes from v0:
>>>       - Rewrite the commit message of the second patch in the series
>>>
>>>
>>> Eran Ben Elisha (2):
>>>   net/mlx5_core: Configure HW to support atomic request in host
>>>     endianness
>>
>> I can fix this up, but generally try to keep your subject of patches s=
hort enough to fit in the generally accepted length.
>=20
> Sure, will keep this in mind for next time.
>=20
>>
>>>   IB/mlx5: Advertise atomic capabilities in query device
>>>
>>>  drivers/infiniband/hw/mlx5/main.c              | 28 ++++++++++++-
>>>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 57 ++++++++++++++++=
+++++++++-
>>>  include/linux/mlx5/driver.h                    |  5 +++
>>>  include/linux/mlx5/mlx5_ifc.h                  | 22 ++++++----
>>>  4 files changed, 102 insertions(+), 10 deletions(-)
>>>
>>
>>
>> --
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>               GPG KeyID: 0E572FDD
>>
>>


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--SgHeM5lp4vxaKEa85j7FNHM8t6xnBPgsm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWe4DAAAoJELgmozMOVy/djLEP/ia0D5pzn2qjFdHduAu31ULF
sURLe+S7Ykm/9bfBB/038tbh+4eb4FXYTV3JC3/7HRv6YMeFNdQTcqjuFQlGIkn6
V9oOabeIQ7pbbjrLK3bv6u5Lr1s1b2ts3h+ZkSmo2m8rm18JPKiMA26yJ/K2Bp/Q
28ZQ7M+4msIzY/c63isGlsmOXvBueUlguJ3uN7LYtAfShYaeVYOcn0xVjMW81sFq
nh2nocIvYsr5wh8SfLE/tNJQpUcdhva9S+XWs/9v72VgJn6HkUydVH6ma1rutAQH
VINCPA3OEQbXHhQwOxYxFun6gc6eDuKD+ghSg/He9DcFjFFAyL2esA6wpSxNYhFd
CrPltp5XDkvBzopu3nDTvVTjccdoITZXaG93NudG6/Wq0FefwyF39eDKiU1b73x1
7JhcSsMuMvvAlMQz3zCaQzrF0b2GqE0e/BoJG0fED3P0TVe+FPaJFtWoC10S4ZAP
Z+Fxm+1R3XlrIph0Ts14V/4heDTuGxVSdLxrJC3TX9+pM18IV8va81FMKMSjjfHU
OpBsUbUSzdReOQaNgxaIdR2b8tuvv1DedgJMuCCMUU2/XzkKnzOV4M5oJiRiI0ea
BSsLnqFtYDeUrOBkhocFuBvxUuyENJII61C+onbQGTZnnB3u0CZLAlNPOI+0udCj
KZ2Bn691bgCuWEoJxFDQ
=6mVW
-----END PGP SIGNATURE-----

--SgHeM5lp4vxaKEa85j7FNHM8t6xnBPgsm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
