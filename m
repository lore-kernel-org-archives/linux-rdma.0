From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Sun, 19 Jul 2015 08:33:24 +0300
Message-ID: <55AB36A4.1070102@dev.mellanox.co.il>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150715073233.GA11535@infradead.org>
 <20150715170750.GA23588@obsidianresearch.com>
 <55A7A1B0.5000808@dev.mellanox.co.il>
 <20150716180806.GC3680@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150716180806.GC3680-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/16/2015 9:08 PM, Jason Gunthorpe wrote:
> On Thu, Jul 16, 2015 at 03:21:04PM +0300, Sagi Grimberg wrote:
>> I gotta say,
>>
>> these suggestions of bool/write or supported_ops with a convert helper
>> seem (to me at least) to make things more complicated.
>>
>> Why not just set the the access_flags as they are?
>> I want local use?
>> set IB_ACCESS_LOCAL_WRITE
>> I want a peer to read from me?
>> set IB_ACCESS_REMOTE_READ
>> I want a peer to write to me?
>> IB_ACCESS_REMOTE_WRITE
>> ...
>>
>> isn't it much simpler?
>
> I don't have a really strong preference, but I like the idea of using
> the OP names because it means the API cannot be used wrong.
>
> Ie this, is absolutely wrong:
>
>   rdma_map_sg_lkey(..,IB_ACCESS_REMOTE_READ);
>
> But this:
>
>   rdma_map_sg_lkey(..,IB_ACCESS_REMOTE_WRITE);
>
> Is only wrong on IB.
>
> While,
>   rdma_map_sg_lkey(..,RDMA_OP_RDMA_READ)
>
> Is always right, and can never be used wrong, and thus is less
> complicated (for the ULP).

I was thinking that the user won't explicitly say which key it registers
and it will be decided from the registration itself.
Meaning, the registration code will do:

if (access | (IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE)
         register rkey...
else
         register lkey...

Will that work with iWARP? or will this break because
iWARP needs REMOTE_WRITE for lkeys?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
