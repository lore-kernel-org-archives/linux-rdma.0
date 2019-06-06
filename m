From: santosh.shilimkar@oracle.com
Subject: Re: [PATCH 1/1] net: rds: fix memory leak in rds_ib_flush_mr_pool
Date: Thu, 6 Jun 2019 08:57:24 -0700
Message-ID: <7519cb35-07b3-e530-0402-67f76c16a6b4@oracle.com>
References: <1559808003-1030-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1559808003-1030-1-git-send-email-yanjun.zhu@oracle.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Zhu Yanjun <yanjun.zhu@oracle.com>, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On 6/6/19 1:00 AM, Zhu Yanjun wrote:
> When the following tests last for several hours, the problem will occur.
> 
> Server:
>      rds-stress -r 1.1.1.16 -D 1M
> Client:
>      rds-stress -r 1.1.1.14 -s 1.1.1.16 -D 1M -T 30
> 
> The following will occur.
> 
> "
> Starting up....
> tsks   tx/s   rx/s  tx+rx K/s    mbi K/s    mbo K/s tx us/c   rtt us cpu
> %
>    1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
>    1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
>    1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
>    1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
> "
>  From vmcore, we can find that clean_list is NULL.
> 
>  From the source code, rds_mr_flushd calls rds_ib_mr_pool_flush_worker.
> Then rds_ib_mr_pool_flush_worker calls
> "
>   rds_ib_flush_mr_pool(pool, 0, NULL);
> "
> Then in function
> "
> int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
>                           int free_all, struct rds_ib_mr **ibmr_ret)
> "
> ibmr_ret is NULL.
> 
> In the source code,
> "
> ...
> list_to_llist_nodes(pool, &unmap_list, &clean_nodes, &clean_tail);
> if (ibmr_ret)
>          *ibmr_ret = llist_entry(clean_nodes, struct rds_ib_mr, llnode);
> 
> /* more than one entry in llist nodes */
> if (clean_nodes->next)
>          llist_add_batch(clean_nodes->next, clean_tail, &pool->clean_list);
> ...
> "
> When ibmr_ret is NULL, llist_entry is not executed. clean_nodes->next
> instead of clean_nodes is added in clean_list.
> So clean_nodes is discarded. It can not be used again.
> The workqueue is executed periodically. So more and more clean_nodes are
> discarded. Finally the clean_list is NULL.
> Then this problem will occur.
> 
> Fixes: 1bc144b62524 ("net, rds, Replace xlist in net/rds/xlist.h with llist")
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
Thanks.
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
