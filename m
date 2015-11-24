From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 3/9] xprtrdma: Introduce ro_unmap_sync method
Date: Tue, 24 Nov 2015 16:40:16 +0200
Message-ID: <565476D0.3020607@dev.mellanox.co.il>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net>
 <20151123221414.32702.87638.stgit@manet.1015granger.net>
 <20151124064556.GA29141@infradead.org> <565442F5.7080400@dev.mellanox.co.il>
 <5654697E.1030809@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5654697E.1030809-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Tom,

> On 11/24/2015 5:59 AM, Sagi Grimberg wrote:
>> As I see it, if we don't wait for local-invalidate to complete before
>> unmap and IO completion (and no one does)
>
> For the record, that is false. Windows quite strictly performs these
> steps,

I meant Linux ULPs. I'm not very familiar with Windows SMBD.

> and deliver millions of real 4K IOPS over SMB Direct.

That's very encouraging! Is this the client side scaling?
 From my experience, getting a storage client/initiator to scale
up to 1.5-3 MIOPs over a single HCA with limited number of cores
is really a struggle for each interrupt and cacheline.

Still the latency of each IO will see a noticable increase.

>> Waiting for local invalidate to complete would be a really big
>> sacrifice for our storage ULPs.
>
> Not waiting would also be a sacrifice, by compromising data integrity.
> It's a tough tradeoff, but if you choose to go that way it will be
> critical to be honest about the consequences to the data.

That's true. I assume that the best compromise would be remote
invalidation but some standards needs enhancements and it doesn't solve
the multi-rkey transactions.

As storage devices are becoming faster we really should try to do our
best to keep up.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
