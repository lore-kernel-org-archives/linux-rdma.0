From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Wed, 4 May 2016 16:44:53 -0700
Message-ID: <572A8975.9060606@sandisk.com>
References: <571A936F.7040409@sandisk.com> <571A94AF.7000609@sandisk.com>
 <20160503093307.GL19931@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160503093307.GL19931-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/03/2016 02:33 AM, Christoph Hellwig wrote:
> On Fri, Apr 22, 2016 at 02:16:31PM -0700, Bart Van Assche wrote:
>> If both max_sectors and the queue_depth are high enough it can
>> happen that the MR pool is depleted temporarily. This causes
>> the SRP initiator to report mapping failures. Although the SRP
>> initiator recovers from such mapping failures, prevent that
>> this can happen by limiting max_sectors.
> 
> FYI, even with this patch I see tons of errors like:
> 
> [ 2237.161106] scsi host7: ib_srp: Failed to map data (-12)

Hello Christoph,

The patch below makes these messages disappear on my setup. Are
you OK with including this change in patch 11/11?

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index fc1e84b..53c8e08 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3409,6 +3409,12 @@ static ssize_t srp_create_target(struct device *dev,
 
 	target_host->sg_tablesize = target->sg_tablesize;
 	target->mr_pool_size = target->scsi_host->can_queue;
+	/*
+	 * The indirect data buffer descriptor is contiguous so the memory for
+	 * that buffer will only be registered if register_always is true.
+	 */
+	if (register_always)
+		target->mr_pool_size *= 2;
 	target->indirect_size = target->sg_tablesize *
 				sizeof (struct srp_direct_buf);
 	target->max_iu_len = sizeof (struct srp_cmd) +

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
