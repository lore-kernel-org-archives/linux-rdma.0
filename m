From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] RDS: IB: fix 'passing zero to ERR_PTR()'
 warning
Date: Tue, 07 Aug 2018 13:20:05 -0700 (PDT)
Message-ID: <20180807.132005.2055315056779068667.davem@davemloft.net>
References: <20180807113416.12680-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180807113416.12680-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: yuehaibing@huawei.com
Cc: santosh.shilimkar@oracle.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 7 Aug 2018 19:34:16 +0800

> Fix a static code checker warning:
>  net/rds/ib_frmr.c:82 rds_ib_alloc_frmr() warn: passing zero to 'ERR_PTR'
> 
> The error path for ib_alloc_mr failure should set err to PTR_ERR.
> 
> Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registration mode") 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied to net-next, thanks.
