From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/9] Start to rely on rdmavt for qp support and other
 verbs
Date: Fri, 22 Jan 2016 12:55:54 -0800
Message-ID: <20160122205437.6530.68843.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set removes the ibport from qib and starts to add in more support for
rdamvt provided verbs functionality. Included is AH notification, pkey support,
and queue pair creation.

This patchset builds on the v2 of "Start to add qp support to rdmavt and other verbs"
patchset.

Changes since v1:
Conflict resolution after rebase onto Doug's k.o/for-4.5

---

Harish Chegondi (9):
      IB/qib: Remove ibport and use rdmavt version
      IB/qib: Implement qib support for AH notification
      IB/qib: Remove mmap from qib
      IB/qib: Use rdmavt pkey verbs function
      IB/qib: Remove qpn, qp tables and related variables from qib
      IB/qib: Delete QIB user context allocation and de-alloction functions
      IB/qib: Remove qib_query_device function
      IB/qib: Use rdmavt send and receive flags
      IB/qib: Remove create qp and create qp table functionality


 drivers/infiniband/hw/qib/Makefile          |    2 
 drivers/infiniband/hw/qib/qib.h             |    3 
 drivers/infiniband/hw/qib/qib_cq.c          |   18 -
 drivers/infiniband/hw/qib/qib_driver.c      |   14 -
 drivers/infiniband/hw/qib/qib_iba6120.c     |    8 
 drivers/infiniband/hw/qib/qib_iba7322.c     |    2 
 drivers/infiniband/hw/qib/qib_init.c        |   10 +
 drivers/infiniband/hw/qib/qib_mad.c         |  240 ++++++------
 drivers/infiniband/hw/qib/qib_mmap.c        |  174 ---------
 drivers/infiniband/hw/qib/qib_qp.c          |  521 ++++++---------------------
 drivers/infiniband/hw/qib/qib_rc.c          |  182 +++++----
 drivers/infiniband/hw/qib/qib_ruc.c         |   32 +-
 drivers/infiniband/hw/qib/qib_sdma.c        |   10 -
 drivers/infiniband/hw/qib/qib_srq.c         |   18 -
 drivers/infiniband/hw/qib/qib_sysfs.c       |   65 +++
 drivers/infiniband/hw/qib/qib_uc.c          |   18 -
 drivers/infiniband/hw/qib/qib_ud.c          |   36 +-
 drivers/infiniband/hw/qib/qib_verbs.c       |  371 ++++++++-----------
 drivers/infiniband/hw/qib/qib_verbs.h       |  187 +---------
 drivers/infiniband/hw/qib/qib_verbs_mcast.c |   28 +
 20 files changed, 668 insertions(+), 1271 deletions(-)
 delete mode 100644 drivers/infiniband/hw/qib/qib_mmap.c

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
