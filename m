From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Perfquery can be too noisy.
Date: Thu, 4 Mar 2010 15:01:44 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB477C97283B@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When perfquery is run against fabrics that do not support PortXmitWait, it emits this warning for every port:

ibwarn: [23225] dump_perfcounters: PortXmitWait not indicated so ignore this counter

When running ibcheckerrors on a large fabric, this leads to a flood of warnings.

The proposed patch reduces the warning to a verbose message and, on fabrics that do not support PortXmitWait, it suppresses the output of the XmitWait attribute.

Signed-off-by: Michael Heinz <michaelheinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

diff --git a/infiniband-diags/src/perfquery.c b/infiniband-diags/src/perfquery.c
index 3ae692c..812b4c2 100644
--- a/infiniband-diags/src/perfquery.c
+++ b/infiniband-diags/src/perfquery.c
@@ -282,6 +282,25 @@ static void output_aggregate_perfcounters_ext(ib_portid_t * portid)
               ALL_PORTS, buf);
 }

+static int dump_fields(char *buf, int bufsz, void *data, int start, int end)
+{
+       char val[64];
+       char *s = buf;
+       int n, field;
+       for (field = start; field <= end && bufsz > 0; field++) {
+               mad_decode_field(data, field, val);
+               if (!mad_dump_field(field, s, bufsz, val))
+                       return -1;
+               n = strlen(s);
+               s += n;
+               *s++ = '\n';
+               *s = 0;
+               n++;
+               bufsz -= n;
+       }
+       return (int)(s - buf);
+}
+
 static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
                              ib_portid_t * portid, int port, int aggregate)
 {
@@ -293,8 +312,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
                        IBERROR("perfquery");
                if (!(cap_mask & 0x1000)) {
                        /* if PortCounters:PortXmitWait not supported clear this counter */
-                       IBWARN
-                           ("PortXmitWait not indicated so ignore this counter");
+                       VERBOSE("PortXmitWait not indicated so ignore this counter");
                        perf_count.xmtwait = 0;
                        mad_encode_field(pc, IB_PC_XMT_WAIT_F,
                                         &perf_count.xmtwait);
@@ -302,7 +320,8 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
                if (aggregate)
                        aggregate_perfcounters();
                else
-                       mad_dump_perfcounters(buf, sizeof buf, pc, sizeof pc);
+                       dump_fields(buf, sizeof buf, pc, IB_PC_FIRST_F,
+                               (cap_mask & 0x1000)?IB_PC_LAST_F:IB_PC_RCV_PKTS_F);
        } else {
                if (!(cap_mask & 0x200))        /* 1.2 errata: bit 9 is extended counter support */
                        IBWARN

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
