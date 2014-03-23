From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 6/9] ibacm: Change base endpoint name
Date: Sun, 23 Mar 2014 13:18:18 -0700
Message-ID: <1395605901-9080-7-git-send-email-sean.hefty@intel.com>
References: <1395605901-9080-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395605901-9080-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Endpoints are given a string identifer (base name) that matches
the first address assigned to the endpoint.  Store the endpoint
string identifier separately from the address name, and identify
the endpoint using the device name, port, and pkey.

The endpoint identifier is only used for logging purposes.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 16e929b..a8a1fb9 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -153,6 +153,7 @@ struct acm_ep {
 	DLIST_ENTRY           entry;
 	union acm_ep_info     addr[MAX_EP_ADDR];
 	char                  name[MAX_EP_ADDR][ACM_MAX_ADDRESS];
+	char		      id_string[ACM_MAX_ADDRESS];
 	uint8_t               addr_type[MAX_EP_ADDR];
 	void                  *dest_map[ACM_ADDRESS_RESERVED - 1];
 	struct acm_dest       mc_dest[MAX_EP_MC];
@@ -1394,7 +1395,7 @@ static void acm_process_recv(struct acm_ep *ep, struct ibv_wc *wc)
 {
 	struct acm_mad *mad;
 
-	acm_log(2, "base endpoint name %s\n", ep->name[0]);
+	acm_log(2, "base endpoint name %s\n", ep->id_string);
 	mad = (struct acm_mad *) (uintptr_t) (wc->wr_id + sizeof(struct ibv_grh));
 	switch (mad->mgmt_class) {
 	case IB_MGMT_CLASS_SA:
@@ -3057,6 +3058,8 @@ acm_alloc_ep(struct acm_port *port, uint16_t pkey, uint16_t pkey_index)
 	DListInit(&ep->active_queue);
 	DListInit(&ep->wait_queue);
 	lock_init(&ep->lock);
+	sprintf(ep->id_string, "%s-%d-0x%x", port->dev->verbs->device->name,
+		port->port_num, pkey);
 
 	return ep;
 }
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
