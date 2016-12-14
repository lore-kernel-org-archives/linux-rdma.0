From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/5] Optimize RoCE address handle creation for
 userspace
Date: Wed, 14 Dec 2016 14:08:03 -0500
Message-ID: <030212a5-7a1c-273e-9573-a0f9976034c0@redhat.com>
References: <1479882206-31212-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="G0hcSfMpnQ03tOxpIUqerEkHKgqtSEeE0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479882206-31212-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G0hcSfMpnQ03tOxpIUqerEkHKgqtSEeE0
Content-Type: multipart/mixed; boundary="G8U8ko5JEJkkbUJCmda5OhkV4UO4NutNS";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <030212a5-7a1c-273e-9573-a0f9976034c0-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/5] Optimize RoCE address handle creation for
 userspace
References: <1479882206-31212-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1479882206-31212-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--G8U8ko5JEJkkbUJCmda5OhkV4UO4NutNS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/23/2016 1:23 AM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> Please find below the patchset from Moni.
>=20
> -----------------------------------------------------------------------=
---
> Creating a UD address handler (user or kernel) when link layer is Ether=
net
> requires resolving the remote L3 address (GID) to a L2 address (MAC/VLA=
N).
>=20
> Doing it in kernel is easy with an interface in that the module ib_addr=

> provides. In userspace such an interface does not exist and kernel help=

> is required.
>=20
> Until now the way to resolve GID (which is the remote IP or a function
> of it) to a MAC was with an interface supplied by libnl. The implementa=
tion
> of this interface is heavy and fails on large load of requests to creat=
e an
> address handle.
>=20
> This series of patches is an infrastructure for user drivers that care
> for it to optimize the resolution of L3 to L2 addresses with uverbs
> interface.
> -----------------------------------------------------------------------=
-
>=20
> The patch #3 was originally posted by Knut Omang and Moni extended it t=
o
> support all available drivers along with enhanced commit message. We ar=
e
> sending the same patch as it exists in our review system, but feel free=
 to
> change authorship to Knut if it is matter.
>=20
> Thanks
>=20
> Available in the "topic/create_ah" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/create_ah
>=20
> Moni Shoua (5):
>   IB/core: Enhance ib_resolve_eth_dmac to be usable for creating AH
>   IB/mlx5: Report that device supports user data response in create_ah
>   IB/core: Let the verb create_ah return extended response to user
>   IB/mlx5: Use kernel driver to help userspace create address handle
>   IB/mlx5: Make create/destroy address handle available to userspace
>=20
>  drivers/infiniband/core/core_priv.h          |  3 -
>  drivers/infiniband/core/uverbs_cmd.c         | 19 ++++--
>  drivers/infiniband/core/verbs.c              | 86 ++++++++++++++------=
--------
>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |  3 +-
>  drivers/infiniband/hw/cxgb4/provider.c       |  4 +-
>  drivers/infiniband/hw/hns/hns_roce_ah.c      |  3 +-
>  drivers/infiniband/hw/hns/hns_roce_device.h  |  3 +-
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c    |  4 +-
>  drivers/infiniband/hw/mlx4/ah.c              |  4 +-
>  drivers/infiniband/hw/mlx4/mlx4_ib.h         |  3 +-
>  drivers/infiniband/hw/mlx5/ah.c              | 25 +++++++-
>  drivers/infiniband/hw/mlx5/main.c            |  5 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h         |  3 +-
>  drivers/infiniband/hw/mthca/mthca_provider.c |  4 +-
>  drivers/infiniband/hw/nes/nes_verbs.c        |  3 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |  3 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.h     |  4 +-
>  drivers/infiniband/hw/qedr/verbs.c           |  3 +-
>  drivers/infiniband/hw/qedr/verbs.h           |  3 +-
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  4 +-
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |  4 +-
>  drivers/infiniband/sw/rxe/rxe_verbs.c        |  4 +-
>  include/rdma/ib_verbs.h                      |  6 +-
>  include/uapi/rdma/mlx5-abi.h                 |  7 +++
>  24 files changed, 140 insertions(+), 70 deletions(-)
>=20
> --
> 2.7.4
>=20

Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--G8U8ko5JEJkkbUJCmda5OhkV4UO4NutNS--

--G0hcSfMpnQ03tOxpIUqerEkHKgqtSEeE0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZiTAAoJELgmozMOVy/dPj8QAIYiJBOsf8Ou0Sk3aXvzxHhG
rXk7/5gCp5rcoV8r0ZHVTslG0hk69tGdiqSpFN1q10BPJ65IIxt6Z3BHEM3tJh8t
75CaKyXAQNWtAF23SCMoX+EMtjRLCzulM43zn4tOZRewu9HDefs1kujeQQDxTeQr
RTHtA4qstnJUOWo7A3CgvZ7/12GJs99gF4QoFrxmo0+2qmzkeB9PAYJn7o4usthI
59glsRpF8PfVqNYmKh1TDuawXVSsXiDdCkSsObRVKAvxDD3f35mqEDxJBxJNmEKq
XNP8/+U1YiZMvTbXLsQxGGikMrZeZTIOdnSGq4EG30JFvMplDigO/G7s5/2kA+oo
+AfDgt+IP0rWvaYjoGa11hUYciK8Jip5onfmObuaFTqtQLhP/gjcMZrkIhQzccF4
2hMpZg75P7QhZepUudcBmH+6C6hbavJrZVpmqXsHDpyaJjvScR0JqHeFQh6UWvQO
yuKPFe0CY58eJPr/pSNNFFyB6RAdMw6quq2o2QDDSHGbflB8DRzUSs+PeMY1hcza
owCS6ZrA6DKN4/uIk3MJyZPuCkWYdPzt8n8+oMpOWMBZHwSeViR0DT2zLOoaLlq7
hRaD00uhEQvVQsRfkWP4HKjVEPP5OqzVK8xBHWIM5rxJVmZo+wL5UPxjn8Zmdcg7
x0XEx/4fAl6MtlHkWvtk
=3pGC
-----END PGP SIGNATURE-----

--G0hcSfMpnQ03tOxpIUqerEkHKgqtSEeE0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
