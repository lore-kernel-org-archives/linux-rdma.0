From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] net: rds: fix memory leak in rds_ib_flush_mr_pool
Date: Thu, 06 Jun 2019 10:33:05 -0700 (PDT)
Message-ID: <20190606.103305.472940054915337291.davem@davemloft.net>
References: <1559808003-1030-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1559808003-1030-1-git-send-email-yanjun.zhu@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: yanjun.zhu@oracle.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Thu,  6 Jun 2019 04:00:03 -0400

> When the following tests last for several hours, the problem will occur.
 ...
> When ibmr_ret is NULL, llist_entry is not executed. clean_nodes->next
> instead of clean_nodes is added in clean_list.
> So clean_nodes is discarded. It can not be used again.
> The workqueue is executed periodically. So more and more clean_nodes are
> discarded. Finally the clean_list is NULL.
> Then this problem will occur.
> 
> Fixes: 1bc144b62524 ("net, rds, Replace xlist in net/rds/xlist.h with llist")
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Applied and queued up for -stable.
