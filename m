From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 32/37] IB/srp: Switch from dma_device to dev.parent
Date: Fri, 20 Jan 2017 13:04:32 -0800
Message-ID: <20170120210437.26389-33-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Prepare for removal of ib_device.dma_device.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8ddc07123193..64b33d69b874 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2904,7 +2904,7 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 	sprintf(target->target_name, "SRP.T10:%016llX",
 		be64_to_cpu(target->id_ext));
 
-	if (scsi_add_host(target->scsi_host, host->srp_dev->dev->dma_device))
+	if (scsi_add_host(target->scsi_host, host->srp_dev->dev->dev.parent))
 		return -ENODEV;
 
 	memcpy(ids.port_id, &target->id_ext, 8);
@@ -3515,7 +3515,7 @@ static struct srp_host *srp_add_port(struct srp_device *device, u8 port)
 	host->port = port;
 
 	host->dev.class = &srp_class;
-	host->dev.parent = device->dev->dma_device;
+	host->dev.parent = device->dev->dev.parent;
 	dev_set_name(&host->dev, "srp-%s-%d", device->dev->name, port);
 
 	if (device_register(&host->dev))
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
