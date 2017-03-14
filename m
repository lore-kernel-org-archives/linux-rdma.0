From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/7] Fix various missing swaps in debugging/logging macros
Date: Tue, 14 Mar 2017 10:21:10 -0600
Message-ID: <1489508474-16664-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1489508474-16664-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489508474-16664-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Based on sparse output.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/prov/acmp/src/acmp.c  | 13 +++++++------
 ibacm/src/acm.c             |  4 ++--
 providers/qedr/qelr_verbs.c |  4 ++--
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index da4e69cd171f5b..fb8d30f3e6ac42 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -2419,8 +2419,8 @@ static struct acmp_port *acmp_get_port(struct acm_endpoint *endpoint)
 	struct acmp_device *dev;
 
 	acm_log(1, "dev 0x%" PRIx64 " port %d pkey 0x%x\n",
-		endpoint->port->dev->dev_guid, endpoint->port->port_num,
-		endpoint->pkey);
+		be64toh(endpoint->port->dev->dev_guid),
+		endpoint->port->port_num, endpoint->pkey);
 
 	list_for_each(&acmp_dev_list, dev, entry) {
 		if (dev->guid == endpoint->port->dev->dev_guid)
@@ -2436,7 +2436,8 @@ acmp_get_ep(struct acmp_port *port, struct acm_endpoint *endpoint)
 	struct acmp_ep *ep;
 
 	acm_log(1, "dev 0x%" PRIx64 " port %d pkey 0x%x\n",
-		endpoint->port->dev->dev_guid, endpoint->port->port_num, endpoint->pkey);
+		be64toh(endpoint->port->dev->dev_guid),
+		endpoint->port->port_num, endpoint->pkey);
 
 	list_for_each(&port->ep_list, ep, entry) {
 		if (ep->pkey == endpoint->pkey)
@@ -2736,13 +2737,13 @@ static int acmp_open_dev(const struct acm_device *device, void **dev_context)
 	int i, ret;
 	struct ibv_context *verbs;
 
-	acm_log(1, "dev_guid 0x%" PRIx64 " %s\n", device->dev_guid,
+	acm_log(1, "dev_guid 0x%" PRIx64 " %s\n", be64toh(device->dev_guid),
 		device->verbs->device->name);
 
 	list_for_each(&acmp_dev_list, dev, entry) {
 		if (dev->guid == device->dev_guid) {
 			acm_log(2, "dev_guid 0x%" PRIx64 " already exits\n",
-				device->dev_guid);
+				be64toh(device->dev_guid));
 			*dev_context = dev;
 			dev->device = device;
 			return 0;
@@ -2823,7 +2824,7 @@ static void acmp_close_dev(void *dev_context)
 {
 	struct acmp_device *dev = dev_context;
 
-	acm_log(1, "dev_guid 0x%" PRIx64 "\n", dev->device->dev_guid);
+	acm_log(1, "dev_guid 0x%" PRIx64 "\n", be64toh(dev->device->dev_guid));
 	dev->device = NULL;
 }
 
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 3550b11b324570..f3512dac106815 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -2136,8 +2136,8 @@ static void acm_port_get_gid_tbl(struct acmc_port *port)
 			if (ret || !port->gid_tbl[j].global.interface_id)
 				break;
 			acm_log(2, "guid %d: 0x%" PRIx64 " %" PRIx64 "\n", j,
-				port->gid_tbl[j].global.subnet_prefix,
-				port->gid_tbl[j].global.interface_id);
+				be64toh(port->gid_tbl[j].global.subnet_prefix),
+				be64toh(port->gid_tbl[j].global.interface_id));
 		}
 		port->gid_cnt = j;
 	}
diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 4800a4b0f43e6f..8d94a122a2b871 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -561,8 +561,8 @@ static void qelr_print_ah_attr(struct qelr_devctx *cxt, struct ibv_ah_attr *attr
 {
 	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP,
 		   "grh.dgid=[%#" PRIx64 ":%#" PRIx64 "], grh.flow_label=%d, grh.sgid_index=%d, grh.hop_limit=%d, grh.traffic_class=%d, dlid=%d, sl=%d, src_path_bits=%d, static_rate = %d, port_num=%d\n",
-		   attr->grh.dgid.global.interface_id,
-		   attr->grh.dgid.global.subnet_prefix,
+		   be64toh(attr->grh.dgid.global.interface_id),
+		   be64toh(attr->grh.dgid.global.subnet_prefix),
 		   attr->grh.flow_label, attr->grh.hop_limit,
 		   attr->grh.sgid_index, attr->grh.traffic_class, attr->dlid,
 		   attr->sl, attr->src_path_bits,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
