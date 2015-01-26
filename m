From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 02/19] IB/core: Cache device attributes for use by upper level drivers
Date: Mon, 26 Jan 2015 14:07:35 -0500
Message-ID: <1422299272-15898-3-git-send-email-ira.weiny@intel.com>
References: <1422299272-15898-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422299272-15898-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Upper level drivers can access these cached device attributes rather than
caching them on their own.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---

Changes from V2:
	Change variable name from attributes to cached_dev_attrs

 drivers/infiniband/core/device.c | 2 ++
 include/rdma/ib_verbs.h          | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 18c1ece..30d9d09 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -294,6 +294,8 @@ int ib_register_device(struct ib_device *device,
 	spin_lock_init(&device->event_handler_lock);
 	spin_lock_init(&device->client_data_lock);
 
+	device->query_device(device, &device->cached_dev_attrs);
+
 	ret = read_port_table_lengths(device);
 	if (ret) {
 		printk(KERN_WARNING "Couldn't create table lengths cache for device %s\n",
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0d74f1d..0116e4b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1675,6 +1675,7 @@ struct ib_device {
 	u32			     local_dma_lkey;
 	u8                           node_type;
 	u8                           phys_port_cnt;
+	struct ib_device_attr        cached_dev_attrs;
 };
 
 struct ib_client {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
