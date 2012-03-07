From: <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] be2net: Added functionality to support RoCE driver
Date: Wed, 7 Mar 2012 23:15:14 +0530
Message-ID: <2659ae1d-6cbb-4fbf-98ef-d80ffee2714d@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

This patch adds functionality to support RoCE (RDMA over Ethernet) driver.
- Detecting RoCE supported adapters and creating linked list of them.
- Enabling 5 more MSIX vectors for RoCE functionality.
- Calling registered callback functions of the RoCE driver
  whenever new RoCE capable device is added/removed.
- Notifying events to RoCE driver when interface is up or down.
- Provides device specific details to RoCE driver for each roce device.
- Provides low level mailbox command to be issued by RoCE driver
  before it can have it own MQ.

Parav Pandit (2):
  be2net: Added function to issue mailbox cmd on MQ.
  be2net: Added functionality to support RoCE driver

 drivers/net/ethernet/emulex/benet/Makefile  |    2 +-
 drivers/net/ethernet/emulex/benet/be.h      |   28 ++++-
 drivers/net/ethernet/emulex/benet/be_cmds.c |   39 ++++++
 drivers/net/ethernet/emulex/benet/be_cmds.h |    1 +
 drivers/net/ethernet/emulex/benet/be_hw.h   |    4 +-
 drivers/net/ethernet/emulex/benet/be_main.c |   83 +++++++++++--
 drivers/net/ethernet/emulex/benet/be_roce.c |  185 +++++++++++++++++++++++++++
 drivers/net/ethernet/emulex/benet/be_roce.h |   75 +++++++++++
 8 files changed, 404 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/ethernet/emulex/benet/be_roce.c
 create mode 100644 drivers/net/ethernet/emulex/benet/be_roce.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
