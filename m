From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: 4.5-rc iser issues
Date: Mon, 15 Feb 2016 00:39:04 +0800
Message-ID: <CACVXFVOYu0j12ixWokg-LfQusKb8TMUCKAiAo3N80z3xMpdTYQ@mail.gmail.com>
References: <20160214074119.GA24558@infradead.org>
	<56C04294.3090701@dev.mellanox.co.il>
	<56C05000.1040001@dev.mellanox.co.il>
	<56C066AF.6050901@dev.mellanox.co.il>
	<56C088EA.1050901@dev.mellanox.co.il>
	<20160214152223.GA5323@infradead.org>
	<CACVXFVNAkf5+XFyf2JkcfeEPO2sv9bqHMR+N+=kKFzrtXpFEnA@mail.gmail.com>
	<56C0AB84.9040004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C0AB84.9040004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ming Lin-SSI <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 15, 2016 at 12:29 AM, Sagi Grimberg
<sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> Hi Sagi,
>
>
> Hey,
>
>>> But I don't think simply not cloning the biovecs is the right thing
>>> to do in the end.  This must be something with the bvec iterators.
>>
>>
>> I agree with Christoph, and there might be issues somewhere.
>>
>
> Me too, it was just an isolation step...
>
>>>  From the log:
>>> iser: sg[0] dma_addr:0x85FC06000 off:0x0 sz:0x200 dma_len:0x200
>>> iser: sg[1] dma_addr:0x860334000 off:0x0 sz:0x200 dma_len:0x200 <-- gap
>>> iser: sg[2] dma_addr:0x860335000 off:0x0 sz:0x200 dma_len:0x200 <-- gap
>>
>>
>> The above gap shouldn't have come since blk_bio_segment_split() splits
>> out one new bio if gap is detected.
>>
>> Sort of the following code can be added in driver or prep_fn to check if
>> bvec of  the rq is correct:
>>
>> rq_for_each_segment(bvec, sc->request, iter) {
>>       //check if there is gap between bvec
>> }
>
>
> I added this indication and the gap detection does trigger a bio
> split.

Then I suggest to add the similar check inside blk_queue_split()
further to see if the result bio('res' bio in the function) has gap.

>
>>
>> I don't know how to use iser, and looks everything works fine after
>> I setup virt boundary as 4095 for null_blk by the attachment
>> patch.
>
>
> That's probably because it's artificial and there is no HW with a real
> limitation...

I do check the trace_printk log, and basically one rq only includes one
segment if I set bs as 512 in fio test.

Thanks,

>
>>
>>> Full quote for Ming:
>>>
>>> On Sun, Feb 14, 2016 at 04:02:18PM +0200, Sagi Grimberg wrote:
>>>>
>>>>
>>>>>> I'm bisecting now, there are a couple of patches from Ming in
>>>>>> the area of the bio splitting code...
>>>>>>
>>>>>> CC'ing Ming, Linux-block and Linux-nvme as iser is identical to nvme
>>>>>> wrt the virtual boundary so I think nvme will break as well.
>>
>>
>> The bisected commit is merged to v4.3, and looks no such kind of
>> report from nvme.
>
>
> I'm wandering how can that be... because clearly iser is seeing gaps
> which like nvme, it can't handle those. Maybe this is scsi specific?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
