From: Roman Penyaev <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block
 Device (IBNBD)
Date: Wed, 7 Feb 2018 13:57:03 +0100
Message-ID: <CAJrWOzD3+tcA1cvSNOsN8t7uCOidJ2x6wsqqvFiEHdxW2th=sA@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <23dcfda7-eac1-ed13-b24e-3586c284ee55@grimberg.me> <CAJrWOzDmU_RWxaY+eXjZ3Az162gr9Bax8=5+1FYj4vzYDoxp7g@mail.gmail.com>
 <1517932890.3934.30.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517932890.3934.30.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 6, 2018 at 5:01 PM, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org> wrote:
> On Tue, 2018-02-06 at 14:12 +0100, Roman Penyaev wrote:
>> On Mon, Feb 5, 2018 at 1:16 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>> > [ ... ]
>> > - srp/scst comparison is really not fair having it in legacy request
>> >   mode. Can you please repeat it and report a bug to either linux-rdma
>> >   or to the scst mailing list?
>>
>> Yep, I can retest with mq.
>>
>> > - Your latency measurements are surprisingly high for a null target
>> >   device (even for low end nvme device actually) regardless of the
>> >   transport implementation.
>>
>> Hm, network configuration?  These are results on machines dedicated
>> to our team for testing in one of our datacenters. Nothing special
>> in configuration.
>

Hello Bart,

> I agree that the latency numbers are way too high for a null target device.
> Last time I measured latency for the SRP protocol against an SCST target
> + null block driver at the target side and ConnectX-3 adapters I measured a
> latency of about 14 microseconds. That's almost 100 times less than the
> measurement results in https://www.spinics.net/lists/linux-rdma/msg48799.html.

Here is the following configuration of the setup:

Initiator and target HW configuration:
    AMD Opteron 6386 SE, 64CPU, 128Gb
    InfiniBand: Mellanox Technologies MT26428
                [ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE]

Also, I remember that between initiator and target there were two IB switches.
Unfortunately, I can't repeat the same configuration, but will retest as
soon as we get new HW.

> Something else I would like to understand better is how much of the latency
> gap between NVMeOF/SRP and IBNBD can be closed without changing the wire
> protocol. Was e.g. support for immediate data present in the NVMeOF and/or
> SRP drivers used on your test setup?

I did not get the question. IBTRS uses empty messages with only imm_data
field set to respond on IO. This is a part of the IBTRS protocol.  I do
not understand how can immediate data be present in other drivers, if
those do not use it in their protocols.  I am lost here.

> Are you aware that the NVMeOF target driver calls page_alloc() from the hot path but that there are plans to
> avoid these calls in the hot path by using a caching mechanism similar to
> the SGV cache in SCST? Are you aware that a significant latency reduction
> can be achieved by changing the SCST SGV cache from a global into a per-CPU
> cache?

No, I am not aware. That is nice, that there is a lot of room for performance
tweaks. I will definitely retest on fresh kernel once everything is done on
nvme, scst or ibtrs (especially when we get rid of fmrs and UNSAFE rkeys).
Maybe there are some other parameters which can be also tweaked?

> Regarding the SRP measurements: have you tried to set the
> never_register kernel module parameter to true? I'm asking this because I
> think that mode is most similar to how the IBNBD initiator driver works.

yes, according to my notes from that link (frankly, I do not remember,
but that is what I wrote 1 year ago):

    * Where suffixes mean:

     _noreg - modules on initiator side (ib_srp, nvme_rdma) were loaded
              with 'register_always=N' param

That what you are asking, right?

--
Roman
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
