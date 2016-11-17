From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSD generic R/W API (sendto path) performance results
Date: Thu, 17 Nov 2016 15:42:37 -0500
Message-ID: <EB5A41EB-53AB-4BC9-A5A3-893A9828A5C9@oracle.com>
References: <9170C872-DEE1-4D96-B9D8-E9D2B3F91915@oracle.com> <024601d23f7f$cef62500$6ce26f00$@opengridcomputing.com> <BA9DC9F7-C893-428B-AFE5-EFCCD13C9F25@oracle.com> <20161117124602.GA25821@lst.de> <84B43CFF-EBF7-4758-8751-8C97102C5BCF@oracle.com> <676323E9-2F30-4DB0-AEF8-CDE38E8A0715@oracle.com> <c6190e4c-9b8e-3937-ba38-7861eebeaaae@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c6190e4c-9b8e-3937-ba38-7861eebeaaae-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 17, 2016, at 3:20 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
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
>> 
>> 
>>> But I'd like a better explanation for this result. Could be a bug
>>> in my implementation, my design, or in the driver. Continuing to
>>> investigate.
> 
> Hi Chuck, sorry for the late reply (have been busy lately..)
> 
> I think that the Call-to-first-Write phenomenon you are seeing makes
> perfect sense, the question is, is a QD=1 1M transfers latency that
> interesting? Did you see a positive effect on small (say 4k) transfers?
> both latency and iops scalability should be able to improve especially
> when serving multiple clients.
> 
> If indeed you feel that this is an interesting workload to optimize, I
> think we can come up with something.

I believe 1MB transfers are interesting: NFS is frequently used in
back-up scenarios, for example, and believe it or not, also for
non-linear editing and animation (4K video).

QD=1 exposes the individual components of latency. In this case, we
can clearly see the cost of preparing the data payload for transfer.
It's basically a tweak so we can debug the problem.

In the "Real World" I expect to see larger transfers, where several
1MB I/Os are dispatched in parallel. I don't reach fabric bandwidth
until 10 or more are in flight, which I think should be improved.

Wrt 4KB, I didn't see much change there, though I admit I didn't
expect much change since both cases have to DMA map a page, and post
one Write WR, so I haven't looked too closely. I'm already down
around 32us for a 4KB NFS READ, even without the server changes,
and 30us for 4KB NFS READ all-inline.

I agree, though, that there is a 3:1 reduction in ib_post_send calls
with the generic API in my test harness, and that can only be a good
thing.


> About the First-to-last-Write, thats weird, and sound like a bug
> somewhere. Maybe Mellanox folks can tell us if splitting 1M to multiple
> writes works better (although I cannot comprehend why).
> 
> Question, are the send and receive cqs still in IB_POLL_SOFTIRQ mode?

Yes, both are still in SOFTIRQ. A while back I played with using the
Work Queue mode, and noticed some slowdowns when the Send CQ was
changed to use Work Queue. I didn't explore it further.

Someday, these will need to be changed, so that the server runs
entirely in process context (as it does for TCP, AFAICT). That gets
rid of BH flapping, but adds heavy-weight context switching latencies.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
