From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 28 Apr 2016 23:05:42 -0400
Message-ID: <5722CF86.80705@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JwoD4fxlBn1tOIKFteVOHdSRnwVwCfTGx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JwoD4fxlBn1tOIKFteVOHdSRnwVwCfTGx
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I've collected up a number of patches that are all pretty small with the
exception of only a couple.  The hfi1 driver has a number of important
patches, and it is what really drives the line count of this pull
request up.  These are all small and I've got this kernel built and
running in the test lab (I have most of the hardware, I think nes is the
only thing in this patch set that I can't say I've personally tested and
have up and running).  This also includes the patch for the security
issue which I was intentionally holding on to and not intending to send
until the very last minute, but since you said this might be the last
-rc cycle, that seems like it might well be now.

Here's the boilerplate:

The following changes since commit 2fe7857176ad6b70e8b2a318506525410e774f=
34:

  i40iw: avoid potential uninitialized variable use (2016-04-06 10:37:16
-0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 4c8bb95921e9ac01b9dd0c3abbaf6514ce88af92:

  RDMA/nes: don't leak skb if carrier down (2016-04-28 21:11:09 -0400)

----------------------------------------------------------------
Final set of -rc fixes for 4.6

- A number of collected fixes for oopses, memory corruptions, deadlocks,
  etc.  All of these fixes are small (many only 5-10 lines), obvious,
  and tested.
- Fix for the security issue related to the use of write for
  bi-directional communications.

----------------------------------------------------------------
Dean Luick (1):
      IB/hfi1: Use kernel default llseek for ui device

Doug Ledford (1):
      IB/core: Fix oops in ib_cache_gid_set_default_gid

Florian Westphal (1):
      RDMA/nes: don't leak skb if carrier down

Hariprasad S (1):
      RDMA/iw_cxgb4: Fix bar2 virt addr calculation for T4 chips

Jason Gunthorpe (1):
      IB/security: Restrict use of the write() interface

Jubin John (1):
      IB/rdmavt: Fix send scheduling

Mike Marciniszyn (1):
      IB/hfi1: Fix missing lock/unlock in verbs drain callback

Mitko Haralanov (4):
      IB/hfi1: Prevent NULL pointer deferences in caching code
      IB/hfi1: Fix deadlock caused by locking with wrong scope
      IB/hfi1: Prevent unpinning of wrong pages
      IB/hfi1: Don't attempt to free resources if initialization failed

Sagi Grimberg (3):
      IB/core: Don't drain non-existent rq queue-pair
      IB/mlx5: Expose correct max_sge_rd limit
      MAINTAINERS: Update iser/isert maintainer contact info

Steve Wise (3):
      iw_cxgb4: initialize ibdev.iwcm->ifname for port mapping
      iw_cxgb3: initialize ibdev.iwcm->ifname for port mapping
      iw_cxgb4: handle draining an idle qp

 MAINTAINERS                                 |  4 +-
 drivers/infiniband/core/cache.c             |  3 +-
 drivers/infiniband/core/ucm.c               |  4 ++
 drivers/infiniband/core/ucma.c              |  3 +
 drivers/infiniband/core/uverbs_main.c       |  5 ++
 drivers/infiniband/core/verbs.c             |  3 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c |  2 +
 drivers/infiniband/hw/cxgb4/cq.c            |  2 +-
 drivers/infiniband/hw/cxgb4/provider.c      |  2 +
 drivers/infiniband/hw/cxgb4/qp.c            | 24 +++++++-
 drivers/infiniband/hw/mlx5/main.c           |  2 +-
 drivers/infiniband/hw/nes/nes_nic.c         |  3 -
 drivers/infiniband/hw/qib/qib_file_ops.c    |  5 ++
 drivers/infiniband/sw/rdmavt/qp.c           |  4 +-
 drivers/staging/rdma/hfi1/TODO              |  2 +-
 drivers/staging/rdma/hfi1/file_ops.c        | 91
+++++++++++------------------
 drivers/staging/rdma/hfi1/mmu_rb.c          | 40 ++++++++-----
 drivers/staging/rdma/hfi1/mmu_rb.h          |  3 +-
 drivers/staging/rdma/hfi1/qp.c              |  2 +
 drivers/staging/rdma/hfi1/user_exp_rcv.c    | 11 ++--
 drivers/staging/rdma/hfi1/user_sdma.c       | 33 +++++++----
 include/linux/mlx5/device.h                 | 11 ++++
 include/rdma/ib.h                           | 16 +++++
 23 files changed, 173 insertions(+), 102 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--JwoD4fxlBn1tOIKFteVOHdSRnwVwCfTGx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXIs+NAAoJELgmozMOVy/dHKIP/0nb83NAs67/R+IImfLyATk1
lhiSzkyzVCzkf0m3QBVlXeIA4eFpwGrooLc2vj9qnLPIad3ttCuKbzK96vkFi6Dx
ZXCcggt9daUBj4FPfWW0KYByOUhxjJfZlJi4SnI+cCt8eSN25lb1JbNSpTCPdimZ
D7+zgjGfIEGnFYtQGb3NTN8VLvzIQZnpCQWEA86GDxxTcV//Da5UV9DCWw+W9KV+
JP1wIXFpZV1V2nlIthu77AufxmxTEkQdnwwW2GR2s8PQpm7i1W0Z3SHm+buzQmVs
DXaAKn1liPNzkn4OjZOX0jWiGtv6JR1U+WrMw8p6OdLp6isupkp0sqDaY5eqYjX3
ARwHLcEVbwJ8lck6pZhsii3mLMWvBY+8oPuvFCqBI3TS2gksBYEvrGPE8uymmHJw
+sY7KM5qbiTBoJ1SiJvGnuM70Ha9r8+wP0SBZPdF/mZ7mv66tMbRk381X7TEQy32
Mm5zi3TYO61J83Rzesgs5xa0pRmyJX9K8KISkWKk3GvTw0A74jF3b75aFD9hOLFA
BjsZ1XTrGXVkE9p/lOE5zai/xaR9RmEiHXlPt/0WXUjZKlSc//dbMqEEKvhbPuIK
diMmSXYY+o/QbLTWpsSjbPuwLolj7Bze87T3yX+BomwNu0eZtLNx4kKdr7DSaLTi
FC6T7poZGcI+ctlrl6qO
=N+gV
-----END PGP SIGNATURE-----

--JwoD4fxlBn1tOIKFteVOHdSRnwVwCfTGx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
