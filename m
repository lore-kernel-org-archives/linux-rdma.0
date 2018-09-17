From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH rdma-next 00/24] Extend DEVX functionality
Date: Mon, 17 Sep 2018 22:34:26 +0300
Message-ID: <20180917193426.GR3661@mtr-leonro.mtl.com>
References: <20180917110418.18937-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9sSKoi6Rw660DLir"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--9sSKoi6Rw660DLir
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 17, 2018 at 02:03:53PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> From Yishai,
>
> This series comes to enable the DEVX functionality in some wider scope,
> specifically,
> - It enables using kernel objects that were created by the verbs
>   API in the DEVX flow.
> - It enables white list commands without DEVX user context.
> - It enables the IB link layer under CAP_NET_RAW capabilities.
> - It exposes the PRM handles for RAW QP (i.e. TIRN, TISN, RQN, SQN)
>   to be used later on directly by the DEVX interface.
>
> In General,
> Each object that is created/destroyed/modified via verbs will be stamped
> with a UID based on its user context. This is already done for DEVX objects
> commands.
>
> This will enable the firmware to enforce the usage of kernel objects
> from the DEVX flow by validating that the same UID is used and the resources are
> really related to the same user.
>
> For example in case a CQ was created with verbs it will be stamped with
> UID and once will be pointed by a DEVX create QP command the firmware will
> validate that the input CQN really belongs to the UID which issues the create QP
> command.
>
> As of the above, all the PRM objects (except of the public ones which
> are managed by the kernel e.g. FLOW, etc.) will have a UID upon their
> create/modify/destroy commands. The detection of UMEM / physical
> addressed in the relevant commands will be done by firmware according to a 'umem
> valid bit' as the UID may be used in both cases.
>
> The series also enables white list commands which don't require a
> specific DEVX context, instead of this a device UID is used so that
> the firmware will mask un-privileged functionality. The IB link layer
> is also enabled once CAP_NET_RAW permission exists.
>
> To enable using the RAW QP underlay objects (e.g. TIRN, RQN, etc.) later
> on by DEVX commands the UHW output for this case was extended to return this
> data when a DEVX context is used.
>
> Thanks
>
> Leon Romanovsky (1):
>   net/mlx5: Update mlx5_ifc with DEVX UID bits
>
> Yishai Hadas (24):
>   net/mlx5: Set uid as part of CQ commands
>   net/mlx5: Set uid as part of QP commands
>   net/mlx5: Set uid as part of RQ commands
>   net/mlx5: Set uid as part of SQ commands
>   net/mlx5: Set uid as part of SRQ commands
>   net/mlx5: Set uid as part of DCT commands

Hi Doug and Jason,

Do you want me to resend 7 patches above in one series and other patches
in another series just to be below 15 patches limit? Please be aware
that those patches above are going to mlx5-next and not to
net-next/rdma-next.

No rebase, no code change, no much meaning too, but it is your call.

Thanks

>   IB/mlx5: Set uid as part of CQ creation
>   IB/mlx5: Set uid as part of QP creation
>   IB/mlx5: Set uid as part of RQ commands
>   IB/mlx5: Set uid as part of SQ commands
>   IB/mlx5: Set uid as part of TIR commands
>   IB/mlx5: Set uid as part of TIS commands
>   IB/mlx5: Set uid as part of RQT commands
>   IB/mlx5: Set uid as part of PD commands
>   IB/mlx5: Set uid as part of TD commands
>   IB/mlx5: Set uid as part of SRQ commands
>   IB/mlx5: Set uid as part of DCT commands
>   IB/mlx5: Set uid as part of XRCD commands
>   IB/mlx5: Set uid as part of MCG commands
>   IB/mlx5: Set valid umem bit on DEVX
>   IB/mlx5: Expose RAW QP device handles to user space
>   IB/mlx5: Manage device uid for DEVX white list commands
>   IB/mlx5: Enable DEVX white list commands
>   IB/mlx5: Enable DEVX on IB
>
>  drivers/infiniband/hw/mlx5/cmd.c              | 129 ++++++++++++++++++
>  drivers/infiniband/hw/mlx5/cmd.h              |  14 ++
>  drivers/infiniband/hw/mlx5/cq.c               |   1 +
>  drivers/infiniband/hw/mlx5/devx.c             | 182 +++++++++++++++++++++++---
>  drivers/infiniband/hw/mlx5/main.c             |  80 +++++++----
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  15 +--
>  drivers/infiniband/hw/mlx5/qp.c               | 141 +++++++++++++++-----
>  drivers/infiniband/hw/mlx5/srq.c              |   1 +
>  drivers/net/ethernet/mellanox/mlx5/core/cq.c  |   4 +
>  drivers/net/ethernet/mellanox/mlx5/core/qp.c  |  81 ++++++++----
>  drivers/net/ethernet/mellanox/mlx5/core/srq.c |  30 ++++-
>  include/linux/mlx5/cq.h                       |   1 +
>  include/linux/mlx5/driver.h                   |   1 +
>  include/linux/mlx5/mlx5_ifc.h                 | 135 +++++++++++--------
>  include/linux/mlx5/qp.h                       |   1 +
>  include/linux/mlx5/srq.h                      |   1 +
>  include/uapi/rdma/mlx5-abi.h                  |  13 ++
>  17 files changed, 657 insertions(+), 173 deletions(-)
>
> --
> 2.14.4
>

--9sSKoi6Rw660DLir
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJboAHCAAoJEORje4g2clinMtsQAJqlZ+9fTKsM4Cc0dweyNQOw
VNw6J5ynSCl45rq4JPSD7XrLxDB/1mJ9SOESdQ96ByLjFGF4dvJdy3zCM1ufy/Li
3T8/1p0kxWw4PJ0G5kw2AG6Yl0GfiGH5u+GluWYtZPD++iPDQQF2MIF7MmM/EXOR
ZLnkMEKFA1/PBIQE3sfpid1kFqAALqd+IyOqXzgwSTDBr4GOMTkC2FrwkPgMmBVk
CsN89BlnH+SJ+EtOYrviqkXg/e3e8/StpI99ASbOrCUL12dLdxUHMgYlF5Umx/hv
c6hCnQZ0uPpnKhsahWR+WCtWTC5VNtp//xQXpAEfRpNWZpFPtDT8vbrhiQRXgNq/
IL5EnJc8MGJ0sGc1SpCBITntWygbf1my45WogsF6Cy3fILlAOGKTf5WBPQWsnvIB
/ayshU+wk2Y+2Hb1nPQJ61CBq8Cx/+RuzXz0AgmrlVxAyiimWFhtp1FTM0Ohkl5U
XXmaRpUcxMkowb6UdpIKY8Q52P4rwIoKl/iIPMdI4z9advDWiQzqEAK8+Du8lYBV
PFLdIX4JVuuNhtlHG4DLQgtnZV4UKTR/BSwdbM85vMwED22I5RN8Kj0Hj0hJ9s88
gBIAKtOq8VloJnrJOURDl1fWjjKcc+0+1GhlHuAf5pw65DmKpbg8uQsjC7njEvlp
JaI6PHWTQI88lwtbzg1j
=Fe0A
-----END PGP SIGNATURE-----

--9sSKoi6Rw660DLir--
