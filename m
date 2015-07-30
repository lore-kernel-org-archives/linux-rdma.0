From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/4] few mlx4 IB driver fixes for 4.3
Date: Thu, 30 Jul 2015 11:18:45 -0400
Message-ID: <55BA4055.6060403@redhat.com>
References: <1438266864-3584-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PQ6KKPcLb8IQeiOOjaKGee5s5P864Aa8l"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438266864-3584-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PQ6KKPcLb8IQeiOOjaKGee5s5P864Aa8l
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/30/2015 10:34 AM, Or Gerlitz wrote:
> Hi Doug,
>=20
> Some fixes included, none of them accounts for regression introduced in=
 4.2-rc1,
> so all can go to 4.3 -- genetated them again 4.2-rc4
>=20
> Or.
>=20
> Jack Morgenstein (3):
>   IB/mlx4: Fix potential deadlock when sending mad to wire
>   IB/mlx4: Deprecate mcast group warning message to debug because of fl=
ooding
>   IB/mlx4: In sysfs under RoCE, do not allow changing the paravirtualiz=
ation mapping for pkeys
>=20
> Noa Osherovich (1):
>   IB/mlx4: Use correct SL on AH query under RoCE
>=20
>  drivers/infiniband/hw/mlx4/ah.c    |  6 +++++-
>  drivers/infiniband/hw/mlx4/mcg.c   | 15 ++++++++++-----
>  drivers/infiniband/hw/mlx4/sysfs.c |  5 ++++-
>  3 files changed, 19 insertions(+), 7 deletions(-)
>=20

These all looked fine to me.  Picked up for 4.3.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--PQ6KKPcLb8IQeiOOjaKGee5s5P864Aa8l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVukBVAAoJELgmozMOVy/dx0kQAJXSigBXPZdUN6xIGcM+kF0P
0pbvRLCzchfo36Ws8Gdss1S/vD7iS0JcIpOCXttf2H2x8hYTHZ70LOMIO9Gphb9/
c9HKvULS6+xAZyp6y19ahkKNHhTMnHYi9LBlR1zJ7ce5nCFowWbqgyjnVJo4Vv2U
Pdfm0xBUHe2eyIiuQbiePW5DMyd6qKdZwRTAuwSYP8cz5HeIrBGkxqdFrIEgpU7R
+Mxf9r1bb9Wlht++nrVWjkbRuTwmAPjfot5RMSzUSNyC+QpHGs53c17VwNA24m5k
2SeB+1WeIpozqMDqO5QtdyY1QQBgf2ofJahq5UsIqr9KwE12EGmizKhFBG6uRP4j
z85E+Gvdo7o6kFmm2ntZm4HXOhZ9x7/xCRQlvAlDuDoh2Mt2tAGj3v5JprEZ/5eY
rsX1xiR3eSZdcKGPAyv2A9gKDDZEDrS20ApaqPlNXO9e73MM9xSWKRrnWjl+Jkva
574ep1U7oVlXoC48JJxTLUwiy7Ig2OHtPuCfzeZFFnne189iIj55aJ5+KciY4apM
+uNf0frlptEs5Gk7Y/r0ofhMvyPdTVus7tAPPAJyRWp4LtciomHHKY6U0ceW/Ebj
mvx55UAqVwGew11/o8ea0gzdExlDlqLgSYiPv2/B94AT146Lrdklnusj4fdNaQWM
KK7fYakr8w8rfQwG9+mQ
=Inc7
-----END PGP SIGNATURE-----

--PQ6KKPcLb8IQeiOOjaKGee5s5P864Aa8l--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
