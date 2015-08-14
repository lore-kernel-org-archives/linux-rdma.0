From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 1/3] IB/core: Access to one past end of array
 in _gid_table_setup_one
Date: Fri, 14 Aug 2015 17:04:57 -0400
Message-ID: <55CE57F9.6000509@redhat.com>
References: <1438607342-11964-1-git-send-email-matanb@mellanox.com>
 <1438607342-11964-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7CBjvh0qTqxQBXJCAKx5e9qCECiqB1Q5w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438607342-11964-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7CBjvh0qTqxQBXJCAKx5e9qCECiqB1Q5w
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/03/2015 09:09 AM, Matan Barak wrote:
> The error flow of _gid_table_setup_one accessed table[port] when
> port was 1-based instead of 0-based.
>=20
> Squash-into: 'IB/core: Add RoCE GID table management'
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Squashed as requested.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--7CBjvh0qTqxQBXJCAKx5e9qCECiqB1Q5w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzlf6AAoJELgmozMOVy/dazgP/RG78JEs/gBMgtgeOnd1vaZD
v69Tybi/Ii/X/+qyKKD2pziM9GzElWZWOE4wKjHcsdsDKt3ztBBR9TS7vnE38BIi
FBhbBT/fiJWtCedRWY9R2HZoP5pdUnFUW25ubTbUFIR5xRxrpJuWQINlBmXtLOOA
a4ZPuSFJn9QKcQDcKMd6PdxMfiY8cuvKM1KpcB6JobhJL56ZKz3owHAgoEfSYjua
Y9QVV19/RDngcIvau7ynVvz6g+/D7bW6s8xFLD9A3m+IbwmIkCy1YOfHG0LTaGWZ
eJ5Q19i/DqmJQiAD3Ri/ZJ8A55ESRcEpiMywO0rPim3vYxHYpCFu0C8yBZ/nuybD
hBEq8FmjPxifmGMoLyHDegcJGj3M8QKgA5mbZTLasBa12GX2dUre6XuqoD1SYj4V
EozhhpVkBxomY42yg/N+p1fuwFVmi7BxnHcjfWCGHfXseUAsiB1Y41E7FmEY9eqK
ELFsmsSXXLzEvh1uxa6E4NfX2OME+hGt0x/fVbA7HI2+Wv4DYdeopaSpf1XvmM6p
ByFg/p83nUDNZFxuOooeJy8ByEz1TdaBcAvulNp5RxCs8fcazwK+9em0tFIr7BnL
JtL71ROzv19RzTzokMUhO0RYCWycx15cz8e8ndgCsysPhFVj75q6np2oLPwS4kFe
B7GJ930VRTAsZp4gOc8V
=DKTw
-----END PGP SIGNATURE-----

--7CBjvh0qTqxQBXJCAKx5e9qCECiqB1Q5w--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
