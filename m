From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Difference between normal and fast memory registration
Date: Thu, 13 Jul 2017 10:53:51 +0300
Message-ID: <ae8c11ae-67af-1620-f069-6295ddc32ad3@grimberg.me>
References: <CAPO=kN1Qcb8SSvyxGgGPLgYOTGoGnV32RLNJU=f+b9_1aMYdcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPO=kN1Qcb8SSvyxGgGPLgYOTGoGnV32RLNJU=f+b9_1aMYdcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arka Sharma <arka.sw1988-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Hi All,

Hi Arka,

> Sorry for asking this question as this might sound very fundamental. I
> am very much new in rdma and Linux. I am trying to figure out how fast
> memory registration improves the cost of registration compared to
> normal registration ?. As per my understanding when we do memory
> registration then following steps occur.
> 1. The pages are pinned in physical memory
> 2. The physical addresses are transferred to the RNIC via bus specific
> mechanism to which RNIC is connected, in my case it is PCIe.
> Once a memory is registered we can acquire Lkey and Rkey. This is the
> case with normal registration. As mentioned in the paper named
> An Efficient Design for Fast Memory Registration in RDMA
> 
>   "With FMR, user pre-allocates a table in kernel memory to record
> physical address of memory region, and pre writes I/O registers of
> RDMA card to register memory information, and only fills the table for
> physical address of memory region during the real memory registration
> operations."
> 
> So my question is in case of fast registration when exactly physical
> addresses are written in registers of RNIC card. If it is done in
> initialization as I am thinking by reading this statement, in that
> case the physical location of data buffer to be registered may be
> different with the address that has been programmed to the RNIC. I
> have read in RDMA verbs specification that in case of fast
> registration we need to create a work request and post to SQ. Why this
> kind of approach is needed in case of fast registration.
> 
> Some clarification of this will be highly appreciated.

I'll try to clarify,

In general memory registration operation is expensive and as a guideline
should not be executed in a performance critical path. Applications
usually pre-register all their networking associated memory buffers in
advanced and simply work with the registered memory regions.

However, pre-registration is not always feasible. middlewares that work
on top of RDMA often do not "own" the memory buffers as they originate
in the upper layer application, so the middleware has no choice but to
register memory in the hot path. There are multiple ways to do that
efficiently, one is described in the paper you mentioned. Another
possible way for user-space middlewares to handle this is to use
"on-demand paging" in case the RNIC supports it.

Kernel-space drivers are often such middlewares as well, for these
drivers, a fast memory registration work-request based interface exist
(one of two interfaces). It a fundamental concept and is heavily used in
all our storage drivers in the kernel.

One important nuance that is important for fast-memory registration, is
that in case the delivery of the rkey to a remote node is (using a SEND
operation) is executed on the same queue-pair, it is *NOT* required to
wait for its completion before the SEND operation (which can and should
be pipelined). That is because the RDMA send-queue semantics guarantees
us ordering of send queue processing.

The way fast registration works is that at setup time, a pool of "free"
memory regions is allocated by the driver, these memory regions do not
have any memory buffers associated with them. Then when an I/O is
served, one MR is grabbed from the pool, and a corresponding work
request is constructed for the corresponding memory buffers and posted
on the session queue-pair. The cost is merely the price of dma mapping,
construction of a page vector and the actual post operation.

Hope this helps...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
