From: David Miller <davem@davemloft.net>
Subject: Re: linux-next: build warning in Linus' tree
Date: Thu, 17 Mar 2011 18:13:36 -0700 (PDT)
Message-ID: <20110317.181336.226775410.davem@davemloft.net>
References: <20110318100418.6556c92c.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20110318100418.6556c92c.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: sfr@canb.auug.org.au
Cc: roland@kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, hal.rosenstock@gmail.com, eric.dumazet@gmail.com, tj@kernel.org, xiaosuo@gmail.com, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 18 Mar 2011 10:04:18 +1100

> Hi all,
> 
> After merging the Linus' tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> drivers/infiniband/core/addr.c: In function 'addr4_resolve':
> drivers/infiniband/core/addr.c:188: warning: 'ret' may be used uninitialized in this function
> 
> I didn't notice this one before, sorry.
> 
> I don't know what introduced it, but the third if statement in the
> function will make us use "ret" uninitialised.

It was the ipv4 route lookup interface changes.

Roland has received a fix already, and will merge it via the infiniband
tree.
