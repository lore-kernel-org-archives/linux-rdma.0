From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.5] iw_cxgb4: Take clip reference first, before
 creating IPv6 listening servers
Date: Tue, 19 Jan 2016 15:54:20 -0500
Message-ID: <569EA27C.7050900@redhat.com>
References: <1452659594-7875-1-git-send-email-hariprasad@chelsio.com>
 <006501d14e11$0b5315a0$21f940e0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="W76dAhICWtwgC8pK2TViFb0XHQTaEVB0c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <006501d14e11$0b5315a0$21f940e0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--W76dAhICWtwgC8pK2TViFb0XHQTaEVB0c
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/13/2016 09:45 AM, Steve Wise wrote:
>=20
>=20
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner@vger.k=
ernel.org] On Behalf Of Hariprasad Shenai
>> Sent: Tuesday, January 12, 2016 10:33 PM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; leedom@chelsio.c=
om; nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; Hariprasad Shenai
>> Subject: [PATCH for-4.5] iw_cxgb4: Take clip reference first, before c=
reating IPv6 listening servers
>>
>> The h/w is designed in such a way that, if you do anything IPv6
>> related, a valid clip entry must be there. So take clip reference
>> before creating IPv6 listening servers, and then if we fail to
>> create server, release the clip entry.
>>
>> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>> ---
>=20
> Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>=20

I shortened the git log subject a bit, but otherwise, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--W76dAhICWtwgC8pK2TViFb0XHQTaEVB0c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqJ8AAoJELgmozMOVy/dw44P/20Dzw4ntzBJhTp5BB1l2NUI
mp+n+YAOrC+bz2kP6hyUB2lqPbkdwbGjPyFdrVQGpcCGB0F21zKBtRnZL/yOfyAC
QfC1Vcqz4tsqaTvqlidI+wdmSMFGL7SQUiKwN+eduaAVK/XV6DOs3OfaypX31qn/
L1oTdYCyLZPpE9Jm8z7UpjZVoLVyd9DteWIL84K8o2dMzJkPxk9d9CC1ux1FNUFB
TdbxOoscwd1jRh6IK3RiV0y1E5pcGpx0d1LAnK471qWWARfdBEE5dpqpGCuy2AFs
hfRYPT3MCIXcM7XCUogpzI2hdZZG7weJ7LjODfHBYGG7+VqagqfwoaCbDTpfgoIm
JiCMaBMCvJPcnkAd2j28gRsh60ywWtoC4IXkq11T2LHk26jKWfbnrey4UIscrmKB
M1rKrGoNSh4QcUjcBZewwnpytXgLLsfa4Y6KGDpjny8C8VcUfpfwGholrZ7ui3wa
cifZRZna/UU7K42EgILoAeIrZQ4fD6aGZ75GlbS4or0QGmT9PIkBHLswXJeFhMLj
vE9s7BdqpBzmxymzhRNd1x61HsayQuZrMpfAPCE4coolruugP0BDsiDm8cFWMkii
y97lZVsEiCfS9nyDf0hx6j7Q+fklkzbSNUKAhaBwDrdZesj+d4VE3y1xdm0tgq42
nVUkfA1n3/V0wlZK82ZQ
=qt20
-----END PGP SIGNATURE-----

--W76dAhICWtwgC8pK2TViFb0XHQTaEVB0c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
