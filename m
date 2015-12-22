From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH V5 1/2] staging/rdma/hfi1: add dd_dev_dbg
Date: Mon, 21 Dec 2015 20:31:52 -0500
Message-ID: <1450747913-27399-2-git-send-email-ira.weiny@intel.com>
References: <1450747913-27399-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450747913-27399-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

To be used in future patches add dd_dev_dbg.  dd_* functions properly decode
the hfi1_devdata structure used throughout the driver

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/hfi.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 62157cc34727..52dcc87689f1 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1804,6 +1804,10 @@ static inline u64 hfi1_pkt_base_sdma_integrity(struct hfi1_devdata *dd)
 	dev_info(&(dd)->pcidev->dev, "%s: " fmt, \
 			get_unit_name((dd)->unit), ##__VA_ARGS__)
 
+#define dd_dev_dbg(dd, fmt, ...) \
+	dev_dbg(&(dd)->pcidev->dev, "%s: " fmt, \
+		get_unit_name((dd)->unit), ##__VA_ARGS__)
+
 #define hfi1_dev_porterr(dd, port, fmt, ...) \
 	dev_err(&(dd)->pcidev->dev, "%s: IB%u:%u " fmt, \
 			get_unit_name((dd)->unit), (dd)->unit, (port), \
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
