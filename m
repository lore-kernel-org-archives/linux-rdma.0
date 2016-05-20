From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v2 0/2] libibverbs memory barrier fixes
Date: Fri, 20 May 2016 16:20:14 -0400
Message-ID: <3ffd3089-ede9-aebf-4781-2e012bc65252@redhat.com>
References: <20160520200053.6983AE0B9D@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jLHp49x5WNsXM8c5o3sTEcqwqND7M7awA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160520200053.6983AE0B9D-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jLHp49x5WNsXM8c5o3sTEcqwqND7M7awA
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/20/2016 03:43 PM, Steve Wise wrote:
> This is v2 of the ARM64 mb* support, plus an additional patch to fail
> compiles if there is no platform implementation of the memory barriers.=

> I've included the 2nd patch because I think it is important to not
> assume any default barrier implementation.  Getting it wrong can result=

> in data corruption.
>=20
> Changes since V1:
>=20
> Put the RFC tag back on because I want to retest this series.
>=20
> Implemented the ARM64 memory barrier macros from scratch using the AMD
> reference docs.
>=20
> Added 2nd patch to fail compiles if no mb* macros exist for the platfor=
m.
>=20
> Steve Wise (2):
>   libibverbs: add ARM64 memory barrier macros
>   Fail compiles if no platform specific memory barriers exist
>=20
>  include/infiniband/arch.h |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
>=20

Please remember to use --thread=3Dshallow when sending patch emails using=

git send-email (which is what I assume you did).

Let me know how the testing comes out.  The patches look fine to me
(thanks for adding the second one, it's the right thing to do).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--jLHp49x5WNsXM8c5o3sTEcqwqND7M7awA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXP3F+AAoJELgmozMOVy/dh4oQALYhMWbKqWj+PgrRY7KCrwZM
h68t8NA+p17U83giHPCgDwpCtzAGfFA8tGv3wMqwL4AR6OqVokNUVKwS4k1DQVau
o7/xUoHJz326QwE7M0/8glw7gDCqfKYvf66Thb7qE4SkeBUugE52fthJDtFhHdZy
YaphfDvtIBL5ugVzJoVDnWkmYLPTYSjWgDtMnQ6zQgqGUHb7PiJi8vuV4Ixm+9R4
AnfOB0fg4D5ixsX/hHRvmhwn698v8dsPY7CjJ7l2IeWTDrKfKMECT2bJdwMrV2br
V0+k5GTskoleQXUV34afjCAUzhJAt/4nJvjMKzeyHB3UzXo0PSnAoZ+cLwFhng+T
kwWDZSnpoODtVWPi7Sv3BAKSZWjSxUhyg1eTKjsV5GMokbTciqJQFO0Kx88gcC2l
nDCaa55MOUpgOStbnKcJ+PK5E//4hgSMIoSiSFMqNAWaT2VSZI9taqbAH2dVMfwe
i5p5o+ojIuHUnpq0YbYu7VjlcRgLuvzFvDd692pPhz51BKLBxwl/XM8+yiJGHZYI
+acN7CEFNOdX8pMhTxxVbV83oMR38WaGIXd5Ae0IBfrbfrtPEPRtIjVUq2rqiDHb
FNBAujjdB5fcz1b/tkREHMNqCx8Y3pPyTuEes+1qQEG4Y+321FmxwNqgb5VGiNg7
rHmCxkNRfE/JXfFBOQs8
=BXUI
-----END PGP SIGNATURE-----

--jLHp49x5WNsXM8c5o3sTEcqwqND7M7awA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
