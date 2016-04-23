From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Sat, 23 Apr 2016 18:12:52 -0400 (EDT)
Message-ID: <1738798592.31261905.1461449572512.JavaMail.zimbra@redhat.com>
References: <571A936F.7040409@sandisk.com> <571A94AF.7000609@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571A94AF.7000609-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Bart

I can confirm testing of this series and the specific patch for the sg map failures.
It prevents the sg mapping failures by reducing the max_sectors_kb and its stable.
That is what it was designed to do.

However it effectively prevents any max_sectors_kb from getting to 4MB in size.
This will also of course prevent 4MB I/O being set for DIRECT_IO.

Note that with DIRECT_IO we issue 4MB writes but the queue depth is lower as we dont have any buffering and the 4MB I/O are sent direct to the target.
The average queue depths are lower.

With buffered I/O we have dynamic queuing and I/O sizes are not set at 4MB.

Does that mean we cannot going forward be looking to get the larger max_sectors_kb 

[  221.378728] scsi host4: ib_srp: Reducing max_sectors from 8192 to 4088
[  229.563814] scsi host5: ib_srp: Reducing max_sectors from 8192 to 4088
[  245.620980] scsi host5: ib_srp: Reducing max_sectors from 8192 to 4088
[  253.677979] scsi host6: ib_srp: Reducing max_sectors from 8192 to 4088

[  221.303479] RHDEBUG: srp_dev->max_pages_per_mr - 1 = 511
[  221.332902] RHDEBUG: srp_dev->mr_page_size = 4096 and ilog(srp_dev->mr_page_size) -9 = 3
[  229.563810] RHDEBUG: srp_dev->max_pages_per_mr - 1 = 511
[  229.563811] RHDEBUG: srp_dev->mr_page_size = 4096 and ilog(srp_dev->mr_page_size) -9 = 3
[  245.544452] RHDEBUG: srp_dev->max_pages_per_mr - 1 = 511
[  245.574899] RHDEBUG: srp_dev->mr_page_size = 4096 and ilog(srp_dev->mr_page_size) -9 = 3
[  253.677977] RHDEBUG: srp_dev->max_pages_per_mr - 1 = 511
[  253.677978] RHDEBUG: srp_dev->mr_page_size = 4096 and ilog(srp_dev->mr_page_size) -9 = 3

For the series Re: [PATCH 1/11] IB/srp to [PATCH 11/11] IB/srp

Tested-by Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
To: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Friday, April 22, 2016 5:16:31 PM
Subject: [PATCH 11/11] IB/srp: Prevent mapping failures

If both max_sectors and the queue_depth are high enough it can
happen that the MR pool is depleted temporarily. This causes
the SRP initiator to report mapping failures. Although the SRP
initiator recovers from such mapping failures, prevent that
this can happen by limiting max_sectors.

Reported-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a173ec4..ebd4d90 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3172,6 +3172,7 @@ static ssize_t srp_create_target(struct device *dev,
 	struct srp_device *srp_dev = host->srp_dev;
 	struct ib_device *ibdev = srp_dev->dev;
 	int ret, node_idx, node, cpu, i;
+	unsigned int max_max_sectors;
 	bool multich = false;
 
 	target_host = scsi_host_alloc(&srp_template,
@@ -3228,6 +3229,25 @@ static ssize_t srp_create_target(struct device *dev,
 		target->sg_tablesize = target->cmd_sg_cnt;
 	}
 
+	if (srp_dev->use_fast_reg || srp_dev->use_fmr) {
+		/*
+		 * FR and FMR can only map one HCA page per entry. If the
+		 * start address is not aligned on a HCA page boundary two
+		 * entries will be used for the head and the tail although
+		 * these two entries combined contain at most one HCA page of
+		 * data. Hence the "- 1" in the calculation below.
+		 */
+		max_max_sectors = (srp_dev->max_pages_per_mr - 1) <<
+				  (ilog2(srp_dev->mr_page_size) - 9);
+		if (target->scsi_host->max_sectors > max_max_sectors) {
+			shost_printk(KERN_WARNING, target->scsi_host,
+				     PFX "Reducing max_sectors from %d to %d\n",
+				     target->scsi_host->max_sectors,
+				     max_max_sectors);
+			target->scsi_host->max_sectors = max_max_sectors;
+		}
+	}
+
 	target_host->sg_tablesize = target->sg_tablesize;
 	target->mr_pool_size = target->scsi_host->can_queue;
 	target->indirect_size = target->sg_tablesize *
-- 
2.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
