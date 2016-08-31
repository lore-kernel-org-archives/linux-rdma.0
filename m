From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/5] IB/hfi1: Fix SGE length for misaligned PIO copy
Date: Wed, 31 Aug 2016 07:24:20 -0700
Message-ID: <20160831142417.27232.19647.stgit@scvm10.sc.intel.com>
References: <20160831141841.27232.61621.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160831141841.27232.61621.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When trying to align the source pointer and there's a byte carry
in an SGE copy, bytes are borrowed from the next quad-word X to
complete the required quad-word copy. Then, the SGE length is
reduced by the number of borrowed bytes. After this, if the
remaining number of bytes from quad-word X (extra bytes) is
greater than the new SGE length, the number of extra bytes needs
to be updated to the new SGE length. Otherwise, when the
SGE length gets updated again after the extra bytes are read to
create the new byte carry, it goes negative, which then becomes
a very large number as the SGE length is an unsigned integer.
This causes SGE buffer to be over-read.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pio_copy.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio_copy.c b/drivers/infiniband/hw/hfi1/pio_copy.c
index 8c25e1b..3a1ef30 100644
--- a/drivers/infiniband/hw/hfi1/pio_copy.c
+++ b/drivers/infiniband/hw/hfi1/pio_copy.c
@@ -771,6 +771,9 @@ void seg_pio_copy_mid(struct pio_buf *pbuf, const void *from, size_t nbytes)
 			read_extra_bytes(pbuf, from, to_fill);
 			from += to_fill;
 			nbytes -= to_fill;
+			/* may not be enough valid bytes left to align */
+			if (extra > nbytes)
+				extra = nbytes;
 
 			/* ...now write carry */
 			dest = pbuf->start + (pbuf->qw_written * sizeof(u64));
@@ -798,6 +801,15 @@ void seg_pio_copy_mid(struct pio_buf *pbuf, const void *from, size_t nbytes)
 			read_low_bytes(pbuf, from, extra);
 			from += extra;
 			nbytes -= extra;
+			/*
+			 * If no bytes are left, return early - we are done.
+			 * NOTE: This short-circuit is *required* because
+			 * "extra" may have been reduced in size and "from"
+			 * is not aligned, as required when leaving this
+			 * if block.
+			 */
+			if (nbytes == 0)
+				return;
 		}
 
 		/* at this point, from is QW aligned */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
