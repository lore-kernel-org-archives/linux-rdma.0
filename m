From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] IB/core: introduce ib_mtu_int_to_enum
Date: Mon, 26 Dec 2016 08:40:56 +0200
Message-ID: <1482734458-32131-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As the functionality to convert the MTU from a number to enum_ib_mtu
is ubiquitous, define a dedicated function and remove the duplicated
code (first patch).
Note that the patch doesn't include ocrdma, qib and hfi1 that check
for an exact match of the int mtu and return a different default value
(or error). I leave it to them to adapt to the new function, if at all.

The second patch fixes a qedr bug using the newly introduced function.

Ram Amrani (2):
  IB/core: add the function ib_mtu_int_to_enum
  qedr: fix MTU returned from QP query

 drivers/infiniband/hw/cxgb3/iwch_provider.c | 11 +----------
 drivers/infiniband/hw/cxgb4/provider.c      | 11 +----------
 drivers/infiniband/hw/i40iw/i40iw_verbs.c   | 11 +----------
 drivers/infiniband/hw/nes/nes_verbs.c       | 12 +-----------
 drivers/infiniband/hw/qedr/verbs.c          |  2 +-
 include/rdma/ib_verbs.h                     | 15 +++++++++++++++
 6 files changed, 20 insertions(+), 42 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
