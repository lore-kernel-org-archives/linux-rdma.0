From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG]kworker blocked for more than 120 seconds in IB_CM/RDMA_CM
Date: Fri, 11 Nov 2016 17:59:03 +0100
Message-ID: <CAD+HZHWsRrnOKE3QnNtLajUKq29M_96pCb_cP55PXDWmL+0j-w@mail.gmail.com>
References: <CAD+HZHUF=tdeJo0bQUD8iCc+V40W1wrAPupFRFq3-VYrEuY7cA@mail.gmail.com>
 <47429de9-d3ad-2a1f-744a-3a2d3ac4aecf@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47429de9-d3ad-2a1f-744a-3a2d3ac4aecf-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2016-11-11 17:41 GMT+01:00 Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>:
> On 11/11/2016 05:32 AM, Jack Wang wrote:
>>
>> Note: we're using 4.4.28 + MLNXOFED 3.3
>
>
> Hello Jack,
>
> How was MOFED built? Are you using the MOFED or the upstream RDMA kernel
> drivers? If you are using the MOFED RDMA kernel drivers you will have to
> contact Mellanox. Otherwise I propose to try to reproduce this with lockdep
> enabled in the kernel config. Maybe this lockup is triggered by lock
> inversion.
>
> Bart.

Thanks, Bart,

I'm enabling LOCKDEP and other debug options locally, also inject some
delay manually to reproduce the bug.
So far no luck.

Cheers,
Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
