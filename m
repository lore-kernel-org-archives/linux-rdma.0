From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSD generic R/W API (sendto path) performance results
Date: Wed, 23 Nov 2016 10:01:13 -0500
Message-ID: <67A5C703-9CD1-4139-8D17-6BE2F81070F9@oracle.com>
References: <9170C872-DEE1-4D96-B9D8-E9D2B3F91915@oracle.com> <024601d23f7f$cef62500$6ce26f00$@opengridcomputing.com> <BA9DC9F7-C893-428B-AFE5-EFCCD13C9F25@oracle.com> <20161117124602.GA25821@lst.de> <84B43CFF-EBF7-4758-8751-8C97102C5BCF@oracle.com> <676323E9-2F30-4DB0-AEF8-CDE38E8A0715@oracle.com> <c6190e4c-9b8e-3937-ba38-7861eebeaaae@grimberg.me> <EB5A41EB-53AB-4BC9-A5A3-893A9828A5C9@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EB5A41EB-53AB-4BC9-A5A3-893A9828A5C9-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 17, 2016, at 3:42 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
>> 
>> On Nov 17, 2016, at 3:20 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>> 
>> 
>>>>> Also did you try to always register for > max_sge
>>>>> calls?  The code can already register all segments with the
>>>>> rdma_rw_force_mr module option, so it would only need a small tweak for
>>>>> that behavior.
>>>> 
>>>> For various reasons I decided the design should build one WR chain for
>>>> each RDMA segment provided by the client. Good clients expose just
>>>> one RDMA segment for the whole NFS READ payload.
>>>> 
>>>> Does force_mr make the generic API use FRWR with RDMA Write? I had
>>>> assumed it changed only the behavior with RDMA Read. I'll try that
>>>> too, if RDMA Write can easily be made to use FRWR.
>>> 
>>> Unfortunately, some RPC replies are formed from two or three
>>> discontiguous buffers. The gap test in ib_sg_to_pages returns
>>> a smaller number than sg_nents in this case, and rdma_rw_init_ctx
>>> fails.
>>> 
>>> Thus with my current prototype I'm not able to test with FRWR.
>>> 
>>> I could fix this in my prototype, but it would be nicer for me if
>>> rdma_rw_init_ctx handled this case the same for FRWR as it does
>>> for physical addressing, which doesn't seem to have any problem
>>> with a discontiguous SGL.
>>> 
>>> 
>>>> But I'd like a better explanation for this result. Could be a bug
>>>> in my implementation, my design, or in the driver. Continuing to
>>>> investigate.
>> 
>> Hi Chuck, sorry for the late reply (have been busy lately..)
>> 
>> I think that the Call-to-first-Write phenomenon you are seeing makes
>> perfect sense, the question is, is a QD=1 1M transfers latency that
>> interesting? Did you see a positive effect on small (say 4k) transfers?
>> both latency and iops scalability should be able to improve especially
>> when serving multiple clients.
>> 
>> If indeed you feel that this is an interesting workload to optimize, I
>> think we can come up with something.
> 
> I believe 1MB transfers are interesting: NFS is frequently used in
> back-up scenarios, for example, and believe it or not, also for
> non-linear editing and animation (4K video).
> 
> QD=1 exposes the individual components of latency. In this case, we
> can clearly see the cost of preparing the data payload for transfer.
> It's basically a tweak so we can debug the problem.
> 
> In the "Real World" I expect to see larger transfers, where several
> 1MB I/Os are dispatched in parallel. I don't reach fabric bandwidth
> until 10 or more are in flight, which I think should be improved.

I've found what looks like the problem.

After disabling DMA API and IOMMU debugging, the post-conversion
server shows 1MB NFS READ latency averaging about 403us, measured
via ibdump captured on the server. Pre-conversion, latency averages
about 397us in my set-up.

Post-conversion, it takes a little longer for the first RDMA Write
request after the NFS READ Call arrives (longer Call-to-first-Write),
but the RDMA Writes are transmitted on average a little faster with
the generic API (shorter First-to-last-Write).

But the "can't reach fabric bandwidth" issue appears to be a client
issue, not a server issue.

I compared a client-side and server-side ibdump capture taken during
the same benchmark run. The server emits an RDMA Write every
microsecond or two, like clockwork. The client, though, shows
occasional RDMA Write Middles arriving after a several hundred
microsecond pause. That's enough to slow down the time between NFS
READ Reply and the next NFS READ Call, and that impacts benchmarked
throughput.

ibqueryerrors shows the client's HCA and switch port are congested
(PortXmitWait). That counter goes up whenever the NFS workload
involves a significant number of RDMA Writes.

During benchmarking, I have used the default NFS rsize of 1MB.

If I mount with a smaller rsize, the ratio of RDMA Writes streamed
per NFS READ request goes down. At rsize=262144, iozone can reach
very close to fabric bandwidth (5.2GB/s) with 2MB and 4MB I/O, which
is about the best I can hope for.

This congestion issue also makes the iozone 1MB QD=1 benchmark
results highly variable.

With ConnectX-4 on the client, the congestion problem seems worse.
The good rsize=256KB result happens only when the client is using its
CX-3 Pro HCA.

Somehow I need to determine why the client's HCA gets hosed up during
heavy RDMA Write workloads. Could be the HCAs need to be in different
slots? Maybe it's NUMA effects? Perhaps the workload's ratio between
RDMA Write and RDMA Send?

Any advice is appreciated! ;-)


--
Chuck Lever


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
