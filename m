From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 17/20] IB/mad: Add registration check for Intel Omni-Path Architecture MADs
Date: Mon, 12 Jan 2015 12:11:09 -0500
Message-ID: <1421082672-22588-18-git-send-email-ira.weiny@intel.com>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421082672-22588-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If the registration specifies an OPA MAD class version and the device does not
support OPA MADs, fail the MAD registration.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---

Changes from RFC:
	remove use of supports_jumbo_mads
	convert to use IB_DEVICE_OPA_MAD_SUPPORT in device_cap_flags2

 drivers/infiniband/core/mad.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index dc78040..2686393 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -227,6 +227,14 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
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
@@ -235,6 +243,14 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 				   mad_reg_req->mgmt_class_version);
 			goto error1;
 		}
+		if (mad_reg_req->mgmt_class_version >= OPA_MIN_CLASS_VERSION &&
+		    !(port_priv->device->attributes.device_cap_flags2 & IB_DEVICE_OPA_MAD_SUPPORT)) {
+			dev_notice(&device->dev,
+				   "ib_register_mad_agent: OPA class Version 0x%x not supported on this device: cap flags 2 0x%llx\n",
+				   mad_reg_req->mgmt_class_version,
+				   port_priv->device->attributes.device_cap_flags2);
+			goto error1;
+		}
 		if (!recv_handler) {
 			dev_notice(&device->dev,
 				   "ib_register_mad_agent: no recv_handler\n");
@@ -312,14 +328,6 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
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
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
