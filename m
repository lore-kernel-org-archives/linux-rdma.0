From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] iser updates for 3.9
Date: Thu, 21 Feb 2013 16:50:07 +0200
Message-ID: <1361458210-856-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

These are the iser updates for the 3.9 merge window, two maintainance 
patches and one patch that allows to run over a VF (e.g in a VM).

Or.

Or Gerlitz (3):
  IB/iser: Use proper define for the commands per lun value advertized to SCSI ML
  IB/iser: Avoid error prints on EAGAIN registration failures
  IB/iser: Enable iser to work when FMRs are not supported

 drivers/infiniband/ulp/iser/iscsi_iser.h  |    2 +-
 drivers/infiniband/ulp/iser/iser_memory.c |    9 +++++----
 drivers/infiniband/ulp/iser/iser_verbs.c  |    8 ++++++--
 3 files changed, 12 insertions(+), 7 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
