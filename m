From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH]: infiniband-diags/ibportstate.c: Add ON and OFF options.
Date: Tue, 19 Mar 2013 15:12:55 +0200
Message-ID: <20130319131255.GA29404@r-ufm5-17.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add new Options :
                1.ON: Changed the port state to enable only in case
                      the current state is disable.
                2.OFF: Change the port state to disable.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 doc/rst/ibportstate.8.in.rst |    6 +++++-
 src/ibportstate.c            |   14 ++++++++++++++
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/doc/rst/ibportstate.8.in.rst b/doc/rst/ibportstate.8.in.rst
index c082638..750ee42 100644
--- a/doc/rst/ibportstate.8.in.rst
+++ b/doc/rst/ibportstate.8.in.rst
@@ -30,13 +30,17 @@ OPTIONS
 
 **<op>**
         Supported ops: enable, disable, reset, speed, espeed, fdr10, width, query,
-                        down, arm, active, vls, mtu, lid, smlid, lmc,
+                        on, off, down, arm, active, vls, mtu, lid, smlid, lmc,
                         mkey, mkeylease, mkeyprot
 			(Default is query)
 
         **enable, disable, and reset** are only allowed on switch ports (An
         error is indicated if attempted on CA or router ports)
 
+        **off** change the port state to disable.
+
+        **on** change the port state to enable(only when the current state is disable).
+
         **speed and width** are allowed on any port
 
         **speed** values are the legal values for PortInfo:LinkSpeedEnabled (An
diff --git a/src/ibportstate.c b/src/ibportstate.c
index 053b0a2..12ed442 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -68,6 +68,8 @@ enum port_ops {
 	MKEY,
 	MKEYLEASE,
 	MKEYPROT,
+	ON,
+	OFF
 };
 
 struct ibmad_port *srcport;
@@ -108,6 +110,8 @@ struct {
 	{"mkey", &mkey, 0},	/* MKEY */
 	{"mkeylease", &mkeylease, 0},	/* MKEY LEASE */
 	{"mkeyprot", &mkeyprot, 0},	/* MKEY PROTECT BITS */
+	{"on", NULL, 0},	/* ON */
+	{"off", NULL, 0},	/* OFF */
 };
 
 #define NPORT_ARGS (sizeof(port_args) / sizeof(port_args[0]))
@@ -534,6 +538,8 @@ int main(int argc, char **argv)
 		 * the SMA command will fail due to an invalid LID.
 		 * Set it to something unlikely but valid.
 		 */
+		physstate = mad_get_field(data, 0, IB_PORT_PHYS_STATE_F);
+
 		val = mad_get_field(data, 0, IB_PORT_LID_F);
 		if (!port_args[LID].set && (!val || val == 0xFFFF))
 			mad_set_field(data, 0, IB_PORT_LID_F, 0x1234);
@@ -544,11 +550,18 @@ int main(int argc, char **argv)
 		mad_set_field(data, 0, IB_PORT_PHYS_STATE_F, 0);	/* NOP */
 
 		switch (port_op) {
+		case ON:
+			/* Enable only if state is Disable */
+			if(physstate != 3) {
+				printf("Port is already in enable state\n");
+				goto close_port;
+			}
 		case ENABLE:
 		case RESET:
 			/* Polling */
 			mad_set_field(data, 0, IB_PORT_PHYS_STATE_F, 2);
 			break;
+		case OFF:
 		case DISABLE:
 			printf("Disable may be irreversible\n");
 			mad_set_field(data, 0, IB_PORT_PHYS_STATE_F, 3);
@@ -732,6 +745,7 @@ int main(int argc, char **argv)
 		}
 	}
 
+close_port:
 	mad_rpc_close_port(srcport);
 	exit(0);
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
