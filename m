From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/8] i40iw: Correct ARP index mask
Date: Fri, 17 Nov 2017 10:46:53 -0600
Message-ID: <20171117164657.14824-5-henry.orosco@intel.com>
References: <20171117164657.14824-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171117164657.14824-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

ARP Index is 16 bits wide not 12 bits. Adjust
the mask for the full 16 bits.

Fixes: 4e9042e647ff ("i40iw: add hw and utils files")
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_d.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_d.h b/drivers/infiniband/hw/i40iw/i40iw_d.h
index 1077b78..029083c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_d.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_d.h
@@ -1114,7 +1114,7 @@
 #define I40IWQPC_VLANTAG_MASK (0xffffULL << I40IWQPC_VLANTAG_SHIFT)
 
 #define I40IWQPC_ARPIDX_SHIFT 48
-#define I40IWQPC_ARPIDX_MASK (0xfffULL << I40IWQPC_ARPIDX_SHIFT)
+#define I40IWQPC_ARPIDX_MASK (0xffffULL << I40IWQPC_ARPIDX_SHIFT)
 
 #define I40IWQPC_FLOWLABEL_SHIFT 0
 #define I40IWQPC_FLOWLABEL_MASK (0xfffffUL << I40IWQPC_FLOWLABEL_SHIFT)
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
