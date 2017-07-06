From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 06 Jul 2017 09:56:17 -0400
Message-ID: <1499349377.2783.34.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-czg6jQ/BpiFObEUQ7TLP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-czg6jQ/BpiFObEUQ7TLP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is my final pull request for the -rc cycle.  It includes two bugs
against the newly added opa vnic that were found by turning on the
debug kernel options (one sleeping while holding a lock, so a one line
fix where they switched it from GFP_KERNEL allocation to a GFP_ATOMIC
allocation, the other a case where they had an isolated caller of their
code that could call them in an atomic context so they had to switch
their use of a mutex to a spinlock to be safe, so this was considerably
more lines of diff because all uses of that lock had to be switched),
one bug that was discussed with you already about an out of bounds
array access in ib_uverbs_modify_qp and ib_uverbs_create_ah and is only
7 lines of diff, and one fix to an earlier fix in the -rc cycle that
broke hfi1 and qib in regards to IPoIB (this one is, unfortunately,
larger than I would like for a -rc7 submission, but fixing the problem
required that we not treat all devices as though they had allocated a
netdev universally because it isn't true, and it took 70 lines of diff
to resolve the issue, but the final patch has been vetted by Intel and
Mellanox and they've both given their approval to the fix).

Here's the boilerplate:

The following changes since commit
d4702645838c8e04893383b50406249382b4e6bf:

  rdma/cxgb4: Fix memory leaks during module exit (2017-06-14 15:24:50
-0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to
8e959601996dc645f4ed7004482a1667c27deb39:

  IB/core, opa_vnic, hfi1, mlx5: Properly free rdma_netdev (2017-07-05
17:11:00 -0400)

----------------------------------------------------------------
Fixes #3 for 4.12-rc

- 2 Fixes for OPA found by debug kernel
- 1 Fix for user supplied input causing kernel problems
- 1 Fix for the IPoIB fixes submitted around -rc4

----------------------------------------------------------------
Boris Pismenny (1):
      RDMA/uverbs: Check port number supplied by user verbs cmds

Niranjana Vishwanathapura (1):
      IB/core, opa_vnic, hfi1, mlx5: Properly free rdma_netdev

Vishwanathapura, Niranjana (2):
      IB/opa_vnic: Use GFP_ATOMIC while sending trap
      IB/opa_vnic: Use spinlock instead of mutex for stats_lock

 drivers/infiniband/core/uverbs_cmd.c               |  8 +++++++
 drivers/infiniband/hw/hfi1/verbs.c                 |  1 -
 drivers/infiniband/hw/hfi1/vnic.h                  |  1 -
 drivers/infiniband/hw/hfi1/vnic_main.c             | 19 +++++++-------
-
 drivers/infiniband/hw/mlx5/main.c                  | 27
++++++++++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  8 +++----
 drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c |  4 ++--
 .../infiniband/ulp/opa_vnic/opa_vnic_internal.h    |  2 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c  | 16 ++++++-------
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c    |  2 +-
 .../infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c  |  8 +++----
 include/rdma/ib_verbs.h                            |  6 +++--
 12 files changed, 58 insertions(+), 44 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-czg6jQ/BpiFObEUQ7TLP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJIBAABCAAyFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlleQYEUHGRsZWRmb3Jk
QHJlZGhhdC5jb20ACgkQuCajMw5XL90MRhAAkad2zbzjX0jgoVWi188MZBLis0yo
ku3deTK29lYpjXa9OdWEdWsqspZB/cKAobGDTUQJLXmGpXxXM0icmMRQTxZMkI4E
w42vSUhIknJD2ffX5uxTrFOXVcNwdRZCqtcpyxaG6Nd3dXOZPQH61W+BX9kjxeB0
jVIqmq2SmkfexBKkHuVTj3J+hK94xgo6PsOOGc5prc/pxOoOPlsKUx7O4X36mgn7
J8Mn8/muubgUPe9Y4PyAeQW76kaBjla2tJ+0t+J4nasqK1U7aedU/HjlajqYZA4e
bu19TEYLdj5ZgKqXrj89//nNwlT9Ix6rX62KGqpTHKRpiBHI7OdUMkt7kApQ8lzv
ka/KrQ0/KqRBsbA9O6eWpZ63a1cjYBOVLFXUukpsYAoXXqsnL8XpKMWOF0qK0co3
rhVnW50inr46QuCuCyzmFuD6gmpLe4e+BtSuTrzll2aBNN9W3xQIIdyRXSp3PwQu
jfeAkfQl9OWqSWCe1GqPb2OLjq6EwB4c613MRhektIKX4XUiWi6bvzBvklU6Vt0R
jha9n8UoDkss+oZe01kvRe3NEDduce1xp5v7b0N00uMFy/R8i0+deo7KGapYkx6U
8ViEcjJoGSrE77cYCsknB2UVSYQUux427afokPoLmPRTuUCjjk+Zgn02hKVnsbzR
nT+3ieQLsuEwaXA=
=NJr3
-----END PGP SIGNATURE-----

--=-czg6jQ/BpiFObEUQ7TLP--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
