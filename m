From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 3/4] nvme: enable SG gaps support
Date: Sun, 23 Apr 2017 16:23:32 +0300
Message-ID: <1e1528f6-718b-2321-7d02-c19e5cffc2ef@mellanox.com>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
 <1492098977-5231-4-git-send-email-maxg@mellanox.com>
 <2bd673ee-8455-32b7-1bad-34fa9eebb076@grimberg.me>
 <20170421064427.GB6095@lst.de>
 <9ff1a2e8-f84f-c772-e294-2339eee8e37d@grimberg.me>
 <20170423084553.GA24434@lst.de>
 <9fe3f5fa-4496-3819-0288-08a073dd1a1a@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9fe3f5fa-4496-3819-0288-08a073dd1a1a-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 4/23/2017 12:45 PM, Sagi Grimberg wrote:
>
>> Each block queue has a ->dma_alignment field, which is set to 511
>> by default unless changed.  Everything not aligned to that will be
>> bounced in __blk_rq_map_user_iov and friends before we send it to
>> the driver.
>
> Thanks, I missed the default setting...
>
>>> I also just tested Bart's unaligned test [1] on scsi_debug and it seems
>>> to go through as well (alignment and length are 4)...
>>
>> SCSI reduces the alignment in __scsi_init_queue:
>>
>>     /*
>>          * set a reasonable default alignment on word boundaries: the
>>      * host and device may alter it using
>>      * blk_queue_update_dma_alignment() later.
>>      */
>>     blk_queue_dma_alignment(q, 0x03);
>
> That explains why I was able to test that with iSER :)
>
> I guess I didn't test single byte alignment after all, but
> I definitely remember using less than a sector...
>
>> still would fit NVMe dword-alignment SGLs, though :)
>
> I would say its useful to have, but its only relevant to ioctls as
> normal io we explicitly on sub logical block size alignment.
>
> Anyways, I still think having ctrl->virt_boundary instead of
> ctrl->sg_gap_support is cleaner...

Sure, I tought about it and actually started my implementation like 
that. It wasn't so clean, though.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
