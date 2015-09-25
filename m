From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc v2 0/4] Remove mlx5 support for
 IB_DEVICE_LOCAL_DMA_LKEY
Date: Fri, 25 Sep 2015 10:52:30 -0400
Message-ID: <56055FAE.5000906@redhat.com>
References: <1443080064-28760-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MfS5jmjhDepkjF80DBSqe6uEjUI2WGl6n"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443080064-28760-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MfS5jmjhDepkjF80DBSqe6uEjUI2WGl6n
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/24/2015 03:34 AM, Sagi Grimberg wrote:
> The Connect-IB device has a specific issue with memory registration usi=
ng
> the reserved lkey (device global_dma_lkey). This caused user-space memo=
ry
> registration which usually uses cached pre-registered memory keys to fa=
il
> due to a device access error during registration. kernel-space memory
> registrations used an internal instance a physical memory key allocated=
 with
> the private pd context, so this error didn't happen there.
>=20
> Since the reserved lkey is not fully functional, remove the support for=

> it altogether. Jason's patches commit 96249d70dd70 ("IB/core: Guarantee=

> that a local_dma_lkey is available") address consumers by allocating a =
physical
> lkey per PD in the core layer. It also allows mlx5 driver to get rid of=
 it's
> private physical lkey (patch #2).
>=20
> The ConnectX-4 device should have this issue fixed so the capability wi=
ll be
> restored depending on a FW query information.
>=20
> Also, fix NFS client to use the PD local_dma_lkey instead of the device=

> local_dma_lkey (which requires a missing check of the device capability=
 in
> frwr mode). And, fix iser initiator which encountered some issues when
> registering a signature capable memory region with an indirect dma_lkey=

> area. The fix covers a larger ground as it does not allow using a globa=
l MR
> with remote access (long standing issue) but on the way makes the speci=
fic
> registration issue go away.
>=20
> Thanks to Haggai for catching this early enough.
>=20
> Many thanks for the reviews.
>=20
> Changes from v1:
> - Fixed changelog of patch #3 (comments from OrG)
>=20
> Changes from v0:
> - Replace xprtrdma patch to Chuck's one
> - Fixed typo in iser modparam description
>=20
> Chuck Lever (1):
>   xprtrdma: Replace global lkey with lkey local to PD
>=20
> Sagi Grimberg (3):
>   IB/iser: Add module parameter for always register memory
>   IB/mlx5: Remove support for IB_DEVICE_LOCAL_DMA_LKEY
>   IB/mlx5: Remove pa_lkey usages
>=20
>  drivers/infiniband/hw/mlx5/main.c            | 67 +-------------------=
--------
>  drivers/infiniband/hw/mlx5/mlx5_ib.h         |  2 -
>  drivers/infiniband/hw/mlx5/qp.c              |  4 +-
>  drivers/infiniband/ulp/iser/iscsi_iser.c     |  5 +++
>  drivers/infiniband/ulp/iser/iscsi_iser.h     |  1 +
>  drivers/infiniband/ulp/iser/iser_memory.c    | 18 +++++---
>  drivers/infiniband/ulp/iser/iser_verbs.c     | 21 +++++----
>  drivers/net/ethernet/mellanox/mlx5/core/fw.c | 22 ---------
>  include/linux/mlx5/device.h                  | 11 -----
>  include/linux/mlx5/driver.h                  |  1 -
>  net/sunrpc/xprtrdma/fmr_ops.c                | 19 --------
>  net/sunrpc/xprtrdma/frwr_ops.c               |  5 ---
>  net/sunrpc/xprtrdma/physical_ops.c           | 10 +----
>  net/sunrpc/xprtrdma/verbs.c                  |  2 +-
>  net/sunrpc/xprtrdma/xprt_rdma.h              |  1 -
>  15 files changed, 35 insertions(+), 154 deletions(-)
>=20

Hi Sagi,

I've applied this for 4.3-rc.  Thanks!

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--MfS5jmjhDepkjF80DBSqe6uEjUI2WGl6n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWBV+uAAoJELgmozMOVy/duWsQAI0XlEEeqN949va5p0IW1lih
4JafN3e437OGe5vtmsiBo6fsyEY21fwl+DjzBmoo0USltOIS2RAVXqkDURQbhiVa
rx0Qm34p63aitTspqPHOUENRmcaKwmhzQeMefbUDMOIGmDa90jd9TbAhp34tj9rx
Ome/4JW9gRABsPnxDpogo/45tXVLMy88SD1rcVxcOVuBHUy3Y1gk2di9ihsLLNM+
j9l2F/RlaFzdtAT6KdapCbEDuNlpDNGghFnoZyk9ntSNWsueiVBTBkZtY7l6eKeO
e8+rPCVc8Qdg3QLzUUl9NWioZ9sO9CpqetIqMPqXVAu/StasXazMOmgWumNOpmN6
rRJALTIKv+ceV4VCauNmvJjc3fmKhlIbyQ32YE08P+Xrji/G+WWtC/xTsxTAE7/+
jd6cr8JCwalge/P3uIF/FC5UGTswB4eAGgdSZQooXHTJZRcKMUxtqrlZOyjr/MFm
mmGQOO+XVYWUENPu953gpo+8Hd+XurNwZWwVMpbTbwXhhepgILkJwu3c+eOZREQg
2JIoUfz+6kV3wDv6snRBuAlcQDbvOn/U7SRN9npVCEwWT2mIR8nSROw7RXSw9p0U
Vw2k6013Xf4UjJCy/3fNSUTAnjO+f8iPwh5YP5gYPnJmnAotuR22AzoRnyBMfaLz
NYD4XKEQpQa2+fqxthIb
=2zt8
-----END PGP SIGNATURE-----

--MfS5jmjhDepkjF80DBSqe6uEjUI2WGl6n--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
