From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Question on RDMA atomic operations
Date: Mon, 29 Aug 2016 08:25:39 -0400
Message-ID: <2f930038-2ba9-cd9a-1670-e29664283858@talpey.com>
References: <DB0C5879-C46D-47BF-98F8-DECE15CC4D08@umich.edu>
 <E7A19716-E97F-4BC3-9865-3740F7847AF7@mellanox.com>
 <F998C7B6-4095-43A6-A717-350C097E3125@gmail.com>
 <95397BB1-B414-4872-A926-1A2CC229EB40@umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <95397BB1-B414-4872-A926-1A2CC229EB40-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dong Young Yoon <dyoon-63aXycvo3TyHXe+LvDLADg@public.gmane.org>, Asgeir Eiriksson <asgeir.eiriksson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is no ordering guarantee between writes and atomics at the
responder. And as you observe, FENCE is only applicable at a single
requestor. Your desired semantic will be possible only with upper-layer
interaction between the multiple requestors.

You should be aware that atomic data does not necessarily reside in
host memory. Because the adapter sits on the PCI bus, and there is
currently no atomic PCI transaction, the RDMA protocol specs permit
the adapter to provide the atomic behavior internally. The data will
eventually reach main memory, but not atomically. Also note, this means
an application running on the CPU of the responder may also encounter
the race you describe.

Tom.

On 8/25/2016 5:15 PM, Dong Young Yoon wrote:
> Thank you so much for the answers. However, the case I was meaning to discuss is where there are multiple client/threads using different send queues, sending RDMA atomic and write operations concurrently to the same HCA as the responder. I understand that even for single send queue, there could be inconsistent ordering between RDMA atomic operations and reads and that is why we need to use FENCE, but I suppose it does not apply in my case?
>
> Thanks,
> Dong Young
>
>> On Aug 25, 2016, at 5:11 PM, Asgeir Eiriksson <asgeir.eiriksson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Hello Dong,
>>
>> The ordering rules for iWARP RDMA are spelled out in RFC7306 (see https://tools.ietf.org/pdf/rfc7306.pdf section 5, pp. 24 for the two ordering cases you asked about) and RFC5040 has the rest of the iWARP RDMA ordering rules
>>
>> The answer to your question is the same for iWARP RDMA as that provided by Majd for IB
>>
>> Regards,
>>
>> ‘Asgeir
>>
>>
>>> On Aug 25, 2016, at 12:11 AM, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>>
>>>> On Aug 24, 2016, at 11:43 PM, Dong Young Yoon <dyoon-63aXycvo3TyHXe+LvDLADg@public.gmane.org> wrote:
>>>>
>>>> Hi,
>>>>
>>>> My name is Dong Young and I am a PhD student at the University of Michigan.
>>>> Recently, we have been working on a research topic related to RDMA and had an observation where there is a race condition between RDMA atomic operations (e.g., fetch-and-add) and RDMA 1-sided writes.
>>>> We would like to verity whether what we observed is actually true (i.e., no atomicity guaranteed between RDMA atomic operation and RDMA read/write).
>>> Hi Dong,
>>>
>>> If you post an atomic operation followed by RDMA read/write, you need a fence between the two, because the second one might start processing before the first one has completed processing.
>>>
>>> In order to do that, you need to set the IBV_SEND_FENCE in the send_flags of the wr.
>>>
>>>> Is it really true? I have also contacted other fellow researchers who worked on RDMA, but they do not seem to be 100% sure on this matter.
>>>> Thank you so much in advance for your help.
>>>>
>>>> Thanks,
>>>> Dong Young--
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
