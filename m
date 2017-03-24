From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [RFC PATCH 00/28] INFINIBAND NETWORK BLOCK DEVICE (IBNBD)
Date: Fri, 24 Mar 2017 13:46:02 +0100
Message-ID: <CAMGffE=CitFGj11NhFKPL2MNiOVVyb-ggRe-MhewcobGY0-u5A@mail.gmail.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com> <20170324121526.GF3571@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170324121526.GF3571-qw2SdCWA0PpjqqEj2zc+bA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, hch <hch-jcswGhMUV9g@public.gmane.org>, Fabian Holler <mail-99BIx50xQYGELgA04lAiVw@public.gmane.org>, Milind Dumbare <Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 24, 2017 at 1:15 PM, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org> wr=
ote:
> On Fri, Mar 24, 2017 at 11:45:15AM +0100, Jack Wang wrote:
>> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>>
>> This series introduces IBNBD/IBTRS kernel modules.
>>
>> IBNBD (InfiniBand network block device) allows for an RDMA transfer of b=
lock IO
>> over InfiniBand network. The driver presents itself as a block device on=
 client
>> side and transmits the block requests in a zero-copy fashion to the serv=
er-side
>> via InfiniBand. The server part of the driver converts the incoming buff=
ers back
>> into BIOs and hands them down to the underlying block device. As soon as=
 IO
>> responses come back from the drive, they are being transmitted back to t=
he
>> client.
>>
>> We design and implement this solution based on our need for Cloud Comput=
ing,
>> the key features are:
>> - High throughput and low latency due to:
>> 1) Only two rdma messages per IO
>> 2) Simplified client side server memory management
>> 3) Eliminated SCSI sublayer
>> - Simple configuration and handling
>> 1) Server side is completely passive: volumes do not need to be
>> explicitly exported
>> 2) Only IB port GID and device path needed on client side to map
>> a block device
>> 3) A device can be remapped automatically i.e. after storage
>> reboot
>> - Pinning of IO-related processing to the CPU of the producer
>>
>> For usage please refer to Documentation/IBNBD.txt in later patch.
>> My colleague Danil Kpnis presents IBNBD in Vault-2017 about our design/f=
eature/
>> tradeoff/performance:
>>
>> http://events.linuxfoundation.org/sites/events/files/slides/IBNBD-Vault-=
2017.pdf
>>
>
> Hi Jack,
>
> Sorry to ask (I haven't attented the Vault presentation) but why can't yo=
u use
> NVMe over Fabrics in your environment? From what I see in your presentati=
on
> and cover letter, it provides all you need and is in fact a standard Linu=
x and
> Windows already have implemented.
>
> Thanks,
>         Johannes
> --
> Johannes Thumshirn                                          Storage
> jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

Hi Johnnes,

Our IBNBD project was started 3 years ago based on our need for Cloud
Computing, NVMeOF is a bit younger.
- IBNBD is one of our components, part of our software defined storage solu=
tion.
- As I listed in features, IBNBD has it's own features

We're planning to look more into NVMeOF, but it's not a replacement for IBN=
BD.

Thanks,
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
