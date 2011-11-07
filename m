From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/man/torus-2QoS.conf.5.in: Update portgroup_max_ports
 section
Date: Mon, 07 Nov 2011 13:45:39 -0500
Message-ID: <4EB82753.7060001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


for host ports including switch port 0 

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
diff --git a/man/torus-2QoS.conf.5.in b/man/torus-2QoS.conf.5.in
index df38ad3..d806ab5 100644
--- a/man/torus-2QoS.conf.5.in
+++ b/man/torus-2QoS.conf.5.in
@@ -1,4 +1,4 @@
-.TH TORUS\-2QOS.CONF 5 "November 11, 2010" "OpenIB" "OpenIB Management"
+.TH TORUS\-2QOS.CONF 5 "November 7, 2011" "OpenIB" "OpenIB Management"
 .
 .SH NAME
 torus\-2QoS.conf \- Torus-2QoS configuration for OpenSM subnet manager
@@ -138,6 +138,10 @@ The default value is 16.
 Torus-2QoS will log an error message during topology discovery if this
 parameter needs to be increased.
 If this keyword appears multiple times, the last instance prevails.
+.P
+Note that the switch management port (switch port 0) gets put into
+the same port group with the host ports, so if you have 16 host ports per
+switch, portgroup_max_ports would need to be at least 17.
 .RE
 .
 .P
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
