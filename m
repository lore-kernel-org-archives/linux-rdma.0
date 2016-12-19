From: Vincent Ficet <jean-vincent.ficet-BUmcmmAb0Fc@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Add Bull device ID support to device
 white lists
Date: Mon, 19 Dec 2016 09:44:45 +0100
Message-ID: <58579DFD.2040206@atos.net>
References: <e5ad4256-53fe-9ecc-f880-89347134ec42@dev.mellanox.co.il>
 <20161207145338.GD24724@phlsvsds.ph.intel.com> <584A8823.4070506@atos.net>
 <703b953b-7165-72d1-3c1e-c3b1f8c54f28@dev.mellanox.co.il>
 <584ABFE6.4070902@atos.net>
 <46fac349-4687-961a-4d63-697064f391da@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E3C611A58@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070602050103070308050300"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E3C611A58-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------070602050103070308050300
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Hello,

On 12/19/2016 08:10 AM, Weiny, Ira wrote:
>> On 12/9/2016 9:29 AM, Vincent Ficet wrote:
>>>> Would it be better to combine Bull Switch-IB and Switch-IB2 ranges
>>>> into one check rather than keeping them separate as the device IDs
>>>> are contiguous ?
>>> I just wanted to separate SwitchIB and SwitchIB2 for clarity, but we can gather
>> them if you wish to do so.
>>> Which option do you prefer, together or split ?
>> I prefer together.
> Together is fine by me.
>
> I was expecting a v2 of this patch.  Was that your intention?
I attached the v3 of this patch to this mail following Hal's remarks and suggestions.

The new code has been fully tested on our cluster and no regression was found.

Please let me know whether the changes I made are acceptable.


Best Regards,

Vincent


>
> Ira
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--------------070602050103070308050300
Content-Type: text/x-patch;
 name="infiniband-diags_fix_bull_device_IDs_v3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="infiniband-diags_fix_bull_device_IDs_v3.patch"

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 21b0522..587dcfe 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -133,7 +133,7 @@ extern void ibexit(const char *fn, char *msg, ...);
  */
 extern char *conv_cnt_human_readable(uint64_t val64, float *val, int data);
 
-int is_mlnx_ext_port_info_supported(uint32_t devid);
+int is_mlnx_ext_port_info_supported(uint32_t vendorid, uint16_t devid);
 
 int is_port_info_extended_supported(ib_portid_t * dest, int port,
 				    struct ibmad_port *srcport);
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 7ba5c91..3b8a65a 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -196,10 +196,28 @@ static void debug_port(ib_portid_t * portid, ibnd_port_t * port)
 static int is_mlnx_ext_port_info_supported(ibnd_port_t * port)
 {
 	uint16_t devid = (uint16_t) mad_get_field(port->node->info, 0, IB_NODE_DEVID_F);
-
-	if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08 || devid == 0x1b02)
+	uint32_t vendorid = (uint32_t) mad_get_field(port->node->info, 0, IB_NODE_VENDORID_F);
+
+	if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08 ||
+	    ((vendorid == 0x119f) &&
+	     /* Bull SwitchX */
+	     (devid == 0x1b02 || devid == 0x1b50 ||
+	      /* Bull SwitchIB and SwitchIB2 */
+	      devid == 0x1ba0 ||
+	      (devid >= 0x1bd0 && devid <= 0x1bd5))))
 		return 1;
-	if (devid >= 0x1003 && devid <= 0x1016)
+	if ((devid >= 0x1003 && devid <= 0x1016) ||
+	    ((vendorid == 0x119f) &&
+	     /* Bull ConnectX3 */
+	     (devid == 0x1b33 || devid == 0x1b73 ||
+	      devid == 0x1b40 || devid == 0x1b41 ||
+	      devid == 0x1b60 || devid == 0x1b61 ||
+	     /* Bull ConnectIB */
+	      devid == 0x1b83 ||
+	      devid == 0x1b93 || devid == 0x1b94 ||
+	      /* Bull ConnectX4 */
+	      devid == 0x1bb4 || devid == 0x1bb5 ||
+	      devid == 0x1bc4)))
 		return 1;
 	return 0;
 }
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index f74eed4..82d30e1 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -527,14 +527,34 @@ int is_port_info_extended_supported(ib_portid_t * dest, int port,
 	return 1;
 }
 
-int is_mlnx_ext_port_info_supported(uint32_t devid)
+int is_mlnx_ext_port_info_supported(uint32_t vendorid,
+				    uint16_t devid)
 {
 	if (ibd_ibnetdisc_flags & IBND_CONFIG_MLX_EPI) {
-		if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08 || devid == 0x1b02)
+
+		if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08 ||
+		    ((vendorid == 0x119f) &&
+		     /* Bull SwitchX */
+		     (devid == 0x1b02 || devid == 0x1b50 ||
+		      /* Bull SwitchIB and SwitchIB2 */
+		      devid == 0x1ba0 ||
+		      (devid >= 0x1bd0 && devid <= 0x1bd5))))
 			return 1;
-		if (devid >= 0x1003 && devid <= 0x1016)
+		if ((devid >= 0x1003 && devid <= 0x1016) ||
+		    ((vendorid == 0x119f) &&
+		     /* Bull ConnectX3 */
+		     (devid == 0x1b33 || devid == 0x1b73 ||
+		      devid == 0x1b40 || devid == 0x1b41 ||
+		      devid == 0x1b60 || devid == 0x1b61 ||
+		      /* Bull ConnectIB */
+		      devid == 0x1b83 ||
+		      devid == 0x1b93 || devid == 0x1b94 ||
+		      /* Bull ConnectX4 */
+		      devid == 0x1bb4 || devid == 0x1bb5 ||
+		      devid == 0x1bc4)))
 			return 1;
 	}
+
 	return 0;
 }
 
diff --git a/src/ibportstate.c b/src/ibportstate.c
index df50469..fe8be25 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -385,6 +385,7 @@ int main(int argc, char **argv)
 	int selfport = 0;
 	int changed = 0;
 	int i;
+	uint32_t vendorid, rem_vendorid;
 	uint16_t devid, rem_devid;
 	uint64_t val;
 	char *endp;
@@ -516,6 +517,7 @@ int main(int argc, char **argv)
 		port_op = QUERY;
 
 	is_switch = get_node_info(&portid, data);
+	vendorid = (uint32_t) mad_get_field(data, 0, IB_NODE_VENDORID_F);
 	devid = (uint16_t) mad_get_field(data, 0, IB_NODE_DEVID_F);
 
 	if ((port_args[MKEY].set || port_args[MKEYLEASE].set ||
@@ -528,7 +530,7 @@ int main(int argc, char **argv)
 		printf("%s PortInfo:\n", is_switch ? "Switch" : "CA/RT");
 	espeed_cap = get_port_info(&portid, data, portnum, is_switch);
 	show_port_info(&portid, data, portnum, espeed_cap, is_switch);
-	if (is_mlnx_ext_port_info_supported(devid)) {
+	if (is_mlnx_ext_port_info_supported(vendorid, devid)) {
 		get_mlnx_ext_port_info(&portid, data2, portnum);
 		show_mlnx_ext_port_info(&portid, data2, portnum);
 	}
@@ -675,6 +677,7 @@ int main(int argc, char **argv)
 
 			/* Get peer port NodeInfo to obtain peer port number */
 			is_peer_switch = get_node_info(&peerportid, data);
+			rem_vendorid = (uint32_t) mad_get_field(data, 0, IB_NODE_VENDORID_F);
 			rem_devid = (uint16_t) mad_get_field(data, 0, IB_NODE_DEVID_F);
 
 			mad_decode_field(data, IB_NODE_LOCAL_PORT_F,
@@ -685,12 +688,12 @@ int main(int argc, char **argv)
 			peer_espeed_cap = get_port_info(&peerportid, data,
 							peerlocalportnum,
 							is_peer_switch);
-			if (is_mlnx_ext_port_info_supported(rem_devid))
+			if (is_mlnx_ext_port_info_supported(rem_vendorid, rem_devid))
 				get_mlnx_ext_port_info(&peerportid, data2,
 						       peerlocalportnum);
 			show_port_info(&peerportid, data, peerlocalportnum,
 				       peer_espeed_cap, is_peer_switch);
-			if (is_mlnx_ext_port_info_supported(rem_devid))
+			if (is_mlnx_ext_port_info_supported(rem_vendorid, rem_devid))
 				show_mlnx_ext_port_info(&peerportid, data2,
 							peerlocalportnum);
 
diff --git a/src/vendstat.c b/src/vendstat.c
index 284ef93..4646b56 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -149,7 +149,18 @@ static uint16_t ext_fw_info_device[][2] = {
 	{0xcf08, 0xcf08},	/* Switch-IB2 */
 	{0x01b3, 0x01b3},	/* IS-4 */
 	{0x1003, 0x1016},	/* Connect-X */
-	{0x1b02, 0x1b02},	/* Bull */
+	{0x1b02, 0x1b02},	/* Bull SwitchX */
+	{0x1b50, 0x1b50},	/* Bull SwitchX */
+	{0x1ba0, 0x1ba0},	/* Bull SwitchIB */
+	{0x1bd0, 0x1bd5},	/* Bull SwitchIB and SwitchIB2 */
+	{0x1b33, 0x1b33},	/* Bull ConnectX3 */
+	{0x1b73, 0x1b73},	/* Bull ConnectX3 */
+	{0x1b40, 0x1b41},	/* Bull ConnectX3 */
+	{0x1b60, 0x1b61},	/* Bull ConnectX3 */
+	{0x1b83, 0x1b83},	/* Bull ConnectIB */
+	{0x1b93, 0x1b94},	/* Bull ConnectIB */
+	{0x1bb4, 0x1bb5},	/* Bull ConnectX4 */
+	{0x1bc4, 0x1bc4},	/* Bull ConnectX4 */
 	{0x0000, 0x0000}};
 
 static int is_ext_fw_info_supported(uint16_t device_id) {

--------------070602050103070308050300--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
