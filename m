From: Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 0/3] infiniband: ocrdma: Cleanups and unncessary memsets
Date: Sun,  5 Oct 2014 16:33:22 +0200
Message-ID: <1412519605-16106-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jes Sorensen <Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi,

I was reading through some of this code for other reasons and this
stood out and hurt my eyes. I don't have hardware to test on, but it
at least compiles.

Cheers,
Jes


Jes Sorensen (3):
  infinitiband: ocrdma: Don't memset() buffers we just allocated with
    kzalloc()
  infiniband: ocrdma: The kernel has a perfectly good BIT() macro - use
    it
  infiniband: ocrdma: Save the bit environment, spare unncessary
    parenthesis

 drivers/infiniband/hw/ocrdma/ocrdma_hw.c  |  16 +-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h | 238 +++++++++++++++---------------
 2 files changed, 123 insertions(+), 131 deletions(-)

-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
