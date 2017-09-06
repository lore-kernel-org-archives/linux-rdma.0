From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] libibmad/fields.c:
 PortInfo:McastPkeyTrapSuppressionEnabled is 2 bits in IBA 1.3
Date: Wed, 6 Sep 2017 07:56:38 -0400
Message-ID: <6e774db9-11d3-8f2f-ab50-d3c661ce102d@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Per MgtWG comment #4576

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibmad/src/fields.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
index e0333f8..bf48689 100644
--- a/libibmad/src/fields.c
+++ b/libibmad/src/fields.c
@@ -162,7 +162,7 @@ static const ib_field_t ib_mad_f[] = {
 	{BITSOFFS(384, 16), "QkeyViolations", mad_dump_uint},
 	{BITSOFFS(400, 8), "GuidCap", mad_dump_uint},
 	{BITSOFFS(408, 1), "ClientReregister", mad_dump_uint},
-	{BITSOFFS(409, 1), "McastPkeyTrapSuppressionEnabled", mad_dump_uint},
+	{BITSOFFS(409, 2), "McastPkeyTrapSuppressionEnabled", mad_dump_uint},
 	{BITSOFFS(411, 5), "SubnetTimeout", mad_dump_uint},
 	{BITSOFFS(419, 5), "RespTimeVal", mad_dump_uint},
 	{BITSOFFS(424, 4), "LocalPhysErr", mad_dump_uint},
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
