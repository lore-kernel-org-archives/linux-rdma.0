From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] net/mlx4_core: avoid resetting HCA when accessing
 an offline device
Date: Mon, 16 Apr 2018 12:51:10 -0400 (EDT)
Message-ID: <20180416.125110.1875435797136179428.davem@davemloft.net>
References: <1523840527-22746-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1523840527-22746-1-git-send-email-yanjun.zhu@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: yanjun.zhu@oracle.com
Cc: tariqt@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, haakon.bugge@oracle.com
List-Id: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Sun, 15 Apr 2018 21:02:07 -0400

> While a faulty cable is used or HCA firmware error, HCA device will
> be offline. When the driver is accessing this offline device, the
> following call trace will pop out.
 ...
> In the above call trace, the function mlx4_cmd_poll calls the function
> mlx4_cmd_post to access the HCA while HCA is offline. Then mlx4_cmd_post
> returns an error -EIO. Per -EIO, the function mlx4_cmd_poll calls
> mlx4_cmd_reset_flow to reset HCA. And the above call trace pops out.
> 
> This is not reasonable. Since HCA device is offline when it is being
> accessed, it should not be reset again.
> 
> In this patch, since HCA is offline, the function mlx4_cmd_post returns
> an error -EINVAL. Per -EINVAL, the function mlx4_cmd_poll directly returns
> instead of resetting HCA.
> 
> CC: Srinivas Eeda <srinivas.eeda@oracle.com>
> CC: Junxiao Bi <junxiao.bi@oracle.com>
> Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Tariq, I'm assuming you'll take this in and send it to me later.

Thanks.
