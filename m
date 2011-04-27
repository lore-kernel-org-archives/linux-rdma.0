From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: ib_types.h add defines for PM CPI
 SamplesOnlySupported and PortCountersXmitWaitSupported
Date: Tue, 26 Apr 2011 17:45:50 -0700
Message-ID: <20110426174550.0cf20b57.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 26 Apr 2011 17:35:38 -0700
Subject: [PATCH] opensm: ib_types.h add defines for PM CPI SamplesOnlySupported and PortCountersXmitWaitSupported

Per IBTA v1.2.1 section 16.1.3.1

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/iba/ib_types.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index 24f5662..b713f33 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -3489,6 +3489,8 @@ typedef struct _ib_class_port_info {
 #define IB_PM_ALL_PORT_SELECT			(CL_HTON16(((uint16_t)1)<<8))
 #define IB_PM_EXT_WIDTH_SUPPORTED		(CL_HTON16(((uint16_t)1)<<9))
 #define IB_PM_EXT_WIDTH_NOIETF_SUP		(CL_HTON16(((uint16_t)1)<<10))
+#define IB_PM_SAMPLES_ONLY_SUP			(CL_HTON16(((uint16_t)1)<<11))
+#define IB_PM_PC_XMIT_WAIT_SUP			(CL_HTON16(((uint16_t)1)<<12))
 
 /****f* IBA Base: Types/ib_class_set_resp_time_val
 * NAME
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
