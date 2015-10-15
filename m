From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 2/7] IB: Introduce Work Queue object and its
 verbs
Date: Thu, 15 Oct 2015 19:25:25 +0300
Message-ID: <561FD375.3000205@dev.mellanox.co.il>
References: <1444893410-13242-1-git-send-email-yishaih@mellanox.com>
 <1444893410-13242-3-git-send-email-yishaih@mellanox.com>
 <CAG53R5V7u7o+cVQnqhfjXdUjKJRVBiMx5CF3snWAWKG6ZbWMow@mail.gmail.com>
 <561FB463.8030602@dev.mellanox.co.il>
 <CAG53R5U256Nt=3xd3sVUuf8J1icdK5YEiQFoQjR_HB_=5-cVww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5U256Nt=3xd3sVUuf8J1icdK5YEiQFoQjR_HB_=5-cVww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vainman <alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/15/2015 6:17 PM, Parav Pandit wrote:
> On Thu, Oct 15, 2015 at 7:42 PM, Yishai Hadas
> <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> On 10/15/2015 12:13 PM, Parav Pandit wrote:
>>>
>>> Just curious, why does WQ need to be bind to PD?
>>> Isn't ucontext sufficient?
>>> Or because kcontext doesn't exist, PD serves that role?
>>> Or Is this just manifestation of how hardware behave?
>>
>>
>> PD is an attribute of a work queue (i.e. send/receive queue), it's used by
>> the hardware for security validation before scattering to a memory region.
>> For that, an external WQ object needs a PD, letting the
>> hardware makes that validation.
>>
>>> Since you mentioned, "QP can be configured to use "external" WQ
>>> object", it might be worth to reuse the WQ across multiple QPs of
>>> different PD?
>>
>>
>> Correct, external WQ can be used across multiple QPs, in that case its PD is
>> used by the hardware for security validation when it accesses to the MR, in
>> that case the QP's PD is not in use.
>>
> I think I get it, just confirming with below example.

.

> So I think below is possible.
> WQ_A having PD=1.
> QP_A having PD=2 bound to WQ_A.
> QP_B having PD=3 bound to WQ_A.
> MR_X having PD=2.
> And checks are done between MR and QP.
No, please follow above description, in that case PD=1 of WQ_A is used 
for the checks.

> In other use case,
> MR is not at all used. (only physical addresses are used)
> WQ_A having PD=1.
> QP_A having PD=2 bound to WQ_A.
> QP_B having PD=3 bound to WQ_A.
>
> WQ entries fail as MR is not associated and QP are bound to different
> PD than the PD of WQ_A.
> Because at QP bound time with WQ, its unknown whether it will use MR
> or not in the WQE at run time.
> Right?

In case there is MR for physical addresses it has a PD and the WQ's PD 
is used, in case there is no MR the PD is not applicable.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
