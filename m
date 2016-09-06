From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Tue, 6 Sep 2016 14:09:37 -0400
Message-ID: <b0a535aa-c2c7-9541-0109-6c966003c04f@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="x6o4hrgFNUMIFJEAsxwt7FsEAjATIuRIG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x6o4hrgFNUMIFJEAsxwt7FsEAjATIuRIG
Content-Type: multipart/mixed; boundary="AhbPqe2lgvqbtFwOfQH7EXTjJ42pQCn13";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <b0a535aa-c2c7-9541-0109-6c966003c04f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git

--AhbPqe2lgvqbtFwOfQH7EXTjJ42pQCn13
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the second pull request for the rdma subsystem.  Most of the
patches are small and obvious.  I took two patches in that are larger
than I wanted this late in the cycle.

The first is the hfi1 patch that implements a work queue to test the
QSFP read state.  I originally rejected the first patch for this (which
would have place up to 20 seconds worth of udelays in their probe
routine).  They then rewrote it the way I wanted (use delayed work tasks
to wait asynchronously up to 20 seconds for the QSFP to come alive), so
I can't really complain about the size of getting what I asked for :-/.

The second is large because it switches the rcu locking in the debugfs
code.  Since a locking change like this is done all at once, the size it
what it is.  It resolves a litany of debug messages from the kernel, so
I pulled it in for -rc.

The rest are all typical -rc worthy patches I think.

There will still be a third -rc pull request from the rdma subsystem
this release.  I hope to have that one ready to go by the end of this
week or early next.

Here's the boilerplate:

The following changes since commit 049b1e7c7e5c21bbb64dc3fc10bb0c53f30b0b=
70:

  Merge branch 'misc-fixes' into k.o/for-4.8-rc (2016-08-25 11:17:10 -040=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 16170d9c102764f76c58aad244e947f4e3f44590:

  IB/hfi1: Rework debugfs to use SRCU (2016-09-02 14:26:55 -0400)

----------------------------------------------------------------
Round two of 4.8 rc fixes

- A smattering of small fixes across the core, ipoib, i40iw, isert, cxgb4=
,
  and mlx4
- A slightly larger group of fixes to each of mlx5 and hfi1

----------------------------------------------------------------
Baoyou Xie (1):
      IB/cxgb4: Make _free_qp static to silence build warning

Christophe Jaillet (3):
      IB/hfi1: Clean up type used and casting
      IB/mlx5: Fix the size parameter to find_first_bit
      IB/hfi1: Fix the size parameter to find_first_bit

Chuck Lever (1):
      IB/mlx5: Return EINVAL when caller specifies too many SGEs

Dean Luick (1):
      IB/hfi1: Add QSFP sanity pre-check

Erez Shitrit (2):
      IB/core: Fix use after free in send_leave function
      IB/ipoib: Fix memory corruption in ipoib cm mode connect flow

Harish Chegondi (1):
      IB/hfi1: Make n_krcvqs be an unsigned long integer

Jubin John (1):
      IB/hfi1: Fix AHG KDETH Intr shift

Leon Romanovsky (4):
      Revert "IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one"
      IB/mlx4: Don't return errors from poll_cq
      IB/mlx5: Simplify code by removing return variable
      IB/mlx5: Don't return errors from poll_cq

Mike Marciniszyn (1):
      IB/hfi1: Rework debugfs to use SRCU

Mustafa Ismail (1):
      i40iw: Update hw_iwarp_state

Raju Rangoju (1):
      IB/isert: Properly release resources on DEVICE_REMOVAL

Sebastian Sanchez (1):
      IB/hfi1: Fix SGE length for misaligned PIO copy

Shiraz Saleem (1):
      i40iw: Receive notification events correctly

Yishai Hadas (1):
      IB/mlx5: Use TIR number based on selector

 drivers/infiniband/core/multicast.c       |  13 +--
 drivers/infiniband/hw/cxgb4/qp.c          |   2 +-
 drivers/infiniband/hw/hfi1/chip.c         |  92 ++++++++++++++++++---
 drivers/infiniband/hw/hfi1/chip.h         |   1 +
 drivers/infiniband/hw/hfi1/debugfs.c      | 132
++++++++++++------------------
 drivers/infiniband/hw/hfi1/hfi.h          |   4 +-
 drivers/infiniband/hw/hfi1/init.c         |   3 +-
 drivers/infiniband/hw/hfi1/mad.c          |  12 +--
 drivers/infiniband/hw/hfi1/pio_copy.c     |  12 +++
 drivers/infiniband/hw/hfi1/user_sdma.c    |   5 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c    |   1 +
 drivers/infiniband/hw/i40iw/i40iw_main.c  |   8 +-
 drivers/infiniband/hw/mlx4/cq.c           |  26 +-----
 drivers/infiniband/hw/mlx5/cq.c           |  22 +----
 drivers/infiniband/hw/mlx5/main.c         |   6 +-
 drivers/infiniband/hw/mlx5/mem.c          |   6 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h      |   1 +
 drivers/infiniband/hw/mlx5/qp.c           |  13 ++-
 drivers/infiniband/ulp/ipoib/ipoib.h      |   1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  16 ++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   2 +-
 drivers/infiniband/ulp/isert/ib_isert.c   |  23 +++++-
 drivers/infiniband/ulp/isert/ib_isert.h   |   2 +
 23 files changed, 226 insertions(+), 177 deletions(-)


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--AhbPqe2lgvqbtFwOfQH7EXTjJ42pQCn13--

--x6o4hrgFNUMIFJEAsxwt7FsEAjATIuRIG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXzwZhAAoJELgmozMOVy/dQmQP/2Nb+q33u7J5DtEwr72a/3B2
kOs8jd5AVWhYETqjUuL1ie2SXWpQWp+k+vnhPqNxUxQ65loJ5BoWhsnXASxy2qj5
SL28kPLRQEaPTsMfYTz+KAfPxbAb031VTRZlY0b+3OgUNYpcuMSQXWQxczvn+bTH
0gYFB75ZLKJqhSyWgCFV9IEhZbB5d7xi+UVwsK+bTaMu89djBsnufU67aXldQuhs
rx6dvLsISVSAMXH+vDuqQWOs/fJr+GsriI5J9LmuyOj2ZBkiyEyNGVfb0N3akctw
brJa0i4FYgLTJ18dlfDhNWPf1cf9dJwydxTT+/QAu3zlpSqKSTxj5LaZpcs1Fgat
IWaBb9gmxB80e85WwWliZdMkUl9NqK99xgidAypskEKFCKjYbywXXH6IBlriJNmY
7Opu/fEuY/AHeBYA5UVm0OYex43tfpSytvFAJrdJps2p20y1tm3WAI9sD+sCJijc
LZNV3OSZaVV3hT6vvjJV+xnI9zU1KGD3iRvu6Z+TC0Vmb/2aycXWI+EpDjm9bNi3
Rm4KcG92YQpfcyGfWjiaFpG/71rT1eKTtYfKbpbxnIiINhJ8b2vkxRPgYNengNi4
cbzTWSFS3Sl9Re8XgUPUCiExUQBse9MfPNChYXjalXLikEKEVWvTQ1WYcHNrgAZy
B5yd8QAKs+HnGAsYOeba
=VS6J
-----END PGP SIGNATURE-----

--x6o4hrgFNUMIFJEAsxwt7FsEAjATIuRIG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
