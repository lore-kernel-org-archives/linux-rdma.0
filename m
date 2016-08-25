From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 25 Aug 2016 15:29:12 -0400
Message-ID: <e5da14cf-fd5a-895e-5fad-9020b6a7efb1@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GJ6vx5St9bF0qdLXLCgct1DdQXJoD9q5A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GJ6vx5St9bF0qdLXLCgct1DdQXJoD9q5A
Content-Type: multipart/mixed; boundary="JUro59l9X1FDN01WrdCt1FUtA5f3rJSg2"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <e5da14cf-fd5a-895e-5fad-9020b6a7efb1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git

--JUro59l9X1FDN01WrdCt1FUtA5f3rJSg2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This should be the bulk of the -rc fixes for 4.8.  I only have a few
things that are still outstanding (two ipoib bugs for which the solution
is not yet fully known, and a few queued items that came in after my
last push and I didn't want to delay this pull request for late comers
again).  There shouldn't be any merge issues at all.  Even though the
patch count is kind of high, everything is minor fixes so the overall
churn is pretty low.

Here's the boilerplate:

The following changes since commit fa8410b355251fd30341662a40ac6b22d3e384=
68:

  Linux 4.8-rc3 (2016-08-21 16:14:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 049b1e7c7e5c21bbb64dc3fc10bb0c53f30b0b70:

  Merge branch 'misc-fixes' into k.o/for-4.8-rc (2016-08-25 11:17:10 -040=
0)

----------------------------------------------------------------
Round one of 4.8 rc fixes

- Minor fixes to cxgb4
- Minor fixes to mlx4
- One minor fix each to core, rxe, isert, srpt, mlx5, ocrdma, and usnic
- Six or so fixes to i40iw fixes
- The rest are hfi1 fixes

----------------------------------------------------------------
Bharat Potnuri (1):
      iw_cxgb4: Fix cxgb4 arm CQ logic w/IB_CQ_REPORT_MISSED_EVENTS

Chris Wilson (1):
      IB/mlx5: Remove superfluous include of io-mapping.h

Christophe Jaillet (2):
      IB/hfi1: Add missing error code assignment before test
      IB/usnic: Fix error return code

Doug Ledford (2):
      IB/srpt: Update sport->port_guid with each port refresh
      Merge branch 'misc-fixes' into k.o/for-4.8-rc

Easwar Hariharan (2):
      IB/hfi1: Fetch monitor values on-demand for CableInfo query
      IB/hfi1: Return invalid field for non-QSFP CableInfo queries

Ira Weiny (1):
      IB/hfi1: Fix mm_struct use after free

Leon Romanovsky (1):
      MAINTAINERS: Fix Soft RoCE location

Markus Elfring (2):
      IB/qib: Use memdup_user() rather than duplicating its implementatio=
n
      IB/core: Use memdup_user() rather than duplicating its implementati=
on

Mike Marciniszyn (4):
      IB/hfi1,IB/qib: Fix qp_stats sleep with rcu read lock held
      IB/hfi1: Pass packet ptr to set_armed_active
      IB/hfi1: Validate header in set_armed_active
      IB/rdmvat: Fix double vfree() in rvt_create_qp() error path

Mitko Haralanov (1):
      IB/hfi1: Improve J_KEY generation

Mustafa Ismail (5):
      i40iw: Protect req_resource_num update
      i40iw: Add missing check for interface already open
      i40iw: Do not set self-referencing pointer to NULL after kfree
      i40iw: Fix double free of allocated_buffer
      i40iw: Avoid writing to freed memory

Selvin Xavier (1):
      RDMA/ocrdma: Fix the max_sge reported from FW

Shiraz Saleem (2):
      i40iw: Change mem_resources pointer to a u8
      i40iw: Add missing NULL check for MPA private data

Steve Wise (2):
      iw_cxgb4: limit IRD/ORD advertised to ULP by device max.
      iw_cxgb4: use the MPA initiator's IRD if < our ORD

Tadeusz Struk (1):
      IB/hfi1: Allocate cpu mask on the heap to silence warning

Tatyana Nikolova (1):
      i40iw: Send last streaming mode message for loopback connections

Wei Yongjun (4):
      IB/core: Fix possible memory leak in cma_resolve_iboe_route()
      IB/isert: fix error return code in isert_alloc_login_buf()
      IB/hfi1: Remove duplicated include from affinity.c
      IB/hfi1: Using kfree_rcu() to simplify the code

Yuval Shaia (2):
      IB/mlx4: Make function use_tunnel_data return void
      IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one

 MAINTAINERS                                 |  2 +-
 drivers/infiniband/core/cma.c               | 18 ++++++++++------
 drivers/infiniband/hw/cxgb4/cm.c            |  6 +++++-
 drivers/infiniband/hw/cxgb4/cq.c            | 10 ++++-----
 drivers/infiniband/hw/cxgb4/t4.h            |  5 +++++
 drivers/infiniband/hw/hfi1/affinity.c       | 21 +++++++++++--------
 drivers/infiniband/hw/hfi1/debugfs.c        | 14 ++++++++-----
 drivers/infiniband/hw/hfi1/driver.c         | 11 +++++-----
 drivers/infiniband/hw/hfi1/file_ops.c       |  4 +++-
 drivers/infiniband/hw/hfi1/hfi.h            | 20 ++++++++++++++++--
 drivers/infiniband/hw/hfi1/init.c           |  2 +-
 drivers/infiniband/hw/hfi1/mad.c            | 14 ++++++-------
 drivers/infiniband/hw/hfi1/qp.c             |  4 ----
 drivers/infiniband/hw/hfi1/qsfp.c           | 32
+++++++++++++++++++++++++++--
 drivers/infiniband/hw/hfi1/qsfp.h           |  3 +++
 drivers/infiniband/hw/i40iw/i40iw.h         |  4 ++--
 drivers/infiniband/hw/i40iw/i40iw_cm.c      | 26 +++--------------------=

 drivers/infiniband/hw/i40iw/i40iw_main.c    |  4 ++++
 drivers/infiniband/hw/i40iw/i40iw_utils.c   |  5 ++++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c   |  4 +---
 drivers/infiniband/hw/mlx4/cq.c             | 20 +++++++++---------
 drivers/infiniband/hw/mlx5/main.c           |  1 -
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 14 ++++++-------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 12 +++++++----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  4 ++--
 drivers/infiniband/hw/qib/qib_debugfs.c     | 12 ++++++++---
 drivers/infiniband/hw/qib/qib_fs.c          | 26 +++++------------------=

 drivers/infiniband/hw/qib/qib_qp.c          |  4 ----
 drivers/infiniband/hw/usnic/usnic_ib_main.c |  3 ++-
 drivers/infiniband/sw/rdmavt/qp.c           |  3 ++-
 drivers/infiniband/ulp/isert/ib_isert.c     |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c       |  9 ++++----
 include/rdma/ib_verbs.h                     | 11 +++-------
 33 files changed, 185 insertions(+), 145 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--JUro59l9X1FDN01WrdCt1FUtA5f3rJSg2--

--GJ6vx5St9bF0qdLXLCgct1DdQXJoD9q5A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXv0cIAAoJELgmozMOVy/d3hkQAJnafDNMXJE5gHAKP5R4q03d
T8DcS/f+UycdODkfBLGNzq3mp/g8f2S8H2k0Yvh2PaNgUCdK4PggQyvd8zLjt3RE
JzAs9tQf1rV1vCLGmLQAgiYYUpvbBL49ijWZz4suahVBeRBA6V9vgwDlTq48nAS2
y1ltn+K4hvfz0wSkhjUK9jmHwt9/ys8idr3IjPyxzVe+bdJa5uqwBjuNNL0xxfpR
Sz9u81u+WDhKJiR4Vzi8dg/xWo1XixOhAxz42PQiRE3MZ9rBvdh/ebXIoCGSXMhT
23rA495IPss4Dg5bG2b+eNkKEhGuNsShZbqBvwrytlWHHFy6n3KvP93EfyrXm4HE
aw4vwrlKPCerrD0cCgnQGoimzlYWkBurix5IVf5LxxmACTZ4gnJ4kQqQdsC9ez2E
cGj782Gc+v+m5Q+x6jStnbIv863eIOVgLmO8VOVCUkq0xyKd+qoxsS2OxWRte7ZB
jc1xxoYR7iEO00vA6eUKOt67LfKwS3L5wA2C4tQoGBqEOonRPv4wcinK2nDXhR0B
s2Fe/2J+dnxE3h0JW0BBDa2V855fLmVbAmcxiCD42h2i97EI1OD9+mCi+3xGoyMN
TIdKFngrZXuCyFMS9y8/HA6OtFgVwWOnvFbEgJef8HhyHj1d6XFriCwlEiEF1rmh
Ti94sxtpZs9cxoCuEIEq
=I54w
-----END PGP SIGNATURE-----

--GJ6vx5St9bF0qdLXLCgct1DdQXJoD9q5A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
