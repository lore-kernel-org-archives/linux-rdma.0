From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA and memory ordering
Date: Tue, 12 Nov 2013 03:28:10 -0400
Message-ID: <CADPSxAjAcBHpRFy6j7j5ZagR2qu_3S-jhS_SWya0nsaE5EHe3Q@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237388CF721E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CF721E-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean,

Thanks for your reply. Sorry for the duplicate email!

Your argument is correct if the structs are large. In my case, the
array A[] contains 32 byte structs that don't span multiple L3
cachelines (ensured via memalign). I've heard that RDMA reads happen
at L3 cacheline granularity - in that case, A[i] will be read once and
placed on the wire. Then we could see partial writes to A[i].value or
A[i].counter, but we'll never see a completed update to A[i].counter
before the corresponding update to A[i].value.

I had parallel questions that could help me understand the issue better:

1. I am I right in assuming that RDMA reads happen from the remote
host's L3 cache? My processors are from the AMD Opteron 6200 series.
The argument I heard in favor of this is that 'modern' processors have
on-chip memory controllers, so DMA reads always come from the L3
cache.

2. Are reads from the L3 cache always consistent with L1 and L2 cache?
i.e. can some update be cached inside L1 cache so that an L3 read sees
an old value? I think that this doesn't happen or I would be seeing
lots of stale reads.

3. When we do an RDMA write, is there an order in which the bytes get
written? For example, I heard during a talk that there is a
left-to-right ordering i.e. the lower addressed bytes get written
before higher addressed bytes. Is this correct?

In general, can I read more about the hardware aspects of RDMA somewhere?

--Anuj

On Mon, Nov 11, 2013 at 7:13 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> I am running a server which essentially does the following operations in a
>> loop:
>>
>> A[i].value = counter;  //It's actually something else
>> asm volatile ("" : : : "memory");
>> asm volatile("mfence" ::: "memory");
>> A[i].counter = counter;
>> printf("%d %d\n", A[i].value, A[i].counter);
>> counter ++;
>>
>> Basically, I want a fresh value of A[i].counter to indicate a fresh
>> A[i].value.
>>
>> I have a remote client which reads the struct A[i] from the server
>> (via RDMA) in a loop. Sometimes in the value that the client reads,
>> A[i].counter is larger than A[i].value. i.e., I see the newer value of
>> A[i].counter but A[i].value corresponds to a previous iteration of the
>> server's loop.
>>
>> How can this happen in the presence of memory barriers? With barriers,
>> A[i].counter should be updated later and therefore should always be
>> smaller than A[i].value.
>>
>> Thanks for your help!
>
> It seems possible for a remote read to start retrieving memory before an update, such that A[i].value is read and placed on the wire, the server modifies the memory, and then A[i].counter is read and placed on the wire.  It may depend on how large the data is that's being read and the RDMA read implementation.
>
> - Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
