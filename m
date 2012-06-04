From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 0/4] IB/IPoIB TSS and RSS support for datagram mode
Date: Mon,  4 Jun 2012 14:49:54 +0300
Message-ID: <1338810598-9488-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Roland, Sean, everyone!

With 3.5-rc1 being out by now, here's V1 of the TSS/RSS patch series,
basically its very similar to V0, with taking out what was already
accepted and few minor fixes for issues we stepped over testing since
the V0 submission.

Still, the 1st and most thing to handle here is feedback on the QP 
groups concept suggested by this patch set to support TSS/RSS over
verbs. The plan is for this concept to (with little help from a 
framework for verbs extension) apply to user space RSS as well, 
for both UD and RAW QPs.

The concept of QP groups for TSS/RSS was introduced in the last OFA conference, 
you can take a look on the user mode ethernet session slides 10-14, the author 
was maybe worried from the MS mob, and hence didn't use the terms RSS/TSS 
but that's the intention... see

https://openfabrics.org/resources/document-downloads/presentations/cat_view/57-ofa-documents/23-presentations/81-openfabrics-international-workshops/104-2012-ofa-international-workshop/107-2012-ofa-intl-workshop-wednesday.html 

Changes from V0:

 - removed accepted patches, the first three on the V0 series
 - fixed crash in the driver EQ teardown flow - merged by commit 3aac6ff "IB/mlx4: Fix EQ deallocation in legacy mode"
 - removed wrong setting done in the ehca driver in ehca_create_srq
 - fixed user space QP creation to specify QPG_NONE
 - fixed usage of wrong API for netif queues stopping in patch 3/4 (V0 6/7)
 - fixed use-after-free of device attr pointer in patch 4/4 (V0 7/7)

* Add support for for RSS and TSS for UD.
        The number of RSS and TSS queues is a function of the number
        of cores and HW capability.

* Utilize multi core CPU and NIC's multi queuing in order to increase
        throughput. It utilize a new "QP Group" concept. A QP group is
        a set of QP consists of a parent QP and two disjoint subsets of
        RSS and TSS QP.

* If RSS is supported by HW then the number of RSS queues is highest
        power of two greater than or equal to the number of cores.
        Otherwise the number is one.

* If TSS is supported by HW then the number of TSS queues is highest
        power of two greater than or equal to the number of cores.
        Otherwise the number is highest power of two greater than or
                equal to the number of cores plus one.

* Transmission and receiving in CM mode uses a send and receive queue
        assigned to each CM instance at creation time.

* Advertise that packets sent from set of QPs will be received. That is,
        A received packets with a source QPN different from the QPN
        advertised with ARP will be accepted.

* The advertising is done by setting a third bit in the flags part
        of the link layer address. This is similar to RFC 4755
        section 3.1 (CM advertisement)

* If TSS is not supported by HW then transmission of multi-cast packets
        is done using device queue N and thus the parent QP, which is
                also the advertised QP.

* If TSS is not supported by HW then usage of TSS is enabled if the peer
        advertised that it will accept TSS packets.

* Drivers can now use a larger portion of the device vectors/IRQ

Shlomo Pongratz (4):
  IB/core: Add RSS and TSS QP groups
  IB/mlx4: Add support for RSS and TSS QP groups
  IB/ipoib: Implement vectorization restructure as pre-step for TSS/RSS
  IB/ipoib: Add RSS and TSS support for datagram mode

 drivers/infiniband/core/uverbs_cmd.c           |    1 +
 drivers/infiniband/core/verbs.c                |    3 +
 drivers/infiniband/hw/amso1100/c2_provider.c   |    3 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |    2 +
 drivers/infiniband/hw/cxgb4/qp.c               |    3 +
 drivers/infiniband/hw/ehca/ehca_qp.c           |    3 +
 drivers/infiniband/hw/ipath/ipath_qp.c         |    3 +
 drivers/infiniband/hw/mlx4/main.c              |    5 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |   13 +
 drivers/infiniband/hw/mlx4/qp.c                |  341 ++++++++++++-
 drivers/infiniband/hw/mthca/mthca_provider.c   |    3 +
 drivers/infiniband/hw/nes/nes_verbs.c          |    3 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |    5 +
 drivers/infiniband/hw/qib/qib_qp.c             |    5 +
 drivers/infiniband/ulp/ipoib/ipoib.h           |  100 +++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   97 +++--
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |   92 +++-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  552 ++++++++++++++------
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  368 ++++++++++++--
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   34 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  660 +++++++++++++++++++++---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |    2 +-
 include/rdma/ib_verbs.h                        |   26 +-
 23 files changed, 1959 insertions(+), 365 deletions(-)

Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
