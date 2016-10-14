From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git (tag for-linus-2)
Date: Fri, 14 Oct 2016 16:25:20 -0400
Message-ID: <9fdaa6b2-74a9-1dec-620b-b7585b1b4d52@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uI3IBxB3GtNVXrHdV55PWQutEH6ODBBng"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uI3IBxB3GtNVXrHdV55PWQutEH6ODBBng
Content-Type: multipart/mixed; boundary="hr9mFgql8dmB4vEgJU3WTJqafN67F11V9";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <9fdaa6b2-74a9-1dec-620b-b7585b1b4d52-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git (tag for-linus-2)

--hr9mFgql8dmB4vEgJU3WTJqafN67F11V9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is another isolated pull request.  This merge window was the first
where Hauwei had to try and coordinate their patches between their net
driver and their new roce driver (similar to mlx4 and mlx5).  They
didn't do horribly, but there were some issues (and we knew that because
they simply didn't know what to do in the beginning).  As a result, I
had a set of patches that depended on some patches that normally would
have come to you via Dave's tree.  Those patches have been on netdev@
for a while, so I got Dave to give me his approval to send them to you.
As such, the other 29 patches I had behind them are also now ready to
go.  This catches the hns and hns-roce drivers up to current, and for
future patches we are working with them to get them up to speed on how
to do joint driver development so that they don't have these sorts of
cross tree dependency issues again.  BTW, Dave gave me permission to add
his Acked-by: to the patches against the net tree, but I've had this
branch through 0day (but not linux-next since it was off by itself) and
I didn't want to rebase the series just to add Dave's ack for the 8
patches in the net area, so that's why I've Cc:ed him on the pull
request.  Hope that was the right thing to do in that regard.

Here's the boilerplate:

The following changes since commit 528f1deb16e5b82e9fe161ebd8caa5983766f0=
f0:

  IB/hns: Add support of ACPI to the Hisilicon RoCE driver (2016-08-25
10:05:10 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus-2

for you to fetch changes up to 1bdab400af5954932714e68ab3df0187a92916cb:

  IB/hns: Fix for removal of redundant code (2016-10-03 11:43:15 -0400)

----------------------------------------------------------------
Updates to the hns drivers

- Small patch set for hns net driver that the roce patches depend on
- Various fixes to the hns-roce driver
- Add connection manager support to the hns-roce driver

----------------------------------------------------------------
Daode Huang (6):
      net: hns: bug fix about setting coalsecs-usecs to 0
      net: hns: add fini_process for v2 napi process
      net: hns: delete repeat read fbd num after while
      net: hns: fix the bug of forwarding table
      net: hns: bug fix about broadcast/multicast packets
      net: hns: delete redundant broadcast packet filter process

Kejian Yan (1):
      net: hns: fix port not available after testing loopback

Lijun Ou (24):
      IB/hns: Register HNS RoCE Driver get_netdev() with IB Core
      IB/hns: Add & initialize "node_guid" parameter for RDMA CM
      IB/hns: Fix the value of device_cap_flags
      IB/hns: Fix two possible bugs for rdma cm
      IB/hns: Add phy_port for computing GSI/QPN
      IB/hns: Change the logic for allocating uar registers
      IB/hns: Fix the bug of rdma cm connecting on user mode
      IB/hns: Fix two bugs for rdma cm connecting
      IB/hns: Add node_guid definition to the bindings document
      IB/hns: Remove unused parameters in some functions
      IB/hns: Remove parameters of resize cq
      IB/hns: Fix bug of using uninit refcount and free
      IB/hns: Simplify function of pd alloc and qp alloc
      IB/hns: Remove unused parameter named qp_type
      IB/hns: Modify the init of iboe lock
      IB/hns: Fix bug of memory leakage for registering user mr
      IB/hns: Return bad wr while post send failed
      IB/hns: The Ack timeout need a lower limit value
      IB/hns: Some items of qpc need to take user param
      IB/hns: Validate mtu when modified qp
      IB/hns: Cq has not been freed
      IB/hns: Update the rq head when modify qp state
      IB/hns: Fix the bug when platform_get_resource() exec fail
      IB/hns: Delete the redundant lines in hns_roce_v1_m_qp()

Salil (1):
      IB/hns: Fix for removal of redundant code

Wei Hu (Xavier) (3):
      IB/hns: Fix bug of clear hem
      IB/hns: Delete the sqp_start from the structure hns_roce_caps
      IB/hns: Optimize code of aeq and ceq interrupt handle and fix the
bug of qpn

lipeng (1):
      net: hns: fix port unavailable after hnae_reserve_buffer_map fail

 .../bindings/infiniband/hisilicon-hns-roce.txt     |   2 +
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  23 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |  18 +-
 drivers/infiniband/hw/hns/hns_roce_eq.c            | 146 +++++-----
 drivers/infiniband/hw/hns/hns_roce_eq.h            |   4 +
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  76 +-----
 drivers/infiniband/hw/hns/hns_roce_hem.h           |   4 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         | 293
+++++++++++++++------
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h         |   9 +
 drivers/infiniband/hw/hns/hns_roce_main.c          |  36 ++-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   3 +
 drivers/infiniband/hw/hns/hns_roce_pd.c            |  22 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  67 ++---
 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c  |  11 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |  13 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h  |   2 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |  10 -
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h |   1 -
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c  |  16 ++
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_reg.h  |   4 +
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      | 107 +++++---
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |   7 +
 22 files changed, 505 insertions(+), 369 deletions(-)


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--hr9mFgql8dmB4vEgJU3WTJqafN67F11V9--

--uI3IBxB3GtNVXrHdV55PWQutEH6ODBBng
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYAT8wAAoJELgmozMOVy/dBHMQAIKxIBkw7L9O7R9G1f8s5ZVp
/+W5jsENaYdahaUF6ukJEZ4FBa4vqoqZerD+gJpkYDlD1Y05jcCK9gc/Eb3Xoa4z
bhyilk3sZzjYDFD0UzimaMh9TnPMQKugp4bBXmx9FFPMziVnxJsIsOQuiZo2ZTgK
bC74FkX1b/nql76QKp+FapUcG4Kr372x1DHp1mBDNUd9MDaIF9lKRj6O1CUha0L1
G6LFz8J1HGEEQV6LbfPqUzrDqT0bQDqbzfIHuPDM2EndPQ6hmkfMtsy3QPOAtviD
qC6GEd6dFFINrTZCZ/TvC/melfJKb9+plvWd1TCcqZBUhK5Rj4B+ouyGG2IYYBcO
VeAXxRuGs9cneurQ861+QFlqRg7E1XXr1EgP9W5x2eKDkC7IgHF9nRTAX6w1Xvxk
i81YHJFgB2nSop4z62Q+VxrfI0YHXhRudhFUv2juaQBVZkKAP+XoC4TOhtrPRqOJ
mfw6F183mVnJIQfhAPvvLEQKAfkzVqYYAabD8MZaPkKm/vPt9uGr2vnBR9S+g5FV
KV6X7Sp/Uvzb+DLUNkmSbDROQ2G9Wfn4VNB97FMiDJQv+lOf4VOb1NdVYwXxZVUD
Rnf+0blfDbOucQlpg23CyZJG+UzfTHdX6sGegsJCRF3e+TeSRYTEZUpWfI5XPFAJ
c7HXzTkqLdIU0ENar+WW
=oqyG
-----END PGP SIGNATURE-----

--uI3IBxB3GtNVXrHdV55PWQutEH6ODBBng--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
