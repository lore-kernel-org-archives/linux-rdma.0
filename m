From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/mlx4: Fix extended counters support
Date: Thu, 11 Feb 2016 11:08:53 -0500
Message-ID: <56BCB215.4050802@redhat.com>
References: <1455179084-4778-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UNl8FOGC6kAGw6wlNPCH3foSJCpi4iHjH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455179084-4778-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UNl8FOGC6kAGw6wlNPCH3foSJCpi4iHjH
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/11/2016 03:24 AM, Matan Barak wrote:
> From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Hi Doug,
>=20
> This series fixes an issue introduced in 4.5 after applying Christoph L=
ameter's
> "IB 64 bit counter support" series.  Christoph used a mad in order to q=
uery the
> vendor driver for extended counters support, however this mad wasn't ha=
ndled in
> mlx4 when link layer is Ethernet.  Thus, extended counters support was =
broken.
> In addition, this series fixes a bug in IB/core sysfs which was also in=
troduced
> in "IB 64 bit counter support" series.
>=20
> Patch 0001 fixes wrong handling of port info capability mask, which cau=
sed
> setting of extended counters sysfs even if underlying device doesn't su=
pport
> it.
> Patch 0002-0003 align mlx4 counters sysfs for extended counters scheme =
in case
> link layer is Ethernet.
>=20
> Thanks,
> Eran and Matan.
>=20
> Eran Ben Elisha (3):
>   IB/core: Fix reading capability mask of the port info class
>   IB/mlx4: Add support for extended counters over RoCE ports
>   IB/mlx4: Add support for the port info class for RoCE ports
>=20
>  drivers/infiniband/core/sysfs.c  |  5 ++--
>  drivers/infiniband/hw/mlx4/mad.c | 63 +++++++++++++++++++++++++++++++-=
--------
>  2 files changed, 52 insertions(+), 16 deletions(-)
>=20

Hi Matan,

The first patch is a true bug fix while the next two add the feature to
RoCE mode.  Based upon the code patches, the RoCE code should work fine
for 4.5 without the new support, there isn't a bug there (they simply
won't respond to the ext counters port request).  So I took the first
patch for-rc and the next two I'll put in for-next.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--UNl8FOGC6kAGw6wlNPCH3foSJCpi4iHjH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWvLIVAAoJELgmozMOVy/dWA0QAMS6PCnB19p4S/lMheVui0+t
MuQv9PxYUO+Vr5j2TWRgIhP1OvhQFqy444HQYYE9tWJPKEP2vV9qQzFenJTrH3FT
VISpeUXcSYtj1LHQzKd7pjWZPzN00TttdBr2XkqoevI3CkXZpk+e4xVaxOvQjvd1
CoHCzrn1ztoxqQ4bxIVb7tip6As0Msp+MfADU+udmiimnk8nKpJvjUXIBNvFTfkB
xJqw1R14an5KCTqrmtPt+J+SosX1zKh3rnNYsmDURpxFAdjpulhjREMK+XIEvsaF
dn6VF8oj12J1sXn5sy3bZq3wo32QdF2Gy9RLopexQIwMBGTykmGXCfQWBZ/2UJpC
5vl4Mr5RB6PCKrjp708NnKYp7eNlshnMxF8Fn4mVz8Wi2wUBWy3uX5kvn0AOAKkr
3yAotC5p7t8WgY4vddEcvpY0lh/CrVXW0qtIhTM3f4dS9NIiFEIt/zwxJ6UbDZvy
hXwFg2n7HM7QW0Bidst05MZ5UvGBnDnBPYAFKv7SbbRNqx06h72bbojNnR5mlVPV
HavMo6yzp/xhkAGtqYs+oSxWG4f64GTOjuK+6o0vZoXQAbtxjVvoauhWkj4Z+nGn
1ksGutUvptVt3TvN5pqPXqy5J/sHqpSfDElP5np9MWALISVZvQ0+xqM+7zEPpzqK
uEzJdqPCfMCkkX3l46d4
=ax/p
-----END PGP SIGNATURE-----

--UNl8FOGC6kAGw6wlNPCH3foSJCpi4iHjH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
