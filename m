From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] IB/core: Fix different types mix in ib_device_cap_flags
 structure values
Date: Tue, 31 May 2016 12:16:19 -0600
Message-ID: <20160531181619.GB21834@obsidianresearch.com>
References: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
 <08df9022-e575-da0d-c76d-a28185c9db2d@sandisk.com>
 <20160531171306.GA6618@obsidianresearch.com>
 <20160531173033.GC7477@leon.nu>
 <13f16fdf-e1d2-0baa-abe1-6423d2196b72@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <13f16fdf-e1d2-0baa-abe1-6423d2196b72@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: leon@kernel.org, Max Gurtovoy <maxg@mellanox.com>, matanb@mellanox.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 31, 2016 at 11:05:00AM -0700, Bart Van Assche wrote:

> Let me rephrase my question. Before and after this patch
> IB_DEVICE_SG_GAPS_REG is defined as 1ULL << 32, so how can this patch make a
> difference?

Excellent question.

I thought the issue was this:

        IB_DEVICE_ON_DEMAND_PAGING              = (1 << 31),

Because (1<<31) is also technically undefined if 1 is signed, which,
IIRC, is a compiler choice.. But you are right, all the other ones
look OK.

Mellanox, so what does this *actually* do??

> And if the issue is that some compilers choose a 32-bit integer for
> ib_device_cap_flags and others a 64-bit integer, shouldn't

That isn't allowed by the standard. The compiler cannot truncate enum
values.

Jason
