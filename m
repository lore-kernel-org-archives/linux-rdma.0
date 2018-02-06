From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Mon, 05 Feb 2018 19:31:38 -0500
Message-ID: <1517877098.3936.88.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-K9LUorT76l/UQfA1qLYq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-K9LUorT76l/UQfA1qLYq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus (and Dave),

As mentioned before, we had about 30 patches that we were waiting on
resubmissions from people.  Those have all come in.  There was a group
of 13 or so for hfi1, a few for the RDMA core, a 6 patch series for soft
RoCE, a 4 patch series for hns RoCE, and a few other random items.

Items of note:

1) There was a two patch series that came out of a regression in the
4.15 kernel.  The 4.14 kernel worked fine with NVMe over Fabrics and
mlx5 adapters.  That broke in 4.15.  The fix is here.  There were two
patches, one came in first from Sagi so I took his, but Max Gurtovoy
from Mellanox had submitted the same fix as Sagi plus an addition fix
for mlx5 intended to harden it against future issues.  It's his second
patch that is the reason I Cc:ed Dave here, as it touched files in
drivers/net/ instead of drivers/infiniband.  It's just an update to a
single #define value to increase capacity, and was part of that fix, and
Max didn't send it to netdev@ so I assumed he intended me to send it,
but I wanted to make sure it was clear why that is in the diffstat.

2) One of the patches from Lijun looks like a lot of lines of change,
but it's mostly mechanical in nature.  The endian notation patch.  We
sent him back to make some minor changes and those were done today so it
got added to the pull request and amounts to the biggest chunk of change
in it (it's about 2/3rds of the overall pull request).

3) The boilerplate says the starting point is the 4.15 merge tag.=20
That's the same merge of Jason's you pulled the first time, so we just
kept with the same branch for this pull request.

Here's the boilerplate:

The following changes since commit e7996a9a77fc669387da43ff4823b91cc4872bd0=
:

  Merge tag v4.15 of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds=
/linux-2.6.git (2018-01-30 09:30:00 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linu=
s

for you to fetch changes up to 03ecdd2dcf39834ff2b012a8b29168d7076da84a:

  net/mlx5: increase async EQ to avoid EQ overrun (2018-02-05 10:58:25 -050=
0)

----------------------------------------------------------------
Second pull request for 4.16 merge window

- Clean up some function signatures in rxe for clarity
- Tidy the RDMA netlink header to remove unimplemented constants
- bnxt_re driver fixes, one is a regression this window.
- Minor hns driver fixes
- Various fixes from Dan Carpenter and his tool
- Fix IRQ cleanup race in HFI1
- HF1 performance optimizations and a fix to report counters in the right u=
nits
- Fix for an IPoIB startup sequence race with the external manager
- Oops fix for the new kabi path
- Endian cleanups for hns
- Fix for mlx5 related to the new automatic affinity support

----------------------------------------------------------------
Alex Estrin (3):
      IB/hfi1: Fix for early release of sdma context
      IB/hfi1: Fix for potential refcount leak in hfi1_open_file()
      IB/ipoib: Fix for potential no-carrier state

Bartlomiej Dudek (1):
      IB/hfi1: Do not override given pcie_pset value

Dan Carpenter (2):
      RDMA/bnxt_re: Fix an error code in bnxt_qplib_create_srq()
      RDMA/nldev: missing error code in nldev_res_get_doit()

Don Hiatt (2):
      IB/core: Map iWarp AH type to undefined in rdma_ah_find_type
      IB/hfi1: Add 16B rcvhdr trace support

Doug Ledford (1):
      RDMA/bnxt_re: Fix static checker warning

Jason Gunthorpe (2):
      IB: Update references to libibverbs
      IB/uverbs: Use the standard kConfig format for experimental

Kamenee Arumugam (2):
      IB/hfi1: Convert PortXmitWait/PortVLXmitWait counters to flit times
      IB/hfi1: Convert kzalloc_node and kcalloc to use kcalloc_node

Leon Romanovsky (1):
      RDMA/netlink: Hide unimplemented NLDEV commands

Markus Elfring (2):
      RDMA/bnxt_re: Delete two error messages for a failed memory allocatio=
n in bnxt_qplib_alloc_dpi_tbl()
      RDMA/bnxt_re: Use common error handling code in bnxt_qplib_alloc_dpi_=
tbl()

Max Gurtovoy (1):
      net/mlx5: increase async EQ to avoid EQ overrun

Michael J. Ruhl (2):
      IB/hfi1: Re-order IRQ cleanup to address driver cleanup race
      IB/core: Avoid a potential OOPs for an unused optional parameter

Mike Marciniszyn (1):
      IB/hfi1: Remove blind constants from 16B update

Mitko Haralanov (2):
      IB/hfi1: Remove dependence on qp->s_hdrwords
      IB/hfi1: Show fault stats in both TX and RX directions

Sagi Grimberg (1):
      mlx5: fix mlx5_get_vector_affinity to start from completion vector 0

Sebastian Sanchez (5):
      IB/hfi1: Compute BTH only for RDMA_WRITE_LAST/SEND_LAST packet
      IB/hfi1: Optimize packet type comparison using 9B and bypass code pat=
hs
      IB/hfi1: Look up ibport using a pointer in receive path
      IB/hfi1: Remove unnecessary fecn and becn fields
      IB/hfi1: Optimize process_receive_ib()

Zhu Yanjun (6):
      IB/rxe: remove redudant parameter in function
      IB/rxe: change the function to void from int
      IB/rxe: remove unnecessary parameter in rxe_av_to_attr
      IB/rxe: change the function to void from int
      IB/rxe: change the function rxe_av_fill_ip_info to void
      IB/rxe: remove redudant parameter in rxe_av_fill_ip_info

oulijun (4):
      RDMA/hns: Remove unnecessary operator
      RDMA/hns: Add names to function arguments in function pointers
      RDMA/hns: Fix misplaced call to hns_roce_cleanup_hem_table
      RDMA/hns: Fix the endian problem for hns

 Documentation/infiniband/user_verbs.txt      |   2 +-
 MAINTAINERS                                  |   2 +-
 drivers/infiniband/Kconfig                   |   7 +-
 drivers/infiniband/core/nldev.c              |   4 +-
 drivers/infiniband/core/uverbs_std_types.c   |   2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c     |   7 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c     |   4 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c    |  18 +-
 drivers/infiniband/hw/hfi1/chip.c            |  82 ++++++--
 drivers/infiniband/hw/hfi1/chip.h            |   4 +-
 drivers/infiniband/hw/hfi1/debugfs.c         |   9 +-
 drivers/infiniband/hw/hfi1/driver.c          |  51 +++--
 drivers/infiniband/hw/hfi1/file_ops.c        |   4 +-
 drivers/infiniband/hw/hfi1/hfi.h             |  26 +--
 drivers/infiniband/hw/hfi1/init.c            |  31 ++-
 drivers/infiniband/hw/hfi1/iowait.h          |   9 +
 drivers/infiniband/hw/hfi1/mad.c             | 127 +++++++++++-
 drivers/infiniband/hw/hfi1/mad.h             |  47 ++++-
 drivers/infiniband/hw/hfi1/pcie.c            |  23 +--
 drivers/infiniband/hw/hfi1/pio.c             |  15 +-
 drivers/infiniband/hw/hfi1/qp.c              |   4 +-
 drivers/infiniband/hw/hfi1/qp.h              |  13 ++
 drivers/infiniband/hw/hfi1/rc.c              |  51 +++--
 drivers/infiniband/hw/hfi1/ruc.c             |  47 ++---
 drivers/infiniband/hw/hfi1/sdma.c            |  16 +-
 drivers/infiniband/hw/hfi1/sdma.h            |   1 +
 drivers/infiniband/hw/hfi1/trace.c           |   8 +-
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h    |  16 +-
 drivers/infiniband/hw/hfi1/trace_rx.h        |  30 ++-
 drivers/infiniband/hw/hfi1/uc.c              |   9 +-
 drivers/infiniband/hw/hfi1/ud.c              |  39 ++--
 drivers/infiniband/hw/hfi1/verbs.c           |  10 +-
 drivers/infiniband/hw/hfi1/verbs.h           |  24 ++-
 drivers/infiniband/hw/hfi1/verbs_txreq.h     |   7 +
 drivers/infiniband/hw/hns/hns_roce_common.h  |   6 +-
 drivers/infiniband/hw/hns/hns_roce_device.h  |  10 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c   |  60 ++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h   | 258 ++++++++++++-----------=
-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c   |  58 ++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h   | 283 ++++++++++++++---------=
----
 drivers/infiniband/hw/hns/hns_roce_main.c    |   3 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c      |  18 +-
 drivers/infiniband/hw/qib/qib_rc.c           |   3 +-
 drivers/infiniband/hw/qib/qib_uc.c           |   3 +-
 drivers/infiniband/hw/qib/qib_ud.c           |   3 +-
 drivers/infiniband/sw/rxe/rxe_av.c           |  14 +-
 drivers/infiniband/sw/rxe/rxe_loc.h          |  10 +-
 drivers/infiniband/sw/rxe/rxe_qp.c           |  15 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c        |  10 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |   2 +-
 include/linux/mlx5/driver.h                  |   2 +-
 include/rdma/ib_hdrs.h                       |  19 +-
 include/rdma/ib_verbs.h                      |  20 +-
 include/uapi/rdma/rdma_netlink.h             |  14 +-
 55 files changed, 919 insertions(+), 644 deletions(-)


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-K9LUorT76l/UQfA1qLYq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlp492oACgkQuCajMw5X
L91P/Q//QVs43+qiccC4XYVOje+AEnBWFb6M/QaYSFU2WlXmgArkxEv3qSwY0+hD
MAA2qng7zdXFBJ14gZ3VE3anuxQ2heLkFImAak6aHzH0+FgOUH3Id6rV4q7aM3cT
yDDrt1L+CbOB1TJfNEmsqaTrgwRAP80v1vdtWMSE2WIXX/RxobQs1EkeDUHEivl6
j+8Sfuhly6gleNEjRlHwf7ATt0C0WPwyxozPgmsWOgZ7mmTngs5DAYnzGR0SqS0K
Bwy2cZDH/bKkwZyC3/v0g3hjTlfqnxOvS6/ibc8DRWtmZATWpVcI0dIpxN3aAyN8
P9BGQn/2Azo2gpyOnrFgexvyYkQMA4tta8b65UPCR8Gfx2a4ai645c8srSNIoK9e
++qzU/8lzgCtaeuBKEQ43YpQIe7gqlS9Bgw/wxPk+YieEVzGq4WEQx6r5l/IJCSA
pY7PnSvLMvB+O2Rh98mdiQmwEuPzeolCQkOif7iFQAaOtKwcHpHRbVqtVRf3GMbJ
4DgXL/XD0hVSePA25S8AKjzLOtnC3H40LkRDJdMmmI2e+1FpktygfighO8KZIYyn
WWfVLNpwEoArSR2Bp2T9K6fFgSiQ57dh6UjOzl1w89Ne+X+LttDN87Gfby/ngvkF
XtlimHxh/TgzGGX34+hfb8OVzaw1azBfDFCESug36Tz3sDQCgio=
=sG2W
-----END PGP SIGNATURE-----

--=-K9LUorT76l/UQfA1qLYq--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
