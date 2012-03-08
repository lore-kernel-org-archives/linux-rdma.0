From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/include/iba/ib_types.h: fix comment typos
	and errors
Date: Thu, 08 Mar 2012 15:45:27 -0800
Message-ID: <1331250327.25470.46.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/iba/ib_types.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index 4a11b89..d28de17 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -11201,7 +11201,7 @@ ib_cc_mad_get_cc_key(IN const ib_cc_mad_t * const p_cc_mad)
 
 /****f* IBA Base: Types/ib_cc_mad_get_log_data_ptr
 * NAME
-*	ib_cc_mad_get_mgt_data_ptr
+*	ib_cc_mad_get_log_data_ptr
 *
 * DESCRIPTION
 *	Gets a pointer to the CC MAD's log data area.
@@ -11504,16 +11504,16 @@ typedef struct _ib_sw_cong_setting {
 *		  bits [254..1]: ports [254..1]
 *		  bit 255: reserved
 *
-*	threshold
-*		bits [15..12] Indicates how agressive cong. marking should be
-*		bits [11..0] Reserved
+*	threshold_resv
+*		bits [7..4] Indicates how aggressive cong. marking should be
+*		bits [3..0] Reserved
 *
 *	packet_size
 *		Any packet less than this size won't be marked with FECN
 *
-*	cs_threshold
-*		bits [7..4] How agressive Credit Starvation should be
-*		bits [3..0] Reserved
+*	cs_threshold_resv
+*		bits [15..12] How aggressive Credit Starvation should be
+*		bits [11..0] Reserved
 *
 *	cs_return_delay
 *		Value that controls credit return rate.
-- 
1.7.1




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
