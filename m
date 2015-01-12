From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH TRIVIAL libibmad] fields.c: Fix commentary typo
Date: Mon, 12 Jan 2015 14:08:25 -0500
Message-ID: <54B41BA9.4050005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/fields.c b/src/fields.c
index 33a6364..9965811 100644
--- a/src/fields.c
+++ b/src/fields.c
@@ -835,7 +835,7 @@ static const ib_field_t ib_mad_f[] = {
 	{BITSOFFS(16, 16), "ThresholdEventCounter", mad_dump_uint},
 	{BITSOFFS(32, 16), "ThresholdCongestionEventMap", mad_dump_hex},
 	/* XXX: Q3/2010 errata lists offset 48, but that means field is not
-	 * world aligned.  Assume will be aligned to offset 64 later.
+	 * word aligned.  Assume will be aligned to offset 64 later.
 	 */
 	{BITSOFFS(64, 32), "CurrentTimeStamp", mad_dump_uint},
 	{0, 0},			/* IB_CC_CONGESTION_LOG_CA_LAST_F */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
