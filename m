From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Mon, 10 Jul 2017 15:03:18 -0400
Message-ID: <A7C8C159-E916-4060-9FD1-8726D816B3C0@oracle.com>
References: <4f0812f1-0067-4e63-e383-b913ee1f319d@grimberg.me> <28F6F58E-B6F4-4114-8DFF-B72353CE814B@oracle.com> <52ad3547-efcf-f428-6b39-117efda3379f@grimberg.me> <9990B5CB-E0FF-481E-9F34-21EACF0E796E@oracle.com> <f1f1a68c-90db-e6bf-e35e-55c4b469c339@grimberg.me> <7D1C540B-FEA0-4101-8B58-87BCB7DB5492@oracle.com> <66b1b8be-e506-50b8-c01f-fa0e3cea98a4@grimberg.me> <9D8C7BC8-7E18-405A-9017-9DB23A6B5C15@oracle.com> <11aa1a24-9f0b-dbb8-18eb-ad357c7727b2@grimberg.me> <9E30754F-464A-4B62-ADE7-F6B2F6D95763@oracle.com> <20170709164755.GB3058@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170709164755.GB3058-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jul 9, 2017, at 12:47 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
> On Sun, Jul 02, 2017 at 02:17:52PM -0400, Chuck Lever wrote:
> 
>> I could kmalloc the SGE array instead, signal each Send,
>> and then in the Send completion handler, unmap the SGEs
>> and then kfree the SGE array. That's a lot of overhead.
> 
> Usually after allocating the send queue you'd pre-allocate all the
> tracking memory needed for each SQE - eg enough information to do the
> dma unmaps/etc?

Right. In xprtrdma, the QP resources are allocated in rpcrdma_ep_create.
For every RPC-over-RDMA credit, rpcrdma_buffer_create allocates an
rpcrdma_req structure, which contains an ib_cqe and an array of SGEs for
the Send, and a number of other resources used to maintain registration
state during an RPC-over-RDMA call. Both of these functions are invoked
during transport instance set-up.

The problem is the lifetime for the rpcrdma_req structure. Currently it
is acquired when an RPC is started, and it is released when the RPC
terminates.

Inline send buffers are never unmapped until transport tear-down, but
since:

commit 655fec6987be05964e70c2e2efcbb253710e282f
Author:     Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
AuthorDate: Thu Sep 15 10:57:24 2016 -0400
Commit:     Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
CommitDate: Mon Sep 19 13:08:38 2016 -0400

    xprtrdma: Use gathered Send for large inline messages

Part of the Send payload can come from page cache pages for NFS WRITE
and NFS SYMLINK operations. Send buffers that are page cache pages are
DMA unmapped when rpcrdma_req is released.

IIUC what Sagi found is that Send WRs can continue running even after an
RPC completes in certain pathological cases. Therefore the Send WR can
complete after the rpcrdma_req is released and page cache-related Send
buffers have been unmapped.

It's not an issue to make the RPC reply handler wait for Send completion.
In most cases, this is not going to add any additional latency because
the Send will complete long before the RPC reply arrives. By far the
common case, and that's an extra completion interrupt for nothing.

The problem arises if the RPC is terminated locally before the reply
arrives. Suppose, for example, user hits ^C, or a timer fires. Then the
rpcrdma_req can be released and re-used before the Send completes.
There's no way to make RPC completion wait for Send completion.

One option is to somehow split the Send-related data structures from
rpcrdma_req, and manage them independently. I've already done that for
MRs: MR state is now located in rpcrdma_mw.

If instead I just never DMA map page cache pages, then all Send buffers
are always left DMA mapped while the transport is active. There's no
problem there with Send retransmits. The overhead is that I have to
either copy data into the Send buffers, or force the server to use RDMA
Read, which has a palpable overhead.


>> Or I could revert all the "map page cache pages" logic and
>> just use memcpy for small NFS WRITEs, and RDMA the rest of
>> the time. That keeps everything simple, but means large
>> inline thresholds can't use send-in-place.
> 
> Don't you have the same problem with RDMA WRITE?

The server side initiates RDMA Writes. The final RDMA Write in a WR
chain is signaled, but a subsequent Send completion is used to
determine when the server may release resources used for the Writes.
We're already doing it the slow way there, and there's no ^C hazard
on the server.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
