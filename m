From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [GIT PULL] Please pull RDMA subsystem changes for 4.15-rc2
Date: Mon, 4 Dec 2017 15:49:24 -0700
Message-ID: <20171204224924.GA14971@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323:

  Linux 4.15-rc1 (2017-11-26 16:01:47 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 315d160c5a4e034a576a13aa21e7235d5c9ec609:

  IB/core: Only enforce security for InfiniBand (2017-12-01 12:21:28 -0700)

----------------------------------------------------------------
Here is the first rc pull request for RDMA. This includes an important core
fix for a regression in iWarp if SELinux is enabled, a fix for a compilation
regression introduced in this merge window, and one obscure kconfig
combination that oops's the kernel.

For drivers, we have hns fixes needed to make their devices work on certain
ARM IOMMU configurations, a stack data leak for hfi1, and various testing
discovered -rc bug fixes for i40iw.

This cycle we pushed back on the driver maintainers to have better commit
messages for -rc material.

You may need to pull my latest PGP key from the GPG key servers for this, I am
not certain if the subkey update will make it to kernel.org's WKD before you
need it.

Thanks,
Jason

----------------------------------------------------------------
Chien Tin Tung (1):
      i40iw: Allocate a sdbuf per CQP WQE

Daniel Jurgens (1):
      IB/core: Only enforce security for InfiniBand

Dennis Dalessandro (1):
      IB/hfi1: Initialize bth1 in 16B rc ack builder

Dmitry Monakhov (1):
      IB/core: Init subsys if compiled to vmlinuz-core

Geert Uytterhoeven (1):
      IB: INFINIBAND should depend on HAS_DMA

Henry Orosco (1):
      i40iw: Notify user of established connection after QP in RTS

Moni Shoua (1):
      RDMA/cma: Make sure that PSN is not over max allowed

Mustafa Ismail (2):
      i40iw: Do not free sqbuf when event is I40IW_TIMER_TYPE_CLOSE
      i40iw: Correct ARP index mask

Tatyana Nikolova (1):
      i40iw: Move MPA request event for loopback after connect

Wei Hu\(Xavier\) (3):
      RDMA/hns: Fix the issue of IOVA not page continuous in hip08
      RDMA/hns: Get rid of virt_to_page and vmap calls after dma_alloc_coherent
      RDMA/hns: Get rid of page operation after dma_alloc_coherent

 drivers/infiniband/Kconfig                  |  2 +-
 drivers/infiniband/core/cma.c               |  1 +
 drivers/infiniband/core/device.c            |  2 +-
 drivers/infiniband/core/security.c          | 50 ++++++++++++++++++++++++++---
 drivers/infiniband/hw/hfi1/rc.c             |  2 +-
 drivers/infiniband/hw/hns/hns_roce_alloc.c  | 23 -------------
 drivers/infiniband/hw/hns/hns_roce_device.h |  4 +--
 drivers/infiniband/hw/hns/hns_roce_hem.c    | 25 ++++++++-------
 drivers/infiniband/hw/hns/hns_roce_hem.h    |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 22 +++++++++----
 drivers/infiniband/hw/i40iw/i40iw_cm.c      | 31 +++++++++++-------
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c    | 43 +++++++++++++++++--------
 drivers/infiniband/hw/i40iw/i40iw_d.h       |  6 ++--
 13 files changed, 134 insertions(+), 78 deletions(-)

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJaJdDzAAoJEDht9xV+IJsaCOIP/io5Mkz/gIfz00flN/epX5Pq
CtryM43WAtEKeeVDqPzIjzpLxGZeGLN8ZC3p9JQTXjW/MDJ2T+6DWzGpjbSIPRBx
OI0AayA87mL5BLBUAt9ywIt/dUZIxOMWUv+3Vmh2Q1I+7zQktCN3cVV0MNlwrQXk
tHDVWe0Ovb1mljEIdj3Viyy/e4H/lp/YY9M06RQRVhTEljgTKCQ/vR+ymBHIRVvs
55Kdyp0OuNixdOf2q5Jx+OKQO2b/DXabcPxeqGTmyYWXPLfMOwoCaz6qo/wcl06f
rJHGZn3DsGt0ZTQFK9rJcaGHTG+34EvpiPv2r0DzRo3cQJb3LwmZAYiI9P9kzBmw
tvVjD94rMk8XjotCjQabZSOtg59mx7nVKKXn/N1ah3E249P0J/bhBu4xGV8XmnWR
byXmIrFtUC71UMSF7bGtNni7+sNRcqnnwgeJUv9qO0KJ0++Xha7hA0wiAcQbGz6T
SxuQYxAAC4ECYfiJc6eI0kdGs6pOxPRqXxqjOoqJ7gRw7pe+SmZV+uHlKZuaSkHz
cY4yZ9602CrynLSPplsTU+TcWjRv3hVQNbuhLqcQB22JZh/cvfjzo60EC6XP/Ogx
7NhonEfYKbgORQoErcbegP8I3HmWGe5O37Hy5U/cGrqwDWtu6U7OHNhhbaJjxBB4
a3ib0lhAY82Z4fiWedUh
=HaCx
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
