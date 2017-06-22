From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 2/3] libibmad: Support the decode of
 PortInfo:CapabilityMask2
Date: Thu, 22 Jun 2017 10:37:06 -0400
Message-ID: <fd593f25-4039-3cc9-25a2-f2ef8faf2b04@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


IsSetNodeDescriptionSupported and IsPortInfoExtendedSupported
are part of IBA 1.3

IsVirtualizationSupported was added by Annex A18: Virtualization

IsSwitchPortStateTableSupported was added by MgtWG erratum #9316
IsLinkWidth2xSupported was added by MgtWG erratum #9309

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibmad/include/infiniband/mad.h |  2 +-
 libibmad/src/dump.c               | 21 +++++++++++++++++++++
 libibmad/src/fields.c             |  2 +-
 libibmad/src/libibmad.map         |  1 +
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniband/mad.h
index 9bd6e20..50c5bc5 100644
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -1651,7 +1651,7 @@ MAD_EXPORT ib_mad_dump_fn
     mad_dump_linkspeed, mad_dump_linkspeedsup, mad_dump_linkspeeden,
     mad_dump_linkspeedext, mad_dump_linkspeedextsup, mad_dump_linkspeedexten,
     mad_dump_portstate, mad_dump_portstates,
-    mad_dump_physportstate, mad_dump_portcapmask,
+    mad_dump_physportstate, mad_dump_portcapmask, mad_dump_portcapmask2,
     mad_dump_mtu, mad_dump_vlcap, mad_dump_opervls,
     mad_dump_node_type, mad_dump_sltovl, mad_dump_vlarbitration,
     mad_dump_nodedesc, mad_dump_nodeinfo, mad_dump_portinfo,
diff --git a/libibmad/src/dump.c b/libibmad/src/dump.c
index 8e1f5d1..24878a6 100644
--- a/libibmad/src/dump.c
+++ b/libibmad/src/dump.c
@@ -616,6 +616,27 @@ void mad_dump_portcapmask(char *buf, int bufsz, void *val, int valsz)
 		*(--s) = 0;
 }
 
+void mad_dump_portcapmask2(char *buf, int bufsz, void *val, int valsz)
+{
+	int mask = *(int *)val;
+	char *s = buf;
+
+	s += sprintf(s, "0x%x\n", mask);
+	if (mask & (1 << 0))
+		s += sprintf(s, "\t\t\t\tIsSetNodeDescriptionSupported\n");
+	if (mask & (1 << 1))
+		s += sprintf(s, "\t\t\t\tIsPortInfoExtendedSupported\n");
+	if (mask & (1 << 2))
+		s += sprintf(s, "\t\t\t\tIsVirtualizationSupported\n");
+	if (mask & (1 << 3))
+		s += sprintf(s, "\t\t\t\tIsSwitchPortStateTableSupported\n");
+	if (mask & (1 << 4))
+		s += sprintf(s, "\t\t\t\tIsLinkWidth2xSupported\n");
+
+	if (s != buf)
+		*(--s) = 0;
+}
+
 void mad_dump_bitfield(char *buf, int bufsz, void *val, int valsz)
 {
 	snprintf(buf, bufsz, "0x%x", *(uint32_t *) val);
diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
index 8273f97..b8a5302 100644
--- a/libibmad/src/fields.c
+++ b/libibmad/src/fields.c
@@ -529,7 +529,7 @@ static const ib_field_t ib_mad_f[] = {
 	/*
 	 * More PortInfo fields
 	 */
-	{BITSOFFS(480, 16), "CapabilityMask2", mad_dump_hex},
+	{BITSOFFS(480, 16), "CapabilityMask2", mad_dump_portcapmask2},
 	{BITSOFFS(496, 4), "LinkSpeedExtActive", mad_dump_linkspeedext},
 	{BITSOFFS(500, 4), "LinkSpeedExtSupported", mad_dump_linkspeedextsup},
 	{BITSOFFS(507, 5), "LinkSpeedExtEnabled", mad_dump_linkspeedexten},
diff --git a/libibmad/src/libibmad.map b/libibmad/src/libibmad.map
index 3240a7b..454e37c 100644
--- a/libibmad/src/libibmad.map
+++ b/libibmad/src/libibmad.map
@@ -34,6 +34,7 @@ IBMAD_1.3 {
 		mad_dump_perfcounters_rcv_err;
 		mad_dump_physportstate;
 		mad_dump_portcapmask;
+		mad_dump_portcapmask2;
 		mad_dump_portinfo;
 		mad_dump_portsamples_control;
 		mad_dump_portsamples_result;
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
