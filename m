From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libibverbs: add ARM64 memory barrier macros
Date: Fri, 20 May 2016 16:17:50 -0400
Message-ID: <2dc25c9c-748c-098c-f7a1-5d6e59504308@redhat.com>
References: <20160520163207.B99DCE0B9D@smtp.ogc.us>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDBB201@ORSMSX115.amr.corp.intel.com>
 <011001d1b2c6$a95a6f40$fc0f4dc0$@opengridcomputing.com>
 <011e01d1b2c7$e9a70c10$bcf52430$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Down6Qi2Xo9t4OtxDfRrtCcIL3Ed7ta5A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <011e01d1b2c7$e9a70c10$bcf52430$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Woodruff Robert J' <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Down6Qi2Xo9t4OtxDfRrtCcIL3Ed7ta5A
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/20/2016 02:46 PM, Steve Wise wrote:
>>> Does this mean that the code you want to add to libibverbs will be ta=
inted
>> with GPL
>>> since they come from the Linux kernel.
>>
>> I guess so.
>>
>>> I know that there are a lot of people that will not use a GPL library=
, since
>> it could
>>> taint their applications with GPL if they
>>> link to that library. I thought that is why LGPL was invented to prev=
ent
> such
>> tainting.
>>
>> I could utilize the code from FreeBSD.  Does that allow me to submit t=
his to
>> libibverbs under the dual GPL/BSD license?
>>
>=20
> I think I can just re-implement these services myself based published w=
orks
> describing the memory barrier assembly for ARM (like the document Jason=

> referenced earlier).  That will avoid any tainting.
>=20
> Doug: Will that work?

Either way works actually.  IANAL, but I've been told this multiple
times and will relay my possibly flawed memory of the legal issue.  The
original patch, even though lifted from the linux kernel, is likely to
fall under the scope of "operationally defined" code.  In other words,
the specific patch you wrote and the thing it implemented is so rigidly
defined by what it does, that there really is little to no room for any
different expression of the code.  When there is no room for different
expressions, the code is not copyrightable.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Down6Qi2Xo9t4OtxDfRrtCcIL3Ed7ta5A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXP3DuAAoJELgmozMOVy/d+8AP/jEQU1yWYQnLYeJ5nxC2bF3V
2h7bShqt7ZZ640TH7XQEm7SP37vYKfwwrG2EyLOsqZIqxprTaCuQUQaeewlYL9nL
sJKMIP3yAdjtIYADbc4dN9PAEmT7uwBrK3XPnCQrSBZ+Idc/ghyYe/bFomM2Ny0A
dAIy84UHGpY650orC4MbRmaFU15O5VF6Sr0TJiVbZ8negVssdg6+X/F62JgW0Xsd
Eflp2A/YZoTjod9aIHrPnPmZBmmcNb67chhSkts308Ii8b0WzcPiEthhny8QQn5n
IxDOtihC2sPXBSfXUlsx/YfJ3KgN3eXiCKUuc9nLaepFua6+BYsu3XYaImJlHBWR
hhVxQj7hM6WgnJXbEzTZaHjIjhse1qTBUjeq+qgXJi2PPuKgUCFE7Ph9dxmTMGBP
o1kRUn0xep0zaEJ9bg1UJsM3lCZXsdRb7lFKn3EG8Jjs3wTtCHL/WosDHR3gwHSG
H2ubg2oB1o+XSChOPSK2gqTXngreZVr74LRxp+UD6Hdrwe38R0HhfqGs+z1mlsmF
/0qfK6Dmlrj8HDIMhR14cZSIsmgfjIPuVaXSQLZQ70AwhZlUzQoLZJxPTbhY/J+I
UKgVOQjqfp3QqqjKpatuTDEQ+dn+pNY782WjRiaQXNjE+I4gpah4Y6i2Em/mrfOw
K8AhX1vrIu6OXi5wyBKf
=GYk6
-----END PGP SIGNATURE-----

--Down6Qi2Xo9t4OtxDfRrtCcIL3Ed7ta5A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
