From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V3 3/8] infiniband-diags/ibportstate.c: Display MKey, lease, and protect bits
Date: Wed, 30 May 2012 10:21:32 -0700
Message-ID: <1338398497-12444-3-git-send-email-foraker1@llnl.gov>
References: <1338398414.11948.29.camel@auk75.llnl.gov>
 <1338398497-12444-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338398497-12444-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

By default, display mkey lease and protection bits.
With a flag, also display mkey itself

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 doc/rst/ibportstate.8.in.rst |    1 +
 src/ibportstate.c            |   30 ++++++++++++++++++++++++------
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/doc/rst/ibportstate.8.in.rst b/doc/rst/ibportstate.8.in.rst
index 3af2aaa..1fc9bb2 100644
--- a/doc/rst/ibportstate.8.in.rst
+++ b/doc/rst/ibportstate.8.in.rst
@@ -89,6 +89,7 @@ Debugging flags
 .. include:: common/opt_h.rst
 .. include:: common/opt_d.rst
 .. include:: common/opt_e.rst
+.. include:: common/opt_K.rst
 .. include:: common/opt_v.rst
 .. include:: common/opt_V.rst
 
diff --git a/src/ibportstate.c b/src/ibportstate.c
index 5559d18..b2df212 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -142,7 +142,7 @@ static int get_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
 }
 
 static void show_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
-			   int espeed_cap)
+			   int espeed_cap, int is_switch)
 {
 	char buf[2300];
 	char val[64];
@@ -201,18 +201,36 @@ static void show_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
 			       val);
 		sprintf(buf + strlen(buf), "%s", "\n");
 	}
+	if (!is_switch || portnum == 0) {
+		if (show_keys) {
+			mad_decode_field(data, IB_PORT_MKEY_F, val);
+			mad_dump_field(IB_PORT_MKEY_F, buf + strlen(buf),
+			    	       sizeof buf - strlen(buf), val);
+		} else 
+			snprint_field(buf+strlen(buf), sizeof(buf)-strlen(buf),
+				      IB_PORT_MKEY_F, 32, NOT_DISPLAYED_STR);
+		sprintf(buf+strlen(buf), "%s", "\n");
+		mad_decode_field(data, IB_PORT_MKEY_LEASE_F, val);
+		mad_dump_field(IB_PORT_MKEY_LEASE_F, buf + strlen(buf),
+			       sizeof buf - strlen(buf), val);
+		sprintf(buf+strlen(buf), "%s", "\n");
+		mad_decode_field(data, IB_PORT_MKEY_PROT_BITS_F, val);
+		mad_dump_field(IB_PORT_MKEY_PROT_BITS_F, buf + strlen(buf),
+			       sizeof buf - strlen(buf), val);
+		sprintf(buf+strlen(buf), "%s", "\n");
+	}
 
 	printf("# Port info: %s port %d\n%s", portid2str(dest), portnum, buf);
 }
 
 static void set_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
-			  int espeed_cap)
+			  int espeed_cap, int is_switch)
 {
 	if (!smp_set_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
 		IBERROR("smp set portinfo failed");
 
 	printf("\nAfter PortInfo set:\n");
-	show_port_info(dest, data, portnum, espeed_cap);
+	show_port_info(dest, data, portnum, espeed_cap, is_switch);
 }
 
 static void get_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
@@ -460,7 +478,7 @@ int main(int argc, char **argv)
 	else
 		printf("%s PortInfo:\n", is_switch ? "Switch" : "CA");
 	espeed_cap = get_port_info(&portid, data, portnum, is_switch);
-	show_port_info(&portid, data, portnum, espeed_cap);
+	show_port_info(&portid, data, portnum, espeed_cap, is_switch);
 	if (is_mlnx_ext_port_info_supported(devid)) {
 		get_ext_port_info(&portid, data2, portnum);
 		show_ext_port_info(&portid, data2, portnum);
@@ -527,7 +545,7 @@ int main(int argc, char **argv)
 				      fdr10);
 			set_ext_port_info(&portid, data2, portnum);
 		}
-		set_port_info(&portid, data, portnum, is_switch);
+		set_port_info(&portid, data, portnum, espeed_cap, is_switch);
 
 	} else if (is_switch && portnum) {
 		/* Now, make sure PortState is Active */
@@ -596,7 +614,7 @@ int main(int argc, char **argv)
 				get_ext_port_info(&peerportid, data2,
 						  peerlocalportnum);
 			show_port_info(&peerportid, data, peerlocalportnum,
-				       peer_espeed_cap);
+				       peer_espeed_cap, is_peer_switch);
 			if (is_mlnx_ext_port_info_supported(rem_devid))
 				show_ext_port_info(&peerportid, data2,
 						   peerlocalportnum);
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
