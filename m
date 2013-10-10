From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 08/10] IB/srp: Export sgid to sysfs
Date: Thu, 10 Oct 2013 14:18:00 +0200
Message-ID: <52569AF8.7070000@acm.org>
References: <52569806.9080201@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52569806.9080201-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On an initiator system with multiple IB ports it is not yet possible
to figure out what the originating port of an SRP connection is. Hence
make the source GID available in sysfs.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 Documentation/ABI/stable/sysfs-driver-ib_srp |  7 +++++++
 drivers/infiniband/ulp/srp/ib_srp.c          | 10 ++++++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-driver-ib_srp b/Documentation/ABI/stable/sysfs-driver-ib_srp
index 18e9b27..ab8efd5 100644
--- a/Documentation/ABI/stable/sysfs-driver-ib_srp
+++ b/Documentation/ABI/stable/sysfs-driver-ib_srp
@@ -155,6 +155,13 @@ Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 Description:	InfiniBand service ID used for establishing communication with
 		the SRP	target.
 
+What:		/sys/class/scsi_host/host<n>/sgid
+Date:		December 1, 2013
+KernelVersion:	3.12
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	InfiniBand GID of the source port used for communication with
+		the SRP target.
+
 What:		/sys/class/scsi_host/host<n>/zero_req_lim
 Date:		September 20, 2006
 KernelVersion:	2.6.18
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 4be3eb8..da60d11 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1965,6 +1965,14 @@ static ssize_t show_pkey(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "0x%04x\n", be16_to_cpu(target->path.pkey));
 }
 
+static ssize_t show_sgid(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	return sprintf(buf, "%pI6\n", target->path.sgid.raw);
+}
+
 static ssize_t show_dgid(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
@@ -2049,6 +2057,7 @@ static DEVICE_ATTR(id_ext,	    S_IRUGO, show_id_ext,	   NULL);
 static DEVICE_ATTR(ioc_guid,	    S_IRUGO, show_ioc_guid,	   NULL);
 static DEVICE_ATTR(service_id,	    S_IRUGO, show_service_id,	   NULL);
 static DEVICE_ATTR(pkey,	    S_IRUGO, show_pkey,		   NULL);
+static DEVICE_ATTR(sgid,	    S_IRUGO, show_sgid,		   NULL);
 static DEVICE_ATTR(dgid,	    S_IRUGO, show_dgid,		   NULL);
 static DEVICE_ATTR(orig_dgid,	    S_IRUGO, show_orig_dgid,	   NULL);
 static DEVICE_ATTR(req_lim,         S_IRUGO, show_req_lim,         NULL);
@@ -2065,6 +2074,7 @@ static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_ioc_guid,
 	&dev_attr_service_id,
 	&dev_attr_pkey,
+	&dev_attr_sgid,
 	&dev_attr_dgid,
 	&dev_attr_orig_dgid,
 	&dev_attr_req_lim,
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
