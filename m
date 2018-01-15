From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 net 0/2] IB/ipoib: ip link support
Date: Mon, 15 Jan 2018 13:13:09 -0500 (EST)
Message-ID: <20180115.131309.1163036253579166139.davem@davemloft.net>
References: <20180101224347.xdxguvvr4g7jrxq4@inn>
        <1515534167-13062-1-git-send-email-denisd@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1515534167-13062-1-git-send-email-denisd@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: denisd@mellanox.com
Cc: jgg@mellanox.com, dledford@redhat.com, leonro@mellanox.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, gerlitz.or@gmail.com
List-Id: linux-rdma@vger.kernel.org

From: Denis Drozdov <denisd@mellanox.com>
Date: Tue,  9 Jan 2018 23:42:45 +0200

> IP link was broken due to the changes in IPoIB for the rdma_netdev
> support after commit cd565b4b51e5
> ("IB/IPoIB: Support acceleration options callbacks").
> 
> This patchset restores IPoIB pkey creation and removal using rtnetlink.
> The first patch introduces changes in the rtnetlink code in order to allow
> IPOIB allocate and free the netdevice.
> 
> The second patch establishes appropriate rtnetlink callbacks for IPoIB
> device and restores IPoIB netlink support
> 
> Changes since v1:
> - Fixed double free_netdev calls in ops->free_link in netdev_run_todo 
> - Removed priv_size from ipoib_link_ops as not required anymore.

Please fix your control flow so that the existing netlink op can do
the right thing.

We're not going to add a whole new set of netdev ops every time a subsystem
has a weird control flow issue that no other device type has.  Please fix
this inside of the IB stack, thank you.
