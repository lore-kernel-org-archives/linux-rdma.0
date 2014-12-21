From: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: Re: [PATCH] Fixes wrong assertion failed in osm_switch_get_lft_block()
Date: Sun, 21 Dec 2014 14:50:28 +0100
Message-ID: <5496D024.2030704@simula.no>
References: <5495BE60.50301@simula.no> <54969BC4.8060400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="h5xkRTJvsv81eJRo2hSVfsAQQkMarhXFs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54969BC4.8060400-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--h5xkRTJvsv81eJRo2hSVfsAQQkMarhXFs
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/21/2014 11:07 AM, Ilya Nelkenbaum wrote:
> On 12/20/2014 8:22 PM, Vangelis Tasoulas wrote:
>> From a399cd7398a86b72541c628588365c252882cd80 Mon Sep 17 00:00:00 2001=

>> From: Vangelis Tasoulas <vangelis-e629+x1LERvk1uMJSBkQmQ@public.gmane.org>
>> Date: Sat, 20 Dec 2014 19:10:33 +0100
>> Subject: [PATCH] Fixes wrong assertion failed in osm_switch_get_lft_bl=
ock()
>>  when LIDs from the top LFT block (0xbfc0-0xbfff) are used.
>>
>> ---
>>  opensm/osm_switch.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
>> index 11efd54..a28ec28 100644
>> --- a/opensm/osm_switch.c
>> +++ b/opensm/osm_switch.c
>> @@ -168,7 +168,7 @@ boolean_t osm_switch_get_lft_block(IN const
>> osm_switch_t * p_sw,
>>         if (base_lid_ho > p_sw->max_lid_ho)
>>                 return FALSE;
>>
>> -       CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE <=3D IB_LID_UCAST_END=
_HO);
>> +       CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE - 1 <=3D
>> IB_LID_UCAST_END_HO);
> What about using IB_LID_MCAST_START_HO (49152) instead of IB_LID_UCAST_=
END_HO (49151)?
> No additional arithemtic will be needed then.

This function is about the LFTs and not the MFTs, so having '<=3D
IB_LID_MCAST_START_HO' would look a bit confusing -at least to me- at a
first glance due to the equal sign.

Less or equal to the first mcast LID? I understand the less, but why equa=
l?

>=20
>>         memcpy(p_block, &(p_sw->lft[base_lid_ho]), IB_SMP_DATA_SIZE);
>>         return TRUE;
>>  }
>>
>=20



--h5xkRTJvsv81eJRo2hSVfsAQQkMarhXFs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUltAoAAoJEEuGx9KTo03qoyYH/RoM7Tm3/yXB3rsFj31cc/RB
xJ1n2QVq6t8On5k1JVQwhbQwrMkIKlwFAb1GrImqiEkOnjP66b902kBS63dp8OOn
CjSP7aZ6g7uKBHN8LfntEhkaCGDRpCTFaL6wmAKew6IYIu2vAWQPyDx22BirDvEF
Vi4Az1jYVDzTXxxg89FWqQIQ9vtApJ0QOHIKZ3bgy42F6c8HEEMwaM/0ODEy0bvF
VPniNPvmjw08QJSvgSjBEx1VNE2VVpV1Hkli68xkvi/jrT/9bomxLl0jn8X4R9CD
xWMdGagGRdbULBNw6PtttbjX0zBZfgTP2kAbd43f9dhp9Ld+tCZUmrhGfQr8Qw8=
=dn72
-----END PGP SIGNATURE-----

--h5xkRTJvsv81eJRo2hSVfsAQQkMarhXFs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
