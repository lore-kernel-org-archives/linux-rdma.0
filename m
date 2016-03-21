From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 1/8] Add ibv_poll_cq_ex verb
Date: Mon, 21 Mar 2016 17:24:23 +0200
Message-ID: <56F01227.9050900@mellanox.com>
References: <20160224190230.GA10588@obsidianresearch.com>
 <56CEB4C7.60607@dev.mellanox.co.il>
 <20160225170541.GA22513@obsidianresearch.com> <56D31A58.20205@mellanox.com>
 <20160229191734.GA15042@obsidianresearch.com> <56D55851.60206@mellanox.com>
 <20160301172448.GA24031@obsidianresearch.com> <56D6979F.6000400@mellanox.com>
 <20160302182836.GA7084@obsidianresearch.com>
 <alpine.DEB.2.20.1603021300491.15609@east.gentwo.org>
 <20160302195138.GA8427@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160302195138.GA8427-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/03/2016 21:51, Jason Gunthorpe wrote:
> On Wed, Mar 02, 2016 at 01:08:30PM -0600, Christoph Lameter wrote:
>> On Wed, 2 Mar 2016, Jason Gunthorpe wrote:
>>
>>> So all this ugly API to minimize cache line usage has no measured
>>> performance gain?
>>
>> We have seen an increased cacheline footprint adding ~100-200ns to receive
>> latencies during loops. This does not show up in synthetic loads that do
>> not do much processing since their cache footprint is minimal.
>
> I know you've seen effects..
>
> But apparently the patch authors haven't.
>
>>>> Does the opaque pointer guarantees an aligned access? Who allocates the
>>>> space for the vendor's CQE? Any concrete example?
>>>> One of the problems here are that CQEs could be formatted as -
>>>> "if QP type is y, then copy the field z from o". Doing that this way may
>>>> result doing the same "if" multiple times. The current approach could still
>>>> avoid memcpy and write straight to the user's buffer.
>>>
>>> No, none of that...
>>>
>>> struct ibv_cq
>>> {
>>>      int (*read_next_cq)(ibv_cq *cq,struct common_wr *res);
>>>      int (*read_address)(ibv_cq *cq,struct wr_address *res);
>>>      uint64_t (*read_timestamp(ibv_cq *cq);
>>>      uint32_t (*read_immediate_data(ibv_cq *cq);
>>>      void (*read_something_else)(ibv_cq *cq,struct something_else *res);
>>> };
>>
>> Argh. You are requiring multiple indirect function calls
>> top retrieve the same imformation and therefore significantly increase
>> latency.
>
> It depends. These are unconditional branches and they elide alot of
> other code and conditional branches by their design.
>

Our performance team and I measured the new ibv_poll_cq_ex vs the old 
poll_cq implementation. We measured the number of cycles around the 
poll_cq call. We saw ~15 cycles increase for every CQE, which is about 
2% over the regular poll_cq (which is not extensible). We've used 
ib_write_lat in order to do these measurements.

Pinpointing the source of this increase, we found that the function 
pointer of our internal poll_one routine is the source of this. Our 
poll_cq_ex implementation uses a per-CQ poll_one_ex function, which is 
*almost* tailored for the user required fields. Using a static poll_one 
will cause a lot of conditional branches and will decrease performance.
Meaning, using a function pointer vs using a static poll_one function 
(that the compiler is free to inline) causes this effect, but using a 
monolithic poll_one function will incur substantial computation overhead.

Using a per field getter introduces such a call (unconditional jump) for 
every field. If we were using static linking (+ whole program linkage), 
I agree this route is better. However, based on the results we saw 
earlier, we are worried this might incur tremendous overhead.
In addition, the user has to call read_next_cq for every completion 
entry (which is another unconditional jump).

> The mlx4 driver does something like this on every CQE to parse the
> immediate data:
>
> +	if (is_send) {
> +		switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
> +		case MLX4_RECV_OPCODE_RDMA_WRITE_IMM:
> +			if (wc_flags & IBV_WC_EX_WITH_IMM) {
> +				*wc_buffer.b32++ = cqe->immed_rss_invalid;
>
> With this additional overhead for all the parse paths that have no
> immediate:
>
> +			if (wc_flags & IBV_WC_EX_WITH_IMM)
> +				wc_buffer.b32++; // No imm to set
>
> Whereas my suggestion would looke more like:
>
> mlx4_read_immediate_data(cq) {return cq->cur_cqe->immed_rss_invalid;};
>
> [and even that can be micro-optimized further]
>
> And the setting of WITH_IMM during the common parse is much less branchy:
>
> opcode = cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK;
> wc->flags |= WITH_IMM_BIT << ((unsigned int)(opcode == MLX4_RECV_OPCODE_RDMA_WRITE_IMM ||
>                                              opcode == MLX4_RECV_OPCODE_SEND_IMM ...))
>
> I bet that is a lot less work going on, even including the indirect
> jump overhead.
>

So we would have read the owner_sr_opcode several times (for almost 
every related wc field) and parse it accordingly or we'll have to store 
the pre-processed owner_sr_opcode in the CQ itself and incur the 
overhead of "copying" it. In addition, we'll need another API (end_cq) 
in order to indicate return-cq-element-to-hardware-ownership (and 
release vendor's per poll_cq locks if exist). So, as far as we 
understand, you propose something like:

struct ibv_cq
{
     /* more argument is new */
     int (*read_next_cq)(ibv_cq *cq,struct common_wr *res, bool more);
     /* function is new */
     int (*end_cq)(ibv_cq *cq);
     int (*read_address)(ibv_cq *cq,struct wr_address *res);
     uint64_t (*read_timestamp(ibv_cq *cq);
     uint32_t (*read_immediate_data(ibv_cq *cq);
     void (*read_something_else)(ibv_cq *cq,struct something_else *res);
};

Again, every call here introduces an unconditional jump and makes the CQ 
structure larger. So, the CQ struct itself might not fit in the cache line.

In addition, ibv_cq isn't extensible as it's today. Addign a new 
ibv_cq_ex will change all APIs that use it.

>> This is going to cause lots of problems for procesing at high
>> speed where we have to use the processor caches as carefully as possible
>> to squeeze out all we can get.
>
> The driver should be built so the branch targets are all in close
> cache lines, with function prologues deliberately elided so the branch
> targets are small. There may even be further techniques to micro
> optimize the jump, if one wanted to spend the effort.
>
> Further, since we are only running the code the caller actually needs
> we are not wasting icache lines trundling through the driver CQE parse
> that has to handle all cases, even ones the caller doesn't care about.
>

The current optimization we implement in our user-space drivers is to 
introduce multiple poll_one_ex functions, where every function assigns 
only some of the WC fields. Each function is tailored for a different 
use case and common scenario. By doing this, we don't assign fields that 
the user doesn't care about and we can avoid all conditional branches.

> It is possible this uses fewer icache lines than what we have today,
> it depends how big the calls end up..
>

The current proposal offers several poll_one_ex function - a function 
per common case. That's true we have more functions, but the function we 
actually used is *almost* tailored to the user's requirements.
All checks and conditions are done once. We trade-off the function 
pointer + re-checking/re-formatting some fields over and over again by 
copying the fields to ibv_wc_ex.

>>> 4) A basic analysis says this trades cache line dirtying of the wc
>>>     array for unconditional branches.
>>>     It  eliminates at least 1 conditional branch per CQE iteration by
>>>     using only 1 loop.
>>
>> This done none of that stuff at all if the device directly follows the
>> programmed format. There will be no need to do any driver formatting at
>> all.
>
> Maybe, but no such device exists? I'm not sure I want to see a
> miserable API on the faint hope of hardware support..
>
> Even if hardware appears, this basic API pattern can still support
> that optimally by using the #5 technique - and still avoids the memcpy
> from the DMA buffer to the user memory.
>
>>>     Compared to the poll_ex proposal this eliminates a huge
>>>     number of conditional branches as 'wc_flags' and related no longer
>>>     exist at all.
>>
>> wc_flags may be something bothersome. You do not want to check inside the
>> loop.
>
> Did you look at the mlx4 driver patch? It checks wc_flags constantly
> when memcpying the HW CQE to the user memory - in the per CQE loop:
>
> +			if (wc_flags & IBV_WC_EX_WITH_IMM) {
> +				*wc_buffer.b32++ = cqe->immed_rss_invalid;
>
> Every single user CQE write (or even not write) is guarded by a
> conditional branch on the flags, and use of post-increment like that
> creates critical path data dependencies and kills ILP. All this extra
> code eats icache lines.
>
 >

Look at the new code for libmlx5. This code is optimized *at compile 
time*. We create a poll_one_ex function for a common case. This has zero 
overhead.

Regarding user-space check for wc_flags, I agree on eliminating this 
check. If you created a CQ with a set of attributes, they are guaranteed 
to exist on known values for the opcode.

> Sure, the scheme saves dritying cache lines, but at the cost of a huge
> number of these conditional branches and more code. I'm deeply
> skeptical that is an overall win compared to dirtying more cache
> lines - mispredicted branches are expensive.
>
> What I've suggested avoids all the cache line dirtying and avoids all
> the above conditional branching and data dependencies at the cost of
> a few indirect unconditional jumps. (and if #5 is possible they aren't
> even jumps)
>

When eliminating "if (wc_flags & IBV_WC_EX_WITH_IMM)" in the user's 
space application, conditional branching is eliminated in this proposal 
as well.

The question becomes - what costs more - copying the data or using an 
unconditional branch.

> I say there is no way to tell which scheme performs better without
> careful benchmarking - it is not obvious any of these trade offs are
> winners.
>

Agree. It may depend on the user application as well.

>> All cqe's should come with the fields requested and the
>> layout of the data must be fixed when in the receive loop. No additional
>> branches in the loop.
>
> Sure, for the caller, I'm looking at this from the whole system
> perspective. The driver is doing a wack more crap to produce this
> formatting and it certainly isn't free.
>

Dynamic WC format (or getter functions) isn't going to be free, at least 
not without linking the vendor's user-space driver to the application 
itself or making all vendors behave the same.

> Jason
>

Yishai and Matan.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
