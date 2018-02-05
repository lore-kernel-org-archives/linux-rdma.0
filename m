From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block
 Device (IBNBD)
Date: Mon, 5 Feb 2018 09:56:56 +0100
Message-ID: <CAMGffEkhqR9Z5bkMfnVn8an2OUM8k+jYoR5EFdtv3k9en1bh=w@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com> <1517591106.2675.28.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1517591106.2675.28.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "roman.penyaev@profitbricks.com" <roman.penyaev@profitbricks.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "danil.kipnis@profitbricks.com" <danil.kipnis@profitbricks.com>, "hch@infradead.org" <hch@infradead.org>, "ogerlitz@mellanox.com" <ogerlitz@mellanox.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "sagi@grimberg.me" <sagi@grimberg.me>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

My another 2 cents:)
On Fri, Feb 2, 2018 at 6:05 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Fri, 2018-02-02 at 15:08 +0100, Roman Pen wrote:
>> o Simple configuration of IBNBD:
>>    - Server side is completely passive: volumes do not need to be
>>      explicitly exported.
>
> That sounds like a security hole? I think the ability to configure whether or
> not an initiator is allowed to log in is essential and also which volumes an
> initiator has access to.
Our design target for well controlled production environment, so
security is handle in other layer.
On server side, admin can set the dev_search_path in module parameter
to set parent directory,
this will concatenate with the path client send in open message to
open  a block device.


>
>>    - Only IB port GID and device path needed on client side to map
>>      a block device.
>
> I think IP addressing is preferred over GID addressing in RoCE networks.
> Additionally, have you noticed that GUID configuration support has been added
> to the upstream ib_srpt driver? Using GIDs has a very important disadvantage,
> namely that at least in IB networks the prefix will change if the subnet
> manager is reconfigured. Additionally, in IB networks it may happen that the
> target driver is loaded and configured before the GID has been assigned to
> all RDMA ports.
>
> Thanks,
>
> Bart.

Sorry, the above description is not accurate, IBNBD/IBTRS support
GID/IPv4/IPv6 addressing.
We will adjust in next post.

Thanks,
-- 
Jack Wang
Linux Kernel Developer
