From: Doug Ledford <dledford-HHGe/kKACDifJOJzLBvvIA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Sat, 20 Feb 2016 20:14:36 -0500
Message-ID: <56C90F7C.3030605@xsintricity.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XLaMEfdmFNjVLhkAfwSNmWmj7hcA0tTvC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XLaMEfdmFNjVLhkAfwSNmWmj7hcA0tTvC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 75c1657e1d50730dc0130a67977f7831a4e241=
f4:

  IB/mlx5: Fix RC transport send queue overhead computation (2016-02-12
14:56:08 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to c2bab619813a525d3f58b5ffbfcdc4edee27e497:

  IB/mlx4: Add support for the port info class for RoCE ports
(2016-02-17 10:07:20 -0500)

----------------------------------------------------------------
Additional 4.5-rc5 fixes

- One fix ocrdma - The new CQ API support was added to ocrdma, but they
  got the arming logic wrong, so without this, transfers eventually fail
  when they fail to arm the interrupt properly under load
- Two related fixes for mlx4 - When we added the 64bit extended counters
  support to the core IB code, they forgot to update the RoCE side of the=

  mlx4 driver (the IB side they properly updated).  I debated whether or
  not to include these patches as they could be considered feature
  enablement patches, but the existing code will blindy copy the 32bit
  counters, whether any counters were requested at all (a bug).  These
  two patches make it A) check to see that counters were requested and
  B) copy the right counters (the 64bit support is new, the 32bit is
  not).  For that reason I went ahead and took them.

----------------------------------------------------------------
Devesh Sharma (1):
      RDMA/ocrdma: Fix arm logic to align with new cq API

Eran Ben Elisha (2):
      IB/mlx4: Add support for extended counters over RoCE ports
      IB/mlx4: Add support for the port info class for RoCE ports

 drivers/infiniband/hw/mlx4/mad.c            | 63
+++++++++++++++++++++++------
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  3 --
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 18 ++-------
 3 files changed, 54 insertions(+), 30 deletions(-)

--=20
Doug Ledford <dledford-HHGe/kKACDifJOJzLBvvIA@public.gmane.org>
              GPG KeyID: 0E572FDD



--XLaMEfdmFNjVLhkAfwSNmWmj7hcA0tTvC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWyQ98AAoJELgmozMOVy/dWB0P/0usS9pms3cR4NagTyw5fz3u
wx+zkYJQWfWpHqJCGQnSsbKG0OPlUUqeJTTMH/qF7NGDc1Eloky1OMLmVNooEDJY
X8TV/tW2piEb6hKQTxx4aYcMhecL9DU83xLrwpRenANq3kpG+yWvzvAnsjvbmVqA
K+dMmrypWRiPScLQXRkIwnfrbFYt06OxKpVGUHNf2APEoai2mhHwszFm6+LlmlGw
g3ilhFyxIRvvkpeXeaZambmfh73lQc0POZJA4IfdbAD2JlgI+rXfrT06/5NUajMX
7+HkZ6z+e+7y3ZNzhcmvWf5G6gxmIKiKU0ei3ppWo+tj73/yO0+XKAW5Ut9au6pj
wXRgX+OjYnAglPUmNxH+dFdVKSd3QoKhgFqy4ClcFMf87Hf3picRbEipjeTuI0R5
HEPByvtfvyNdsdjiPvUeQkTJQ8V7ELXSTAVfz64G9RABQAVjefINDQXxdFUhjykA
fjXwbUJLP7RW1MdT/k2GHODnil7lEzEdI0tv7Fk8YvPS5OlqjAj4+NcwmknKaS4Z
HzuVmFVIq5X8PFl4ZuQChoe0kWjPNlGCqcdda4OqPRQ8wQdie26e3FkQydTRlNHJ
PO/XmMrXH7XxiJfuSn/g5R0seRtwXM7vb5jXQ5ZrccSp5xNchiXDhLiNHbpuvKv0
v6YmVsPQeOd6Zp3Wk+em
=pg0U
-----END PGP SIGNATURE-----

--XLaMEfdmFNjVLhkAfwSNmWmj7hcA0tTvC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
