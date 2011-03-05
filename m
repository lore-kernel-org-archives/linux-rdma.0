From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/7] ibacm: Delay opening address file until assigning
 addresses
Date: Fri, 4 Mar 2011 16:05:55 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC92EACF@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to handle ports that are down, we need to add
new endpoints only when they are brought online or assigned
new partitions (pkeys).  This is easier to handle if we
delay the opening of the address configuration file until
it is needed to assign addresses.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 1f3c470..38f41d2 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -203,7 +203,6 @@ static SOCKET listen_socket;
 static struct acm_client client[FD_SETSIZE - 1];
 
 static FILE *flog;
-static FILE *faddr;
 static lock_t log_lock;
 PER_THREAD char log_data[ACM_MAX_ADDRESS];
 
@@ -2389,6 +2388,7 @@ err:
 
 static int acm_assign_ep_names(struct acm_ep *ep)
 {
+	FILE *faddr;
 	char *dev_name;
 	char s[120];
 	char dev[32], addr[32], pkey_str[8];
@@ -2401,7 +2401,11 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 	acm_log(1, "device %s, port %d, pkey 0x%x\n",
 		dev_name, ep->port->port_num, ep->pkey);
 
-	rewind(faddr);
+	if (!(faddr = acm_open_addr_file())) {
+		acm_log(0, "ERROR - address file not found\n");
+		return -1;
+	}
+
 	while (fgets(s, sizeof s, faddr)) {
 		if (s[0] == '#')
 			continue;
@@ -2445,6 +2449,7 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 			}
 		}
 	}
+	fclose(faddr);
 
 	return !index;
 }
@@ -2969,11 +2974,6 @@ int CDECL_FUNC main(int argc, char **argv)
 	DListInit(&timeout_list);
 	event_init(&timeout_event);
 
-	if (!(faddr = acm_open_addr_file())) {
-		acm_log(0, "ERROR - address file not found\n");
-		return -1;
-	}
-
 	umad_init();
 	ibdev = ibv_get_device_list(&dev_cnt);
 	if (!ibdev) {
@@ -2990,7 +2990,6 @@ int CDECL_FUNC main(int argc, char **argv)
 		acm_log(0, "ERROR - no active devices\n");
 		return -1;
 	}
-	fclose(faddr);
 
 	acm_log(1, "initiating multicast joins\n");
 	acm_join_groups();


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
