From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Wed, 14 Oct 2015 15:08:21 -0400
Message-ID: <561EA825.2080300@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DDeVvrXISMKuE641gQo9bWwspvt3EkKUQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DDeVvrXISMKuE641gQo9bWwspvt3EkKUQ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

We have four batched up patches for the current rc kernel.

Two of them are small fixes that are obvious.

One of them is larger than I would like for a late stage rc pull, but we
found an issue in the namespace lookup code related to RoCE and this
works around the issue for now (we allow a lookup with a namespace to
succeed on RoCE since RoCE namespaces aren't implemented yet).  This
will go away in 4.4 when we put in support for namespaces in RoCE devices=
=2E

The last one is large in terms of lines, but is all legal and no
functional changes.  Cisco needed to update their files to be more
specific about their license.  They had intended the files to be dual
licensed as GPL/BSD all along, and specified that in their module
license tag, but their file headers were not up to par.  They contacted
all of the contributors to get agreement and then submitted a patch to
update the license headers in the files.

Thanks!

The following changes since commit 2866196f294954ce9fa226825c8c1eaa64c7da=
8a:

  IB/ipoib: increase the max mcast backlog queue (2015-09-25 22:30:24 -04=
00)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 0b5c9279e568d90903acedc2b9b832d8d78e8288:

  IB/ipoib: For sendonly join free the multicast group on leave
(2015-10-13 16:4
3:59 -0400)

----------------------------------------------------------------
Changes for 4.3-rc5

- Work around connection namespace lookup bug related to RoCE
- Change usnic license to Dual GPL/BSD (was intended to be that way
  all along, but wasn't clear, permission from contributors was
  chased down)
- Fix an issue between NFSoRDMA and mlx5 that could cause an oops
- Fix leak of sendonly multicast groups

----------------------------------------------------------------
Christoph Lameter (1):
      IB/ipoib: For sendonly join free the multicast group on leave

Haggai Eran (1):
      IB/cma: Accept connection without a valid netdev on RoCE

Jeff Squyres (1):
      usnic: add missing clauses to BSD license

Sagi Grimberg (1):
      xprtrdma: Don't require LOCAL_DMA_LKEY support for fastreg

 drivers/infiniband/core/cma.c                      | 54
++++++++++++++++------
 drivers/infiniband/hw/usnic/usnic.h                | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_abi.h            | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_common_util.h    | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_debugfs.c        | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_debugfs.h        | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_fwd.c            | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_fwd.h            | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_ib.h             | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_ib_main.c        | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h      | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c       | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.h       | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h       | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_log.h            | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_transport.c      | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_transport.h      | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_uiom.c           |  2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.h           | 21 +++++++--
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.c | 21 +++++++--
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.h | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_vnic.c           | 21 +++++++--
 drivers/infiniband/hw/usnic/usnic_vnic.h           | 21 +++++++--
 drivers/infiniband/ulp/ipoib/ipoib.h               |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  4 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |  2 +-
 net/sunrpc/xprtrdma/verbs.c                        |  8 ++--
 30 files changed, 481 insertions(+), 94 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--DDeVvrXISMKuE641gQo9bWwspvt3EkKUQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWHqglAAoJELgmozMOVy/dqLgP/jJbkoPfwgNs5HxKXyHIxNId
Eq2XMvy+WsfJjQmQpt3NUhM7Gc/lZodutvkv00X0/a32HBda0tWPTBbNQBKYwFqZ
9YL0YF50QidDB9sXOLnA/D2nrg3IpPyjcUDpZyQ8htPsbleGCZq2IoJodnDLCk1B
FVLuVuLEqe6xFGUyT6aaF/4L2gMaXN/jvYKS3mrIXzun+eLDT0ZQGN7r8gtOKKmL
wWyhMrE1IN45wB1/GDuoc4ikYLC2yuHuVVe5uiw/3deOPUVpU0GtlWKxGnqXHdjx
VFcpYn/cgaB8iDW5mWWGfG6bjBzO83Fo3ISf1Ix6Jvae74PkpQbTV3AX/Rzf8jMY
t04s1LbqDClbyJKip9ypIvNjuuxm6tGTFxbqnSRud/lK7CWH1f6KKGb/rq+fY9bI
9RYaS2G8V4DI/8FKgvkWWfyX5nUaA1xZGW23eV52px3NPRXigyjm4LEosVCBF8aB
tBChfABPbmVS1j3DWtNAuZhzbFXu8KxemV0N/HzX/ax4uBjjHZ/YxBFB6RT1JGIn
JuwilfRTpo33zl9UUlFbjjUeMRjUAeQDQkzP3hz7dlmV6lZtn1wOPUd2AMNfDLT0
n3TMaIcZ8r2MCyJRhn4BJ1/jK6s6vH1d1VOFMtD842PjplREkOVefNwDKCcktMxv
xX2fyG0yTYxGEtECenav
=+C8g
-----END PGP SIGNATURE-----

--DDeVvrXISMKuE641gQo9bWwspvt3EkKUQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
