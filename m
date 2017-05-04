From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] rxe: expose num_possible_cpus() cnum_comp_vectors
Date: Thu, 4 May 2017 17:43:51 +0300
Message-ID: <CAG9sBKOHETvPb3LW_O-6Ntwi=hnviJJncaNBEDi1sO2BwvYgHw@mail.gmail.com>
References: <1493904187-13686-1-git-send-email-sagi@grimberg.me>
 <CAG9sBKNBXkhJ9viPJ7ZMD8fEdUJ9i_c4FTVg27=GLL2SyBSM2g@mail.gmail.com>
 <5c52626d-3347-173e-a9f5-c1c45cafb508@grimberg.me> <CAG9sBKOc6EK-qrbvFa6x7QM5ZFEvJmUXfuhRkbXNAJpi+FT_Kg@mail.gmail.com>
 <eeea953a-1508-d0c9-66a6-1b73e03ea80a@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <eeea953a-1508-d0c9-66a6-1b73e03ea80a-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

So you say that even if rxe driver doesn't do anything with the
comp_vector parameter  passed to create cq, a ULP can benefit from rxe
reporting num_comp_vectors = number of cpus.
I can agree with that even though that IMHO the benefit deepens on how
the real eth device handles received packets.

Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

thanks




On Thu, May 4, 2017 at 5:26 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>
>>> Because that can change on the fly and should not effect on
>>> the number of logical completion vectors rxe exposes.
>>>
>>> --
>>
>> BTW, what will be the affect of this if rxe driver doesn't use the
>> comp_vector parameter in create_cq()?
>
>
> Some ULPs won't create more queue-pairs than what the rdma device
> supports (per multi-queue session). One example for that exists in a
> patch set I submitted for exposing to ULPs IRQ affinity mappings
> through the RDMA core so they in turn can make smart assignment
> decisions for queue<->cpu mappings in a multi-queue environment.
>
> I think its safe to assume that any modern HCA drivers supports a fair
> share of completion vectors.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
