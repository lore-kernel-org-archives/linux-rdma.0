From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs] init.c: increase sysfs read buffer size to 16
Date: Wed, 9 Dec 2015 16:36:22 -0500
Message-ID: <56689ED6.4000602@redhat.com>
References: <1449184181-25676-1-git-send-email-jsquyres@cisco.com>
 <56658940.5040506@mellanox.com>
 <8CCFAB20-21D8-4915-98C6-3DE6130BF389@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iBhJAfwVG3wWb68Nv6KK8mttUBshFFwvA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8CCFAB20-21D8-4915-98C6-3DE6130BF389-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Xuyang Wang (xuywang)" <xuywang-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iBhJAfwVG3wWb68Nv6KK8mttUBshFFwvA
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/09/2015 10:05 AM, Jeff Squyres (jsquyres) wrote:
> Any further comments on this?
>=20
> Doug -- does it look ok to you?
>=20
>=20
>> On Dec 7, 2015, at 5:27 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> On 12/04/2015 01:09 AM, Jeff Squyres wrote:
>>> The default value of 8 is too small to read
>>> /sys/class/infiniband/usnic_x/node_type, which contains "6: usNIC
>>> UDP".  Per a7a73a8c1b39362f1701256bc772d82847832f9c, the too-small
>>> buffer causes a stderr warning to be emitted from ibv_devinfo when
>>> reading usNIC devices.
>>>
>>> This commit therefore increases the buffer size to 16, which is long
>>> enough to read the usNIC node_type value.
>>
>> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
>=20

Yeah, looks fine to me.  I'll pull it in shortly.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--iBhJAfwVG3wWb68Nv6KK8mttUBshFFwvA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWaJ7WAAoJELgmozMOVy/dwFkP/0JBlro9ZwygH/x2kGFZ3UuJ
Wj6ZIfmEsUq2bhl2wPkLWetC98V/NowLEsFxnZ8hCFZD/qva+NcTe6SKpLulxsyW
fUcD6Zpac+bxX3+68Grrstw5U/vhElaeSHDSlWvVf80hO+W5zAMXef2M4QBOoE6R
BxjIGTM9ksRwlubNQl4Bl0GdFwh4cXL1Y28gYlFGOwXZHWCUxFMmOSeEXReS0O1n
hbmYBj+Uk3+GQXm5Sq+Seh5ksjEKza8WiBJOdjdCeyf3hi64+JR+5hrr0P5otn3I
vD5UH3+AyC2vS2v+ApX2FqZ69+SrituVxf0NZLeN+bv0ethS5okitZZ0C1JfZiVG
2ZOxkg9Ir52UDXQ78eeWSBhQXCKkLNaFze8ZC0sPLIyrOUGt0FtpRrWd10s2gQ1V
paxVHy0Cc4jLOy9hEUDQiwhRF9hiNT9ZZ3N4hCB0gvsuctbnDLMVfwtheuanIO/c
Mbg5rc2k2HL7g5HSMyZgQpa98OM0DoJEJIL5hIywJq5DzV5lKgG0GOJXNffkm+tx
5v8Gl1RY7Lydm6t0DkxTcqe6S0kU+44OVVEjfhzwBL4Buo0HsTlNAYAFrbBgZ4QH
SqwGs9UzSpscCXndmNm4fSWa4AbwGNx5MKeRWzMTKpM3DMJsD1aA1EJaYGJ3aBcF
cIeLyi0u6BpmM9XZFh58
=pjhe
-----END PGP SIGNATURE-----

--iBhJAfwVG3wWb68Nv6KK8mttUBshFFwvA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
