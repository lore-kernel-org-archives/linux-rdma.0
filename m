From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 0/5] IB/IPoIB: Add multi-queue TSS and RSS support
Date: Sun, 24 Mar 2013 14:43:27 +0200
Message-ID: <1364129012-12198-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Here's V4 of the IPoIB TSS/RSS patch series, basically its very similar to V3, 
with a modification to apply over Mike's IPoIB change in patch #3

The concept of QP groups for TSS/RSS was introduced in the 2012 OFA conference, 
you can take a look on the user mode ethernet session slides 10-14, the author 
didn't use the terms RSS/TSS but that's the intention... see

https://openfabrics.org/resources/document-downloads/presentations/cat_view/57-ofa-documents/23-presentations/81-openfabrics-international-workshops/104-2012-ofa-international-workshop/107-2012-ofa-intl-workshop-wednesday.html 

V3 http://marc.info/?l=linux-rdma&m=136267629831723&w=2
V2 http://marc.info/?l=linux-rdma&m=136007935605406&w=2
V1 http://marc.info/?l=linux-rdma&m=133881081520248&w=2
V0 http://marc.info/?l=linux-rdma&m=133649429821312&w=2

V4 changes:

 - rebased to Roland's for-next which is on 3.9-rc3 
 - changed patch #3 to apply over the change introduced by 
   commit 1ee9e2aa7b "IPoIB: Fix send lockup due to missed TX completion"

V3 changes:

 - rebased to 3.9-rc1

 - fixed few sparse errors on patch on patch #3

 - Implement Sean Hefty's suggestion, that is don't allow to modify parent QP state 
   before all RSS/TSS children were created. Also disallow to destroy the parent QP 
   unless all RSS/TSS children were destroyed.

 - solved a race condition when creation of an ipoib_neigh was attempted from more 
   than one TX context, the change was merged into patch #3

V2 changes:

 - added pre-patch correcting the ipoib_neigh hash function

 - ported to infiniband tree / for-next branch 

 - following commit b63b70d877 "IPoIB: Use a private hash table for path lookup in xmit path" 
   from kernel 3.6, the TX select queue logic for UD neighbours was changed to be based on 
   "full" hashing ala skb_tx_hash that covers L4 too wheres in V1 the queue selection 
   was in the neighbours level. This means that different sessions (TCP/UDP five-tuples)
   would map to different TX rings subject to hashing.

 - for CM neighbours, the queue selection uses the destination IPoIB HW addr as the base 
   for hashing. Previously each ipoib_neigh was assigned a running index upon creation
   and that neighbour was accessed during select queue. Now, we want to issue only 
   ONE ipoib_neigh lookup in the xmit path and do that in start_xmit.

 - added patch #6 to allow for the number of TX and RX rings to be changed at runtime. 
   By supporting ethtool directives to get/set the number of channels.
   move code which is common to device cleanup and device reinit from
   "ipoib_dev_cleanup" to "ipoib_dev_uninit".
       
 - CM TX completions are spreaded among CQs (for NAPI) using hash of the destination 
   IPoIB HW address.

 - use netif_tx bh locking in ipoib_cm_handle_tx_wc and drain_tx_cq. Also, in 
   drain_tx_cq revert from subqueue locking to full locking, did it since 
   __netif_tx_lock doesn't set __QUEUE_STATE_FROZEN_BIT.

 - handle the rare case were the device CM "state" ipoib_cm_admin_enabled() status 
   changes between the time select queue was done to when the transmit routine was 
   called.

 - fixed a race in the CM RX drain/reap logic caused by the change to multiple 
   rings, added detailed comment in ipoib_cm_start_rx_drain to explain the fix.

 - changed the CM code that posts receive buffers (both srq and non-srq
   flows) to use per ring WR and SGE objects, since now buffer re-fill may happen from different
   NAPI contexts

V1 changes:

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

Shlomo Pongratz (5):
  IB/core: Add RSS and TSS QP groups
  IB/mlx4: Add support for RSS and TSS QP groups
  IB/ipoib: Move to multi-queue device
  IB/ipoib: Add RSS and TSS support for datagram mode
  IB/ipoib: Support changing the number of RX/TX rings with ethtool

 drivers/infiniband/core/uverbs_cmd.c           |    1 +
 drivers/infiniband/core/verbs.c                |  118 +++++
 drivers/infiniband/hw/amso1100/c2_provider.c   |    3 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |    2 +
 drivers/infiniband/hw/cxgb4/qp.c               |    3 +
 drivers/infiniband/hw/ehca/ehca_qp.c           |    3 +
 drivers/infiniband/hw/ipath/ipath_qp.c         |    3 +
 drivers/infiniband/hw/mlx4/main.c              |    5 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |   13 +
 drivers/infiniband/hw/mlx4/qp.c                |  344 ++++++++++++-
 drivers/infiniband/hw/mthca/mthca_provider.c   |    3 +
 drivers/infiniband/hw/nes/nes_verbs.c          |    3 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |    5 +
 drivers/infiniband/hw/qib/qib_qp.c             |    5 +
 drivers/infiniband/ulp/ipoib/ipoib.h           |  118 ++++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  208 +++++---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |  160 ++++++-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  550 ++++++++++++++------
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  523 +++++++++++++++++---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   44 ++-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  662 +++++++++++++++++++++---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |    2 +-
 include/rdma/ib_verbs.h                        |   40 ++-
 23 files changed, 2389 insertions(+), 429 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
