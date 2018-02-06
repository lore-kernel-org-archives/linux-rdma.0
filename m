From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block
 Device (IBNBD)
Date: Tue, 6 Feb 2018 12:47:12 +0100
Message-ID: <CAJrWOzCHeeoXW6r9O87MBVpO+o_VjE0sPynwEQRmFcPW_ZaZnw@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <23dcfda7-eac1-ed13-b24e-3586c284ee55@grimberg.me> <1517849882.3764.13.camel@wdc.com>
 <CAJrWOzDwDAt-w08-zmhJHsgedTyGQ-Dp=vHTvmrdSz9st7npxQ@mail.gmail.com> <1517851229.3764.15.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1517851229.3764.15.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "jinpu.wang@profitbricks.com" <jinpu.wang@profitbricks.com>, "sagi@grimberg.me" <sagi@grimberg.me>, "ogerlitz@mellanox.com" <ogerlitz@mellanox.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "danil.kipnis@profitbricks.com" <danil.kipnis@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 5, 2018 at 6:20 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Mon, 2018-02-05 at 18:16 +0100, Roman Penyaev wrote:
>> Everything (fio jobs, setup, etc) is given in the same link:
>>
>> https://www.spinics.net/lists/linux-rdma/msg48799.html
>>
>> at the bottom you will find links on google docs with many pages
>> and archived fio jobs and scripts. (I do not remember exactly,
>> one year passed, but there should be everything).
>>
>> Regarding smaller iodepth_batch_submit - that decreases performance.
>> Once I played with that, even introduced new iodepth_batch_complete_max
>> option for fio, but then I decided to stop and simply chose this
>> configuration, which provides me fastest results.
>
> Hello Roman,
>
> That's weird. For which protocols did reducing iodepth_batch_submit lead
> to lower performance: all the tested protocols or only some of them?

Hi Bart,

Seems that does not depend on protocol (when I tested it was true for nvme
and ibnbd).  That depends on a load.  On high load (1 or few fio jobs are
dedicated to each cpu, and we have 64 cpus) it turns out to be faster to wait
completions for all queue for that particular block dev, instead of switching
from kernel to userspace for each completed IO.

But I can assure you that performance difference is very minor, it exists,
but it does not change the whole picture of what you see on this google
sheet. So what I tried to achieve is to squeeze everything I could, nothing
more.

--
Roman
