From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] ibacm: automatically generate addresses if missing
 acm_addr.cfg
Date: Wed, 8 Dec 2010 12:40:14 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C1ECAC@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the acm_addr.cfg file is missing, automatically attempt to
generate the file.  If no addresses can be assigned to any
endpoints because of a missing file, log an error and exit
the service.  This avoids running a service that is basically
useless.

This change allows the ib_acm service to execute using defaults
without requiring that a user first run 'ib_acme -A -O' or
otherwise creating the acm configuration files.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   37 +++++++++++++++++++++++++++++--------
 1 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 40f2205..e035741 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -203,6 +203,7 @@ static SOCKET listen_socket;
 static struct acm_client client[FD_SETSIZE - 1];
 
 static FILE *flog;
+static FILE *faddr;
 static lock_t log_lock;
 PER_THREAD char log_data[ACM_MAX_ADDRESS];
 
@@ -2249,7 +2250,6 @@ err:
 static int acm_assign_ep_names(struct acm_ep *ep)
 {
 	char *dev_name;
-	FILE *f;
 	char s[120];
 	char dev[32], addr[32], pkey_str[8];
 	uint16_t pkey;
@@ -2261,12 +2261,8 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 	acm_log(1, "device %s, port %d, pkey 0x%x\n",
 		dev_name, ep->port->port_num, ep->pkey);
 
-	if (!(f = fopen(addr_file, "r"))) {
-		acm_log(0, "ERROR - unable to open acm_addr.cfg file\n");
-		return ACM_STATUS_ENODATA;
-	}
-
-	while (fgets(s, sizeof s, f)) {
+	rewind(faddr);
+	while (fgets(s, sizeof s, faddr)) {
 		if (s[0] == '#')
 			continue;
 
@@ -2310,7 +2306,6 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 		}
 	}
 
-	fclose(f);
 	return !index;
 }
 
@@ -2722,6 +2717,22 @@ static FILE *acm_open_log(void)
 	return f;
 }
 
+static FILE *acm_open_addr_file(void)
+{
+	FILE *f;
+
+	if ((f = fopen(addr_file, "r")))
+		return f;
+
+	acm_log(0, "notice - generating acm_addr.cfg file\n");
+	if (!(f = popen("ib_acme -A", "r"))) {
+		acm_log(0, "ERROR - cannot generate acm_addr.cfg\n");
+		return NULL;
+	}
+	pclose(f);
+	return fopen(addr_file, "r");
+}
+
 static int acm_open_lock_file(void)
 {
 	int lock_fd;
@@ -2818,6 +2829,11 @@ int CDECL_FUNC main(int argc, char **argv)
 	DListInit(&timeout_list);
 	event_init(&timeout_event);
 
+	if (!(faddr = acm_open_addr_file())) {
+		acm_log(0, "ERROR - address file not found\n");
+		return -1;
+	}
+
 	umad_init();
 	ibdev = ibv_get_device_list(&dev_cnt);
 	if (!ibdev) {
@@ -2830,6 +2846,11 @@ int CDECL_FUNC main(int argc, char **argv)
 		acm_open_dev(ibdev[i]);
 
 	ibv_free_device_list(ibdev);
+	if (DListEmpty(&dev_list)) {
+		acm_log(0, "ERROR - no active devices\n");
+		return -1;
+	}
+	fclose(faddr);
 
 	acm_log(1, "initiating multicast joins\n");
 	acm_join_groups();


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
