From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [RFC PATCH 00/28] INFINIBAND NETWORK BLOCK DEVICE (IBNBD)
Date: Mon, 27 Mar 2017 12:21:21 +0200
Message-ID: <CAMGffEmgsP9GjQQp63matwxpzJT+SZu+VPU+Co-h99b8D5g5Zw@mail.gmail.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com> <cfde9eab-a52a-8888-7d32-4f6fc9f9640a@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cfde9eab-a52a-8888-7d32-4f6fc9f9640a@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: linux-block@vger.kernel.org, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Jens Axboe <axboe@kernel.dk>, hch <hch@lst.de>, Fabian Holler <mail@fholler.de>, Milind Dumbare <Milind.dumbare@gmail.com>, Michael Wang <yun.wang@profitbricks.com>, Roman Penyaev <roman.penyaev@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

On Mon, Mar 27, 2017 at 4:20 AM, Sagi Grimberg <sagi@grimberg.me> wrote:
>
>> This series introduces IBNBD/IBTRS kernel modules.
>>
>> IBNBD (InfiniBand network block device) allows for an RDMA transfer of
>> block IO
>> over InfiniBand network. The driver presents itself as a block device on
>> client
>> side and transmits the block requests in a zero-copy fashion to the
>> server-side
>> via InfiniBand. The server part of the driver converts the incoming
>> buffers back
>> into BIOs and hands them down to the underlying block device. As soon as
>> IO
>> responses come back from the drive, they are being transmitted back to t=
he
>> client.
>
>
> Hi Jack, Danil and Roman,
>
> I met Danil and Roman last week at Vault, and I think you guys
> are awesome, thanks a lot for open-sourcing your work! However,
> I have a couple of issues here, some are related to the code and
> some are fundamental actually.

Thanks for comments and suggestions, reply in inline.

>
> - Is there room for this ibnbd? If we were to take every block driver
>   that was submitted without sufficient justification, it'd be very
>   hard to maintain. What advantage (if any) does this buy anyone over
>   existing rdma based protocols (srp, iser, nvmf)? I'm really (*really*)
>   not sold on this one...
>
> - To me, the fundamental design that the client side owns a pool of
>   buffers that it issues writes too, seems inferior than the
>   one taken in iser/nvmf (immediate data). IMO, the ibnbd design has
>   scalability issues both in terms of server side resources, client
>   side contention and network congestion (on infiniband the latter is
>   less severe).
>
> - I suggest that for your next post, you provide a real-life use-case
>   where each of the existing drivers can't suffice, and by can't
>   suffice I mean that it has a fundamental issue with it, not something
>   that requires a fix. With that our feedback can be much more concrete
>   and (at least on my behalf) more open to accept it.
>
> - I'm not exactly sure why you would suggest that your implementation
>   supports only infiniband if you use rdma_cm for address resolution,
>   nor I understand why you emphasize feature (2) below, nor why even
>   in the presence of rdma_cm you have ibtrs_ib_path? (confused...)
>   iWARP needs a bit more attention if you don't use the new generic
>   interfaces though...
You reminds me, we also tested in rxe drivers in the past, but not iWARP.
Might work.
ibtrs_ib_path was leftover for APM feature, we used in house, will
remove next round.

>
> - I honestly do not understand why you need *19057* LOC to implement
>   a rdma based block driver. Thats almost larger than all of our
>   existing block drivers combined... First glance at the code provides
>   some explanations, (1) you have some strange code that has no business
>   in a block driver like ibtrs_malloc/ibtrs_zalloc (yikes) or
>   open-coding various existing logging routines, (2) you are for some
>   reason adding a second tag allocation scheme (why?), (3) you are open
>   coding a lot of stuff that we added to the stack in the past months...
>   (4) you seem to over-layer your code for reasons that I do not
>   really understand. And I didn't really look deep at all into the
>   code, just to get the feel of it, and it seems like it needs a lot
>   of work before it can even be considered upstream ready.
Agree, we will clean up the code further, that's why I sent it RFC to
get a early feedback.


>
>> We design and implement this solution based on our need for Cloud
>> Computing,
>> the key features are:
>> - High throughput and low latency due to:
>> 1) Only two rdma messages per IO
>
>
> Where exactly did you witnessed latency that was meaningful by having
> another rdma message on the wire? That's only for writes, anyway, and
> we have first data bursts for that..
Clearly, we need to benchmark on latest kernel.

>
>> 2) Simplified client side server memory management
>> 3) Eliminated SCSI sublayer
>
>
> That's hardly an advantage given all we are losing without it...
>
> ...
>
> Cheers,
> Sagi.

Thanks,
--=20
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
