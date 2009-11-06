From: Michael Reed <mdr-sJ/iWh9BUns@public.gmane.org>
Subject: [PATCH 1/1] opensm/main.c: opensm cannot be killed while asking for
 port guid
Date: Fri, 06 Nov 2009 12:41:47 -0600
Message-ID: <4AF46DEB.7090105@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sammy Wilborn <samm-sJ/iWh9BUns@public.gmane.org>, Jeremy Higdon <jeremy-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

opensm enters an uninterruptible loop when the user enters
"-g 0" on the command line.  The only way to kill opensm is to
background the process and send "kill -9".

This patch provides the user an out in get_port_guid() by
introducing "0" as a valid selection.  This patch also changes
the "Lame choice!" error message to something a bit more, uh,
"professional".  main() is modified to test the return code.
This was probably a bug as a return of 0 is returned under a
number of different circumstances by get_port_guid().

Applies to 1.15 RC2.

Signed-off-by: Michael Reed <mdr-sJ/iWh9BUns@public.gmane.org>


--- /tmp/OFED-1.5-rc2/main.c	2009-11-06 08:56:59.089100487 -0800
+++ opensm/main.c	2009-11-06 09:42:34.698963811 -0800
@@ -434,15 +434,19 @@ static ib_net64_t get_port_guid(IN osm_o
 			       i + 1, cl_ntoh64(attr_array[i].port_guid),
 			       attr_array[i].lid,
 			       ib_get_port_state_str(attr_array[i].link_state));
-		printf("\nEnter choice (1-%u): ", i);
+		printf("\n\t0: Exit\n");
+		printf("\nEnter choice (0-%u): ", i);
 		fflush(stdout);
 		if (scanf("%u", &choice) <= 0) {
 			char junk[128];
 			if (scanf("%s", junk) <= 0)
 				printf("\nError: Cannot scan!\n");
-		} else if (choice && choice <= num_ports)
+		}
+		else if (choice == 0)
+			return (0);
+		else if (choice <= num_ports)
 			break;
-		printf("\nError: Lame choice!\n");
+		printf("\nError: Please try again.\n");
 	}
 	choice--;
 	printf("Choice guid=0x%" PRIx64 "\n",
@@ -1039,6 +1043,9 @@ int main(int argc, char *argv[])
 	if (opt.guid == 0 || cl_hton64(opt.guid) == CL_HTON64(INVALID_GUID))
 		opt.guid = get_port_guid(&osm, opt.guid);
 
+	if (opt.guid == 0)
+		goto Exit;
+
 	status = osm_opensm_bind(&osm, opt.guid);
 	if (status != IB_SUCCESS) {
 		printf("\nError from osm_opensm_bind (0x%X)\n", status);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
