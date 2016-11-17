From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSD generic R/W API (sendto path) performance results
Date: Thu, 17 Nov 2016 15:20:46 -0500
Message-ID: <239858AD-07B9-4236-A693-EF3093F003DF@oracle.com>
References: <9170C872-DEE1-4D96-B9D8-E9D2B3F91915@oracle.com> <024601d23f7f$cef62500$6ce26f00$@opengridcomputing.com> <BA9DC9F7-C893-428B-AFE5-EFCCD13C9F25@oracle.com> <20161117124602.GA25821@lst.de> <84B43CFF-EBF7-4758-8751-8C97102C5BCF@oracle.com> <676323E9-2F30-4DB0-AEF8-CDE38E8A0715@oracle.com> <01f001d2410d$b16c97f0$1445c7d0$@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01f001d2410d$b16c97f0$1445c7d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 17, 2016, at 3:03 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> 
>>> 
>>> On Nov 17, 2016, at 10:04 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>> 
>>>> On Nov 17, 2016, at 7:46 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>>>> Also did you try to always register for > max_sge
>>>> calls?  The code can already register all segments with the
>>>> rdma_rw_force_mr module option, so it would only need a small tweak for
>>>> that behavior.
>>> 
>>> For various reasons I decided the design should build one WR chain for
>>> each RDMA segment provided by the client. Good clients expose just
>>> one RDMA segment for the whole NFS READ payload.
>>> 
>>> Does force_mr make the generic API use FRWR with RDMA Write? I had
>>> assumed it changed only the behavior with RDMA Read. I'll try that
>>> too, if RDMA Write can easily be made to use FRWR.
>> 
>> Unfortunately, some RPC replies are formed from two or three
>> discontiguous buffers. The gap test in ib_sg_to_pages returns
>> a smaller number than sg_nents in this case, and rdma_rw_init_ctx
>> fails.
>> 
>> Thus with my current prototype I'm not able to test with FRWR.
>> 
>> I could fix this in my prototype, but it would be nicer for me if
>> rdma_rw_init_ctx handled this case the same for FRWR as it does
>> for physical addressing, which doesn't seem to have any problem
>> with a discontiguous SGL.
> 
> Just to make sure I'm understanding you, for rdma-rw to handle this,  it would
> have to use multiple REG_MR registrations, one for each contiguous area in the
> scatter list.  
> 
> Right?

Right, that's the approach the NFS client takes. See
net/sunrpc/xprtrdma/frwr_ops.c :: frwr_op_map.

If the passed-in memory list isn't contiguous, frwr_op_map stops
registering and returns to the caller, who allocates another
MR and calls in again with the remaining part of the list.

I think this would not apply to SG_GAP MRs, which should
already be able to handle discontiguous SGLs?

Note this doesn't apply to most NFS READs, where just the data
payload is going via RDMA Write, and the payload is already in
a contiguous piece of memory. But Reply chunks, which are used
for READDIRs and other requests, can be built from discontiguous
memory.

I haven't looked closely at the RDMA Read logic, but I think
it always reads into a contiguous set of pages, then builds
the xdr_buf out of that. It shouldn't have the same problem
(and it is already known to work with FRWR ;-).


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
