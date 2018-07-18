From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/rds: void function cannot return -1
Date: Wed, 18 Jul 2018 14:44:25 +0900 (KST)
Message-ID: <20180718.144425.289131710667497329.davem@davemloft.net>
References: <20180716130009.1591379-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716130009.1591379-1-Haakon.Bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Haakon.Bugge@oracle.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Håkon Bugge <Haakon.Bugge@oracle.com>
Date: Mon, 16 Jul 2018 15:00:09 +0200

> Commit b6fb0df12db6 ("RDS/IB: Make ib_recv_refill return void") did
> not change the comment accordingly.
> 
> Fixes: b6fb0df12db6 ("RDS/IB: Make ib_recv_refill return void")
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>

Applied.
