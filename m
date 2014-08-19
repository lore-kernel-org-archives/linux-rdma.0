From: Mark Lehrer <lehrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx5 + SRP: max_qp_sz mismatch
Date: Tue, 19 Aug 2014 11:01:48 -0600
Message-ID: <CADvaNzVkKuvHw58meQD962VSm4Y-QZoHC3ndsYSBW8rw7S68cw@mail.gmail.com>
References: <CADvaNzWGThMx1gMYfheFVwHzk10+8KWmAPkYZ1_FxArhdmri8Q@mail.gmail.com>
	<53F36420.3060607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53F36420.3060607-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> From what I see srp_sq_size is controlled via
> configfs. Can you set it to 2048 just for the sake of
> confirmation this is indeed the issue?

Yes!  This setting allowed the two machines to establish an SRP session.

I'll try some I/O tests to see how well it works.

Thanks,
Mark


On Tue, Aug 19, 2014 at 8:50 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 8/19/2014 2:20 AM, Mark Lehrer wrote:
>>
>> I have a client machine that is trying to establish an SRP connection,
>> and it is failing due to an ENOMEM memory allocation error.  I traced
>> it down to the max_qp_sz field -- the mlx5 limits this to 16384 but
>> the request wants 32768.
>>
>> I spent some time trying to figure out how this limit is set, but it
>> isn't quite obvious.  Is there a driver parameter I can set, or a hard
>> coded limit somewhere?
>>
>> I'm using Ubuntu 14.04 and targetcli on the target side, Windows
>> 2008r2 and WinOFED on the client side.
>>
>
> Hi Mark,
>
> I think the issue here is that the SRP target asks for srp_sq_size (default
> 4096) to allocate room for send WRs, but it also asks for
> SRPT_DEF_SG_PER_WQE(16) to allocate room for max_send_sge which
> generally makes the work queue entries bigger as they come inline. That
> probably exceeds the mlx5 max send queue size supported...
>
> It is strange that mlx5 driver is not able to fit same send queue
> lengths as mlx4... Probably work queue entries are slightly bigger (I
> can check that - and I will).
>
> I just wander how can the ULP requesting the space reservations in the
> send queue know that, and if it should know that at all...
>
> From what I see srp_sq_size is controlled via configfs. Can you set
> it to 2048 just for the sake of confirmation this is indeed the issue?
>
> Thanks,
> Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
