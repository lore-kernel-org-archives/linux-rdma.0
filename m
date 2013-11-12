From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA and memory ordering
Date: Tue, 12 Nov 2013 16:59:19 -0400
Message-ID: <CADPSxAgF1CAiYoYbxbCON4NCD-tH8cAsJFRtECkTGJJQC4MXCg@mail.gmail.com>
References: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w@mail.gmail.com>
	<5281FFF9.5070705@gmail.com>
	<CADPSxAh6i74j8JVmWncttN6W4ithTGmsMgqWWpoBy2Z8RRb=_g@mail.gmail.com>
	<20131112183142.GB6639@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131112183142.GB6639-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

[Included missed conversation with Jason at end].

Jason,

Thanks again. So we conclude there is nothing like an atomic cacheline
read. Then my current design is a dud. But there should be 8 byte
atomicity, right? I think I can leverage that to get what I want.

This part is interesting (from Jason's reply):
"If you burst read from the HCA value and counter then the result is
undefined, you don't know if counter was read before value, or the
other way around."

Is there a way of knowing the order in which they are read - for
example, I heard in a talk that there is a left-to-right ordering when
a HCA reads a contiguous buffer. This could be totally architecture
specific, for example, I just want the answer for Mellanox ConnectX-3
cards. I think I can check this experimentally, but a definitive
answer would be great.

--Anuj

[Conversation with Jason follows]

Jason,

Thanks a lot for your reply.

I think I understand that the RDMA reader will not see the ordering in
the updates to A[i].value and A[i].counter if they are in different L3
cache lines. But what are the guarantees when they are in the same
cache line?

For example, 32 bit processors have atomic 32 bit loads and stores
i.e. memory operations to the same 32 bit (aligned) word are
linearizable.

On 12 Nov 2013 13:31, "Jason Gunthorpe" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>
> On Tue, Nov 12, 2013 at 06:31:04AM -0400, Anuj Kalia wrote:
>
> > That makes sense. This way, we have no consistency between the CPU's
> > view and the HCA's view - it all depends when the cache gets flushed
> > to RAM.
>
> What you are talking about is firmly in undefined territory. You might
> be able to get something to work today, but tomorrows CPUs and HCAs
> might mess it up.
>
> You will never reliably get the guarentee you desired with the scheme
> you have. Even with two CPUs it is not going to happen.
>
> > I have a remote client which reads the struct A[i] from the server
> > (via RDMA) in a loop. Sometimes in the value that the client reads,
> > A[i].counter is larger than A[i].value. i.e., I see the newer value of
> > A[i].counter but A[i].value corresponds to a previous iteration of the
> > server's loop.
>
>
>
> This is a fundamental mis-understanding of what FENCE does, it just
> makes the writes happen in-order, it doesn't alter the reader side
>
> CPU1                         CPU2
>                              read avalue
> value = counter
> FENCE
> a.counter = counter
>                              read a.counter
>
> value < counter
>
That's right - thanks for the detailed explanation! However, I'm
assuming that the HCA performs atomic cacheline reads (I don't have a
lot of basis for this assumption and it would be great if someone
could tell me more about it). If that is true, 'read a.value' and
'read a.counter' are not 2 separate operations. Instead, there is one
'read cacheline(a)' - that should provide a snapshot of a's state at
CPU1.
>
>
> CPU1                         CPU2
> a.value = counter
>                              read a.value
> FENCE
> a.counter = counter
>                              read a.coutner
>
> value < counter
>
>
> CPU1                         CPU2
> a.value = counter
> FENCE
>                              read a.value
> < SCHEDULE >
> a.counter = counter
>                              read a.coutner
>
> value < counter
>
> etc.
>
> This stuff is hard, if you want a crazy scheme to be reliable you need
> to have really detailed understanding of what is actually being
> guarenteed.
>
> > However, if the HCA performs reads from L3 cache, then everything
> > should be consistent, right? While ordering the writes, I think we
> > can
>
> No. The cache makes no difference. Fundamentally you aren't atomically
> writing cache lines. You are writing single values.


I was not assuming atomic writes to the entire cacheline - I was only
assuming that the ordering imposed by mfence is preserved in cache -
the write to 'a.value' appears in the cache hierarchy before the write
to 'a.counter'.

>
> 99% of the time it might look like atomic cache line writes, but there
> is a 1% where that assumption will break.
>
> Probably the best you can do is a collision detect scheme:
>
> uint64_t counter
> void data[];
>
> writer
>  counter++
>  FENCE
>  data = [.....];
>  FENCE
>  counter++
>
> reader:
>   read counter
>    if counter % 2 == 1: retry
>   read data
>   read counter
>    if counter != last_counter: retry
>
> But even something as simple as that probably has scary races - I only
> thought about it for a few moments. :)
>
> Jason


So I guess my primary question is this now: does the HCA perform
atomic cacheline reads (wrt other CPU operations to the same
cacheline)?

On Tue, Nov 12, 2013 at 03:18:35PM -0400, Anuj Kalia wrote:
> Jason,
>
> Thanks a lot for your reply.
>
> I think I understand that the RDMA reader will not see the ordering

This isn't just RDMA, CPU to CPU coherency is the same.

To be honest, your test doesn't really show anything, the reads and
writes can be interleaved in any way, and value >, == < counter are
all valid outcomes.

What the fence gives you is this:
   Read counter, then value. FENCE ensures that value >= counter.

If you burst read from the HCA value and counter then the result is
undefined, you don't know if counter was read before value, or the
other way around.

> in the updates to A[i].value and A[i].counter if they are in
> different L3 cache lines.  But what are the guarantees when they are
> in the same cache line?

Cache lines make no difference. They are not really modeled as part of
the coherency API the processor presents.

Two nearby writes in the instruction stream might be merged into an
atomic cache line update, or they might not. You have no control over
this

> That's right - thanks for the detailed explanation! However, I'm
> assuming that the HCA performs atomic cacheline reads (I don't have
> a lot of basis for this assumption and it would be great if someone
> could tell me more about it). If that is true, 'read a.value' and
> 'read a.counter' are not 2 separate operations. Instead, there is
> one 'read cacheline(a)' - that should provide a snapshot of a's
> state at CPU1.

That is an implementation detail, there is no architectural guarantee.

I don't think any current implementations provides atomic cacheline
reads.

> I was not assuming atomic writes to the entire cacheline - I was
> only assuming that the ordering imposed by mfence is preserved in
> cache - the write to 'a.value' appears in the cache hierarchy before
> the write to 'a.counter'.

mfence preserves the ordering, but there is no such thing as an atomic
cache line read or write. So the only way to see the ordering created
by mfence is with two non-burst reads, strongly ordered in time.

(Note, transactional memory extensions create something that looks an
 awful lot like an atomic cache line write. However that stuff is
 still really new so not alot of info on how it co-exists with DMA/etc)


On Tue, Nov 12, 2013 at 2:31 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Nov 12, 2013 at 06:31:04AM -0400, Anuj Kalia wrote:
>
>> That makes sense. This way, we have no consistency between the CPU's
>> view and the HCA's view - it all depends when the cache gets flushed
>> to RAM.
>
> What you are talking about is firmly in undefined territory. You might
> be able to get something to work today, but tomorrows CPUs and HCAs
> might mess it up.
>
> You will never reliably get the guarentee you desired with the scheme
> you have. Even with two CPUs it is not going to happen.
>
>> I have a remote client which reads the struct A[i] from the server
>> (via RDMA) in a loop. Sometimes in the value that the client reads,
>> A[i].counter is larger than A[i].value. i.e., I see the newer value of
>> A[i].counter but A[i].value corresponds to a previous iteration of the
>> server's loop.
>
> This is a fundamental mis-understanding of what FENCE does, it just
> makes the writes happen in-order, it doesn't alter the reader side
>
> CPU1                         CPU2
>                              read avalue
> value = counter
> FENCE
> a.counter = counter
>                              read a.counter
>
> value < counter
>
>
> CPU1                         CPU2
> a.value = counter
>                              read a.value
> FENCE
> a.counter = counter
>                              read a.coutner
>
> value < counter
>
>
> CPU1                         CPU2
> a.value = counter
> FENCE
>                              read a.value
> < SCHEDULE >
> a.counter = counter
>                              read a.coutner
>
> value < counter
>
> etc.
>
> This stuff is hard, if you want a crazy scheme to be reliable you need
> to have really detailed understanding of what is actually being
> guarenteed.
>
>> However, if the HCA performs reads from L3 cache, then everything
>> should be consistent, right? While ordering the writes, I think we
>> can
>
> No. The cache makes no difference. Fundamentally you aren't atomically
> writing cache lines. You are writing single values.
>
> 99% of the time it might look like atomic cache line writes, but there
> is a 1% where that assumption will break.
>
> Probably the best you can do is a collision detect scheme:
>
> uint64_t counter
> void data[];
>
> writer
>  counter++
>  FENCE
>  data = [.....];
>  FENCE
>  counter++
>
> reader:
>   read counter
>    if counter % 2 == 1: retry
>   read data
>   read counter
>    if counter != last_counter: retry
>
> But even something as simple as that probably has scary races - I only
> thought about it for a few moments. :)
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
