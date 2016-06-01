From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH] IB/core: Fix different types mix in ib_device_cap_flags
 structure values
Date: Wed, 1 Jun 2016 15:04:20 +0300
Message-ID: <574ECF44.3070003@mellanox.com>
References: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
 <08df9022-e575-da0d-c76d-a28185c9db2d@sandisk.com>
 <20160531171306.GA6618@obsidianresearch.com> <20160531173033.GC7477@leon.nu>
 <13f16fdf-e1d2-0baa-abe1-6423d2196b72@sandisk.com>
 <20160531181223.GE7477@leon.nu> <20160531182100.GC21834@obsidianresearch.com>
 <20160531185432.GF7477@leon.nu> <20160531193956.GD21834@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160531193956.GD21834@obsidianresearch.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Leon Romanovsky <leon@kernel.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, matanb@mellanox.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> The four constants have different types and the types are not
> necessarily what you'd expect (eg FOO_VALUE3 has been promoted to a
> 64 bit signed long, FOO_VALUE1 has been demoted to an int)
>
> So the enum is safe, but having different types of the values is
> certainly unexpected.
>
> I still think the actual bug is only 1<<31 I pointed out earlier:
>
> enum Foo
> {
> 	FOO_VALUE1 = 1,
> 	FOO_VALUE2 = ((uint64_t)2) << 32,
> 	FOO_VALUE3 = 1<<31,
> };
> uint64_t res = FOO_VALUE1 | FOO_VALUE2 | FOO_VALUE3;
> printf("%lx\n",res);
> ==
> ffffffff80000001
>
> Which is clearly wrong. This is because signed int becomes sign
> extended when converted to uint64_t, corrupting the upper bits.
>
> Since adding the ULL's doesn't make the enum constants have uniform
> type I would not bother with the churn.

tested this with single casting to IB_DEVICE_ON_DEMAND_PAGING (1 << 31) 
to (1ULL << 31). works fine.
I'll send another patch today.

Thanks,
Max.

>
> Jason
>
