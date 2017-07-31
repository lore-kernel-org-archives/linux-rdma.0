From: Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] drivers/rxe: improve rxe loopback
Date: Mon, 31 Jul 2017 12:53:51 +0300
Message-ID: <c1642e45-d814-cda1-357c-dfd9eb2a97c4@redhat.com>
References: <20170726145248.21677-1-marcel@redhat.com>
 <20170726195727.GB2339@yuvallap>
 <CAG9sBKNbC=TzgMpSuiGwiBJo_ZX0eSoQfni2YRUHg9J96yNkww@mail.gmail.com>
 <778dcc67-30f2-aecc-3e53-7cf4d0afb74e@redhat.com>
 <CAG9sBKNc89nVeJM-UZk8JRy9zXz-U1JdWJ8KkjpeSXvdbwNNsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKNc89nVeJM-UZk8JRy9zXz-U1JdWJ8KkjpeSXvdbwNNsg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 30/07/2017 12:57, Moni Shoua wrote:
>>> Have you considered using ip_route_output_key() for IPv4 or
>>> ip6_route_output() for IPv6 to decide if  this is a loopback?
>>> For reference you can check the flow starting at  rdma_resolve_ip()
>>>
>>
>> Hi Moni,
>>
>> Yes, I had looked into it, but I haven't seen how I can find
>> out if the destination IP belongs to the same RXE.
>> The loopback flag will give us the "same host"
>> confirmation, but not the same rxe instance, right?
>>
>> Any ideas would be welcomed.
>>
>> Thanks,
>> Marcel
>>
> Hi Marcel
> 

Hi Moni,

> You are right about that. IFF_LOOPBACK tells you that the source and
> destination addresses are on the same host but not necessarily on the
> same RXE device.
> 
> As Leon mentioned, calling addrX_same_rxe() for each packet seems to
> heavy , especially when the use case that justifies it (instead of
> calling memcmp() on src and dst) is rare. Do you agree?

I do agree is rare, but is depending on use-case. And since it
is a bug we should fix it, but not on the expense of performance
of course.

> If so I think that marking a connection as loopback once is the right approach
> For RC/UC - when modified to RTR

Sounds good to me.

> For UD - this is harder. IsLoopback() is function of the WQE (or at
> least the QP and AH together( but not the QP. I think you can add an
> improvement that will work for the majority of cases. This is a sketch
> of what I have in mind. Let me know what you think please
> 
> 1. Add bool last_used_qp to AH structure
> 2. Add bool is_loopback_with_last_qp to AH structure
> 3. Set values to AH.last_used_qp and AH.is_loopback_with_last_qp in
> post_send() modify_ah(),...
> 4. Mark WQE as loopback depending on the above
> 

Your pointer is very much appreciated, I will look into it.

Thanks,
Marcel

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
