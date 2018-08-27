From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] net/rds: Use rdma_read_gids to get connection
 SGID/DGID in IPv6
Date: Mon, 27 Aug 2018 15:26:19 -0700 (PDT)
Message-ID: <20180827.152619.1765710083731716396.davem@davemloft.net>
References: <20180825071905.2749-1-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180825071905.2749-1-yanjun.zhu@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: yanjun.zhu@oracle.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Sat, 25 Aug 2018 15:19:05 +0800

> In IPv4, the newly introduced rdma_read_gids is used to read the SGID/DGID
> for the connection which returns GID correctly for RoCE transport as well.
> 
> In IPv6, rdma_read_gids is also used. The following are why rdma_read_gids
> is introduced.
> 
> rdma_addr_get_dgid() for RoCE for client side connections returns MAC
> address, instead of DGID.
> rdma_addr_get_sgid() for RoCE doesn't return correct SGID for IPv6 and
> when more than one IP address is assigned to the netdevice.
> 
> So the transport agnostic rdma_read_gids() API is provided by rdma_cm
> module.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Applied.
