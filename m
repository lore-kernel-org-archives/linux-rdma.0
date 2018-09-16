From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] net: rds: use memset to optimize the recv
Date: Sun, 16 Sep 2018 15:36:37 -0700 (PDT)
Message-ID: <20180916.153637.2289306962750648161.davem@davemloft.net>
References: <20180914084538.11666-1-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180914084538.11666-1-yanjun.zhu@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: yanjun.zhu@oracle.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Fri, 14 Sep 2018 04:45:38 -0400

> The function rds_inc_init is in recv process. To use memset can optimize
> the function rds_inc_init.
> The test result:
> 
>     Before:
>     1) + 24.950 us   |        rds_inc_init [rds]();
>     After:
>     1) + 10.990 us   |        rds_inc_init [rds]();
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

This doesn't apply cleanly to net-next, please respin.
