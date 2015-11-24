From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Future of FMR support, was: Re: [PATCH v1 5/9] xprtrdma: Add
 ro_unmap_sync method for FMR
Date: Tue, 24 Nov 2015 07:36:34 -0500
Message-ID: <565459D2.9010600@talpey.com>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net>
 <20151123221430.32702.86114.stgit@manet.1015granger.net>
 <5653B606.3070700@talpey.com> <20151124065225.GB29141@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124065225.GB29141-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/24/2015 1:52 AM, Christoph Hellwig wrote:
> On Mon, Nov 23, 2015 at 07:57:42PM -0500, Tom Talpey wrote:
>> On 11/23/2015 5:14 PM, Chuck Lever wrote:
>>> FMR's ro_unmap method is already synchronous because ib_unmap_fmr()
>>> is a synchronous verb. However, some improvements can be made here.
>>
>> I thought FMR support was about to be removed in the core.
>
> Seems like everyone would love to kill it, but no one dares to do
> it just yet.  Reasons to keep FMRs:
>
>   - mthca doesn't support FRs but haven't been staged out
>   - RDS only supports FRMs for the IB transports (it does support FRs for
>     an entirely separate iWarp transports.  I'd love to know why we can't
>     just use that iWarp transport for IB as well).
>   - mlx4 hardware might be slower with FRs than FRMs (Or mentioned this
>     in reply to the iSER remote invalidation series).

Ok, let me add then.

Reasons to kill FMRs:

   - FMRs are UNSAFE. They protect on page boundaries, not byte,
     therefore a length error on an operation can corrupt data
     outside the i/o buffer remotely. To say nothing of maliciousness.

   - FMRs are SLOWER. The supposed performance improvement of FMR
     comes from the "mempool" that is often placed in front of them.
     These pools cache remotely registered regions, in the hope of
     reusing them without having to invalidate in between. See the
     first bullet for the ramifications of that.

   - FMRs are SYNCHRONOUS. The FMR verbs make direct calls into the
     verbs which block and/or do not return control to the caller
     promptly as do work queue operations. The processor spends
     more time servicing the device, typically at raised irq.

   - FMRs are PROPRIETARY. Only one vendor supports them, only one
     of their NICs has no decent alternative, and that NIC is
     functionally obsolete.

If storage stacks continue to support them, I personally feel it
is critical to carefully document the risks to customer data as
part of shipping the code.

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
