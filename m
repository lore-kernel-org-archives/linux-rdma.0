From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Tue, 3 May 2016 14:13:32 -0700
Message-ID: <5729147C.5000904@sandisk.com>
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

That's unintended. I can reproduce this and will analyze this further.
 
>> +		/*
>> +		 * FR and FMR can only map one HCA page per entry. If the
>> +		 * start address is not aligned on a HCA page boundary two
>> +		 * entries will be used for the head and the tail although
>> +		 * these two entries combined contain at most one HCA page of
>> +		 * data. Hence the "- 1" in the calculation below.
>> +		 */
>> +		max_max_sectors = (srp_dev->max_pages_per_mr - 1) <<
>> +				  (ilog2(srp_dev->mr_page_size) - 9);
>> +		if (target->scsi_host->max_sectors > max_max_sectors) {
>> +			shost_printk(KERN_WARNING, target->scsi_host,
>> +				     PFX "Reducing max_sectors from %d to %d\n",
>> +				     target->scsi_host->max_sectors,
>> +				     max_max_sectors);
>> +			target->scsi_host->max_sectors = max_max_sectors;
>> +		}
> 
> I don't think there is any good reason to printk a warning here -
> limited hardware is a totally normal thing.  E.g. if we merge
> your RDMA/CM support and someone runs SRP on chelsio hardware they'd
> probably hit this all the time..

Are you sure? What I see in the v4.6-rc6 tree seems to indicate that Chelsio
hardware supports large page lists:

$ git grep -nHw T[34]_MAX_MR_SIZE
drivers/infiniband/hw/cxgb3/cxio_hal.h:58:#define T3_MAX_MR_SIZE 0x100000000ULL
drivers/infiniband/hw/cxgb3/iwch.c:125:	rnicp->attr.max_mr_size = T3_MAX_MR_SIZE;
drivers/infiniband/hw/cxgb4/provider.c:328:	props->max_mr_size = T4_MAX_MR_SIZE;
drivers/infiniband/hw/cxgb4/t4.h:41:#define T4_MAX_MR_SIZE (~0ULL)

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
