From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 3/9] xprtrdma: Introduce ro_unmap_sync method
Date: Tue, 24 Nov 2015 12:59:01 +0200
Message-ID: <565442F5.7080400@dev.mellanox.co.il>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net>
 <20151123221414.32702.87638.stgit@manet.1015granger.net>
 <20151124064556.GA29141@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124064556.GA29141-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 24/11/2015 08:45, Christoph Hellwig wrote:
> On Mon, Nov 23, 2015 at 05:14:14PM -0500, Chuck Lever wrote:
>> In the current xprtrdma implementation, some memreg strategies
>> implement ro_unmap synchronously (the MR is knocked down before the
>> method returns) and some asynchonously (the MR will be knocked down
>> and returned to the pool in the background).
>>
>> To guarantee the MR is truly invalid before the RPC consumer is
>> allowed to resume execution, we need an unmap method that is
>> always synchronous, invoked from the RPC/RDMA reply handler.
>>
>> The new method unmaps all MRs for an RPC. The existing ro_unmap
>> method unmaps only one MR at a time.
>
> Do we really want to go down that road?  It seems like we've decided
> in general that while the protocol specs say MR must be unmapped before
> proceeding with the data that is painful enough to ignore this
> requirement.  E.g. iser for example only does the local invalidate
> just before reusing the MR.

It is painful, too painful. The entire value proposition of RDMA is
low-latency and waiting for the extra HW round-trip for a local
invalidation to complete is unacceptable, moreover it adds a huge loads
of extra interrupts and cache-line pollutions.

As I see it, if we don't wait for local-invalidate to complete before
unmap and IO completion (and no one does) then local invalidate before
re-use is only marginally worse. For iSER, remote invalidate solves this 
(patches submitted!) and I'd say we should push for all the
storage standards to include remote invalidate. There is the question
of multi-rkey transactions, which is why I stated in the past that
arbitrary sg registration is important (which will be submitted soon
for ConnectX-4).

Waiting for local invalidate to complete would be a really big
sacrifice for our storage ULPs.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
