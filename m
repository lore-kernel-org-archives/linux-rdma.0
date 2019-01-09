From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] packet: Do not leak dev refcounts on error exit
Date: Tue, 08 Jan 2019 18:59:30 -0800 (PST)
Message-ID: <20190108.185930.1694064159905466574.davem@davemloft.net>
References: <20190108232658.GA1911@ziepe.ca>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190108232658.GA1911@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: jgg@mellanox.com
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, willemb@google.com, leonro@mellanox.com
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>
Date: Tue, 8 Jan 2019 23:27:06 +0000

> 'dev' is non NULL when the addr_len check triggers so it must goto a label
> that does the dev_put otherwise dev will have a leaked refcount.
> 
> This bug causes the ib_ipoib module to become unloadable when using
> systemd-network as it triggers this check on InfiniBand links.
> 
> Fixes: 99137b7888f4 ("packet: validate address length")
> Reported-by: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

Applied and queued up for -stable, thanks.
