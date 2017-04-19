From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: RDMA performance comparison: IBNBD, SCST, NVMEoF
Date: Wed, 19 Apr 2017 08:02:26 +0200
Message-ID: <CAJrWOzD90kM7cwjpqX3oqK+0bC8L_WTzD+r5xmyx2QEYsajxcA@mail.gmail.com>
References: <CAJrWOzAM_A6fwFxTZVo9MmiwWF1d6Bp9zTdBvUfnDFCPY_CmCQ@mail.gmail.com>
 <1492539735.2689.7.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1492539735.2689.7.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "mail@fholler.de" <mail@fholler.de>, "sagi@grimberg.me" <sagi@grimberg.me>, "jinpu.wang@profitbricks.com" <jinpu.wang@profitbricks.com>, "yun.wang@profitbricks.com" <yun.wang@profitbricks.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "danil.kipnis@profitbricks.com" <danil.kipnis@profitbricks.com>, "Milind.dumbare@gmail.com" <Milind.dumbare@gmail.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

Hello Bart,

On Tue, Apr 18, 2017 at 8:22 PM, Bart Van Assche
<Bart.VanAssche@sandisk.com> wrote:
> On Tue, 2017-04-18 at 19:33 +0200, Roman Penyaev wrote:
>> By current email I would like to share some fresh RDMA performance
>> results of IBNBD, SCST and NVMEof, based on 4.10 kernel and variety
>> of configurations.
>
> Hello Roman,
>
> Thank you for having shared these results. But please do not expect me
> to have another look at IBNBD before the design bugs in the driver and
> also in the protocol get fixed.

I expected only that you might find results interesting, where I target
the following:

    1) retest on latest kernel
    2) compare against NVMEoF
    3) retest using register_always=N


> The presentation during Vault 2017 made
> it clear that the driver does not scale if more than two CPUs submit I/O
> simultaneously at the initiator side.

On the iops graph, where I increase number of simultaneous fio jobs up to 128
(initiator has 64 CPUs), NVMEoF tends to repeat the same curve, staying always
below IBNBD.  So even this is a scalability problem, it can be seen on NVMEoF
runs also. That's why I posted these results to draw someone's attention.


--
Roman
