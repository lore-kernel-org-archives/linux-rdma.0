From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 07/14] mlx4: Update to use new udma write
 barriers
Date: Mon, 6 Mar 2017 16:57:40 +0200
Message-ID: <45d2b7da-9ad6-6b37-d0b2-00f7807966b4@dev.mellanox.co.il>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-8-git-send-email-jgunthorpe@obsidianresearch.com>
 <206559e5-0488-f6d5-c4ec-bf560e0c3ba6@dev.mellanox.co.il>
 <20170221181407.GA13138@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170221181407.GA13138-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/21/2017 8:14 PM, Jason Gunthorpe wrote:
> On Mon, Feb 20, 2017 at 07:46:02PM +0200, Yishai Hadas wrote:
>
>>> 	pthread_spin_lock(&qp->sq.lock);
>>>
>>> +	/* Get all user DMA buffers ready to go */
>>> +	udma_to_device_barrier();
>>> +
>>> 	/* XXX check that state is OK to post send */
>>
>> Not clear why do we need here an extra barrier ? what is the future
>> optimization that you pointed on ?
>
> Writes to different memory types are not guarenteed to be strongly
> ordered. This is narrowly true on x86-64 too apparently.
>
> The purpose of udma_to_device_barrier is to serialize all memory
> types.
>
> This allows the follow on code to use the weaker
> 'udma_ordering_write_barrier' when it knows it is working exclusively
> with cached memory.
>
> Eg in an ideal world on x86 udma_to_device_barrier should be SFENCE
> and 'udma_ordering_write_barrier' should be compiler_barrier()
>
> Since the barriers have been so ill defined and wonky on x86 other
> arches use much stronger barriers than they actually need for each
> cases. Eg ARM64 can switch to much weaker barriers.
>
> Since there is no cost on x86-64 to this barrier I would like to leave
> it here as it lets us actually optimize the ARM and other barriers. If
> you take it out then 'udma_ordering_write_barrier' is forced to be the
> strongest barrier on all arches.

Till we make the further optimizations, we suspect a performance 
degradation in other ARCH(s) rather than X86, as this patch introduce an 
extra barrier which wasn't before (i.e udma_to_device_barrier).
Usually such a change should come with its follows improvement patch to 
justify it. The impact is still something that we should measure but 
basically any new code in the data path must be justified when it's 
added from performance point of view.

>>> @@ -478,7 +481,7 @@ out:
>>> 		 * Make sure that descriptor is written to memory
>>> 		 * before writing to BlueFlame page.
>>> 		 */
>>> -		wmb();
>>> +		mmio_wc_start();
>>
>> Why to make this change which affects at least X86_64 ? the data was
>> previously written to the host memory so we expect that wmb is
>> enough here.
>
> Same as above, writes to different memory types are not strongly
> ordered and wmb() is not the right barrier to serialize writes to
> DMA'able ctrl with the WC memcpy.
>
> If this is left wrong then again other arches are again required to
> adopt the strongest barrier for everything which hurts them.
>
> Even on x86, it is very questionable to not have the SFENCE in that
> spot. AFAIK it is not defined to be strongly ordered.
>
> mlx5 has the SFENCE here, for instance.

We made some performance testing with the above change, initial results 
point on degradation of about 3% in the message rate in the above 
BlueFlame path in X86, this is something that we should prevent.

Based on below analysis it looks as the change to use 'mmio_wc_start()' 
which is mapped to SFENCE in X86 is redundant.

Details:
There is a call to 'pthread_spin_lock()' in between the WB (write back 
host memory) to WC writes.

pthread_spin_lock is defined [1] to x86 XCHG atomic instruction. Based 
on Intel® 64 and IA-32 Architectures [2] such an operation operates as 
some barrier to make sure that previous memory writes were completed.
As such we expect to see here some other macro which consider whether 
lock is a barrier based on ARCH instead of taking in call cases the 
SFENCE barrier.



[1] http://code.metager.de/source/xref/gnu/glibc/nptl/pthread_spin_lock.c
Call atomic_exchange_acq() which is defined in Line 115 at:
http://code.metager.de/source/xref/gnu/glibc/sysdeps/x86_64/atomic-machine.h


[2] Intel® 64 and IA-32 Architectures Software Developer’s Manual
At: 
https://software.intel.com/sites/default/files/managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf

8.1.2.2 Software Controlled Bus Locking

On page 8-3 Vol. 3A  : “The LOCK prefix is automatically assumed for 
XCHG instruction.”

On page 8-4 Vol. 3A: “Locked instructions can be used to synchronize 
data written by one processor and read by another processor.
For the P6 family processors, locked operations serialize all 
outstanding load and store operations (that is, wait for
them to complete). This rule is also true for the Pentium 4 and Intel 
Xeon processors, with one exception. Load
operations that reference weakly ordered memory types (such as the WC 
memory type) may not be serialized.

8.3 SERIALIZING INSTRUCTIONS

On page 8-16 Vol. 3A: “Locking operations typically operate like I/O 
operations in that they wait for all previous instructions to complete 
and for all buffered writes to drain to memory”









--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
