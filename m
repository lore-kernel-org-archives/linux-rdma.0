From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Sat, 13 Feb 2016 20:23:26 -0500
Message-ID: <56BFD70E.6070905@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eTagcePgWIk94BhQ849tWh3X0rIQGFf2b"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eTagcePgWIk94BhQ849tWh3X0rIQGFf2b
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I think we are getting pretty close to done now.  There are four one-off
fixes in this update, as documented in the tag message.  Thanks.

The following changes since commit 7425f410ca6cffe81400906286f80e8e15d9b3=
01:

  RDMA/ocrdma: Fixing ocrdma debugfs directory remove (2016-02-05
15:14:28 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 75c1657e1d50730dc0130a67977f7831a4e241f4:

  IB/mlx5: Fix RC transport send queue overhead computation (2016-02-12
14:56:08 -0500)

----------------------------------------------------------------
Additional 4.5-rc3 fixes

- One fix to ipoib multicast joins
- One fix to mlx4 error handling
- One fix to mlx5 size computation
- One fix to a thinko in core code

----------------------------------------------------------------
Alex Estrin (1):
      IB/ipoib: fix for rare multicast join race condition

Eran Ben Elisha (1):
      IB/core: Fix reading capability mask of the port info class

Leon Romanovsky (1):
      IB/mlx5: Fix RC transport send queue overhead computation

Rasmus Villemoes (1):
      net/mlx4: fix some error handling in mlx4_multi_func_init()

 drivers/infiniband/core/sysfs.c                |  5 ++---
 drivers/infiniband/hw/mlx5/qp.c                | 12 +++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 24
+++++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx4/cmd.c       |  2 +-
 4 files changed, 27 insertions(+), 16 deletions(-)


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--eTagcePgWIk94BhQ849tWh3X0rIQGFf2b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWv9cPAAoJELgmozMOVy/dzKcP/308Ai/rJjv6zha+Ph2I/Zy3
6YzGDuK5gCIQqlkRPhx3rFZ0NOuov9CyuNnL8xfwF4QPeLgezuPag0tfWkAyVN6/
70OIuEZPW48WC1rAk3kbZZFizw1pSTB4VLNfRerLwp/kDmDd2iXPrBKOEiViSJnA
lyRzkxF3IHAGzXS3G4gNr7lmlX/HYuPS5aHnMWL1hw9hrI+hg87qiCEecB6N1JzB
41j84LFBz+Hv1L7F/p+t0h437377lt9uJLl2l4/w4F6ZF2NFTivbDe2X0SXg38JN
m/OqaW7aru0Za3MZIfJi292LXVmHJR4urGGNYFFNjTC/BHB6goA3JRi6kJDETctS
wlqnwKZXK5IQm9hslD1dAbhgyX33FvX8CphTd1H99b+VNWletpFLJg1823ty7KW0
wNBP/BLHSdayDfoVUTSMueTwMBGB/r0UpaAk6hBbG0oqbnvC83EHvPp3L+6Bsr5M
S0tOK0DU1TVfQCXJPaKoLIFSWkTvHjydL5VcbnP3lPJWmRZjR3Ov7FVO7qH6j+ai
E3JVOANT9Uo6xA6gAZaheBW7mKE+MOXuiP+tAHny+LQCHS+aJhiTvpyynNd/B3Z8
wD5MN8MUDh7YIgw2u7sxwGWGgI48hHzbsRlUmrXQuD4cn0ZLm6jpvpWoePy9fduU
kI+M+NcW4esIjcUPzz74
=yr5k
-----END PGP SIGNATURE-----

--eTagcePgWIk94BhQ849tWh3X0rIQGFf2b--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
