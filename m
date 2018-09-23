From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] RDS: IB: Use DEFINE_PER_CPU_SHARED_ALIGNED for
 rds_ib_stats
Date: Sun, 23 Sep 2018 12:38:54 -0700
Message-ID: <20180923193854.GA27723@flashbox>
References: <20180921180451.18711-1-natechancellor@gmail.com>
 <20180923064445.GC12338@flashbox>
 <20180923.121927.436285462706036460.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180923.121927.436285462706036460.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, ndesaulniers@google.com
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 23, 2018 at 12:19:27PM -0700, David Miller wrote:
> From: Nathan Chancellor <natechancellor@gmail.com>
> Date: Sat, 22 Sep 2018 23:44:45 -0700
> 
> > I have sent a v2 because this should be DECLARE_PER_CPU_SHARED_ALIGNED,
> > not DEFINE (thanks to 0day for catching it).
> 
> Your first version was already applied to the networking GIT tree, so
> you will need to submit a relative fixup with a proper "Fixes: " tag.

Hi David,

My apologies, I didn't receive an email saying my patch was applied so I
didn't think to check your tree. I'll be better about this in the
future.

Thank you for fixing this up yourself and all your patience, sorry for
all the noise!

Nathan
