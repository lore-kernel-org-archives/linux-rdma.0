From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 10/16] ib/mad: Add registration check for Intel Omni-Path Architecture MADs
Date: Thu, 13 Nov 2014 14:54:19 -0500
Message-ID: <1415908465-24392-11-git-send-email-ira.weiny@intel.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415908465-24392-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If the registration specifies an OPA MAD class version and the device does not
support jumbo MADs, fail the MAD registration.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index a3ba37f..0ddfbd7 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -238,6 +238,14 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 		goto error1;
 	}
 
+	/* Validate device and port */
+	port_priv = ib_get_mad_port(device, port_num);
+	if (!port_priv) {
+		dev_notice(&device->dev, "ib_register_mad_agent: Invalid port\n");
+		ret = ERR_PTR(-ENODEV);
+		goto error1;
+	}
+
 	/* Validate MAD registration request if supplied */
 	if (mad_reg_req) {
 		if (mad_reg_req->mgmt_class_version >= MAX_MGMT_VERSION) {
@@ -246,6 +254,12 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 				   mad_reg_req->mgmt_class_version);
 			goto error1;
 		}
+		if (mad_reg_req->mgmt_class_version >= OPA_MIN_CLASS_VERSION
+		    && !port_priv->qp_info[qpn].supports_jumbo_mads) {
+			dev_notice(&device->dev,
+				   "ib_register_mad_agent: OPA class Version specified on a device which does not support jumbo MAD's\n");
+			goto error1;
+		}
 		if (!recv_handler) {
 			dev_notice(&device->dev,
 				   "ib_register_mad_agent: no recv_handler\n");
@@ -323,14 +337,6 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 			goto error1;
 	}
 
-	/* Validate device and port */
-	port_priv = ib_get_mad_port(device, port_num);
-	if (!port_priv) {
-		dev_notice(&device->dev, "ib_register_mad_agent: Invalid port\n");
-		ret = ERR_PTR(-ENODEV);
-		goto error1;
-	}
-
 	/* Verify the QP requested is supported.  For example, Ethernet devices
 	 * will not have QP0 */
 	if (!port_priv->qp_info[qpn].qp) {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
