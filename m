From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH TRIVIAL infiniband-diags] ibportstate.c: When not switch, port
 can be router port
Date: Fri, 23 Sep 2016 09:17:10 -0400
Message-ID: <f44f2a4f-15f7-6ae5-d1fb-7af0a77aeaee@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Indicate PortInfo is on CA/RT port rather than just CA port when not
on Switch port. RT is what's used by ibnetdiscover for router nodes.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibportstate.c b/src/ibportstate.c
index cb47aa9..cfb8be7 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -522,9 +522,9 @@ int main(int argc, char **argv)
 		IBEXIT("Can't set M_Key fields on switch port != 0");
 
 	if (port_op != QUERY || changed)
-		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA");
+		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA/RT");
 	else
-		printf("%s PortInfo:\n", is_switch ? "Switch" : "CA");
+		printf("%s PortInfo:\n", is_switch ? "Switch" : "CA/RT");
 	espeed_cap = get_port_info(&portid, data, portnum, is_switch);
 	show_port_info(&portid, data, portnum, espeed_cap, is_switch);
 	if (is_mlnx_ext_port_info_supported(devid)) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
