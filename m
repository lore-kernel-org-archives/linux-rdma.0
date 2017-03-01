From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] rds: ib: add the static type to the variables
Date: Wed, 01 Mar 2017 12:51:55 -0500 (EST)
Message-ID: <20170301.125155.287193477729242606.davem@davemloft.net>
References: <1488264340-20044-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1488264340-20044-1-git-send-email-yanjun.zhu@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: yanjun.zhu@oracle.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Tue, 28 Feb 2017 01:45:40 -0500

> The variables rds_ib_mr_1m_pool_size and rds_ib_mr_8k_pool_size
> are used only in the ib.c file. As such, the static type is
> added to limit them in this file.
> 
> Cc: Joe Jin <joe.jin@oracle.com>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Applied.
