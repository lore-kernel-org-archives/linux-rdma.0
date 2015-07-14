From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Tue, 14 Jul 2015 19:12:01 +0300
Message-ID: <55A534D1.6030008@dev.mellanox.co.il>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150713163015.GA23832@obsidianresearch.com>
 <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714153347.GA11026-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/14/2015 6:33 PM, Christoph Hellwig wrote:
> On Tue, Jul 14, 2015 at 11:39:24AM +0300, Sagi Grimberg wrote:
>> This is exactly what I don't want to do. I don't think that implicit
>> posting is a good idea for reasons that I mentioned earlier:
>>
>> "This is where I have a problem. Providing an API that may or may not
>> post a work request on my QP is confusing, and I don't understand its
>> semantics at all. Do I need to reserve slots on my QP? should I ask for
>> a completion? If we suppress the completion will I see an error
>> completion? What should I expect to find in the wr_id?"
>>
>> We're much better off with keeping the post interface in place but
>> have it much simpler.
>
> The ULP doesn't care if it needs to reserver the slot, and it generally
> doesn't care about the notification either unless it needs to handle an
> error.

That's generally correct. But the ULP may want to suppress notifications
of other posts as well (for example a storage initiator may want to
suppress send completions since it needs to reserve the request context
until it receives the status anyway - which is a receive completion). It
needs to take what was posted and what not into account to avoid
wrapping.

If I'm not mistaken iWARP requires to ask for a completion once every
send-queue length and empirically, IB drivers requires it too. So again,
I don't think implicit posting is a very good idea.

> The completions are another mad mightmare in the RDMA stack API.  Every
> other subsystem would just allow submitter to attach a function pointer
> that handles the completion to the posted item.

This is actually a good idea. And it can be easily added I think (at
least to mlx drivers which I better). It can help removing a switch
statement for the ULPs when handling the completions.

   But no, the RDMA stack
> instead require ID allocators and gigantic boilerplate code in the
> consumer to untangle that gigantic mess again.

I don't think the wr_id was ever intended to be an allocated tag. It's
the ULP context, usually a pointer to a transaction structure. Even
with passing a function pointer you need to get back your original
context don't you?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
