From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] net: rds: fix memory leak when unload rds_rdma
Date: Wed, 05 Jun 2019 17:08:52 -0700 (PDT)
Message-ID: <20190605.170852.389314570750893823.davem@davemloft.net>
References: <1559566099-30289-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1559566099-30289-1-git-send-email-yanjun.zhu@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: yanjun.zhu@oracle.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Mon,  3 Jun 2019 08:48:19 -0400

> When KASAN is enabled, after several rds connections are
> created, then "rmmod rds_rdma" is run. The following will
> appear.
 ...
> This is rds connection memory leak. The root cause is:
> When "rmmod rds_rdma" is run, rds_ib_remove_one will call
> rds_ib_dev_shutdown to drop the rds connections.
> rds_ib_dev_shutdown will call rds_conn_drop to drop rds
> connections as below.
> "
> rds_conn_path_drop(&conn->c_path[0], false);
> "
> In the above, destroy is set to false.
 ...
> In the above function, destroy is set to false. rds_destroy_pending
> is called. This does not move rds connections to ib_nodev_conns.
> So destroy is set to true to move rds connections to ib_nodev_conns.
> In rds_ib_unregister_client, flush_workqueue is called to make rds_wq
> finsh shutdown rds connections. The function rds_ib_destroy_nodev_conns
> is called to shutdown rds connections finally.
> Then rds_ib_recv_exit is called to destroy slab.
 ...
> Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Applied.
