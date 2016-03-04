From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 4 Mar 2016 12:04:46 -0500
Message-ID: <56D9C02E.8060206@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xoU5W944E23cio0EmiGfLvfvPIC0qI9dI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xoU5W944E23cio0EmiGfLvfvPIC0qI9dI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I have four patches today.  I had previously thought I had submitted two
of them last week, but they were accidentally skipped :-(.

The following changes since commit c2bab619813a525d3f58b5ffbfcdc4edee27e4=
97:

  IB/mlx4: Add support for the port info class for RoCE ports
(2016-02-17 10:07:20 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 11d8d645343efba0c975aefe7c2cf3b33c836c75:

  IB/core: Use GRH when the path hop-limit > 0 (2016-03-03 10:52:58 -0500=
)

----------------------------------------------------------------
Additional 4.5-rc6 fixes

- One fix to an error path in the core
- One fix for RoCE in the core
- Two related fixes for the core/mlx5

----------------------------------------------------------------
Leon Romanovsky (1):
      IB/core: Fix missed clean call in registration path

Majd Dibbiny (2):
      IB/mlx5: Avoid using user-index for SRQs
      IB/{core, mlx5}: Fix input len in vendor part of create_qp/srq

Or Gerlitz (1):
      IB/core: Use GRH when the path hop-limit > 0

 drivers/infiniband/core/device.c     |  1 +
 drivers/infiniband/core/sa_query.c   |  2 +-
 drivers/infiniband/core/uverbs_cmd.c |  9 +++++---
 drivers/infiniband/hw/mlx5/srq.c     | 41
+++++++++++++++++++-----------------
 4 files changed, 30 insertions(+), 23 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--xoU5W944E23cio0EmiGfLvfvPIC0qI9dI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2cAuAAoJELgmozMOVy/dx7UP/1WOQN9slK496gTdXYzzN7hZ
Nsd+qqknqBt2HpZHMMcRCJPQsjfKourbL5Hb3byDM9g0jijjxeCF5bvGR4QbJijX
ljdPSswM3WTYnofZjL+r4DkXegfivxJuoHsfBw5Iqojx2cxgQMivide612rTNDOZ
W9TSTB24E3IAujl12dy4ZWWo/qwd+sqxU/qa9BFDBw572QHYdzxpDuF9jdulOe01
YiqdfnbnD0Gt5+rN2OMxT4tmbW4g4MfIKGikqAlKSiDOOlycSBfVnlWg1PJjaNhF
T8GMjTUX3zMdPGuoKQU9cOi7ROLS0+NpOWg9FzwjooD/7nrqAuS/7cdu0mtwuorm
v+kSEN7eZNXYLFVTIT6pdEeKKHfAQgLvx4aJo9x1CTydfqkegYfBDbQTPUIzsAL6
Hn5ZvtJZqOxx2Qc8WwcWNKTZpdJdX1Olm2hK/drFWoEEl+AeTflC6Q3mMmXXHQ1/
4XBdz04U8EV0uOj9ed8/1ItFXsqf7lz0or3NGV67XZYmHgR9Tn9HAKOI3F2B12hW
7nwH99J5AEHc46n8+YPbjH36B/17xz1r83axqR8zamdgiS3bnglcrDMH7EjAlDxd
CCMGfUTKkcrc1JBYYVvWnOmwcTKMNuULU9jJuyM5t2thFwikL8yCqhUw6f0ji266
X9ss3lqYj0rIqDhZicmQ
=TkNe
-----END PGP SIGNATURE-----

--xoU5W944E23cio0EmiGfLvfvPIC0qI9dI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
