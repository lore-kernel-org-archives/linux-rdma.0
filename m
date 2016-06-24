From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 24 Jun 2016 19:12:56 -0400
Message-ID: <26e766ca-e79a-0db2-a81a-754a0a5b7fb9@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HQfctQRFXxMeWJPnXxa6LW9mkfTR5tehL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HQfctQRFXxMeWJPnXxa6LW9mkfTR5tehL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the second batch of queued up rdma patches for this rc cycle.
There isn't anything really major in here.  It's passed 0day,
linux-next, and local testing across a wide variety of hardware.  There
are still a few known issues to be tracked down, but this should amount
to the vast majority of the rdma RC fixes.

Here's the boilerplate:

The following changes since commit 8c5122e45a10a9262f872b53f151a592e870f9=
05:

  IB/mlx4: Properly initialize GRH TClass and FlowLabel in AHs
(2016-06-17 19:36:54 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 9903fd1374e913f5086b58af09d4e3fd6e9e86fe:

  Merge branches '4.7-rc-misc', 'hfi1-fixes', 'i40iw-rc-fixes' and
'mellanox-rc-fixes' into k.o/for-4.7-rc (2016-06-23 12:22:33 -0400)

----------------------------------------------------------------
Round two of 4.7 rc fixes

- A couple minor fixes to the rdma core
- Multiple minor fixes to hfi1
- Multiple minor fixes to mlx4/mlx4
- A few minor fixes to i40iw

----------------------------------------------------------------
Alex Vesker (1):
      IB/core: Fix RoCE v1 multicast join logic issue

Ashutosh Dixit (1):
      IB/hfi1: Don't zero out qp->s_ack_queue in rvt_reset_qp

Bart Van Assche (2):
      IB/cma: Make the code easier to verify
      IB/srpt: Reduce QP buffer size

Brian Welty (2):
      IB/rdmavt: Correct required callback functions for MODIFY_QP
      IB/rdmavt: Correct warning during QPN allocation

Chuck Lever (1):
      IB/mlx4: Prevent cross page boundary allocation

Dotan Barak (1):
      IB/mlx4: Fix memory leak if QP creation failed

Doug Ledford (1):
      Merge branches '4.7-rc-misc', 'hfi1-fixes', 'i40iw-rc-fixes' and
'mellanox-rc-fixes' into k.o/for-4.7-rc

Eli Cohen (2):
      IB/core: Fix false search of the IB_SA_WELL_KNOWN_GUID
      IB/mlx5: Fix post send fence logic

Faisal Latif (2):
      i40iw: Correct status check on i40iw_get_pble
      i40iw: Return correct max_fast_reg_page_list_len

Ira Weiny (2):
      IB/hfi1: Prevent context loss
      IB/qib: Prevent context loss

Jubin John (2):
      IB/hfi1: Fix credit return threshold adjustment
      IB/hfi1: Increase packet egress timeout

Maor Gottlieb (1):
      IB/uverbs: Initialize ib_qp_init_attr with zeros

Mike Marciniszyn (2):
      IB/hfi1: Fix deadlock with txreq allocation slow path
      IB/rdmavt: Correct qp_priv_alloc() return value test

Sebastian Sanchez (2):
      IB/hfi1: Remove FULL_MGMT_P_KEY from pkey table at link up
      IB/hfi1: Send a pkey change event on driver pkey update

Shiraz Saleem (2):
      i40iw: Correct CQ arming
      i40iw: Enable level-1 PBL for fast memory registration

Tadeusz Struk (2):
      IB/hfi1: Fix potential NULL ptr dereference
      IB/hfi1: Fix potential buffer overflow

Talat Batheesh (2):
      IB/core: Fix no default GIDs when netdevice reregisters
      IB/mlx5: Fix wrong naming of port_rcv_data counter

Yishai Hadas (3):
      IB/mlx4: Fix the SQ size of an RC QP
      IB/mlx4: Fix error flow when sending mads under SRIOV
      IB/mlx4: Verify port number in flow steering create flow

 drivers/infiniband/core/cache.c           |  4 +-
 drivers/infiniband/core/cma.c             | 62
+++++++++++++++----------------
 drivers/infiniband/core/uverbs_cmd.c      |  2 +-
 drivers/infiniband/core/verbs.c           | 16 +++++---
 drivers/infiniband/hw/hfi1/chip.c         | 28 ++++++++++----
 drivers/infiniband/hw/hfi1/file_ops.c     |  3 ++
 drivers/infiniband/hw/hfi1/init.c         |  2 +-
 drivers/infiniband/hw/hfi1/mad.c          | 19 ++++++----
 drivers/infiniband/hw/hfi1/mad.h          |  2 +
 drivers/infiniband/hw/hfi1/pio.c          | 26 +++++++++++--
 drivers/infiniband/hw/hfi1/qsfp.c         |  3 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.c  |  4 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.h  |  1 +
 drivers/infiniband/hw/i40iw/i40iw.h       |  2 +
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 17 +++++++--
 drivers/infiniband/hw/mlx4/mad.c          | 24 +++++++++---
 drivers/infiniband/hw/mlx4/main.c         |  3 ++
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |  2 +-
 drivers/infiniband/hw/mlx4/mr.c           | 34 ++++++++---------
 drivers/infiniband/hw/mlx4/qp.c           |  6 ++-
 drivers/infiniband/hw/mlx5/mad.c          |  2 +-
 drivers/infiniband/hw/mlx5/qp.c           |  7 ++--
 drivers/infiniband/hw/qib/qib_file_ops.c  |  5 +++
 drivers/infiniband/sw/rdmavt/qp.c         | 14 +++----
 drivers/infiniband/sw/rdmavt/vt.c         |  4 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c     |  3 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h     |  1 +
 include/linux/mlx5/qp.h                   |  1 +
 include/rdma/rdma_vt.h                    |  4 +-
 29 files changed, 189 insertions(+), 112 deletions(-)


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--HQfctQRFXxMeWJPnXxa6LW9mkfTR5tehL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXbb55AAoJELgmozMOVy/dD8AP/2PuZ8p5GYiZ1vDPtqSpZ1An
C16YT2gvRmVr9/pJnbss3hthM6+YuZB3T8VTxqN7xS1v0UIs6UQ09ArT5W/1n/aQ
S4SEexU/kRG7jwm3//W8usrFuIy9DRyjOeF2H5eK4jbVwiy/VX88L6YMOdgPu2aH
U4cfx91YHuR2a1UZOPa+vw1FYFApn/olKW7HchsePPRNnG6V33CErszLRr4WOoma
hy2Bo/VfPssSMCF2j2dIZ5grrOzkhjVRgFz9SAXaw955KA405Q2N+GUXyZcvNTyL
JnIaNcMljtu9hZ0HrRR4tOgHxG3mtBTp/5j4U2nyk5N7Kx8xnj6i9jRS8ffUqFXO
4m7yChiRhh9rl2IhNOk18lxKXk0rW9YNvbIgb4oOF/jJ4cXOhaKuumlYG/QEjn07
0IbBLnJkH+ZflLQiPGr1ctbnnGoFSeCv08EuSVbH5oBRuwYMZcu0Lv/o170cRCK6
6ETl7pHMr12nYFV+Pt/wgdF2ONMjqwz6WVUCdjyNXJlW7LnpGTE1dWdwBl4GJEQo
IVZhDXdIbNnYHYpdHDxGEUdOkOEX6AFdJc0demMstcIlUQTwyCaCX1ik91hdsNw5
PIVP72yGMXaLrkEvWk4xh98JUuv+qQ9viIQWMFWqtPCEODGA4D37yT5DtKk83LZT
iZqUN8aWnW9IcgeKHB30
=sngq
-----END PGP SIGNATURE-----

--HQfctQRFXxMeWJPnXxa6LW9mkfTR5tehL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
