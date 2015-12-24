From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 0/4] ocrdma bug fix for linux-4.4-rc
Date: Thu, 24 Dec 2015 13:14:04 -0500
Message-ID: <1450980848-18945-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series fixes for critical bugs introduced due to recent
changes in linux Infiniband stack.

Patch 0001 fixes a vlan-id assignment issues in presence of PFC.
This bug was introduced recently got introduced and it fixes
dbf727de7440 ('IB/core: Use GID table in AH creation and dmac resolution')

Patches 0002 to 0004 fixes a deadlock condition reported by Dough Ledford
while testing linux-4.4-rc5. The deadlock happens when any be2net hook 
(e.g. open/close) is called in parallel to insmod ocrdma.ko.

A. be2net is sending administrative open/close event to ocrdma holding
   device_list_mutex. It does this from ndo_open/ndo_stop hooks of be2net.
   So sequence of locks is rtnl_lock---> device_list lock

B.  When new ocrdma roce device gets registered, infiniband stack now
    takes rtnl_lock in ib_register_device() in GID initialization routines.
    So sequence of locks in this path is device_list lock ---> rtnl_lock.

This improper locking sequence causes deadlock.

Patch 0002 removes an unwanted code to force all active-QPs to error state
using a management command. It is rather simple to let active-QPs to move
to error on their own due to a completion error after the port error is
reported.

Patch 0003 makes IB-dispatch-event mechanism independent of administrative
open/close events injected from be2net driver. Instead of those events, now
ocrdma relies on async-events generated from CNA. Thus, solving the problem
of keeping device_list_mutex busy under rtnl-lock. Moving from administrative
events to CNA async-events does not change the functionality of ocrdma driver
in any way.

Patch 0004 Removes the dead code from be2net driver.

Devesh Sharma (4):
  RDMA/ocrdma: Fix vlan-id assignment in qp parameters
  RDMA/ocrdma: Dispatch only port event when port state changes
  RDMA/ocrdma: Depend on async link events from CNA
  RDMA/be2net: Remove open and close entry points

 drivers/infiniband/hw/ocrdma/ocrdma.h       | 10 +++++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 49 ++++++++++++++++++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |  4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 57 +++++++++++++----------------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 49 +++++++++++++++++++++++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  2 +-
 drivers/net/ethernet/emulex/benet/be.h      |  2 -
 drivers/net/ethernet/emulex/benet/be_main.c |  4 --
 drivers/net/ethernet/emulex/benet/be_roce.c | 36 ------------------
 drivers/net/ethernet/emulex/benet/be_roce.h |  4 +-
 10 files changed, 124 insertions(+), 93 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
