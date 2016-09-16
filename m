From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 16 Sep 2016 16:19:46 -0400
Message-ID: <e3d11140-72ac-ca99-2dac-d3cc520f1cf0@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gHhRCw78LP0dGrrvfjpEtHkp93ijPUKg4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gHhRCw78LP0dGrrvfjpEtHkp93ijPUKg4
Content-Type: multipart/mixed; boundary="gj5voRBCA4BwAD2qFoQgqlwHnOVIAtlCF";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <e3d11140-72ac-ca99-2dac-d3cc520f1cf0-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git

--gj5voRBCA4BwAD2qFoQgqlwHnOVIAtlCF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is likely the last rdma pull request this cycle.  The new rxe
driver had a few issues (you probably saw the boot bot bug report) and
they should be addressed now.  There are a couple other fixes here,
mainly mlx4.  There are still two outstanding issues that need resolved
but I don't think their fix will make this kernel cycle.

Here's the boilerplate:

The following changes since commit 16170d9c102764f76c58aad244e947f4e3f445=
90:

  IB/hfi1: Rework debugfs to use SRCU (2016-09-02 14:26:55 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to e4618d40eb3dc1a6d1f55f7150ea25bb23ab410a:

  IB/rdmavt: Don't vfree a kzalloc'ed memory region (2016-09-16 14:14:23
-0400)

----------------------------------------------------------------
Round three of 4.8 rc fixes

- Various fixes to rdmavt, ipoib, mlx5, mlx4, rxe

----------------------------------------------------------------
Alex Vesker (2):
      IB/ipoib: Don't allow MC joins during light MC flush
      IB/mlx4: Fix incorrect MC join state bit-masking on SR-IOV

Alexey Khoroshilov (1):
      IB/rxe: fix GFP_KERNEL in spinlock context

Colin Ian King (1):
      IB/rdmavt: Don't vfree a kzalloc'ed memory region

Jack Morgenstein (2):
      IB/mlx4: Fix code indentation in QP1 MAD flow
      IB/mlx4: Use correct subnet-prefix in QP1 mads under SR-IOV

Kamal Heib (1):
      IB/mlx4: Diagnostic HW counters are not supported in slave mode

Maor Gottlieb (1):
      IB/mlx5: Set source mac address in FTE

Noa Osherovich (1):
      IB/mlx5: Enable MAD_IFC commands for IB ports only

Yonatan Cohen (4):
      IB/rxe: Fix kernel panic in udp_setup_tunnel
      IB/rxe: Fix duplicate atomic request handling
      IB/rxe: Fix race condition between requester and completer
      IB/rxe: Fix kmem_cache leak

 drivers/infiniband/hw/mlx4/mad.c        | 23 +++++++++++++
 drivers/infiniband/hw/mlx4/main.c       |  3 ++
 drivers/infiniband/hw/mlx4/mcg.c        | 14 ++++----
 drivers/infiniband/hw/mlx4/mlx4_ib.h    |  2 +-
 drivers/infiniband/hw/mlx4/qp.c         | 37 +++++++++++----------
 drivers/infiniband/hw/mlx5/main.c       | 11 ++++++-
 drivers/infiniband/sw/rdmavt/mr.c       |  2 +-
 drivers/infiniband/sw/rxe/rxe.c         | 25 +++++++++++++--
 drivers/infiniband/sw/rxe/rxe_comp.c    | 13 ++++++++
 drivers/infiniband/sw/rxe/rxe_net.c     | 55
+++++++++++++++----------------
 drivers/infiniband/sw/rxe/rxe_net.h     |  5 ++-
 drivers/infiniband/sw/rxe/rxe_recv.c    |  2 +-
 drivers/infiniband/sw/rxe/rxe_req.c     | 57
+++++++++++++++++++++++++--------
 drivers/infiniband/sw/rxe/rxe_resp.c    | 11 ++++---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |  9 ++++++
 15 files changed, 189 insertions(+), 80 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--gj5voRBCA4BwAD2qFoQgqlwHnOVIAtlCF--

--gHhRCw78LP0dGrrvfjpEtHkp93ijPUKg4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX3FPiAAoJELgmozMOVy/dIosP/jC0+JOGkQPZFEBAQzFoFisx
X1xaYdOqLV25RfndMIM5AeZ/W3NQ+eJbzYdRmOEpyThfGHG+rBbOt8BgXhaG7Ff6
0uNbTvr8xmGa8ukHJQwWFYcKgv4yl3ZMDvcWIklOlMIv/y8MpmNi62bAK+gLKvSk
GrNEkcWDEtPMLpudnDFY5wqglloXjCOGT+0PeENLZb9p5Y7Dp0YZlluSaKMomdnJ
KFz5QChHN1jkkaZL0yf3JaGAutdijDo7arNTDj866ZfBRRa/SqezXg3Y1gee3rNA
Cr8b3w/WBXuqKk45uR0RKSQu3uwBUDDMBjF8OorMVIymCjiUmg1lqD0MkNqRJQhP
ZUN4ByKbFEXhLMsyOB2vu9tcRcmixDzqY0K+qmK2abJHQkRkgKfht/8tTBHBP9j0
sz0QDVKTsbhRWkr/13DgaP7nvBPfziqZxUHHkXkeQhq2wG4FPAIt+F0OCPZTl48r
Ne13LXzr8/OnbR4vpazP5oQ5bpBTKMdIF66eE+Pcc7acaVAO+OFMyKrsb89Xauax
8GaAVeYEn5qeKubDnQToN25R9eSb8AZ74/fTHocTfsnHHQGq3Rd2bLx8B+vQTts0
+5ckV/6rTLYDmTlCYJJaYEbx07iUfeTF6iWtlKrHb1qKlqhHZYIdnaUCwNmUT/eY
pVb/Jb07FxlGTMtGlF2/
=YMlu
-----END PGP SIGNATURE-----

--gHhRCw78LP0dGrrvfjpEtHkp93ijPUKg4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
