From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/1] IB/sa: Put netlink request into the request list
 before sending
Date: Thu, 10 Dec 2015 15:36:59 -0500
Message-ID: <5669E26B.5020209@redhat.com>
References: <1446207825-17664-1-git-send-email-kaike.wan@intel.com>
 <3F128C9216C9B84BB6ED23EF16290AFB1857DA25@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jg7iUBfClVfQd9GuCaUfP3VBmkOvNmetw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB1857DA25-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jg7iUBfClVfQd9GuCaUfP3VBmkOvNmetw
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/13/2015 08:57 AM, Wan, Kaike wrote:
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
>> Sent: Friday, October 30, 2015 8:24 AM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: Wan, Kaike
>> Subject: [PATCH v2 1/1] IB/sa: Put netlink request into the request li=
st before
>> sending
>>
>> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> It was found by Saurabh Sengar that the netlink code tried to allocate=

>> memory with GFP_KERNEL while holding a spinlock. While it is possible =
to fix
>> the issue by replacing GFP_KERNEL with GFP_ATOMIC, it is better to get=
 rid
>> of the spinlock while sending the packet. However, in order to protect=

>> against a race condition that a quick response may be received before =
the
>> request is put on the request list, we need to put the request on the =
list first.
>>
>> Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>=20
> Reported-by: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20

This was pulled in for 4.4-rc.  Thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--jg7iUBfClVfQd9GuCaUfP3VBmkOvNmetw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWaeJrAAoJELgmozMOVy/dGEgP/ickQZLkJO2oIpjbsz1jtbjm
8iNXeSlKaZF3ATmiVK68f7BV29H1U7lXCq+qFGJb/HipKOWl4VmLhMAtsNVJ5p9m
ovSilZNj5Prsg37W/mjbk5+OAehVJmzyDFCCTVdusr8XRya1Iei8x9qEDgqJjYZj
jpKyqmLIIlrfbaDOsdkVTfjx+g0doGD2vcyuSanYm+p/rNwD8qYgLtIiWMfu0Njh
5RJP42TfPTcZd4FHufUBpJG3yrLM2HUjDURNZpsFPhaP1ypKOpXxgp7T/DMqQoXv
GBuWpolXNaI7rMR7z1XOAQ9SIy9v3nx6uAu/5vHGzuTywWyt5SRKUpc29+TbiKry
bKZi3zGB2DbpY4Qo+PGGr3AARMmitFmr9a9rk15fk2imqBJALPOi/JatL0e8/qUC
/UaaWlfdsZYC1oJkZ+svmQkgK9PYeKHS4f0PBMhY1InMjoqpmiY0ZhRGqxms5Wsl
cZ3fX9vJuSVXY8Td4pP3ZYNJ3qgejDu0VzcyyquJpxCepPHUBlVtLcSfj6eChd4F
OI5QF6tL2f+o1VFOIrfsATCEVc5VHIYk6yBxgRG22vERBlRgVyXfktlbE/Cs76CQ
labsJFsCoIecD21X6S0TgELMLxHlB06eeMqtqMBSJyiXfO5MJZFM54SFEZPSN7OX
EWz+CT1pUpwh93xqC8bO
=YGCp
-----END PGP SIGNATURE-----

--jg7iUBfClVfQd9GuCaUfP3VBmkOvNmetw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
