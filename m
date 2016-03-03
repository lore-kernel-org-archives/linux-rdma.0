From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Arbitrary SG list registration support
Date: Thu, 3 Mar 2016 17:05:18 -0500
Message-ID: <56D8B51E.4060107@redhat.com>
References: <1456765654-27592-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DAfuSOKfVIDSoe6VusKJkvpjGcrv1ntRd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456765654-27592-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DAfuSOKfVIDSoe6VusKJkvpjGcrv1ntRd
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/29/2016 12:07 PM, Sagi Grimberg wrote:
> This patch adds arbitrary SG list memory registration support
> which is pending on the device capability (Introduced in Mellanox
> ConnectX-4).
>=20
> Now that the core is able to handle sg lists, the addition of
> this support is pretty straight-forward and with minimal changes
> to the core and ULP conversion.
>=20
> Just add another MR creation type which is capable of handling
> SG lists with gaps (pending on the device capability).
>=20
> Patch 0001 - IB core flagging
> Patch 0002 - mlx5 support
> Patch 0003 - First consumer, iser initiator (more will follow!)
>=20
> This has come up just now because I've been waiting for FW cap
> exposure that now is included in patchset "Add memory window user-space=

> support to mlx5" by Matan (so it obviously depends on it).
>=20
> Code is available at:
> git-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org:sagigrimberg/linux.git arb_sg.3
>=20
> Sagi Grimberg (3):
>   IB/core: Add arbitrary sg_list support
>   mlx5: Add arbitrary sg list support
>   iser: Accept arbitrary sg lists mapping if the device supports it
>=20
>  drivers/infiniband/core/verbs.c          |  2 ++
>  drivers/infiniband/hw/mlx5/main.c        |  2 ++
>  drivers/infiniband/hw/mlx5/mlx5_ib.h     |  1 +
>  drivers/infiniband/hw/mlx5/mr.c          | 50 ++++++++++++++++++++++++=
++++----
>  drivers/infiniband/hw/mlx5/qp.c          | 15 ++++++++--
>  drivers/infiniband/ulp/iser/iscsi_iser.c | 11 ++++++-
>  drivers/infiniband/ulp/iser/iser_verbs.c | 23 ++++++++++-----
>  include/rdma/ib_verbs.h                  |  6 ++++
>  8 files changed, 93 insertions(+), 17 deletions(-)
>=20

I added this series to the mlx5 branch I have (it needs other mlx5
patches to apply cleanly).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--DAfuSOKfVIDSoe6VusKJkvpjGcrv1ntRd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2LUeAAoJELgmozMOVy/d9rIP/3/JAs8xrOks2QJxTtShb0QT
kfOf1EREVtPdYpLUh9/z6hMvcJDGDUp9L3Mn2Aj7IhtvT/tfMbwhD/AKAvyvtVgw
tKq54rQgV59X6qLe3IpLY4HyRJHVVLbeNEp8Ft3fDGamBeWOKEsdTs1thN9OUmUE
ldLfaj1UuF26zlisWQF788r4f1pYb4QXEOR6GiFiqS/H5z1HQIZFmd1IRTJSHwt5
2lHrOwxJn2n8TSrsbvaDnJlNSdJeiuQVWqoNRnIusbZs2Jo3icalF338FXlBuo1F
T8EafDXVDw+kLyDg7IAQYvAoWRKHKJ7+Vl9AqgiRdUrYDwzxunk0XB/p8W3EkAB8
Kgx83C3Ifhr9ht86PbHD/VJya4KSODRkJrSxIpBTPGRIs10YdOEk5DpDtgH4kuce
CkAzyLN3v5DWVe/+Ee6GX+YyWgiodd1LSwBVvWogITxIIXmLqedkjhdMXO41ESKT
5zjzEwuKo9KOvT1L+D6wpaS5y6W8SpfqsdvERn14Zu5xWpMb4wvpD4ucw+v9BkpE
nlZtZeTh9MxgS3mt8/zc2LNOmj0rH/y6ck2i257QTg5h47BPcvkM7rUvEHnFb2pX
Sg0V6YTaTPtSYvmLFoOqOa1XACCnVjehhp8K/2BKG+t+ZCl6ye12BbXsa3PwyPsd
sUL4Ahv7FZe3lostPrSm
=spJ0
-----END PGP SIGNATURE-----

--DAfuSOKfVIDSoe6VusKJkvpjGcrv1ntRd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
