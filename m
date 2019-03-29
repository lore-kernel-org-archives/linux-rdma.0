From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net: rds: force to destroy connection if t_sock is
 NULL in rds_tcp_kill_sock().
Date: Thu, 28 Mar 2019 17:18:40 -0700 (PDT)
Message-ID: <20190328.171840.536122682640768471.davem@davemloft.net>
References: <20190328091056.186547-1-maowenan@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190328091056.186547-1-maowenan@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: maowenan@huawei.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Thu, 28 Mar 2019 17:10:56 +0800

> When it is to cleanup net namespace, rds_tcp_exit_net() will call
> rds_tcp_kill_sock(), if t_sock is NULL, it will not call
> rds_conn_destroy(), rds_conn_path_destroy() and rds_tcp_conn_free() to free
> connection, and the worker cp_conn_w is not stopped, afterwards the net is freed in
> net_drop_ns(); While cp_conn_w rds_connect_worker() will call rds_tcp_conn_path_connect()
> and reference 'net' which has already been freed.
> 
> In rds_tcp_conn_path_connect(), rds_tcp_set_callbacks() will set t_sock = sock before
> sock->ops->connect, but if connect() is failed, it will call
> rds_tcp_restore_callbacks() and set t_sock = NULL, if connect is always
> failed, rds_connect_worker() will try to reconnect all the time, so
> rds_tcp_kill_sock() will never to cancel worker cp_conn_w and free the
> connections.
> 
> Therefore, the condition !tc->t_sock is not needed if it is going to do
> cleanup_net->rds_tcp_exit_net->rds_tcp_kill_sock, because tc->t_sock is always
> NULL, and there is on other path to cancel cp_conn_w and free
> connection. So this patch is to fix this.
> 
> rds_tcp_kill_sock():
> ...
> if (net != c_net || !tc->t_sock)
> ...
> ==================================================================
> BUG: KASAN: use-after-free in inet_create+0xbcc/0xd28
 ...
> ==================================================================
> 
> Fixes: 467fa15356ac("RDS-TCP: Support multiple RDS-TCP listen endpoints, one per netns.")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Applied and queued up for -stable.
