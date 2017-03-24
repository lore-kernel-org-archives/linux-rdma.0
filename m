From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [RFC PATCH 00/28] INFINIBAND NETWORK BLOCK DEVICE (IBNBD)
Date: Fri, 24 Mar 2017 15:37:02 +0100
Message-ID: <CAMGffEmhPj4dz4vAR4p2u8=vt+j4gkLRGLpsCgM2mgQ0jYAcww@mail.gmail.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com> <03bc01d2a4a9$b8b69f10$2a23dd30$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <03bc01d2a4a9$b8b69f10$2a23dd30$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, hch <hch-jcswGhMUV9g@public.gmane.org>, Fabian Holler <mail-99BIx50xQYGELgA04lAiVw@public.gmane.org>, Milind Dumbare <Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 24, 2017 at 3:20 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> w=
rote:
>>
>> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>>
>> This series introduces IBNBD/IBTRS kernel modules.
>>
>> IBNBD (InfiniBand network block device) allows for an RDMA transfer of b=
lock
> IO
>> over InfiniBand network. The driver presents itself as a block device on
> client
>> side and transmits the block requests in a zero-copy fashion to the
> server-side
>> via InfiniBand. The server part of the driver converts the incoming buff=
ers
> back
>> into BIOs and hands them down to the underlying block device. As soon as=
 IO
>> responses come back from the drive, they are being transmitted back to t=
he
>> client.
>
> Hey Jack, why is this IB specific?  Can it work over iWARP transports as =
well?
>
> Steve.
>
>
>
Hi Steve,

Because we only use IB in our production, as I replied to Bart, sorry, not =
yet.

Regards,
--=20
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
