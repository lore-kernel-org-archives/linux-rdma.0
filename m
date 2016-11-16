From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSD generic R/W API (sendto path) performance results
Date: Wed, 16 Nov 2016 14:45:33 -0500
Message-ID: <BA9DC9F7-C893-428B-AFE5-EFCCD13C9F25@oracle.com>
References: <9170C872-DEE1-4D96-B9D8-E9D2B3F91915@oracle.com> <024601d23f7f$cef62500$6ce26f00$@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <024601d23f7f$cef62500$6ce26f00$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 15, 2016, at 3:35 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> 
>> 
>> I've built a prototype conversion of the in-kernel NFS server's sendto
>> path to use the new generic R/W API. This path handles NFS Replies, so
>> it is responsible for building and sending RDMA Writes carrying NFS
>> READ payloads, and for transmitting all NFS Replies.
>> 
>> I've published the prototype (against my for-4.10 server series) here:
>> 
>> 
> http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=shortlog;h=refs/heads/nfsd-rdma-rw
> -api
>> 
>> It's the very last patch in the series.
>> 
>> 
>> "iozone -i0 -i1 -s2g -r1m -I" with NFSv3, sec=sys, CX-3 on both sides,
>> FDR fabric, share is a tmpfs. This test writes and reads a 2GB file with
>> 1MB direct writes and reads.
>> 
>> The client forms NFS requests with a single 1MB RDMA segment to catch
>> the NFS READ payload. Before the conversion, the server posts a series
>> of single Write WRs with 30 pages each, for each RDMA segment written
>> to the client. After the conversion, the server posts a single chain
>> of 30-page Write WRs for each RDMA segment written to the client.
>> 
>> Before the API conversion: rdma_stat_post_send = 45097
>> 
>> After the API conversion: rdma_stat_post_send = 16411
>> 
>> That's what I expected to see. This shows the number of ib_post_send
>> calls is significantly lower after the conversion.
>> 
>> 
>> Unfortunately the throughput and latency numbers are worse (ignore
>> the write/rewrite numbers for now). Output is in kBytes/sec.
>> 
>> Before conversion, one iozone run:
>> 
>>              kB  reclen    write  rewrite    read    reread
>>         2097152    1024   772835   931267  1895922  1927848
>> 
>> READ:
>>    4098 ops (49%)
>>    avg bytes sent per op: 140    avg bytes received per op: 1048704
>>    backlog wait: 0.006345     RTT: 0.321132     total execute time: 0.332113
>> 
>> After conversion:
>> 
>>              kB  reclen    write  rewrite    read    reread
>>         2097152    1024   703850   913824  1561682  1441448
>> 
>> READ:
>>    4098 ops (49%)
>>    avg bytes sent per op: 140    avg bytes received per op: 1048704
>>    backlog wait: 0.010737     RTT: 0.469497     total execute time: 0.488043
>> 
>> That's 140us worse RTT per READ, in this run. The gap between before and
>> after was roughly the same for all runs.
>> 
>> 
>> To partially explain this, I captured traffic on the server using ibdump
>> during a similar iozone test. This removes fabric and client HCA latencies
>> from the picture.
>> 
>> This is a QD=1 test, so it's easy to analyze individual NFS READ operations
>> in each capture. I computed three latency numbers per READ transaction
>> based on the timestamps in the capture file, which should be accurate to
>> 1 microsecond:
>> 
>> 1. Call took: the time between when the server i/f sees the incoming RDMA
>> Send carrying the NFS READ Call, and when the server i/f sees the outgoing
>> RDMA Send carrying the NFS READ Reply.
>> 
>> 2. Call-to-first-Write: the time between when the server i/f sees the
>> incoming RDMA Send carrying the NFS READ Call, and when the server i/f
>> sees the first outgoing RDMA Write request. Roughly how long it takes
>> the server to prepare and post the RDMA Writes.
>> 
>> 3. First-to-last-Write: the time between when the server i/f sees the
>> first outgoing RDMA Write request, and when the server i/f sees the
>> last outgoing RDMA Write request. Roughly how long it takes the HCA
>> to transmit the RDMA Writes.
>> 
>> 
>> Averages over 5 NFS READ calls chosen at random, before conversion:
>> Call took 414us. Call-to-first-Write 85us. First-to-last-Write 327us
>> 
>> Averages over 5 NFS READ calls chosen at random, after conversion:
>> Call took 521us. Call-to-first-Write 160us. First-to-last-Write 360us
>> 
>> The gap between before and after results was 100% consistent with
>> the average results across the individual NFS READ operations.
>> 
>> 
> 
> Good work here! 
> 
>> There are two stories here:
>> 
>> 1. Call-to-first-Write takes longer. My first guess is that the server
>> takes longer to build and DMA map a long Write WR chain than it does
>> to build, map, and post a single Write WR. The HCA can get started
>> transmitting Writes sooner, and the server continues working on
>> posting Write WRs in parallel with the on-the-wire activity.
>> 
> 
> So perhaps the RDMA R/W API can have a threshold where it will dump a list of
> WRs once it exceeds the threshold, and continue chunking?  That threshold, by
> the way, is probably device-specific.
> 
>> 2. First-to-last-Write takes longer. I don't have any explanation
>> for the HCA taking 10% longer to transmit the full 1MB payload.
>> 
> 
> Perhaps the single WR posts are hitting device's fast-path and lowering latency
> vs a long chain post that must be DMAed by the device?  I'm not sure exactly how
> the MLX devices work, but they do have a fast path that utilizes the CPU's
> write-combining logic to send a WR over the bus as a single PCIE transaction.
> But your WRs are probably large since they have 30 pages in the SGE.  I'm not
> sure what the threshold is for this fastpath logic for mlx.  For cxgb, its 64B,
> so the WR would have to fit in 64B to take advantage.

Out of curiosity, I hacked up my NFS client to limit the size of RDMA
segments to 30 pages (the server HCA's max_sge).

A 1MB NFS READ now takes 9 segments. That forces the after-conversion
server to build single-Write chains and use 9 post_send calls to
transmit the READ payload, just like the before-conversion server.

Performance of before- and after-conversion servers is now equivalent.

              kB  reclen    write  rewrite    read    reread
         2097152    1024  1061237  1141614  1961410  2000223                                                                                  

READ:
    4098 ops (49%) 
    avg bytes sent per op: 140    avg bytes received per op: 1048704
    backlog wait: 0.006345     RTT: 0.314300     total execute time: 0.325037

At 60-page segments (2 Write WRs per chain), I see about the same
throughput, and RT latency is a touch higher.

At 61-page segments (3 Write WRs per chain), throughput drops
significantly:

              kB  reclen    write  rewrite    read    reread
         2097152    1024   932665   976784  1627842  1627169                                                                                  

READ:
    4098 ops (49%) 
    avg bytes sent per op: 140	avg bytes received per op: 1048704
    backlog wait: 0.009761 	RTT: 0.383358 	total execute time: 0.398731

A couple of random samples of an ibdump capture show that most of the
latency increase is in the Call-to-first-Write gap (1. above).


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
