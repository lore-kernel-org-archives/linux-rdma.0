From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH net-next] RDS: IB: fix 'passing zero to ERR_PTR()' warning
Date: Tue, 7 Aug 2018 10:09:49 -0700
Message-ID: <62d6f34a-3bdc-8c32-bcae-cd55cf27a911@oracle.com>
References: <20180807113416.12680-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180807113416.12680-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On 8/7/2018 4:34 AM, YueHaibing wrote:
> Fix a static code checker warning:
>   net/rds/ib_frmr.c:82 rds_ib_alloc_frmr() warn: passing zero to 'ERR_PTR'
> 
> The error path for ib_alloc_mr failure should set err to PTR_ERR.
> 
> Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registration mode")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
Looks good. Thanks !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
