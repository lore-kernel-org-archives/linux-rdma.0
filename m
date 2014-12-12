From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/4] add provider and proxy support for GUID across platform
Date: Fri, 12 Dec 2014 08:50:41 -0800
Message-ID: <1418403043-2221-3-git-send-email-arlin.r.davis@intel.com>
References: <1418403043-2221-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418403043-2221-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/util.c |    4 ++--
 dapl/openib_mcm/device.c  |   19 +++++++++++--------
 dapl/openib_scm/device.c  |   27 +++++++++++++++------------
 dapl/openib_ucm/device.c  |   20 ++++++++++++--------
 dapl/svc/mpxyd.c          |   17 +++++++++--------
 5 files changed, 49 insertions(+), 38 deletions(-)

diff --git a/dapl/openib_common/util.c b/dapl/openib_common/util.c
index 7647824..d253f6e 100644
--- a/dapl/openib_common/util.c
+++ b/dapl/openib_common/util.c
@@ -411,14 +411,14 @@ DAT_RETURN dapls_ib_query_hca(IN DAPL_HCA * hca_ptr,
 		hca_ptr->ib_trans.na.dev = ia_attr->adapter_name;
 		hca_ptr->ib_trans.na.mtu = dapl_ib_mtu_str(hca_ptr->ib_trans.mtu);
 		hca_ptr->ib_trans.na.port = dapl_ib_port_str(port_attr.state);
-		hca_ptr->ib_trans.guid = ntohll(ibv_get_device_guid(hca_ptr->ib_trans.ib_dev));
+		if (!hca_ptr->ib_trans.guid)
+			hca_ptr->ib_trans.guid = ntohll(ibv_get_device_guid(hca_ptr->ib_trans.ib_dev));
 		sprintf(hca_ptr->ib_trans.guid_str, "%04x:%04x:%04x:%04x",
 			(unsigned) (hca_ptr->ib_trans.guid >> 48) & 0xffff,
 			(unsigned) (hca_ptr->ib_trans.guid >> 32) & 0xffff,
 			(unsigned) (hca_ptr->ib_trans.guid >> 16) & 0xffff,
 			(unsigned) (hca_ptr->ib_trans.guid >>  0) & 0xffff);
 #ifdef _OPENIB_MCM_
-		hca_ptr->ib_trans.sys_guid = dev_attr.sys_image_guid; /* network order */
 		if (hca_ptr->ib_trans.self.node)
 			hca_ptr->ib_trans.na.mode = "PROXY";
 		else
diff --git a/dapl/openib_mcm/device.c b/dapl/openib_mcm/device.c
index b60ba1c..9fdbe0b 100644
--- a/dapl/openib_mcm/device.c
+++ b/dapl/openib_mcm/device.c
@@ -199,18 +199,21 @@ DAT_RETURN dapls_ib_open_hca(IN IB_HCA_NAME hca_name,
 		return DAT_INTERNAL_ERROR;
 	}
 	dapl_log(DAPL_DBG_TYPE_UTIL, " open_hca %p: %d devices found\n", hca_ptr, nd);
+	hca_ptr->ib_trans.ib_dev = NULL;
 	for (i = 0; i < nd; ++i) {
-		if (!strcmp(dev_list[i]->name, hca_name)) {
+		if (!hca_ptr->ib_trans.guid &&
+		    dev_list[i]->transport_type == IBV_TRANSPORT_IB)
+			hca_ptr->ib_trans.guid = ibv_get_device_guid(dev_list[i]);
+
+		if (!strcmp(dev_list[i]->name, hca_name))
 			hca_ptr->ib_trans.ib_dev = dev_list[i];
-			goto found;
-		}
+	}
+	if (hca_ptr->ib_trans.ib_dev == NULL) {
+		dapl_log(DAPL_DBG_TYPE_ERR, " open_hca: device %s not found\n", hca_name);
+		dat_status = DAT_PROVIDER_NOT_FOUND;
+		goto err;
 	}
 
-	dapl_log(DAPL_DBG_TYPE_ERR, " open_hca: device %s not found\n", hca_name);
-	dat_status = DAT_PROVIDER_NOT_FOUND;
-	goto err;
-
-found:
 	hca_ptr->ib_hca_handle = ibv_open_device(hca_ptr->ib_trans.ib_dev);
 	if (!hca_ptr->ib_hca_handle) {
 		dapl_log(DAPL_DBG_TYPE_ERR,
diff --git a/dapl/openib_scm/device.c b/dapl/openib_scm/device.c
index a35ab69..aaea686 100644
--- a/dapl/openib_scm/device.c
+++ b/dapl/openib_scm/device.c
@@ -274,7 +274,7 @@ DAT_RETURN dapls_ib_open_hca(IN IB_HCA_NAME hca_name,
 {
 	struct ibv_device **dev_list;
 	struct ibv_port_attr port_attr;
-	int i;
+	int i, nd = 0;
 	DAT_RETURN dat_status = DAT_SUCCESS;
 
 	dapl_log(DAPL_DBG_TYPE_UTIL, " open_hca: %s %s - %p in %s\n",
@@ -289,25 +289,28 @@ DAT_RETURN dapls_ib_open_hca(IN IB_HCA_NAME hca_name,
 	}
 
         /* Get list of all IB devices, find match, open */
-	dev_list = ibv_get_device_list(NULL);
+	dev_list = ibv_get_device_list(&nd);
 	if (!dev_list) {
 		dapl_log(DAPL_DBG_TYPE_ERR,
 			 " open_hca: ibv_get_device_list() failed\n",
 			 hca_name);
 		return DAT_INTERNAL_ERROR;
 	}
+	hca_ptr->ib_trans.ib_dev = NULL;
+	for (i = 0; i < nd; ++i) {
+		if (!hca_ptr->ib_trans.guid &&
+		    dev_list[i]->transport_type == IBV_TRANSPORT_IB)
+			hca_ptr->ib_trans.guid = ibv_get_device_guid(dev_list[i]);
 
-	for (i = 0; dev_list[i]; ++i) {
-		hca_ptr->ib_trans.ib_dev = dev_list[i];
-		if (!strcmp(ibv_get_device_name(hca_ptr->ib_trans.ib_dev),
-			    hca_name))
-			goto found;
+		if (!strcmp(dev_list[i]->name, hca_name))
+			hca_ptr->ib_trans.ib_dev = dev_list[i];
+	}
+	if (hca_ptr->ib_trans.ib_dev == NULL) {
+		dapl_log(DAPL_DBG_TYPE_ERR, " open_hca: device %s not found\n", hca_name);
+		dat_status = DAT_PROVIDER_NOT_FOUND;
+		goto err;
 	}
-	dapl_log(DAPL_DBG_TYPE_ERR,
-		 " open_hca: device %s not found\n", hca_name);
-	goto err;
 
-found:
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " open_hca: Found dev %s %016llx\n",
 		     ibv_get_device_name(hca_ptr->ib_trans.ib_dev),
 		     (unsigned long long)
diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index c6b4546..75d7306 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -216,17 +216,21 @@ DAT_RETURN dapls_ib_open_hca(IN IB_HCA_NAME hca_name,
 			 hca_name);
 		return DAT_INTERNAL_ERROR;
 	}
-
+	hca_ptr->ib_trans.ib_dev = NULL;
 	for (i = 0; i < nd; ++i) {
-		if (!strcmp(dev_list[i]->name, hca_name)) {
+		if (!hca_ptr->ib_trans.guid &&
+		    dev_list[i]->transport_type == IBV_TRANSPORT_IB)
+			hca_ptr->ib_trans.guid = ibv_get_device_guid(dev_list[i]);
+
+		if (!strcmp(dev_list[i]->name, hca_name))
 			hca_ptr->ib_trans.ib_dev = dev_list[i];
-			goto found;
-		}
 	}
-	dapl_log(DAPL_DBG_TYPE_ERR, " open_hca: %s not found\n", hca_name);
-	dat_status = DAT_PROVIDER_NOT_FOUND;
-	goto err;
-found:
+	if (hca_ptr->ib_trans.ib_dev == NULL) {
+		dapl_log(DAPL_DBG_TYPE_ERR, " open_hca: device %s not found\n", hca_name);
+		dat_status = DAT_PROVIDER_NOT_FOUND;
+		goto err;
+	}
+
 	hca_ptr->ib_hca_handle = ibv_open_device(hca_ptr->ib_trans.ib_dev);
 	if (!hca_ptr->ib_hca_handle) {
 		dapl_log(DAPL_DBG_TYPE_ERR,
diff --git a/dapl/svc/mpxyd.c b/dapl/svc/mpxyd.c
index 4f228bc..bdc6896 100644
--- a/dapl/svc/mpxyd.c
+++ b/dapl/svc/mpxyd.c
@@ -196,6 +196,15 @@ static struct ibv_context *open_ib_device(struct mcm_ib_dev *md, char *name, int
 	}
 
 	for (i=0; i < ibcnt; ++i) {
+		/* system GUID set to first IB device GUID */
+		if (!system_guid && iblist[i]->transport_type == IBV_TRANSPORT_IB) {
+			system_guid = ibv_get_device_guid(iblist[i]);
+			mlog(0, "System GUID == %04x:%04x:%04x:%04x\n",
+				(unsigned) (system_guid >> 48) & 0xffff,
+				(unsigned) (system_guid >> 32) & 0xffff,
+				(unsigned) (system_guid >> 16) & 0xffff,
+				(unsigned) (system_guid >>  0) & 0xffff);
+		}
 		if (!strcmp(iblist[i]->name, name)) {
 			ibctx = ibv_open_device(iblist[i]);
 			if (!ibctx) {
@@ -219,14 +228,6 @@ static struct ibv_context *open_ib_device(struct mcm_ib_dev *md, char *name, int
 					mlog(0," ERR ibdev %s numa_node at "
 					     "%s/device/numa_node unreadable\n",
 					      name, md->ibdev->ibdev_path);
-
-				if (!system_guid) /* first time, set system guid */
-#ifdef MPXYD_LOCAL_SUPPORT
-					system_guid = ibv_get_device_guid(md->ibdev);
-#else
-					system_guid = rand();
-#endif
-
 				break;
 			}
 		}
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
