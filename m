From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/uverbs: Use the standard kConfig format for experimental
Date: Fri, 2 Feb 2018 14:40:03 -0700
Message-ID: <20180202214003.GA28856@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We really don't want people turning this on just yet, make it very
clear with capital letters.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index fe63af421e798d..857beed1459ce7 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -35,7 +35,7 @@ config INFINIBAND_USER_ACCESS
 	  rdma-core <https://github.com/linux-rdma/rdma-core>.
 
 config INFINIBAND_EXP_USER_ACCESS
-	bool "Allow experimental support for Infiniband ABI"
+	bool "Enable the full uverbs ioctl interface (EXPERIMENTAL)"
 	depends on INFINIBAND_USER_ACCESS
 	---help---
 	  IOCTL based ABI support for Infiniband. This allows userspace
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
