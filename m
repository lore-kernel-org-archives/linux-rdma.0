From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 1/7] ib_srpt: Add hw_address and service_id to sysfs
Date: Sun, 9 Jan 2011 17:24:47 +0100
Message-ID: <201101091724.48001.bvanassche@acm.org>
References: <201101091723.41399.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201101091723.41399.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add the attribute 'service_id' at driver level and add the attribute
'hw_address' at device level. Remove the sysfs attribute 'login_info'
because all information it contains is now redundant with other sysfs
attributes. Document the newly added attributes.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 Documentation/ABI/stable/sysfs-devices-scst_target |   11 ++++
 .../ABI/stable/sysfs-driver-scst_target-ib_srpt    |    9 +++
 drivers/scst/srpt/ib_srpt.c                        |   56 +++++++++-----------
 3 files changed, 46 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-driver-scst_target-ib_srpt

diff --git a/Documentation/ABI/stable/sysfs-devices-scst_target b/Documentation/ABI/stable/sysfs-devices-scst_target
index 1792aa3..b5e3980 100644
--- a/Documentation/ABI/stable/sysfs-devices-scst_target
+++ b/Documentation/ABI/stable/sysfs-devices-scst_target
@@ -56,6 +56,17 @@ Description:
 		$ echo "in target_driver/ib_srpt/ib_srpt_target_0 enable" >/sys/devices/scst/mgmt
 		$ cat /sys/devices/ib_srpt_target_0/enabled
 
+What:		/sys/bus/scst_target/devices/<target>/hw_address
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
+Description:
+		Address that uniquely identifies the hardware entity that
+		corresponds to a target. For ib_srpt this is the HCA node
+		GUID. Read-only. An example:
+
+		$ cat /sys/bus/scst_target/devices/ib_srpt_target_0/address
+		0002c9030005f34e
+
 What:		/sys/bus/scst_target/devices/*/hw_target
 Date:		December 2010
 Contact:	Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
diff --git a/Documentation/ABI/stable/sysfs-driver-scst_target-ib_srpt b/Documentation/ABI/stable/sysfs-driver-scst_target-ib_srpt
new file mode 100644
index 0000000..4e54cb9
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-driver-scst_target-ib_srpt
@@ -0,0 +1,9 @@
+What:		/sys/bus/scst_target/drivers/ib_srpt/service_id
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
+Description:
+		SRP Service ID used by ib_srpt on this server. Read-only. An
+		example:
+
+		$ cat /sys/bus/scst_target/drivers/ib_srpt/service_id
+		0002c9030005f34e
diff --git a/drivers/scst/srpt/ib_srpt.c b/drivers/scst/srpt/ib_srpt.c
index 28f860f..4c9c700 100644
--- a/drivers/scst/srpt/ib_srpt.c
+++ b/drivers/scst/srpt/ib_srpt.c
@@ -3222,46 +3222,41 @@ static uint16_t srpt_get_scsi_transport_version(struct scst_tgt *scst_tgt)
 	return 0x0940; /* SRP */
 }
 
-static ssize_t show_login_info(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+static ssize_t tgtt_service_id_show(struct device_driver *drv, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%016llx\n", srpt_service_guid);
+}
+
+static struct driver_attribute srpt_tgtt_service_id_attr =
+	__ATTR(service_id, S_IRUGO, tgtt_service_id_show, NULL);
+
+static const struct driver_attribute *srpt_tgtt_attrs[] = {
+	&srpt_tgtt_service_id_attr,
+	NULL
+};
+
+static ssize_t hw_address_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct scst_tgt *scst_tgt;
 	struct srpt_device *sdev;
-	struct srpt_port *sport;
-	int i;
-	int len;
+	struct ib_device *device;
 
 	scst_tgt = scst_dev_to_tgt(dev);
 	sdev = scst_tgt_get_tgt_priv(scst_tgt);
-	len = 0;
-	for (i = 0; i < sdev->device->phys_port_cnt; i++) {
-		sport = &sdev->port[i];
-
-		len += sprintf(buf + len,
-			       "tid_ext=%016llx,ioc_guid=%016llx,pkey=ffff,"
-			       "dgid=%04x%04x%04x%04x%04x%04x%04x%04x,"
-			       "service_id=%016llx\n",
-			       srpt_service_guid,
-			       srpt_service_guid,
-			       be16_to_cpu(((__be16 *) sport->gid.raw)[0]),
-			       be16_to_cpu(((__be16 *) sport->gid.raw)[1]),
-			       be16_to_cpu(((__be16 *) sport->gid.raw)[2]),
-			       be16_to_cpu(((__be16 *) sport->gid.raw)[3]),
-			       be16_to_cpu(((__be16 *) sport->gid.raw)[4]),
-			       be16_to_cpu(((__be16 *) sport->gid.raw)[5]),
-			       be16_to_cpu(((__be16 *) sport->gid.raw)[6]),
-			       be16_to_cpu(((__be16 *) sport->gid.raw)[7]),
-			       srpt_service_guid);
-	}
-
-	return len;
+	device = sdev->device;
+	return scnprintf(buf, PAGE_SIZE, "%04x%04x%04x%04x\n",
+			 be16_to_cpu(((__be16 *)&device->node_guid)[0]),
+			 be16_to_cpu(((__be16 *)&device->node_guid)[1]),
+			 be16_to_cpu(((__be16 *)&device->node_guid)[2]),
+			 be16_to_cpu(((__be16 *)&device->node_guid)[3]));
 }
 
-static struct device_attribute srpt_show_login_info_attr =
-	__ATTR(login_info, S_IRUGO, show_login_info, NULL);
+static struct device_attribute srpt_hw_address_attr =
+	__ATTR(hw_address, S_IRUGO, hw_address_show, NULL);
 
 static const struct device_attribute *srpt_tgt_attrs[] = {
-	&srpt_show_login_info_attr,
+	&srpt_hw_address_attr,
 	NULL
 };
 
@@ -3310,6 +3305,7 @@ static struct scst_tgt_template srpt_template = {
 	.max_hw_pending_time		 = 60/*seconds*/,
 	.enable_target			 = srpt_enable_target,
 	.is_target_enabled		 = srpt_is_target_enabled,
+	.tgtt_attrs			 = srpt_tgtt_attrs,
 	.tgt_attrs			 = srpt_tgt_attrs,
 	.sess_attrs			 = srpt_sess_attrs,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
