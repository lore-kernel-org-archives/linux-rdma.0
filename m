From: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 for-4.13 2/6] mlx5: move affinity hints assignments to
 generic code
Date: Thu, 8 Jun 2017 14:42:07 +0300
Message-ID: <CALzJLG_sFqSm5o1WvjJzoBLMdoSPuQFBBbiBF8T8xn9m8SDc5g@mail.gmail.com>
References: <1496644560-28923-1-git-send-email-sagi@grimberg.me>
 <1496644560-28923-3-git-send-email-sagi@grimberg.me> <CALzJLG-SQj2OsOOjhHsMaD8gKC0JKD068L=ZjYRPBG=iwf9r8Q@mail.gmail.com>
 <20170607083156.GB24876@lst.de> <9332ed02-9711-0196-14d9-e9641c4dc932@grimberg.me>
 <CALzJLG_h8ig97uzz9S_4n-DhcFFi1e+WcUwLejM4cHUFd1MozA@mail.gmail.com> <aff81384-517a-94e4-c743-8b89fd8cda1b@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aff81384-517a-94e4-c743-8b89fd8cda1b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 8, 2017 at 1:16 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>
>>>> is there any reason you want to start assining vectors on the local
>>>> node?  This is doable, but would complicate the code quite a bit
>>>> so it needs a good argument.
>>>
>>>
>>>
>>> My interpretation is that mlx5 tried to do this for the (rather esoteric
>>> in my mind) case where the platform does not have enough vectors for the
>>> driver to allocate percpu. In this case, the next best thing is to stay
>>> as close to the device affinity as possible.
>>>
>>
>> No, we did it for the reason that mlx5e netdevice assumes that
>> IRQ[0]..IRQ[#num_numa/#cpu_per_numa]
>> are always bound to the numa close to the device. and the mlx5e driver
>> choose those IRQs to spread
>> the RSS hash only into them and never uses other IRQs/Cores
>
>
> OK, that explains a lot of weirdness I've seen with mlx5e.
>
> Can you explain why you're using only a single numa node for your RSS
> table? What does it buy you? You open RX rings for _all_ cpus but
> only spread on part of them? I must be missing something here...

Adding Tariq,

this is also part of the weirdness :), we do that to make sure any OOB
test you run you always get the best performance
and we will guarantee to always use close numa cores.

we open RX rings on all of the cores in case if the user want to
change the RSS table to point to the whole thing on the fly "ethtool
-X"

But we are willing to change that, Tariq can provide the patch,
without changing this mlx5e is broken.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
