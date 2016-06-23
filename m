From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 00/13] Create device FW version call back
Date: Thu, 23 Jun 2016 12:11:34 -0400
Message-ID: <70eed872-d95c-9569-9e31-ce9630b4ba28@redhat.com>
References: <1465971728-24104-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="22GPrerPHM2XFXa8a9wGMqXU3jnVTwt9b"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465971728-24104-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--22GPrerPHM2XFXa8a9wGMqXU3jnVTwt9b
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/15/2016 02:21 AM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Currently there are 3 ways to get the firmware version for an
> RDMA device.
>=20
> 1) verbs query device
> 2) ethtool
> 3) sysfs entry
>=20
> Both 1 and 2 are expecting a 64bit field which is vendor specific
> and encodes a 3 number version.  Some hardware, like OPA, only
> has 2 numbers in it's version, while other hardware like cxgb4
> has 4.
>=20
> Support for the sysfs entry was left to the devices but generally
> done in a "common" way.
>=20
> This series moves to unify firmware version reporting by creating
> the ib_get_device_fw_str method within the ib_device.  With this
> we can then do 3 things.
>=20
> 1) Support device dependent formats of version strings with
>    ethtool (IPoIB)
>=20
> 2) Support a common sysfs entry in the core for backwards
>    compatibility which can either be changed to a common
>    FW version string with the new verbs interface or simply
>    removed in favor of using ethtool.
>=20
> 3) Eventually drop the sysfs entry once we can get user space
>    tools off of it.  If we decide not to have an interface
>    through verbs (require the use of ethtool via IPoIB) iWarp
>    and RoCE devices don't even have to have this support at
>    all and the code can be eliminated for those devices.
>=20
> 1 and 2 are done with this patch series.  3 needs to be decided
> by the community if, and when, sysfs support can be dropped.
>=20
> NOTE: I have tested these patches with mlx4, qib, and hfi1.
> Other drivers were compile tested only.
>=20
> ---
> Changes from V0:
> 	Address comments by Jason and Leon
> 	Rebase to upstream
> 	Add Reviewed-by for cxgb4
>=20
>=20
> Ira Weiny (13):
>   IB/core: Add get FW version string to the core
>   IB/cxgb3: Support device FW version string
>   IB/cxgb4: Support device FW version string
>   IB/i40iw: Support device FW version string
>   IB/mlx4: Support device FW version string
>   IB/mlx5: Support device FW version string
>   IB/mthca: Supprot device FW version string
>   IB/nes: Support device FW version string
>   IB/ocrdma: Support device FW version string
>   IB/usnic: Support device FW version string
>   IB/ipoib: Use new device FW version string
>   IB/core: Export a common fw_ver sysfs entry
>   IB/hfi1: Add device FW version string
>=20
>  drivers/infiniband/core/device.c             |  9 ++++++++
>  drivers/infiniband/core/sysfs.c              | 15 ++++++++++++-
>  drivers/infiniband/hw/cxgb3/iwch_provider.c  | 27 +++++++++++---------=
---
>  drivers/infiniband/hw/cxgb4/provider.c       | 31 +++++++++++++-------=
------
>  drivers/infiniband/hw/hfi1/hfi.h             |  2 ++
>  drivers/infiniband/hw/hfi1/verbs.c           | 15 +++++++++++++
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c    | 24 +++++++++-----------=

>  drivers/infiniband/hw/mlx4/main.c            | 24 ++++++++++----------=

>  drivers/infiniband/hw/mlx5/main.c            | 21 +++++++++---------
>  drivers/infiniband/hw/mthca/mthca_provider.c | 24 ++++++++++----------=

>  drivers/infiniband/hw/nes/nes_verbs.c        | 33 ++++++++++++--------=
--------
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   | 19 ++++++++--------
>  drivers/infiniband/hw/usnic/usnic_ib_main.c  | 16 ++++++++++++++
>  drivers/infiniband/hw/usnic/usnic_ib_sysfs.c | 17 --------------
>  drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |  6 ++---
>  include/rdma/ib_verbs.h                      |  3 +++
>  16 files changed, 156 insertions(+), 130 deletions(-)
>=20

Thanks Ira, series taken in for 4.8.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--22GPrerPHM2XFXa8a9wGMqXU3jnVTwt9b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXbAo2AAoJELgmozMOVy/dA68P/RsjUOXRgEhXMqEo8BvmASte
m1AtQ8sU9frOzlNDDo8OYxSBskoTkjTjdZ303Zs3zfdp22yttCFBPe7QO5cepIRa
F6sVatVCaIer1S4H8IvaGqcAXtnuSKkQpNAw38xxynOECk9Z0MqhWBfexoB7I1lZ
ECTBIVC/QXZSBrbgD1IkYcSlLRJzsWaNG71TGgJjbFBNUfiWLS/rZ4HdBXVe0pvL
QAwQN3nqYuFcXpYKAz5+nPVr4mr0IOaMr6opbuTFOQpvqxWCq0QhZDjO4ASpH6oh
i9WvN9pFpjI9cwzNTeEuTrZeTzkbyGGDYRdADedes0FtTfYyJWSf21/RXLXXShvv
8xLrxJI7GQufpwxdUmmxDM0b3KD04jolwmO+hWS/qoUOl0Ke7d79+M1HxQ03qyym
iODXHKWvqYPL9VUS+A3htfiwGruWeSqC1HoBoOhObtXNZMc4oiU4KKy3tYMKuHVP
CCUMUv/YZTDl5lxiulRRh/jsv4snyTMklDDaklHXr/7qm+GHV6a0Hnt+DC23IpCh
ii6J4n4RHaNBBrEwyYIqgap4qVpEYfDfa1/ljvN0/6YBPWVONFLxjGY7UJJQkvxi
Hhv0roZfO6yJmvZEB/kA37ikNA34Mynjv/q/YJ8GLxBHeRe4c0ztlPtCytoaYAqu
tCyO6H9pvoA1XwtDT/qq
=ga0B
-----END PGP SIGNATURE-----

--22GPrerPHM2XFXa8a9wGMqXU3jnVTwt9b--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
