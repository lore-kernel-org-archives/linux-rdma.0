From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Thu, 16 Jul 2015 11:29:56 +0300
Message-ID: <55A76B84.30504@dev.mellanox.co.il>
References: <20150713163015.GA23832@obsidianresearch.com>
 <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org>
 <55A534D1.6030008@dev.mellanox.co.il>
 <20150714163506.GC7399@obsidianresearch.com>
 <55A53F0B.5050009@dev.mellanox.co.il>
 <20150714170859.GB19814@obsidianresearch.com>
 <55A6136A.8010204@dev.mellanox.co.il>
 <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com>
 <55A754BC.6010706@dev.mellanox.co.il> <20150716080702.GD9093@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150716080702.GD9093-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/16/2015 11:07 AM, Christoph Hellwig wrote:
> On Thu, Jul 16, 2015 at 09:52:44AM +0300, Sagi Grimberg wrote:
>>>> I suggest to start with what I proposed. And in a later stage (if we
>>>> still think its needed) we can have a higher level API that hides the
>>>> post, something like:
>>>
>>>> rdma_reg_sg(struct ib_qp *qp,
>>>>             struct ib_mr *mr,
>>>>             struct scatterlist *sg,
>>>>             int sg_nents,
>>>>             u64 offset,
>>>>             u64 length,
>>>>             int access_flags)
>>>
>>> I still wonder what ?length? means in the context of a scatterlist.
>>
>> Would byte_count be a more explanatory name?
>
> What do you even need it for?  The total length is implicitly stored in
> the S/G list as the list of all elements.
>
> What's the offset for?  To allow skipping parts of a S/G list previously
> mapped?
>

These were added when I thought of the pages helper. The memory region
HW tables consist of physical addresses, a first byte offset, and a
byte length to indicate when the region ends in the last page.

However, if we have only sg lists, I agree that the length is derived
from the sg_list itself and the offset will be sg[0]->offset.

I can drop it, unless anyone can think of a use-case where a ULP would
want to register a region with a different offset from sg[0]->offset
and/or ends before the sum(sg->length).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
