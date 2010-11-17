From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3 v2] ibacm: Introduce loopback resolution 'protocol'
Date: Wed, 17 Nov 2010 10:39:32 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B867F156@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168B9@orsmsx501.amr.corp.intel.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168CE@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168CE-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

OFED 1.5.2 introduced a kernel patch that disables looping
back multicast messages to the sending QP.  This capability
was enabled by default.  The current ACM address resolution
protocol depends on this feature of multicast.  To handle
the case where multicast loopback has been disabled, add an
option to ACM to resolve loopback addresses using local data
only.  This option is enabled by default.

When loopback resolution is set to 'local', ACM will automatically
insert a loopback destination into each endpoint.  Requests
to resolve a loopback address will find this destination
and use it to respond to client requests.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
change from v1:
Used acm configuration option to specify loopback resolution rather
than reading from mlx4 module parameter file.

 acm_opts.cfg |    8 +++++++
 src/acm.c    |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/acme.c   |    8 +++++++
 3 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/acm_opts.cfg b/acm_opts.cfg
index 3dbb0c6..65faac9 100644
--- a/acm_opts.cfg
+++ b/acm_opts.cfg
@@ -41,6 +41,14 @@ addr_prot acm
 
 route_prot sa
 
+# loopback_prot:
+# Address and route resolution protocol to resolve local addresses
+# Supported protocols are:
+# none - Use same protocols defined for addr_prot and route_prot
+# local - Resolve information used locally available data
+
+loopback_prot local
+
 # server_port:
 # TCP port number that the server listens on.
 # If this value is changed, then a corresponding change is required for
diff --git a/src/acm.c b/src/acm.c
index 77194ff..099518e 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -69,6 +69,12 @@ enum acm_route_prot
 	ACM_ROUTE_PROT_SA
 };
 
+enum acm_loopback_prot
+{
+	ACM_LOOPBACK_PROT_NONE,
+	ACM_LOOPBACK_PROT_LOCAL
+};
+
 /*
  * Nested locking order: dest -> ep, dest -> port
  */
@@ -204,6 +210,7 @@ static char log_file[128] = "stdout";
 static int log_level = 0;
 static enum acm_addr_prot addr_prot = ACM_ADDR_PROT_ACM;
 static enum acm_route_prot route_prot = ACM_ROUTE_PROT_ACM;
+static enum acm_loopback_prot loopback_prot = ACM_LOOPBACK_PROT_LOCAL;
 static short server_port = 6125;
 static int timeout = 2000;
 static int retries = 15;
@@ -2133,6 +2140,16 @@ static enum acm_route_prot acm_convert_route_prot(char *param)
 	return route_prot;
 }
 
+static enum acm_loopback_prot acm_convert_loopback_prot(char *param)
+{
+	if (!stricmp("none", param))
+		return ACM_LOOPBACK_PROT_NONE;
+	else if (!stricmp("local", param))
+		return ACM_LOOPBACK_PROT_LOCAL;
+
+	return loopback_prot;
+}
+
 static enum ibv_rate acm_get_rate(uint8_t width, uint8_t speed)
 {
 	switch (width) {
@@ -2294,6 +2311,43 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 	return !index;
 }
 
+static int acm_init_ep_loopback(struct acm_ep *ep)
+{
+	struct acm_dest *dest;
+	int i;
+
+	acm_log(2, "\n");
+	if (loopback_prot != ACM_LOOPBACK_PROT_LOCAL)
+		return 0;
+
+	for (i = 0; i < MAX_EP_ADDR && ep->addr_type[i]; i++) {
+		dest = acm_acquire_dest(ep, ep->addr_type[i], ep->addr[i].addr);
+		if (!dest) {
+			acm_format_name(0, log_data, sizeof log_data,
+					ep->addr_type[i], ep->addr[i].addr,
+					sizeof ep->addr[i].addr);
+			acm_log(0, "ERROR - unable to create loopback dest %s\n", log_data);
+			return -1;
+		}
+
+		ibv_query_gid(ep->port->dev->verbs, ep->port->port_num,
+			      0, &dest->path.sgid);
+
+		dest->path.dgid = dest->path.sgid;
+		dest->path.dlid = dest->path.slid = htons(ep->port->lid);
+		dest->path.reversible_numpath = IBV_PATH_RECORD_REVERSIBLE;
+		dest->path.pkey = htons(ep->pkey);
+		dest->path.mtu = (uint8_t) ep->port->mtu;
+		dest->path.rate = (uint8_t) ep->port->rate;
+
+		dest->remote_qpn = ep->qp->qp_num;
+		dest->state = ACM_READY;
+		acm_put_dest(dest);
+		acm_log(1, "added loopback dest %s\n", dest->name);
+	}
+	return 0;
+}
+
 static int acm_activate_ep(struct acm_port *port, struct acm_ep *ep, uint16_t pkey_index)
 {
 	struct ibv_qp_init_attr init_attr;
@@ -2383,6 +2437,11 @@ static int acm_activate_ep(struct acm_port *port, struct acm_ep *ep, uint16_t pk
 	if (ret)
 		goto err2;
 
+	ret = acm_init_ep_loopback(ep);
+	if (ret) {
+		acm_log(0, "ERROR - unable to init loopback\n");
+		goto err2;
+	}
 	return 0;
 
 err2:
@@ -2599,6 +2658,8 @@ static void acm_set_options(void)
 			addr_prot = acm_convert_addr_prot(value);
 		else if (!stricmp("route_prot", opt))
 			route_prot = acm_convert_route_prot(value);
+		else if (!stricmp("loopback_prot", opt))
+			loopback_prot = acm_convert_loopback_prot(value);
 		else if (!stricmp("server_port", opt))
 			server_port = (short) atoi(value);
 		else if (!stricmp("timeout", opt))
@@ -2627,6 +2688,7 @@ static void acm_log_options(void)
 	acm_log(0, "log level %d\n", log_level);
 	acm_log(0, "address resolution %d\n", addr_prot);
 	acm_log(0, "route resolution %d\n", route_prot);
+	acm_log(0, "loopback resolution %d\n", loopback_prot);
 	acm_log(0, "server_port %d\n", server_port);
 	acm_log(0, "timeout %d ms\n", timeout);
 	acm_log(0, "retries %d\n", retries);
diff --git a/src/acme.c b/src/acme.c
index e03679f..b54738e 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -121,6 +121,14 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "\n");
 	fprintf(f, "route_prot sa\n");
 	fprintf(f, "\n");
+	fprintf(f, "# loopback_prot:\n");
+	fprintf(f, "# Address and route resolution protocol to resolve local addresses\n");
+	fprintf(f, "# Supported protocols are:\n");
+	fprintf(f, "# none - Use same protocols defined for addr_prot and route_prot\n");
+	fprintf(f, "# local - Resolve information used locally available data\n");
+	fprintf(f, "\n");
+	fprintf(f, "loopback_prot local\n");
+	fprintf(f, "\n");
 	fprintf(f, "# server_port:\n");
 	fprintf(f, "# TCP port number that the server listens on.\n");
 	fprintf(f, "# If this value is changed, then a corresponding change is required for\n");


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
