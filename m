From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [RFC PATCH 00/28] INFINIBAND NETWORK BLOCK DEVICE (IBNBD)
Date: Fri, 24 Mar 2017 15:24:00 +0100
Message-ID: <CAMGffE=fd8EqxeEqSpRdwX_1XmjLe2VAT1_6iJyWASDtwcbyRw@mail.gmail.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
 <20170324121526.GF3571@linux-x5ow.site> <CAMGffE=CitFGj11NhFKPL2MNiOVVyb-ggRe-MhewcobGY0-u5A@mail.gmail.com>
 <1490362271.2516.4.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490362271.2516.4.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "jthumshirn-l3A5Bk7waGM@public.gmane.org" <jthumshirn-l3A5Bk7waGM@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mail-99BIx50xQYGELgA04lAiVw@public.gmane.org" <mail-99BIx50xQYGELgA04lAiVw@public.gmane.org>, "yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roman Penyaev <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 24, 2017 at 2:31 PM, Bart Van Assche
<Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On Fri, 2017-03-24 at 13:46 +0100, Jinpu Wang wrote:
>> Our IBNBD project was started 3 years ago based on our need for Cloud
>> Computing, NVMeOF is a bit younger.
>> - IBNBD is one of our components, part of our software defined storage s=
olution.
>> - As I listed in features, IBNBD has it's own features
>>
>> We're planning to look more into NVMeOF, but it's not a replacement for =
IBNBD.
>
> Hello Jack, Danil and Roman,
>
> Thanks for having taken the time to open source this work and to travel t=
o
> Boston to present this work at the Vault conference. However, my
> understanding of IBNBD is that this driver has several shortcomings neith=
er
> NVMeOF nor iSER nor SRP have:
> * Doesn't scale in terms of number of CPUs submitting I/O. The graphs sho=
wn
>   during the Vault talk clearly illustrate this. This is probably the res=
ult
>   of sharing a data structure across all client CPUs, maybe the bitmap th=
at
>   tracks which parts of the target buffer space are in use.
> * Supports IB but none of the other RDMA transports (RoCE / iWARP).
>
> We also need performance numbers that compare IBNBD against SRP and/or
> NVMeOF with memory registration disabled to see whether and how much fast=
er
> IBNBD is compared to these two protocols.
>
> The fact that IBNBD only needs to messages per I/O is an advantage it has
> today over SRP but not over NVMeOF nor over iSER. The upstream initiator
> drivers for the latter two protocols already support inline data.
>
> Another question I have is whether integration with multipathd is support=
ed?
> If multipathd tries to run scsi_id against an IBNBD client device that wi=
ll
> fail.
>
> Thanks,
>
> Bart.
Hello Bart,

Thanks for your comments. As usual in house driver mainly covers needs
for ProfitBricks,
We only tested in our hardware environment. We only use IB not
RoCE/iWARP. The idea to
opensource is :
- Present our design/implementation/tradeoff, others might be interested.
- Attract more attention from developers/testers, so we can improve
the project better and faster.

We will gather performance data compare with NVMeOF in next submitting.

multipath is not supported, we're using APM for failover. (patch from
Mellanox developers)

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
