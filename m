From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] ibacm: check for special handling of loopback requests
Date: Tue, 16 Nov 2010 16:15:13 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168CE@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168B9@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168B9-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

OFED 1.5.2 introduced a kernel patch that disables looping
back multicast messages to the sending QP.  This capability
was enabled by default.  The current ACM address resolution
protocol depends on this feature of multicast.  To handle
the case where multicast loopback has been disabled, modify
ACM to check for this setting (which is controlled via a
module parameter) and adjust its behavior accordingly.

If the module parameter is set, ACM will automatically
insert a loopback destination into each endpoint.  Requests
to resolve a loopback address will find this destination
and use it to respond to client requests.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 77194ff..78e3b42 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -204,6 +204,7 @@ static char log_file[128] = "stdout";
 static int log_level = 0;
 static enum acm_addr_prot addr_prot = ACM_ADDR_PROT_ACM;
 static enum acm_route_prot route_prot = ACM_ROUTE_PROT_ACM;
+static int loopback_prot = 0;
 static short server_port = 6125;
 static int timeout = 2000;
 static int retries = 15;
@@ -2294,6 +2295,43 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 	return !index;
 }
 
+static int acm_init_ep_loopback(struct acm_ep *ep)
+{
+	struct acm_dest *dest;
+	int i;
+
+	acm_log(2, "\n");
+	if (!loopback_prot)
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
@@ -2383,6 +2421,11 @@ static int acm_activate_ep(struct acm_port *port, struct acm_ep *ep, uint16_t pk
 	if (ret)
 		goto err2;
 
+	ret = acm_init_ep_loopback(ep);
+	if (ret) {
+		acm_log(0, "ERROR - unable to init loopback\n");
+		goto err2;
+	}
 	return 0;
 
 err2:
@@ -2620,6 +2663,12 @@ static void acm_set_options(void)
 	}
 
 	fclose(f);
+
+	if (!(f = fopen("/sys/module/mlx4_core/parameters/block_loopback", "r")))
+		return;
+
+	fscanf(f, "%d", &loopback_prot);
+	fclose(f);
 }
 
 static void acm_log_options(void)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
