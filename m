From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 03/14] svcrdma: Eliminate RPCRDMA_SQ_DEPTH_MULT
Date: Wed, 22 Mar 2017 15:30:22 -0400
Message-ID: <EA949818-1DC4-471C-95C7-C96EA1977236@oracle.com>
References: <20170316154132.4482.56769.stgit@klimt.1015granger.net> <20170316155250.4482.49638.stgit@klimt.1015granger.net> <46eb6195-a542-b35c-4902-a2bebb38feba@grimberg.me> <391F0D90-2A46-4B2F-BCF0-B3BE7D48A3EF@oracle.com> <ec82feb4-d6b9-7fb4-5b11-b8007e313845@grimberg.me> <C9D8A91C-DE08-4A41-A07D-1F4C42DD9B97@oracle.com> <68e3eda0-90f4-5bca-28be-b2cf494ed172@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <68e3eda0-90f4-5bca-28be-b2cf494ed172-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Mar 22, 2017, at 3:06 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
>> Roughly speaking, I think there needs to be an rdma_rw API that
>> assists the ULP with setting its CQ and SQ sizes, since rdma_rw
>> hides the registration mode (one of which, at least, consumes
>> more SQEs than the other).
> 
> Hiding the registration mode was the largely the motivation for
> this... It buys us simplified implementation and inherently supports
> both IB and iWARP (which was annoying and only existing in svc but
> still suboptimal).
> 
>> I'd like to introduce one new function call that surfaces the
>> factor used to compute how many additional SQEs that rdma_rw will
>> need. The ULP will invoke it before allocating new Send CQs.
> 
> I see your point... We should probably get a sense on how to
> size the completion queue. I think that this issue is solved with
> the CQ pool API that Christoph sent a while ago but was never
> pursued.
> 
> The basic idea is that the core would create a pool of long CQs
> and then assigns queue-pairs depending on the sq+rq depth.
> If we were to pick it up would you consider using it?

I will certainly take a look at it. But I don't think that's
enough.

The ULP is also responsible for managing send queue accounting,
and possibly queuing WRs when a send queue is full. So it still
needs to know the maximum number of send WRs that can be posted
at one time. For svc_rdma, this is sc_sq_avail.

I believe that the ULP needs to know the actual number of SQEs
both for determining CQ size, and for knowing when to plug the
send queue.

This maximum depends on the registration mode, the page list
depth capability of the HCA (relative to the maximum ULP data
payload size), and the page size of the platform.

For example, for NFS, the typical maximum rsize and wsize is 1MB.
The CX-3 Pro cards I have allow 511 pages per MR in FRWR mode.
My systems are x64 using 4KB pages.

So I know that one rdma_rw_ctx can handle 256 pages (or 1MB) of
payload on my system.

An HCA with a smaller page list depth or if the system has larger
pages, or an rsize/wsize of 4MB might want a different number of
MRs for the same transport, and thus a larger send queue.

Alternately, we could set a fixed arbitrary send queue size, and
force all ULPs and devices to live with that. That would be much
simpler.


>> I'll try to provide an RFC in the nfsd-rdma-rw-api topic branch.
> 
> Cool, lets see what you had in mind...


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
