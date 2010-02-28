From: David Miller <davem@davemloft.net>
Subject: Re: [net-next-2.6 PATCH] infiniband: convert to use
 netdev_for_each_mc_addr
Date: Sun, 28 Feb 2010 01:33:30 -0800 (PST)
Message-ID: <20100228.013330.116370303.davem@davemloft.net>
References: <20100227103835.GA2862@psychotron.redhat.com>
	<20100227184410.GB13231@obsidianresearch.com>
	<20100227220731.GB6550@psychotron.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20100227220731.GB6550@psychotron.redhat.com>
Sender: netdev-owner@vger.kernel.org
To: jpirko@redhat.com
Cc: jgunthorpe@obsidianresearch.com, ogerlitz@voltaire.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, monis@voltaire.com
List-Id: linux-rdma@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Sat, 27 Feb 2010 23:07:33 +0100

> Subject: [net-next-2.6 PATCH] ipoib: returned back addrle check for mc addresses
> 
> Apparently bogus mc address can brake IPOIB multicast processing. Therefore
> returning the check for addrlen back until this is resolved in bonding (I don't
> see any other point from where mc address with non-dev->addr_len length can came
> from).
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>

Applied.
