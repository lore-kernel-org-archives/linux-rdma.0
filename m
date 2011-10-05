From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] opensm: Get correct guid in case of multiple ports
Date: Wed, 5 Oct 2011 13:36:13 -0500
Message-ID: <20111005183610.GA18253@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


In case of multiple ports and running in daemon mode, the active port is not selected because opt.guid is set to INVALID_GUID in main() but the check in get_port_guid is done against zero: 
	if (port_guid == 0) {

On second thoughts, passing port_guid is worthless because this function is called only when no guid is supplied at the command prompt. So, removed the port_guid parameter from the function altogether.

If not in daemon mode, it would show the list of ports as intended.

Also added error message if no ports are found.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>

diff --git a/opensm/main.c b/opensm/main.c
index 51c8291..a236859 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -403,7 +403,7 @@ static void show_usage(void)
 	exit(2);
 }
 
-static ib_net64_t get_port_guid(IN osm_opensm_t * p_osm, uint64_t port_guid)
+static ib_net64_t get_port_guid(IN osm_opensm_t *p_osm)
 {
 	ib_port_attr_t attr_array[MAX_LOCAL_IBPORTS];
 	uint32_t num_ports = MAX_LOCAL_IBPORTS;
@@ -436,21 +436,19 @@ static ib_net64_t get_port_guid(IN osm_opensm_t * p_osm, uint64_t port_guid)
 		       cl_hton64(attr_array[0].port_guid));
 		return attr_array[0].port_guid;
 	}
-	/* If port_guid is 0 - use the first connected port */
-	if (port_guid == 0) {
+	/* If in daemon mode autoselect first available port */
+	if (p_osm->subn.opt.daemon) {
 		for (i = 0; i < num_ports; i++)
 			if (attr_array[i].link_state > IB_LINK_DOWN)
 				break;
+		/* No port found which is available */
 		if (i == num_ports)
-			i = 0;
+			return 0;
 		printf("Using default GUID 0x%" PRIx64 "\n",
 		       cl_hton64(attr_array[i].port_guid));
 		return attr_array[i].port_guid;
 	}
 
-	if (p_osm->subn.opt.daemon)
-		return 0;
-
 	/* More than one possible port - list all ports and let the user
 	 * to choose. */
 	while (1) {
@@ -1106,10 +1104,12 @@ int main(int argc, char *argv[])
 	   then get a port GUID value with which to bind.
 	 */
 	if (opt.guid == 0 || cl_hton64(opt.guid) == CL_HTON64(INVALID_GUID))
-		opt.guid = get_port_guid(&osm, opt.guid);
+		opt.guid = get_port_guid(&osm);
 
-	if (opt.guid == 0)
+	if (opt.guid == 0) {
+		printf("\nError: No available ports\n");
 		goto Exit;
+	}
 
 	status = osm_opensm_bind(&osm, opt.guid);
 	if (status != IB_SUCCESS) {

-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
