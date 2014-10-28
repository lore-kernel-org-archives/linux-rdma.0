From: Evgenii Smirnov <evgenii.smirnov-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: ib_post_send execution time
Date: Tue, 28 Oct 2014 17:49:38 +0100
Message-ID: <CAEv+Kc3Z8wSphNYuvgSOcJc1BkWtiNfscr-NE9qYU5a+Had5QQ@mail.gmail.com>
References: <CAEv+Kc1mioxX+pUky3a9Wfd8HzzOTAqyjw0tgdf4Qu2956hOaw@mail.gmail.com>
 <CAL1RGDVS2h4wJrxsYwjMH6cOz2jXCuUiY-OjZPjQrSu1btkHmw@mail.gmail.com>
 <20141024003933.GA30941@mtldesk30> <CAJ3xEMhN1HvddjMECnobZixd+v=0JasRzCXxY_aQXznU2Zx1sQ@mail.gmail.com>
 <544A75B5.1080304@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <544A75B5.1080304-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I forgot to mention that in both cases flag IB_SEND_INLINE (or
IBV_SEND_INLINE) is cleared.
Below are the results from perf top. They are quite equal to the
results of perf record. The functions that consumes almost 50% of
cycles is my function. Essentially, all it does is calling
ib_post_send with already predefined structs ib_send_wr and ib_sge.
Still have no idea why mlx4_ib_post_send consumes such big amount of
cycles.


  48.93%  /proc/kcore  0x7fffa078774c      k [k] test_send
  35.20%  /proc/kcore  0x7fffa0317a99      k [k] mlx4_ib_post_send
   6.39%  /proc/kcore  0x7fff8150cd3f      k [k] _raw_spin_lock_irqsave
   3.85%  /proc/kcore  0x7fffa0313e0f      k [k] stamp_send_wqe
   2.03%  /proc/kcore  0x7fff8150c9de      k [k] _raw_spin_unlock_irqrestore
   1.80%  /proc/kcore  0x7fffa05fc7a9      k [k] client_send
   1.13%  /proc/kcore  0x7fff81086a75      k [k] kthread_should_stop
   0.18%  /proc/kcore  0x7fffa03080d8      k [k] mlx4_ib_poll_cq
   0.17%  /proc/kcore  0x7fffa0787b80      k [k] process_wc
   0.14%  /proc/kcore  0x7fffa0307403      k [k] get_sw_cqe
   0.02%  /proc/kcore  0x7fff8150dcd0      k [k] irq_entries_start
   0.02%  /proc/kcore  0x7fffa017bf37      k [k] eq_set_ci.isra.14
   0.02%  /proc/kcore  0x7fffa017c4d6      k [k] mlx4_eq_int
   0.01%  /proc/kcore  0x7fff8150cd7e      k [k] _raw_spin_lock
   0.01%  /proc/kcore  0x7fffa017b106      k [k] mlx4_cq_completion
   0.01%  /proc/kcore  0x7fff8150e1f0      k [k] apic_timer_interrupt
   0.01%  /proc/kcore  0x7fffa0308a5d      k [k] mlx4_ib_arm_cq
   0.01%  /proc/kcore  0x7fff81051a86      k [k] native_read_msr_safe
   0.01%  /proc/kcore  0x7fffa017d07b      k [k] mlx4_msi_x_interrupt
   0.01%  /proc/kcore  0x7fff81051aa6      k [k] native_write_msr_safe
   0.01%  /proc/kcore  0x7fff8138c83e      k [k] add_interrupt_randomness
   0.00%  /proc/kcore  0x7fff8101c312      k [k] native_read_tsc
   0.00%  /proc/kcore  0x7fff810bc6d0      k [k] handle_edge_irq
   0.00%  /proc/kcore  0x7fff8150de92      k [k] common_interrupt
   0.00%  /proc/kcore  0x7fff8106ba3c      k [k] raise_softirq
   0.00%  /proc/kcore  0x7fff812accd0      k [k] __radix_tree_lookup
   0.00%  /proc/kcore  0x7fff81072ebc      k [k] run_timer_softirq
   0.00%  /proc/kcore  0x7fff81094721      k [k] idle_cpu

On Fri, Oct 24, 2014 at 5:52 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> On 10/24/2014 6:30 AM, Or Gerlitz wrote:
>>
>> On Fri, Oct 24, 2014 at 3:39 AM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>>
>>> On Thu, Oct 23, 2014 at 11:45:05AM -0700, Roland Dreier wrote:
>>>>
>>>> On Thu, Oct 23, 2014 at 10:21 AM, Evgenii Smirnov
>>>> <evgenii.smirnov-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
>>>>>
>>>>> I am trying to achieve high packet per second throughput with 2-byte
>>>>> messages over Infiniband from kernel using IB_SEND verb. The most I
>>>>> can get so far is 3.5 Mpps. However, ib_send_bw utility from perftest
>>>>> package is able to send 2-byte packets with rate of 9 Mpps.
>>>>> After some profiling I found that execution of ib_post_send function
>>>>> in kernel takes about 213 ns in average, for the user-space function
>>>>> ibv_post_send takes only about 57 ns.
>>>>> As I understand, these functions do almost same operations. The work
>>>>> request fields and queue pair parameters are also the same. Why do
>>>>> they have such big difference in execution times?
>>>>
>>>>
>>>> Interesting.  I guess it would be useful to look at perf top / and or
>>>> get a perf report with "perf report -a -g" when running your high PPS
>>>> workload, and see where the time is wasted.
>>>>
>>> I assume ib_send_bw uses inline with blueflame so it may be part of
>>> the explanation to the differences you see.
>>
>> I think it should be the other way around... when we use inline we
>> consume more CPU cycles and here we see notable different (213ns --
>> kernel 57ns user) in favor of libmlx4
>>
>
> Inline may consume more cpu cycles but should reduce latency because the IO
> is completed with only 1 DMA transaction, the WR fetch, which includes the
> data.  Non-inline requires 2 DMA transactions, the WR fetch and the data
> fetch.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
