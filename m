From: Pramod Kumar <pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/2] : cxgb4/rdma patches
Date: Thu, 16 Oct 2014 15:06:27 +0530
Message-ID: <1413452189-5427-1-git-send-email-pramod@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Pramod Kumar <pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PATCH 1/2: Handles debug interface buffer size. Since IPv6 
size is bigger than IPv4 hence increased debug interface 
buffer size.

PATCH 2/2: 0B MRs need some tweaks to work correctly with HW
hence handling the same throug this patch.

Pramod Kumar (2):
  cxgb4/rdma:Increase epd buff size for debug interface
  cxgb4/rdma: configure 0B MRs to match HW implementation

 drivers/infiniband/hw/cxgb4/device.c |    2 +-
 drivers/infiniband/hw/cxgb4/mem.c    |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
