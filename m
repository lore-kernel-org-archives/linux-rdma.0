From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 1/9] i40iw: Set MAX_IRD_SIZE to 64
Date: Fri, 22 Dec 2017 09:46:54 -0600
Message-ID: <20171222154702.12632-2-shiraz.saleem@intel.com>
References: <20171222154702.12632-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222154702.12632-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Increase I40IW_MAX_IRD_SIZE to 64 which is the device limit.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_user.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
index e73efc5..5467c6f 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_user.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
@@ -72,7 +72,7 @@ enum i40iw_device_capabilities_const {
 	I40IW_MAX_SQ_PAYLOAD_SIZE =		2145386496,
 	I40IW_MAX_INLINE_DATA_SIZE =		48,
 	I40IW_MAX_PUSHMODE_INLINE_DATA_SIZE =	48,
-	I40IW_MAX_IRD_SIZE =			63,
+	I40IW_MAX_IRD_SIZE =			64,
 	I40IW_MAX_ORD_SIZE =			127,
 	I40IW_MAX_WQ_ENTRIES =			2048,
 	I40IW_Q2_BUFFER_SIZE =			(248 + 100),
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
