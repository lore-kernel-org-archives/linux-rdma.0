From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Fixe for rmmod crash and warnings.
Date: Mon, 28 Oct 2013 17:29:33 +0530
Message-ID: <5994768f-1112-47df-8367-a3397b67c951@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Please neglect my last two patches. I am resending those.

Naresh Gottumukkala (2):
  RDMA/ocrdma: Remove redundant check in ocrdma_build_fr.
  RDMA/ocrdma: Fix the driver crash during rmmod.

 drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 7 ++++---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 4 +---
 2 files changed, 5 insertions(+), 6 deletions(-)

-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
