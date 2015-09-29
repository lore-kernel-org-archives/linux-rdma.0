From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Tue, 29 Sep 2015 14:04:15 -0400
Message-ID: <560AD29F.8060708@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cbRj4xO0LVOWTOsSxIXqiXc3629uuaW0C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cbRj4xO0LVOWTOsSxIXqiXc3629uuaW0C
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I have a few -rc fixes for you.  One fix in particular, for the NFSoRDMA
code, relied upon changes that went in during the 4.3 merge window to
apply cleanly, but also relied on a group of related commits in this
set, making it need to come through my tree.  So I merged up to 4.3-rc2,
and this is what's in my tree beyond that:

The following changes since commit 310b7cec8ea32dcd4e9978423717ce78dd89d4=
5d:

  Merge tag 'v4.3-rc2' into k.o/for-4.3-v1 (2015-09-25 10:46:07 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 2866196f294954ce9fa226825c8c1eaa64c7da8a:

  IB/ipoib: increase the max mcast backlog queue (2015-09-25 22:30:24 -04=
00)

----------------------------------------------------------------
Changes for 4.3-rc4

- Fixes for mlx5 related issues
- Fixes for ipoib multicast handling

----------------------------------------------------------------
Christoph Lameter (1):
      IB/ipoib: Expire sendonly multicast joins

Chuck Lever (1):
      xprtrdma: Replace global lkey with lkey local to PD

Doug Ledford (2):
      IB/ipoib: Make sendonly multicast joins create the mcast group
      IB/ipoib: increase the max mcast backlog queue

Sagi Grimberg (3):
      IB/iser: Add module parameter for always register memory
      IB/mlx5: Remove support for IB_DEVICE_LOCAL_DMA_LKEY
      IB/mlx5: Remove pa_lkey usages

 drivers/infiniband/hw/mlx5/main.c              | 67
+-------------------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h           |  2 -
 drivers/infiniband/hw/mlx5/qp.c                |  4 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |  4 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 18 +++++++
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 26 +++++-----
 drivers/infiniband/ulp/iser/iscsi_iser.c       |  5 ++
 drivers/infiniband/ulp/iser/iscsi_iser.h       |  1 +
 drivers/infiniband/ulp/iser/iser_memory.c      | 18 ++++---
 drivers/infiniband/ulp/iser/iser_verbs.c       | 21 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c   | 22 ---------
 include/linux/mlx5/device.h                    | 11 -----
 include/linux/mlx5/driver.h                    |  1 -
 net/sunrpc/xprtrdma/fmr_ops.c                  | 19 --------
 net/sunrpc/xprtrdma/frwr_ops.c                 |  5 --
 net/sunrpc/xprtrdma/physical_ops.c             | 10 +---
 net/sunrpc/xprtrdma/verbs.c                    |  2 +-
 net/sunrpc/xprtrdma/xprt_rdma.h                |  1 -
 18 files changed, 70 insertions(+), 167 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--cbRj4xO0LVOWTOsSxIXqiXc3629uuaW0C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWCtKfAAoJELgmozMOVy/dqHwQAMIPPiqnp9G42G/FrjE4elhL
Ikr41eeZ1lPpDvcbVmVlkFCa8+Xew76aGkjjqIdJ+k09uaIzJ3L9v6w2Vpry7yWj
yGc56phf8R4LFZdINbwvhs89uJa+C2W0cTBhj89WaVuEeCjpTV6DrSp1DGOMO0Aa
08XbqRfP+X6v2VSxqFZe6kkTfQy1zEHJB+Azbkr4+aj/t080UEAcLEOWchi3pJzt
rxDCs2uHe2CvXn7zSsg5cuvuZhzBcGH1XD6TDbHhXvsfRCxIvvv5Pk97nEQSFj00
sq9nugu4rc639WNaVUwPDrZ5Kse6Vlv4nBkjsBgwCBTPZ1BtCy4uYMMMEIFrGMsi
QvAja/QbmaytujpB/5DVU80JLXk8sNAUW0hrQ69ehRJszPqukDmBy3uHMz/kSlkE
/XwzmIKU2NPoLlrFq06lSsyyTxQgSbfJn6bhXWJOzMKhEYGdzw/MQpUGUkMQFmhg
qHSECyhERWSm6IqwXXLxJI/4ghva1jwQgSp3hmk/LIjEO7OHC+9VQNYkIxFbp/Vt
KpvKK6k0JFeGXHs7Qb3Aa+So0TY4az5dlUH40tFQELDMQQoEZWdnEgP8a5PuYaYO
VUu93BGZ44ri9K66NOAVpKv/e7xZi22nZXHjowfvCFiSgIbKEUbzylm0ul3R18jF
pBQZsBs6XKuRkxCnXGce
=FN6T
-----END PGP SIGNATURE-----

--cbRj4xO0LVOWTOsSxIXqiXc3629uuaW0C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
