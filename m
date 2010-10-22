From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] [IB/QIB] Fix QIB early error reporting prints
Date: Fri, 22 Oct 2010 14:41:24 -0600
Message-ID: <20101022204124.GB30241@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Noticed this odd looking thing in dmesg:

ib_qib 0000:02:00.0: <3>ib_qib: Unable to enable pcie error reporting: -5

Which is due to a bad use of dev_info.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 3593983..0268326 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1402,7 +1402,7 @@ extern struct mutex qib_mutex;
  */
 #define qib_early_err(dev, fmt, ...) \
 	do { \
-		dev_info(dev, KERN_ERR QIB_DRV_NAME ": " fmt, ##__VA_ARGS__); \
+		dev_err(dev, fmt, ##__VA_ARGS__); \
 	} while (0)
 
 #define qib_dev_err(dd, fmt, ...) \
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
