From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 1/6] ibdiag_common.c: In
 is_port_info_extended_supported, query PortInfo for port, 0 when node is a
 switch for HDR support
Date: Tue, 28 Nov 2017 17:11:39 -0500
Message-ID: <94344ecd-c036-9927-b3a5-e21201de03ec@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Per MgtWG comment #9363

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibmad/src/dump.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libibmad/src/dump.c b/libibmad/src/dump.c
index 2244f38..1f41e62 100644
--- a/libibmad/src/dump.c
+++ b/libibmad/src/dump.c
@@ -632,6 +632,8 @@ void mad_dump_portcapmask2(char *buf, int bufsz, void *val, int valsz)
 		s += sprintf(s, "\t\t\t\tIsSwitchPortStateTableSupported\n");
 	if (mask & (1 << 4))
 		s += sprintf(s, "\t\t\t\tIsLinkWidth2xSupported\n");
+	if (mask & (1 << 5))
+		s += sprintf(s, "\t\t\t\tIsLinkSpeedHDRSupported\n");
 
 	if (s != buf)
 		*(--s) = 0;
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
