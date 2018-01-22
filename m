From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDS: Fix rds-ping inducing kernel panic
Date: Mon, 22 Jan 2018 14:25:47 -0800
Message-ID: <8cec0803-701a-be79-802d-bac2e84acbbd@oracle.com>
References: <20180122112415.GA41074@beast>
 <2768ae2b-b7de-cf00-c599-4c164a6228be@oracle.com>
 <CAGXu5jKhPk2MPCvYCOTbcNs7vdej5iuzJbJ9tM92QqXc7MczUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jKhPk2MPCvYCOTbcNs7vdej5iuzJbJ9tM92QqXc7MczUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sowmini Varadhan <sowmini.varadhan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Steve Beattie <sbeattie-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/22/2018 2:17 PM, Kees Cook wrote:
> On Tue, Jan 23, 2018 at 4:01 AM, Santosh Shilimkar
> <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> On 1/22/2018 3:24 AM, Kees Cook wrote:
>>>
>>> As described in: https://bugzilla.redhat.com/show_bug.cgi?id=822754
>>>
>>> Attempting an RDS connection from the IP address of an IPoIB interface
>>> to itself causes a kernel panic due to a BUG_ON() being triggered.
>>> Making the test less strict allows rds-ping to work without crashing
>>> the machine.
>>>
>>> A local unprivileged user could use this flaw to crash the sytem.
>>>
>> Are you able to reproduce this issue on mainline kernel ?
>> IIRC, this sjouldn't happen anymore but if you see it, please
>> let me know. Will try it as well. rds-ping on self
>> loopback device is often tested and used as well for
>> monitoring services in production.
> 
> I don't have an RDS test setup, no. But it sounds like kernels without
> this patch aren't seeing the problem.
>
Yep. Thats what I thought and hence asked.

>> Am not sure if its applicable anymore. Infact the issue with
>> loopback device was due to congestion update and thats been
>> already addressed with commit '18fc25c94: {rds: prevent BUG_ON
>> triggered on congestion update to loopback}'
> 
> That looks very much like it was fixed there. Thanks!
> 
Yeah. Thanks Kees !!

Regards,
Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
