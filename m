From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibmad/fields.c: Change all PortCounter names to match
 the Specification
Date: Tue, 7 Sep 2010 19:37:27 -0700
Message-ID: <20100907193727.83c64672.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 3 Aug 2010 10:40:56 -0700
Subject: [PATCH] libibmad/fields.c: Change all PortCounter names to match the Specification


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 libibmad/src/fields.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
index a5a510a..d992065 100644
--- a/libibmad/src/fields.c
+++ b/libibmad/src/fields.c
@@ -246,24 +246,24 @@ static const ib_field_t ib_mad_f[] = {
 	 */
 	{BITSOFFS(8, 8), "PortSelect", mad_dump_uint},
 	{BITSOFFS(16, 16), "CounterSelect", mad_dump_hex},
-	{BITSOFFS(32, 16), "SymbolErrors", mad_dump_uint},
-	{BITSOFFS(48, 8), "LinkRecovers", mad_dump_uint},
-	{BITSOFFS(56, 8), "LinkDowned", mad_dump_uint},
-	{BITSOFFS(64, 16), "RcvErrors", mad_dump_uint},
-	{BITSOFFS(80, 16), "RcvRemotePhysErrors", mad_dump_uint},
-	{BITSOFFS(96, 16), "RcvSwRelayErrors", mad_dump_uint},
-	{BITSOFFS(112, 16), "XmtDiscards", mad_dump_uint},
-	{BITSOFFS(128, 8), "XmtConstraintErrors", mad_dump_uint},
-	{BITSOFFS(136, 8), "RcvConstraintErrors", mad_dump_uint},
+	{BITSOFFS(32, 16), "SymbolErrorCounter", mad_dump_uint},
+	{BITSOFFS(48, 8), "LinkErrorRecoveryCounter", mad_dump_uint},
+	{BITSOFFS(56, 8), "LinkDownedCounter", mad_dump_uint},
+	{BITSOFFS(64, 16), "PortRcvErrors", mad_dump_uint},
+	{BITSOFFS(80, 16), "PortRcvRemotePhysicalErrors", mad_dump_uint},
+	{BITSOFFS(96, 16), "PortRcvSwitchRelayErrors", mad_dump_uint},
+	{BITSOFFS(112, 16), "PortXmitDiscards", mad_dump_uint},
+	{BITSOFFS(128, 8), "PortXmitConstraintErrors", mad_dump_uint},
+	{BITSOFFS(136, 8), "PortRcvConstraintErrors", mad_dump_uint},
 	{BITSOFFS(144, 8), "CounterSelect2", mad_dump_hex},
-	{BITSOFFS(152, 4), "LinkIntegrityErrors", mad_dump_uint},
-	{BITSOFFS(156, 4), "ExcBufOverrunErrors", mad_dump_uint},
+	{BITSOFFS(152, 4), "LocalLinkIntegrityErrors", mad_dump_uint},
+	{BITSOFFS(156, 4), "ExcessiveBufferOverrunErrors", mad_dump_uint},
 	{BITSOFFS(176, 16), "VL15Dropped", mad_dump_uint},
-	{192, 32, "XmtData", mad_dump_uint},
-	{224, 32, "RcvData", mad_dump_uint},
-	{256, 32, "XmtPkts", mad_dump_uint},
-	{288, 32, "RcvPkts", mad_dump_uint},
-	{320, 32, "XmtWait", mad_dump_uint},
+	{192, 32, "PortXmitData", mad_dump_uint},
+	{224, 32, "PortRcvData", mad_dump_uint},
+	{256, 32, "PortXmitPkts", mad_dump_uint},
+	{288, 32, "PortRcvPkts", mad_dump_uint},
+	{320, 32, "PortXmitWait", mad_dump_uint},
 	{0, 0},			/* IB_PC_LAST_F */
 
 	/*
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
