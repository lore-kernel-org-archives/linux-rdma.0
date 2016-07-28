From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 04/13] IB/hfi1: Add parameter names to function declarations
Date: Thu, 28 Jul 2016 12:27:28 -0400
Message-ID: <1469723257-27317-5-git-send-email-ira.weiny@intel.com>
References: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469723257-27317-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Parameter names to function declarations make it more clear
what those parameters do.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 63ce587d6f94..6fb86fee0701 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1700,9 +1700,11 @@ void shutdown_led_override(struct hfi1_pportdata *ppd);
  */
 #define DEFAULT_RCVHDR_ENTSIZE 32
 
-bool hfi1_can_pin_pages(struct hfi1_devdata *, u32, u32);
-int hfi1_acquire_user_pages(unsigned long, size_t, bool, struct page **);
-void hfi1_release_user_pages(struct mm_struct *, struct page **, size_t, bool);
+bool hfi1_can_pin_pages(struct hfi1_devdata *dd, u32 nlocked, u32 npages);
+int hfi1_acquire_user_pages(unsigned long vaddr, size_t npages, bool writable,
+			    struct page **pages);
+void hfi1_release_user_pages(struct mm_struct *mm, struct page **p,
+			     size_t npages, bool dirty);
 
 static inline void clear_rcvhdrtail(const struct hfi1_ctxtdata *rcd)
 {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
