From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 00/11] Critical bug fixes for RDMA/cxgb4
Date: Mon,  7 Jan 2013 18:41:49 +0530
Message-ID: <1357564320-15022-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This patch series fixes critical bugs for RDMA/cxgb4. It fixes bugs in following
areas:
- Aborts connection in error scenarios
- Logs only critical errors
- Holds the reference of the QP untill TID is released
- Avoids race condition in endpoint timeout  
- Fixes reconnect and version mismatch related bugs in MPAv2 related logic
- Avoids removing hwtid which was not inserted
- Addresses several sparse warnings

The patch-series is based on Roland's infiniband tree for-next branch.

Thanks,
Vipul Pandya

Vipul Pandya (11):
  RDMA/cxgb4: abort connections that receive unexpected streaming mode
    data
  RDMA/cxgb4: abort connections when moving to ERROR state.
  RDMA/cxgb4: Display streaming mode error only if detected in RTS.
  RDMA/cxgb4: keep qp referenced until TID released.
  RDMA/cxgb4: Always log async errors.
  RDMA/cxgb4: only log rx_data warnings if cpl status is non zero.
  RDMA/cxgb4: endpoint timeout race condition
  RDMA/cxgb4: don't reconnect on abort for mpa_rev 1
  RDMA/cxgb4: Don't wakeup threads for MPAv2
  RDMA/cxgb4: Insert hwtid in pass_accept_req instead in pass_establish
  RDMA/cxgb4: Address sparse warnings

 drivers/infiniband/hw/cxgb4/cm.c       |  170 +++++++++++++++++++-------------
 drivers/infiniband/hw/cxgb4/device.c   |    3 +-
 drivers/infiniband/hw/cxgb4/ev.c       |    8 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    2 +
 drivers/infiniband/hw/cxgb4/qp.c       |    1 +
 5 files changed, 113 insertions(+), 71 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
