From: David Miller <davem@davemloft.net>
Subject: Re: [pull request][net-next 0/7] Mellanox, mlx5e and IPoIB netlink
 support fixes
Date: Mon, 15 Oct 2018 21:50:51 -0700 (PDT)
Message-ID: <20181015.215051.301253264060154339.davem@davemloft.net>
References: <20181011012444.28194-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181011012444.28194-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeedm@mellanox.com
Cc: netdev@vger.kernel.org, jgg@mellanox.com, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 10 Oct 2018 18:24:37 -0700

> This series was meant to go to -rc but due to this late submission and the
> size/complexity of this patchset, I am submitting to net-next.
> 
> This series came to fix a very serious regression in RDMA
> IPoIB netlink child creation API, the patcheset contains fixes to two
> components and they must come together:
> 1) IPoIB netllink implementation to allow allocation of the netdev to be done by
> the rtnl netdev code
> 2) mlx5e refactoring and changes to correctly initialize netdevices
> created by the rdma stack.
> 
> For more details please see tag log below.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks.
