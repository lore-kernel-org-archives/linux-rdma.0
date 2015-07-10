From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Fri, 10 Jul 2015 18:33:41 -0400
Message-ID: <55A04845.7040004@redhat.com>
References: <559CD174.4040901@dev.mellanox.co.il> <20150708190842.GB11740@obsidianresearch.com> <20150708203205.GA21847@infradead.org> <20150709000337.GE16812@obsidianresearch.com> <559EF332.7060103@redhat.com> <20150709225306.GA30741@obsidianresearch.com> <559FC710.1050307@talpey.com> <20150710161108.GA19042@obsidianresearch.com> <55A00754.4010009@redhat.com> <55A01225.9000000@talpey.com> <20150710195420.GA31500@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LIOIQ65hM7FnSPUA7Tpp5NsoTIVrHODMD"
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150710195420.GA31500-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LIOIQ65hM7FnSPUA7Tpp5NsoTIVrHODMD
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/10/2015 03:54 PM, Jason Gunthorpe wrote:
> On Fri, Jul 10, 2015 at 02:42:45PM -0400, Tom Talpey wrote:
>=20
>>>> For the proposed iSER patch the problem is very acute, iser makes a
>>>> single PD and phys MR at boot time for each device. This means there=

>>>> is a single machine wide unchanging rkey that allows remote physical=

>>>> memory access. An attacker only has to repeatedly open QPs to iSER a=
nd
>>>> guess rkey values until they find it. Add in likely non-crypto
>>>> randomness for rkeys, and I bet it isn't even that hard to do.
>>
>> The rkeys have a PD, wich cannot be forged, so it's not a matter of
>> attacking, but it is most definitely a system integrity risk, as I
>> mentioned earlier, a simple arithmetic offset mistake can overwrite
>> anything.
>=20
> Can you explain this conclusion?

I think Tom's comment was referring to the fact that if you have a
trusted client, then a third party attacker can't attack your rkey
because they wouldn't have a QP in your PD and so the rkey would be
invalid for them.  Your arguments have been centered around a malicious
client, his presumed a trusted client and malicious third party.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--LIOIQ65hM7FnSPUA7Tpp5NsoTIVrHODMD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVoEhFAAoJELgmozMOVy/dXnkQAKkRDHbJ25BCPPxbuUlKNb6c
MnGv38ns8OhmkB+k6d0VItIJ6MWvOiyg9zG4cN8QvkogJMON+EXptcNKX1xWXaVZ
PnX0eLUZ8KL5hJ7XUBVORzRGkvRg3ZdC53IXKy3dqT+uE0VDdNvYNqsZ6DXS5bGJ
Wb3rGe8aRSYIBf2TXakUYc+tTekXHlcfDQbyqrzEhCgYd+zvK4Xj+YI8ITPaSkN1
geki3n78oZaW7ZfWANgv6G1L4ZReQVOXogJvi4qpCGjhroTkK2iPAfT7+N0k1nsh
9QnLMUvQ2ibrfI3329Yd/9NJz44W8DxydxX1XJEzoqIV2PKST2vOQDQkwkYwK9qv
P7k0T/khacM5kofQL+LtzbHoLEb32/G+P8IZqWPl4V3nHApV9TqoaMT2Y7/GIW8Z
oVyqqPUNizVyJdt65oTg5gI+2ZbhD5sBwmzT2Aeg65tLxaMC0S0KDKBM1JCJsKSC
WKRjpPdjPhoWqpADan8e4PmOSvz17JScHK72ziYHzkLgY+YlQQxFUbJQ7ZLQJfVd
9N2Yrtq18tRAVh1A4m+7zR3yTkR+RPRLVscjzkhs9gUUuwTtIWGjAOlgBZBYdWcy
bT8Cz0LBBMkmJyBupt2vC4PNRnHaNCiEdflmdN9Ef3TlyTSQQUztViN3E7BW6RL2
qplXPGa6kwvj6Ef16kVt
=1E32
-----END PGP SIGNATURE-----

--LIOIQ65hM7FnSPUA7Tpp5NsoTIVrHODMD--
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
