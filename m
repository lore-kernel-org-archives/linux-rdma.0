From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 10 Dec 2015 16:00:23 -0500
Message-ID: <5669E7E7.7040409@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7iCXdwkWl5DjT42d9v8KqwmdPaOexcDOm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org " <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7iCXdwkWl5DjT42d9v8KqwmdPaOexcDOm
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 527e9316f8ec44bd53d90fb9f611fa7ffff52b=
b9:

  Linux 4.4-rc4 (2015-12-06 15:43:12 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to ab5cdc31630c7596d81ca8fbe7d695f10666f39b:

  IB/mlx5: Postpone remove_keys under knowledge of coming preemption
(2015-12-08 16:55:31 -0500)

----------------------------------------------------------------
Series of 4.4-rc fixes

Most are minor to important fixes.  There is one performance enhancement
that I took on the grounds that failing to check if other processes can
run before running what's intended to be a background, idle-time task
is a bug, even though the primary effect of the fix is to improve
performance (and it was a very simple patch).

----------------------------------------------------------------
Arnd Bergmann (1):
      IB/iser: use sector_div instead of do_div

Bart Van Assche (5):
      IB/srp: Fix a memory leak
      IB/srp: Fix indirect data buffer rkey endianness
      IB/srp: Fix srp_map_sg_fr()
      IB core: Fix ib_sg_to_pages()
      IB/cma: Add a missing rcu_read_unlock()

Christoph Hellwig (1):
      IB/srp: Initialize dma_length in srp_map_idb

Easwar Hariharan (1):
      IB/qib: Minor fixes to qib per SFF 8636

Hal Rosenstock (1):
      IB/mad: Require CM send method for everything except ClassPortInfo

Ira Weiny (1):
      IB/qib: Fix qib_mr structure

Kaike Wan (1):
      IB/sa: Put netlink request into the request list before sending

Leon Romanovsky (1):
      IB/mlx5: Postpone remove_keys under knowledge of coming preemption

Mike Marciniszyn (2):
      IB/core: Fix user mode post wr corruption
      IB/core: use RCU for uverbs id lookup

Sagi Grimberg (3):
      IB/srp: Fix possible send queue overflow
      mlx4: Expose correct max_sge_rd limit
      iser-target: Remove explicit mlx4 work-around

Wengang Wang (2):
      IB/mlx4: Use correct order of variables in log message
      IB/mlx4: Use vmalloc for WR buffers when needed

 drivers/infiniband/core/cma.c            |  5 +---
 drivers/infiniband/core/mad.c            |  5 ++++
 drivers/infiniband/core/sa_query.c       | 32 +++++++++++----------
 drivers/infiniband/core/uverbs_cmd.c     | 27 +++++++++++-------
 drivers/infiniband/core/verbs.c          | 43 ++++++++++++++------------=
--
 drivers/infiniband/hw/mlx4/main.c        |  2 +-
 drivers/infiniband/hw/mlx4/qp.c          | 19 +++++++++----
 drivers/infiniband/hw/mlx4/srq.c         | 11 ++++++--
 drivers/infiniband/hw/mlx5/mr.c          | 14 +++++++++-
 drivers/infiniband/hw/qib/qib_qsfp.c     |  4 +--
 drivers/infiniband/hw/qib/qib_verbs.h    |  2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c |  2 +-
 drivers/infiniband/ulp/isert/ib_isert.c  | 13 ++-------
 drivers/infiniband/ulp/srp/ib_srp.c      | 48
+++++++++++++++++---------------
 drivers/infiniband/ulp/srp/ib_srp.h      |  5 +---
 drivers/net/ethernet/mellanox/mlx4/cmd.c |  2 +-
 include/linux/mlx4/device.h              | 11 ++++++++
 include/rdma/ib_mad.h                    |  2 ++
 include/rdma/ib_verbs.h                  |  1 +
 19 files changed, 146 insertions(+), 102 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--7iCXdwkWl5DjT42d9v8KqwmdPaOexcDOm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWaefnAAoJELgmozMOVy/ddJ8QAI94uCKeMV4HxMuOOB9IPipk
DKAYam8mPC1d46qBymlqxS4QdWQ6aV3j4przN+xpohfwZkTeHbWJBxO2DhdO2HmB
DGwdAK4quDbbLhOwDXEXkpYc1uKuTyIoZB6BMx7yCOlCGsNNgxlN72pzVUpr1cF7
pULexw5ggpAJ3A5N3r7TfAiPvazLSII2LDjGRdrfiHY/4PnWh6xtToQdWvQhKg5m
2mDxFVEYlMtSMbrG7K9ZHHkm9ukw3GflcCTzfOGVaB2LFRbmp09NuuRKSgBmJACu
FwZfppzw04HF6SVx9zCe5zmzFSfRVQzYt4h2s9HcmkWgaNWAPKiNuEzgEtLN8ai9
fQ7ZuYIjx34MUmRlFYgzmw3+bvTieXPPUqj27Qvry2VWSucsf1d19qZFsFUzVxyt
IUDFKoef/QAmXANrhoE9DrYGXLBRQ72CSVsbvRn3Z9TVrN2l02KrpmACzwBzUcHK
2kf6rbsvdkS12isDb0CsqI69ghTu7uOMfdXHXpu6XBw2lfS4uld66DvmxHisyTJ8
CZVvW9m7ZjFn0n9lJpb6jVdwRLCnV0UPESCQzUpaSSCSWw0JYAs2faxWlVZ8jp1+
WAbwSZ/XPZaj1ymCJhko39/Q1zJ9401F0stLyyatUSWPD54UBuQxPmhKrOCY9fWL
qefJSEcko3T1Sn1FSb3W
=Is3t
-----END PGP SIGNATURE-----

--7iCXdwkWl5DjT42d9v8KqwmdPaOexcDOm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
