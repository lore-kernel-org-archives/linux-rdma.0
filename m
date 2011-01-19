From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 8/8] IB/srp and direct IO: patches for testing large indirect
 tables
Date: Tue, 18 Jan 2011 23:27:22 -0500
Message-ID: <1295411242-26148-9-git-send-email-dillowda@ornl.gov>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1295411242-26148-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add .dma_boundary to force each page into its own S/G entry to give us
worst case fragmentation.

include scatterlist.h to pick up ARCH_HAS_SG_CHAIN for scsi.h -- patch
to fix is floating in the ether

Fix direct IO when doing more than 1 MB IOs -- proper patch to fix is
floating in the ether as well, now landed in Andrew Morton's tree.
---
 drivers/infiniband/ulp/srp/ib_srp.c |   11 ++++++++++-
 fs/direct-io.c                      |    1 +
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1da8b25..b9daf2f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -41,6 +41,10 @@
 
 #include <asm/atomic.h>
 
+/* XXX This has to be included before scsi.h to pickup ARCH_HAS_SG_CHAIN
+ * There is a patch for this floating on LKML and linus-scsi now
+ */
+#include <linux/scatterlist.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_dbg.h>
@@ -1845,7 +1849,12 @@ static struct scsi_host_template srp_template = {
 	.this_id			= -1,
 	.cmd_per_lun			= SRP_CMD_SQ_SIZE,
 	.use_clustering			= ENABLE_CLUSTERING,
-	.shost_attrs			= srp_host_attrs
+	.shost_attrs			= srp_host_attrs,
+
+	/* XXX Force a new SG entry for every page crossing to simulate
+	 * maxmimum fragmentation.
+	 */
+	.dma_boundary			= (4096 - 1),
 };
 
 static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 85882f6..9eb0553 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -583,6 +583,7 @@ static int dio_new_bio(struct dio *dio, sector_t start_sector)
 		goto out;
 	sector = start_sector << (dio->blkbits - 9);
 	nr_pages = min(dio->pages_in_io, bio_get_nr_vecs(dio->map_bh.b_bdev));
+	nr_pages = min(nr_pages, BIO_MAX_PAGES);
 	BUG_ON(nr_pages <= 0);
 	ret = dio_bio_alloc(dio, dio->map_bh.b_bdev, sector, nr_pages);
 	dio->boundary = 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
