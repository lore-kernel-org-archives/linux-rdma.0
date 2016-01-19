From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 for-next 0/2] Fix hop-limit for RoCE
Date: Tue, 19 Jan 2016 16:10:19 -0500
Message-ID: <569EA63B.2@redhat.com>
References: <1451897394-24525-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nwMgsNmGDaB2MHSifCa223xch1wK1dq4I"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451897394-24525-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nwMgsNmGDaB2MHSifCa223xch1wK1dq4I
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/04/2016 03:49 AM, Matan Barak wrote:
> Hi Doug,
>=20
> Previously, the hop limit of RoCE packets were set to
> IPV6_DEFAULT_HOPLIMIT. This generally works, but RoCE stack needs to
> follow the IP stack rules. Therefore, this patch series use
> ip4_dst_hoplimit and ip6_dst_hoplimit in order to set the correct
> hop limit for RoCE traffic.
>=20
> The first patch refactors the name of rdma_addr_find_dmac_by_grh to
> rdma_addr_find_l2_eth_by_grh while the second one does the actual
> change.
>=20
> Regards,
> Matan
>=20
> Changes from V0:
>  - Hop limit in IB when using reversible path should be 0xff.
>=20
> Matan Barak (2):
>   IB/core: Rename rdma_addr_find_dmac_by_grh
>   IB/core: Use hop-limit from IP stack for RoCE
>=20
>  drivers/infiniband/core/addr.c           | 14 +++++++++++---
>  drivers/infiniband/core/cm.c             |  1 +
>  drivers/infiniband/core/cma.c            | 12 +++++-------
>  drivers/infiniband/core/verbs.c          | 30 ++++++++++++++----------=
------
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c |  7 ++++---
>  include/rdma/ib_addr.h                   |  7 +++++--
>  6 files changed, 40 insertions(+), 31 deletions(-)
>=20

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nwMgsNmGDaB2MHSifCa223xch1wK1dq4I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqY7AAoJELgmozMOVy/dDq4QAMShtEZvEkCm85cKkaIpmdWR
gbjAYm9MyQNTNxRhmm8HvDjeXDdHJrqafzQkTUKZk0wMXp5vAkUxw0ZyeRKt2J9E
2ayDpCuBihoASmosTDzwqNJ7AMfHYyHkoBGC/vfruqp0OKAEhLhL0bBLfpwdu6+d
Uy4+8l/h2paFurEV7Mhwy3Lga5grTb8TGmdzrjeR/9J4sk81+DI+s4GZVsYzCiJ8
gtBRDoRB8to3WmMb9Cl9uhrWa8uZ43dYqgS7sf447rtV72dGagFPNZV1j5y5F/cq
heZtbyjKAlKaG0iCZB1ufpVb6BSG+HakaZQTt33AmZb8wTcJoUH0WGibqswTLIlS
YbcXGGuxuCzqv9NxowdAimZsTLDaTMI/LGFTfKfTcvJcabFNtpttkWda3Ps9k5QS
ihwj7tidpNzTCAAALm+8UQrMtogpP52bo2M5orJ1OZMBJgxj3nEQlE4wXlILaG/4
3dYba0fiBsZDC32gg+0xGIhhDcf3NbSIdk2L/cvdSzHZ21kHEm/3tzrygqIryDGM
1cEBdgDq/VROHCgbNSA6Lk2YIQOHhangSY7TJbAkG+XOuzAkql2+UPYoA5ysa8RW
uUJ5rUtCPlZI6OXhNzo7SJvfOsitkCsYJmoLj8LnHvXn2jAkGVe+1v/QzwqS4B7o
1oN7Ln4vCaQ3n0rHLcmK
=IhJO
-----END PGP SIGNATURE-----

--nwMgsNmGDaB2MHSifCa223xch1wK1dq4I--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
