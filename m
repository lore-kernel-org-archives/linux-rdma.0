From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 00/10] Add RoCE support to the mlx5 driver
Date: Wed, 23 Dec 2015 12:22:44 -0500
Message-ID: <567AD864.40807@redhat.com>
References: <1450889245-30347-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vkkMODhKqSOxM5mEovmWOERDesOkvEKb3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450889245-30347-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vkkMODhKqSOxM5mEovmWOERDesOkvEKb3
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/23/2015 11:47 AM, Matan Barak wrote:
> Hi Doug,
>=20
> This patchset adds RoCE V1 and RoCE V2 support to the mlx5 device
> driver.
>=20
> This patchset was applied and tested over the third version of
> "Add RoCE v2 support".

This one worked.  Thanks, applied.

> Regards,
> Achiad and Matan
>=20
> Changes from V1:
>  - Rebased over Doug's k.o/for-4.4-rc branch.
>=20
> Changes from V0:
>  - Fixed using rwlock before initializing it.
>  - Rebased over Doug's k.o/for-4.5 branch.
>=20
>=20
> Achiad Shochat (10):
>   IB/mlx5: Support IB device's callback for getting the link layer
>   IB/mlx5: Support IB device's callback for getting its netdev
>   net/mlx5_core: Break down the vport mac address query function
>   net/mlx5_core: Introduce access functions to enable/disable RoCE
>   net/mlx5_core: Introduce access functions to query vport RoCE fields
>   IB/mlx5: Extend query_device/port to support RoCE
>   IB/mlx5: Set network_hdr_type upon RoCE responder completion
>   IB/mlx5: Support IB device's callbacks for adding/deleting GIDs
>   IB/mlx5: Add RoCE fields to Address Vector
>   IB/mlx5: Support RoCE
>=20
>  drivers/infiniband/hw/mlx5/ah.c                 |  32 ++-
>  drivers/infiniband/hw/mlx5/cq.c                 |  17 ++
>  drivers/infiniband/hw/mlx5/main.c               | 318 ++++++++++++++++=
++++++--
>  drivers/infiniband/hw/mlx5/mlx5_ib.h            |  15 +-
>  drivers/infiniband/hw/mlx5/qp.c                 |  42 +++-
>  drivers/net/ethernet/mellanox/mlx5/core/vport.c | 139 ++++++++++-
>  include/linux/mlx5/device.h                     |  26 ++
>  include/linux/mlx5/driver.h                     |   7 -
>  include/linux/mlx5/mlx5_ifc.h                   |  10 +-
>  include/linux/mlx5/qp.h                         |  21 +-
>  include/linux/mlx5/vport.h                      |   8 +
>  11 files changed, 578 insertions(+), 57 deletions(-)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--vkkMODhKqSOxM5mEovmWOERDesOkvEKb3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWethkAAoJELgmozMOVy/dng8QAKYd9YTjNSqdO3zRHG/m+/jR
pF3wjiQz+xwdEFfRB5NB8nz90u0h5jg7fInKuYbde5M1wiftyZRkO3PP0boRpy4y
kNLMz0UNHWRqlB4LR5xiejVkSW6sxX26fy0x4vjR7B3NbNyXwvhmjOrcLb2o5icR
0Zx358IySclGw63J/Aq0SXpkn5x2+zE9A+bgIOI5Jb8WODbbljXkQUgEpfBouA+g
iPg0WZoJmO5hYnQZCyyAPGRNTI8VLTlQ9+yVaB3Vj2u7RL4oMoZSISZ7aegmfFpy
tKVLwmRQANeKf3poangoBm9fkKQUs3SE+TATobi6F0W6QULdm4GCM6LZIyRnCBEG
WrXhssIftzt5RdPectCoz0W7GTzPyhSCHTqHCX+i/VK2h0ZsVsw79nzryNZlr87d
/awRd7KM3ObzmsT1SYdY0oMifY3AFp+1sxeVzQdf8mS86i+2Cb253RW68jp/mv8d
u3a9gUW4sDnDXukvOde373CTUL5l+L9/fZTN0KN7N3G5LSMiMyfn1gLjCxRerjfr
W60O6rRacgnI9b1W9RLvKtkM+QmJxad1HBCx6frJOQ3z/7c+oQwonu/krgj5xOsO
ACI78h/NHplCqPGitHiqgaGAgc/Eo2ZoHvamRQbx49SBb3yybMIUtu2XMLoPjcJ1
rSCp+nbSOozQ3rSNuyhG
=kvxl
-----END PGP SIGNATURE-----

--vkkMODhKqSOxM5mEovmWOERDesOkvEKb3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
