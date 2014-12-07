From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: IB_CQ_VECTOR_LEAST_ATTACHED
Date: Sun, 7 Dec 2014 14:22:40 +0200
Message-ID: <54844690.4040501@mellanox.com>
References: <54809030.6090107@oracle.com> <5480AB49.1080209@acm.org>
 <5480B8CE.3080704@oracle.com> <54842A05.9070207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54842A05.9070207-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 12/7/2014 12:20 PM, Sagi Grimberg wrote:
> On 12/4/2014 9:41 PM, Shirley Ma wrote:
>> On 12/04/2014 10:43 AM, Bart Van Assche wrote:
>>> On 12/04/14 17:47, Shirley Ma wrote:
>>>> What's the history of this patch?
>>>>
>>>> http://lists.openfabrics.org/pipermail/general/2008-May/050813.html
>>>>
>>>> I am working on multiple QPs workload. And I created a similar approach
>>>> with IB_CQ_VECTOR_LEAST_ATTACHED, which can bring up about 17% small
>>>> I/O
>>>> performance. I think this CQ_VECTOR loading balance should be
>>>> maintained
>>>> in provider not the caller. I didn't see this patch was submitted to
>>>> mainline kernel, wonder any reason behind?
>>>
>>> My interpretation is that an approach similar to
>>> IB_CQ_VECTOR_LEAST_ATTACHED is useful on single-socket systems but
>>> suboptimal on multi-socket systems. Hence the code for associating CQ
>>> sets with CPU sockets in the SRP initiator. These changes have been
>>> queued for kernel 3.19. See also branch drivers-for-3.19 in git repo
>>> git://git.infradead.org/users/hch/scsi-queue.git.
>>
>> What I did is that I manually controlled IRQ and working thread on the
>> same socket. The CQ is created when mounting the file system in
>> NFS/RDMA, but the workload thread might start from different socket,
>> so per-cpu based implementation might not apply. I will look at SRP
>> implementation.
>>
>
> Hey Shirley,
>
> Bart is correct, in general the LEAST_ATTACHED approach might not be
> optimal in the NUMA case. The thread <-> QP/CQ/CPU assignment is
> addressed by the multi-channel approach which to my understanding won't
> be implemented in NFSoRDMA in the near future (right Chuck?)
>
> However, the LEAST_ATTACH vector hint will revive again in the future
> as there is a need to spread applications on different interrupt
> vectors (especially for user-space).
>
> CC'ing Matan who is working on this, perhaps he can comment on this as
> well.
>
> Sagi.
>
>

Hi,

I'm not sure LEAST_ATTACHED is the best practice here. Applications 
might want to create a CQ on n different cores. You can't guarantee that 
with LEAST_ATTACHED policy. Anything smarter would probably require an 
API change or some tricks.

We might, for example, add an API like "give me the least attached CQ 
vector which isn't in the following list {a, b, c....}". Another option 
might be that when several CQs are registered with LEAST_ATTACHED on the 
same PD, we'll try to give them different vectors.

Anyway, these are some rough ideas. We should really think about that 
thoroughly before implementing.

Regards,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
