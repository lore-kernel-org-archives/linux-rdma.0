From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block
 Device (IBNBD)
Date: Mon, 5 Feb 2018 18:16:02 +0100
Message-ID: <CAJrWOzDwDAt-w08-zmhJHsgedTyGQ-Dp=vHTvmrdSz9st7npxQ@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <23dcfda7-eac1-ed13-b24e-3586c284ee55@grimberg.me> <1517849882.3764.13.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1517849882.3764.13.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "hch@infradead.org" <hch@infradead.org>, "danil.kipnis@profitbricks.com" <danil.kipnis@profitbricks.com>, "jinpu.wang@profitbricks.com" <jinpu.wang@profitbricks.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ogerlitz@mellanox.com" <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

On Mon, Feb 5, 2018 at 5:58 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Mon, 2018-02-05 at 14:16 +0200, Sagi Grimberg wrote:
>> - Your latency measurements are surprisingly high for a null target
>>    device (even for low end nvme device actually) regardless of the
>>    transport implementation.
>>
>> For example:
>> - QD=1 read latency is 648.95 for ibnbd (I assume usecs right?) which is
>>    fairly high. on nvme-rdma its 1058 us, which means over 1 millisecond
>>    and even 1.254 ms for srp. Last time I tested nvme-rdma read QD=1
>>    latency I got ~14 us. So something does not add up here. If this is
>>    not some configuration issue, then we have serious bugs to handle..
>>
>> - QD=16 the read latencies are > 10ms for null devices?! I'm having
>>    troubles understanding how you were able to get such high latencies
>>    (> 100 ms for QD>=100)
>>
>> Can you share more information about your setup? It would really help
>> us understand more.
>
> I would also appreciate it if more information could be provided about the
> measurement results. In addition to answering Sagi's questions, would it
> be possible to share the fio job that was used for measuring latency? In
> https://events.static.linuxfound.org/sites/events/files/slides/Copy%20of%20IBNBD-Vault-2017-5.pdf
> I found the following:
>
> iodepth=128
> iodepth_batch_submit=128
>
> If you want to keep the pipeline full I think that you need to set the
> iodepth_batch_submit parameter to a value that is much lower than iodepth.
> I think that setting iodepth_batch_submit equal to iodepth will yield
> suboptimal IOPS results. Jens, please correct me if I got this wrong.

Sorry, Bart, I would answer here in a few words (I would like to answer
in details tomorrow on Sagi's mail).

Everything (fio jobs, setup, etc) is given in the same link:

https://www.spinics.net/lists/linux-rdma/msg48799.html

at the bottom you will find links on google docs with many pages
and archived fio jobs and scripts. (I do not remember exactly,
one year passed, but there should be everything).

Regarding smaller iodepth_batch_submit - that decreases performance.
Once I played with that, even introduced new iodepth_batch_complete_max
option for fio, but then I decided to stop and simply chose this
configuration, which provides me fastest results.

--
Roman
