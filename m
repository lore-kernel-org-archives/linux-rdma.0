From: Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block
 Device (IBNBD)
Date: Mon, 5 Feb 2018 14:38:00 +0100
Message-ID: <CAHg0HuxawAjCf711gkKKiQbbLskNsvUDhP+m32oiGFsY2BRz5g@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <1517591106.2675.28.camel@sandisk.com> <CAMGffEkhqR9Z5bkMfnVn8an2OUM8k+jYoR5EFdtv3k9en1bh=w@mail.gmail.com>
 <40a7fc35-f86c-1d9d-f057-e5822708fc32@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <40a7fc35-f86c-1d9d-f057-e5822708fc32-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
>> Hi Bart,
>>
>> My another 2 cents:)
>> On Fri, Feb 2, 2018 at 6:05 PM, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
>> wrote:
>>>
>>> On Fri, 2018-02-02 at 15:08 +0100, Roman Pen wrote:
>>>>
>>>> o Simple configuration of IBNBD:
>>>>     - Server side is completely passive: volumes do not need to be
>>>>       explicitly exported.
>>>
>>>
>>> That sounds like a security hole? I think the ability to configure
>>> whether or
>>> not an initiator is allowed to log in is essential and also which volumes
>>> an
>>> initiator has access to.
>>
>> Our design target for well controlled production environment, so
>> security is handle in other layer.
>
>
> What will happen to a new adopter of the code you are contributing?

Hi Sagi, Hi Bart,
thanks for your feedback.
We considered the "storage cluster" setup, where each ibnbd client has
access to each ibnbd server. Each ibnbd server manages devices under
his "dev_search_path" and can provide access to them to any ibnbd
client in the network. On top of that Ibnbd server has an additional
"artificial" restriction, that a device can be mapped in writable-mode
by only one client at once.

-- 
Danil
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
