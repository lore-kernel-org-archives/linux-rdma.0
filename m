From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/mlx5: Fix RC transport send queue overhead
 computation
Date: Fri, 12 Feb 2016 14:55:52 -0500
Message-ID: <56BE38C8.8050309@redhat.com>
References: <1455217797-15635-1-git-send-email-leonro@mellanox.com>
 <56BDEA0E.5090104@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pS5O6b0h2Ooq9SI5lnMGdEe7PlcE6V3o7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BDEA0E.5090104-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pS5O6b0h2Ooq9SI5lnMGdEe7PlcE6V3o7
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/12/2016 09:19 AM, Sagi Grimberg wrote:
>=20
>> Fix the RC QPs send queue overhead computation to take into account
>> two additional segments in the WQE which are needed for registration
>> operations.
>>
>> The ATOMIC and UMR segments can't coexist together, so chose maximum o=
ut
>> of them.
>>
>> The commit 9e65dc371b5c ("IB/mlx5: Fix RC transport send queue overhea=
d
>> computation") was intended to update RC transport as commit messages
>> states, but added the code to UC transport.
>>
>> Fixes: 9e65dc371b5c ("IB/mlx5: Fix RC transport send queue overhead
>> computation")
>> Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--pS5O6b0h2Ooq9SI5lnMGdEe7PlcE6V3o7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWvjjIAAoJELgmozMOVy/dTccP/i5Pw4NgI8l9NFTrKSzWBtA2
UkHJt6eaOapI2/TQC0g5qODfDku7pRBKMrimvvuGbtz372rgFfhTAlnYJIPms2DN
a4/Y60PO6VkMUt9Zcco6yQwVLxPmASCWBhAY3Q+DBMAXbfFQ+/FS/GeE/Mv6Wj5K
CyIrMtwTjmHFWnqqx/NxG+A1kVpy4wigAZbsKK+vg00YOlRB/L1Lg305dyJtmcFw
n3fp/soTgOMSzWaQjim4V29f3THqJiu0KghIW4dyZTwEQeP5s+JxVnrY41zOfLiJ
uSY3h8YhOq/XUa9PiKOygkvJwj/SwlBbz6IgunzlnQN1ExNZy6yVKu6J4EIU0F5R
Y/yJ5ywOlY+Pkliw9jA8DYVaSXSmRmkakviqMz13ZGcx3KOuPr3dfzsbaJd0P5TS
GKRmz1rkUTAzD+pQxDHPNbtZHbaoiiUUU7OFiQcLgv5R72UEeaoOkvZGRX/S5yIg
juqv6iqQ2mApoPzzRXuRQiLp+Fcjp9JdACzYkRy6lDxgahD/mTKfhk2Xb7U8rRxq
LF3M0r6dXVJxL36WUrsIKlMBaNeW8z6XsjCv/dwjtEK8qA3+UcNz2QKv+6l3n40N
ZyVLx/3iQWkkTBSk+iZEUQn/xJ2gtVzvk0tvjFG7nLI21beQrxrZRso5Jevwex7b
Fg4T+I6w3kYMf8JS+xlQ
=tzk4
-----END PGP SIGNATURE-----

--pS5O6b0h2Ooq9SI5lnMGdEe7PlcE6V3o7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
