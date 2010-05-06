From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] management: adding mad_dump_fields to libibmad
Date: Thu, 6 May 2010 13:30:02 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A4740CD9@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A4740CD8@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A4740CD8-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha asked that I re-submit the patches for perfquery in a slightly different format. This is the second of 3 patches.

This patch uses the new mad_dump_fields function to suppress the display of extended attributes when querying switches that do not support them.

Signed off: Michael Heinz

---------- snip ----------
diff --git a/infiniband-diags/src/perfquery.c b/infiniband-diags/src/perfquery.c
index 00ebfff..07a9226 100644
--- a/infiniband-diags/src/perfquery.c
+++ b/infiniband-diags/src/perfquery.c
@@ -302,7 +302,10 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
 		if (aggregate)
 			aggregate_perfcounters();
 		else
-			mad_dump_perfcounters(buf, sizeof buf, pc, sizeof pc);
+			mad_dump_fields(buf, sizeof buf, pc, sizeof pc,
+							IB_PC_FIRST_F,
+							(cap_mask & 0x1000)?IB_PC_LAST_F:(IB_PC_RCV_PKTS_F+1));
+
 	} else {
 		if (!(cap_mask & 0x200))	/* 1.2 errata: bit 9 is extended counter support */
 			IBWARN
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
