From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix different types mix in ib_device_cap_flags
 structure values
Date: Wed, 1 Jun 2016 18:35:56 +0300
Message-ID: <574F00DC.5000002@grimberg.me>
References: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
 <08df9022-e575-da0d-c76d-a28185c9db2d@sandisk.com>
 <20160531171306.GA6618@obsidianresearch.com> <20160531173033.GC7477@leon.nu>
 <13f16fdf-e1d2-0baa-abe1-6423d2196b72@sandisk.com>
 <20160531181223.GE7477@leon.nu> <20160531182100.GC21834@obsidianresearch.com>
 <20160531185432.GF7477@leon.nu> <20160531193956.GD21834@obsidianresearch.com>
 <574ECF44.3070003@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <574ECF44.3070003-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> Which is clearly wrong. This is because signed int becomes sign
>> extended when converted to uint64_t, corrupting the upper bits.
>>
>> Since adding the ULL's doesn't make the enum constants have uniform
>> type I would not bother with the churn.
>
> tested this with single casting to IB_DEVICE_ON_DEMAND_PAGING (1 << 31)
> to (1ULL << 31). works fine.
> I'll send another patch today.

Good to know, thanks Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
