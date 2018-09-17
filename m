From: David Miller <davem@davemloft.net>
Subject: Re: [PATCHv2 net-next 1/1] net: rds: use memset to optimize the
 recv
Date: Mon, 17 Sep 2018 08:21:07 -0700 (PDT)
Message-ID: <20180917.082107.503155904547300915.davem@davemloft.net>
References: <20180917024930.22171-1-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917024930.22171-1-yanjun.zhu@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: yanjun.zhu@oracle.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Sun, 16 Sep 2018 22:49:30 -0400

> The function rds_inc_init is in recv process. To use memset can optimize
> the function rds_inc_init.
> The test result:
> 
>      Before:
>      1) + 24.950 us   |        rds_inc_init [rds]();
>      After:
>      1) + 10.990 us   |        rds_inc_init [rds]();
> 
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
> V1->V2: a new patch for net-next

Applied.
