From: Michael Neuling <mikey@neuling.org>
Subject: Re: linux-next: Tree for Oct 2 (ipoib_netlink.c)
Date: Wed, 03 Oct 2012 09:50:31 +1000
Message-ID: <10635.1349221831@neuling.org>
References: <20121002163229.d377074dc8f6c029428faeaa@canb.auug.org.au> <506B3FE4.9040407@xenotime.net>
Return-path: <linux-next-owner@vger.kernel.org>
In-reply-to: <506B3FE4.9040407@xenotime.net>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-rdma@vger.kernel.org

> on x86_64:
> 
> drivers/built-in.o: In function `ipoib_changelink':
> ipoib_netlink.c:(.text+0x6a5fc9): undefined reference to `ipoib_set_mode'
> ipoib_netlink.c:(.text+0x6a5fe3): undefined reference to `ipoib_set_mode'

Happens on powerpc too with ppc64e_defconfig compiling modules.

Reverting this fixes it:
  862096a IB/ipoib: Add more rtnl_link_ops callbacks

Adding patch owners and committer to CC.

Mikey
