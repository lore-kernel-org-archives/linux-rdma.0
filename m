From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] RDS: IB: Use DEFINE_PER_CPU_SHARED_ALIGNED for
 rds_ib_stats
Date: Sun, 23 Sep 2018 12:19:27 -0700 (PDT)
Message-ID: <20180923.121927.436285462706036460.davem@davemloft.net>
References: <20180921180451.18711-1-natechancellor@gmail.com>
        <20180923064445.GC12338@flashbox>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180923064445.GC12338@flashbox>
Sender: linux-kernel-owner@vger.kernel.org
To: natechancellor@gmail.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, ndesaulniers@google.com
List-Id: linux-rdma@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Sat, 22 Sep 2018 23:44:45 -0700

> I have sent a v2 because this should be DECLARE_PER_CPU_SHARED_ALIGNED,
> not DEFINE (thanks to 0day for catching it).

Your first version was already applied to the networking GIT tree, so
you will need to submit a relative fixup with a proper "Fixes: " tag.
