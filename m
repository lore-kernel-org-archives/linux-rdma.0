From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/3] infiniband-diags: Make ibportstate support
	displaying/changing MKey, lease, and protect bits
Date: Tue, 06 Mar 2012 12:24:29 -0800
Message-ID: <1331065469.10889.11.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Displaying/changing are both supported for the 
MKey itself, plus lease and protect bits

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 src/ibportstate.c |   64
+++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/src/ibportstate.c b/src/ibportstate.c
index ec6b823..b5a1a98 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -64,6 +64,9 @@ enum port_ops {
 	LID,
 	SMLID,
 	LMC,
+	MKEY,
+	MKEYLEASE,
+	MKEYPROT,
 };
 
 struct ibmad_port *srcport;
@@ -76,6 +79,10 @@ int smlid;
 int lmc;
 int mtu;
 int vls = 0; /* no state change */
+int mkeyfake; /* Just a placeholder */
+uint64_t mkey;
+int mkeylease;
+int mkeyprot;
 
 struct {
 	const char *name;
@@ -98,6 +105,9 @@ struct {
 	{"lid", &lid, 0},	/* LID */
 	{"smlid", &smlid, 0},	/* SMLID */
 	{"lmc", &lmc, 0},	/* LMC */
+	{"mkey", &mkeyfake, 0},	/* MKEY */
+	{"mkeylease", &mkeylease, 0},	/* MKEY LEASE */
+	{"mkeyprot", &mkeyprot, 0},	/* MKEY PROTECT BITS */
 };
 
 #define NPORT_ARGS (sizeof(port_args) / sizeof(port_args[0]))
@@ -142,7 +152,7 @@ static int get_port_info(ib_portid_t * dest, uint8_t
* data, int portnum,
 }
 
 static void show_port_info(ib_portid_t * dest, uint8_t * data, int
portnum,
-			   int espeed_cap)
+			   int espeed_cap, int is_switch)
 {
 	char buf[2300];
 	char val[64];
@@ -201,18 +211,32 @@ static void show_port_info(ib_portid_t * dest,
uint8_t * data, int portnum,
 			       val);
 		sprintf(buf + strlen(buf), "%s", "\n");
 	}
+	if (!is_switch || portnum == 0) {
+		mad_decode_field(data, IB_PORT_MKEY_F, val);
+		mad_dump_field(IB_PORT_MKEY_F, buf + strlen(buf),
+			       sizeof buf - strlen(buf), val);
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
 
 static void set_port_info(ib_portid_t * dest, uint8_t * data, int
portnum,
-			  int espeed_cap)
+			  int espeed_cap, int is_switch)
 {
 	if (!smp_set_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
 		IBERROR("smp set portinfo failed");
 
 	printf("\nAfter PortInfo set:\n");
-	show_port_info(dest, data, portnum, espeed_cap);
+	show_port_info(dest, data, portnum, espeed_cap, is_switch);
 }
 
 static void get_ext_port_info(ib_portid_t * dest, uint8_t * data, int
portnum)
@@ -351,7 +375,7 @@ int main(int argc, char **argv)
 	long val;
 	char usage_args[] = "<dest dr_path|lid|guid> <portnum> [<op>]\n"
 	    "\nSupported ops: enable, disable, reset, speed, width, query,\n"
-	    "\tdown, arm, active, vls, mtu, lid, smlid, lmc\n";
+	    "\tdown, arm, active, vls, mtu, lid, smlid, lmc, mkey, mkeylease,
mkeyprot\n";
 	const char *usage_examples[] = {
 		"3 1 disable\t\t\t# by lid",
 		"-G 0x2C9000100D051 1 enable\t# by guid",
@@ -441,6 +465,18 @@ int main(int argc, char **argv)
 			case LMC:
 				if (val < 0 || val > 7)
 					IBERROR("invalid lmc value %ld", val);
+				break;
+			case MKEY:
+				/* port_args is using ints, but we need uint64 */
+				mkey = strtoll(argv[i], 0, 0);
+				break;
+			case MKEYLEASE:
+				if (val < 0 || val > 0xFFFF)
+					IBERROR("invalid mkey lease time %ld", val);
+				break;
+			case MKEYPROT:
+				if (val < 0 || val > 3)
+					IBERROR("invalid mkey protection bit setting %ld", val);
 			}
 			*port_args[j].val = (int)val;
 			changed = 1;
@@ -455,12 +491,16 @@ int main(int argc, char **argv)
 	is_switch = get_node_info(&portid, data);
 	devid = (uint16_t) mad_get_field(data, 0, IB_NODE_DEVID_F);
 
+	if ((port_args[MKEY].set || port_args[MKEYLEASE].set ||
+	     port_args[MKEYPROT].set) && is_switch && portnum != 0)
+		IBERROR("Can't set M_Key fields on switch port != 0");
+
 	if (port_op != QUERY || changed)
 		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA");
 	else
 		printf("%s PortInfo:\n", is_switch ? "Switch" : "CA");
 	espeed_cap = get_port_info(&portid, data, portnum, is_switch);
-	show_port_info(&portid, data, portnum, espeed_cap);
+	show_port_info(&portid, data, portnum, espeed_cap, is_switch);
 	if (is_mlnx_ext_port_info_supported(devid)) {
 		get_ext_port_info(&portid, data2, portnum);
 		show_ext_port_info(&portid, data2, portnum);
@@ -527,7 +567,17 @@ int main(int argc, char **argv)
 				      fdr10);
 			set_ext_port_info(&portid, data2, portnum);
 		}
-		set_port_info(&portid, data, portnum, is_switch);
+
+		if (port_args[MKEY].set)
+			mad_set_field64(data, 0, IB_PORT_MKEY_F, mkey);
+		if (port_args[MKEYLEASE].set)
+			mad_set_field(data, 0, IB_PORT_MKEY_LEASE_F,
+				      mkeylease);
+		if (port_args[MKEYPROT].set)
+			mad_set_field(data, 0, IB_PORT_MKEY_PROT_BITS_F,
+				      mkeyprot);
+
+		set_port_info(&portid, data, portnum, espeed_cap, is_switch);
 
 	} else if (is_switch && portnum) {
 		/* Now, make sure PortState is Active */
@@ -596,7 +646,7 @@ int main(int argc, char **argv)
 				get_ext_port_info(&peerportid, data2,
 						  peerlocalportnum);
 			show_port_info(&peerportid, data, peerlocalportnum,
-				       peer_espeed_cap);
+				       peer_espeed_cap, is_peer_switch);
 			if (is_mlnx_ext_port_info_supported(rem_devid))
 				show_ext_port_info(&peerportid, data2,
 						   peerlocalportnum);
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
