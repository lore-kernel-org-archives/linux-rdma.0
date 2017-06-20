From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Tue, 20 Jun 2017 08:41:09 -0600
Message-ID: <CAANLjFqay8rTR_a7e+XN4zRkvO-cdLkJ1RoXFS=65Mz8b85c9g@mail.gmail.com>
References: <82dd5b24-5657-ae5e-8a33-646fddd8b75b@grimberg.me>
 <20170515133122.GG3616@mtr-leonro.local> <9465cd0c-83db-b058-7615-5626ef60dbb0@grimberg.me>
 <20170515143632.GH3616@mtr-leonro.local> <20170515145952.GA7871@infradead.org>
 <20170515170506.GK3616@mtr-leonro.local> <779753075.36035391.1495025796237.JavaMail.zimbra@kalray.eu>
 <20170518133439.GD3616@mtr-leonro.local> <CAANLjFrCLpX3nb3q7LpFPpLJKciU+1Hvmt_hxyTovQJM2-zQmg@mail.gmail.com>
 <6073e553-e8c2-6d14-ba5d-c2bd5aff15eb@grimberg.me> <20170620074639.GP17846@mtr-leonro.local>
 <1c706958-992e-b104-6bae-4a6616c0a9f9@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1c706958-992e-b104-6bae-4a6616c0a9f9-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 20, 2017 at 1:58 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>
>>> Hi Robert,
>>>
>>>> I ran into this with 4.9.32 when I rebooted the target. I tested
>>>> 4.12-rc6 and this particular error seems to have been resolved, but I
>>>> now get a new one on the initiator. This one doesn't seem as
>>>> impactful.
>>>>
>>>> [Mon Jun 19 11:17:20 2017] mlx5_0:dump_cqe:275:(pid 0): dump error cqe
>>>> [Mon Jun 19 11:17:20 2017] 00000000 00000000 00000000 00000000
>>>> [Mon Jun 19 11:17:20 2017] 00000000 00000000 00000000 00000000
>>>> [Mon Jun 19 11:17:20 2017] 00000000 00000000 00000000 00000000
>>>> [Mon Jun 19 11:17:20 2017] 00000000 93005204 0a0001bd 45c8e0d2
>>>
>>>
>>> Max, Leon,
>>>
>>> Care to parse this syndrome for us? ;)
>>
>>
>> Here the parsed output, it says that it was access to mkey which is
>> free.
>>
>> ======== cqe_with_error ========
>> wqe_id                           : 0x0
>> srqn_usr_index                   : 0x0
>> byte_cnt                         : 0x0
>> hw_error_syndrome                : 0x93
>> hw_syndrome_type                 : 0x0
>> vendor_error_syndrome            : 0x52
>
>
> Can you share the check that correlates to the vendor+hw syndrome?
>
>> syndrome                         : LOCAL_PROTECTION_ERROR (0x4)
>> s_wqe_opcode                     : SEND (0xa)
>
>
> That's interesting, the opcode is a send operation. I'm assuming
> that this is immediate-data write? Robert, did this happen when
> you issued >4k writes to the target?

I was running dd with oflag=direct, so yes.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
