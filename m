From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Thu, 16 Jul 2015 09:52:44 +0300
Message-ID: <55A754BC.6010706@dev.mellanox.co.il>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150713163015.GA23832@obsidianresearch.com>
 <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org>
 <55A534D1.6030008@dev.mellanox.co.il>
 <20150714163506.GC7399@obsidianresearch.com>
 <55A53F0B.5050009@dev.mellanox.co.il>
 <20150714170859.GB19814@obsidianresearch.com>
 <55A6136A.8010204@dev.mellanox.co.il>
 <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A9EF2F26-E737-4E80-B2E3-F8D6406F9893-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/15/2015 5:32 PM, Chuck Lever wrote:
>
> On Jul 15, 2015, at 4:01 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>=
 wrote:
>
>> On 7/14/2015 8:09 PM, Jason Gunthorpe wrote:
>>> On Tue, Jul 14, 2015 at 07:55:39PM +0300, Sagi Grimberg wrote:
>>>
>>>> But, if people think that it's better to have an API that does imp=
licit
>>>> posting always without notification, and then silently consume err=
or or
>>>> flush completions. I can try and look at it as well.
>>>
>>> Can we do FMR transparently if we bundle the post? If yes, I'd call
>>> that a winner..
>>
>> Doing FMR transparently is not possible as the unmap flow is schedul=
ing.
>> Unlike NFS, iSER unmaps from a soft-IRQ context, SRP unmaps from
>> hard-IRQ context.
>
> The context in which RPC/RDMA performs FMR unmap mustn=92t sleep.
> RPC/RDMA is in roughly the same situation as the other initiators.
>
>
>> Changing the context to thread context is not
>> acceptable. The best we can do is using FMR_POOLs transparently.
>> Other than polluting the API and its semantics I suspect people will
>> have other problems with it (leaving the MRs open).
>
> Count me in that group.
>
> I would rather not build a non-deterministic delay into the
> unmap interface. Using a pool or having map do an implicit
> unmap are both solutions I=92d rather avoid.
>
> In both situations, MRs can be left mapped indefinitely if,
> say, the workload pauses.
>
>
>> I suggest to start with what I proposed. And in a later stage (if we
>> still think its needed) we can have a higher level API that hides th=
e
>> post, something like:
>
>> rdma_reg_sg(struct ib_qp *qp,
>>             struct ib_mr *mr,
>>             struct scatterlist *sg,
>>             int sg_nents,
>>             u64 offset,
>>             u64 length,
>>             int access_flags)
>
> I still wonder what =93length=94 means in the context of a scatterlis=
t.

Would byte_count be a more explanatory name?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
