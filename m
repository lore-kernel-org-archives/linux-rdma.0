From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/7] IB/hfi1: Export drivers user sw version via sysfs
Date: Thu, 14 Apr 2016 08:41:41 -0700
Message-ID: <20160414154140.6387.47005.stgit@scvm10.sc.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160414153727.6387.96381.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

User space consumers of hfi1 will need to know what version of the
driver they are dealing with. This becomes particularly important when
the write() interface is removed. User's will need to be able to query
the driver information but without asking the driver directly.

Add the driver's software version to sysfs for this exact purpose.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/sysfs.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sysfs.c b/drivers/staging/rdma/hfi1/sysfs.c
index 8cd6df8..2ff5a14 100644
--- a/drivers/staging/rdma/hfi1/sysfs.c
+++ b/drivers/staging/rdma/hfi1/sysfs.c
@@ -622,6 +622,12 @@ static ssize_t show_tempsense(struct device *device,
 	return ret;
 }
 
+static ssize_t show_user_sw_version(struct device *device,
+				    struct device_attribute *attr, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "0x%x\n", HFI1_USER_SWVERSION);
+}
+
 /*
  * end of per-unit (or driver, in some cases, but replicated
  * per unit) functions
@@ -636,6 +642,7 @@ static DEVICE_ATTR(serial, S_IRUGO, show_serial, NULL);
 static DEVICE_ATTR(boardversion, S_IRUGO, show_boardversion, NULL);
 static DEVICE_ATTR(tempsense, S_IRUGO, show_tempsense, NULL);
 static DEVICE_ATTR(chip_reset, S_IWUSR, NULL, store_chip_reset);
+static DEVICE_ATTR(user_sw_version, S_IRUGO, show_user_sw_version, NULL);
 
 static struct device_attribute *hfi1_attributes[] = {
 	&dev_attr_hw_rev,
@@ -646,6 +653,7 @@ static struct device_attribute *hfi1_attributes[] = {
 	&dev_attr_boardversion,
 	&dev_attr_tempsense,
 	&dev_attr_chip_reset,
+	&dev_attr_user_sw_version,
 };
 
 int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
