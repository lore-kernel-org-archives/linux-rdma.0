From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block
 Device (IBNBD)
Date: Mon, 5 Feb 2018 17:36:44 +0100
Message-ID: <CAMGffEkdFqgDmRnaRMuJz2tZFserg2kmOhc3Rde1+0zsz=du0Q@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <1517591106.2675.28.camel@sandisk.com> <CAMGffEkhqR9Z5bkMfnVn8an2OUM8k+jYoR5EFdtv3k9en1bh=w@mail.gmail.com>
 <1517847408.3764.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517847408.3764.5.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 5, 2018 at 5:16 PM, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org> wrote:
> On Mon, 2018-02-05 at 09:56 +0100, Jinpu Wang wrote:
>> Hi Bart,
>>
>> My another 2 cents:)
>> On Fri, Feb 2, 2018 at 6:05 PM, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org> wrote:
>> > On Fri, 2018-02-02 at 15:08 +0100, Roman Pen wrote:
>> > > o Simple configuration of IBNBD:
>> > >    - Server side is completely passive: volumes do not need to be
>> > >      explicitly exported.
>> >
>> > That sounds like a security hole? I think the ability to configure whether or
>> > not an initiator is allowed to log in is essential and also which volumes an
>> > initiator has access to.
>>
>> Our design target for well controlled production environment, so security is
>> handle in other layer. On server side, admin can set the dev_search_path in
>> module parameter to set parent directory, this will concatenate with the path
>> client send in open message to open a block device.
>
> Hello Jack,
>
> That approach may work well for your employer but sorry I don't think this is
> sufficient for an upstream driver. I think that most users who configure a
> network storage target expect full control over which storage devices are exported
> and also over which clients do have and do not have access.
>
> Bart.
Hello Bart,

I agree for general purpose, it may be good to have better access control.

Thanks,
-- 
Jack Wang
Linux Kernel Developer
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
