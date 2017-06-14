From: Avinash Repaka <avinash.repaka@oracle.com>
Subject: Re: [PATCH] RDS: IB: NULL dereference on error in rds_ib_alloc_frmr()
Date: Wed, 14 Jun 2017 13:59:16 -0700
Message-ID: <0d556f30-3a33-695e-4a13-a2e0070d0684@oracle.com>
References: <20170614103924.GK29394@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170614103924.GK29394@elgon.mountain>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Reviewed-by: Avinash Repaka <avinash.repaka@oracle.com>

On 06/14/2017 03:39 AM, Dan Carpenter wrote:
> We accidentally return ERR_PTR(0) if ib_alloc_mr() fails.  The caller
> is expecting error pointers so it results in a NULL dereference.
>
> Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registration mode")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
> index 48332a6ed738..74a66cc162ed 100644
> --- a/net/rds/ib_frmr.c
> +++ b/net/rds/ib_frmr.c
> @@ -38,7 +38,7 @@ static struct rds_ib_mr *rds_ib_alloc_frmr(struct rds_ib_device *rds_ibdev,
>   	struct rds_ib_mr_pool *pool;
>   	struct rds_ib_mr *ibmr = NULL;
>   	struct rds_ib_frmr *frmr;
> -	int err = 0;
> +	int err;
>   
>   	if (npages <= RDS_MR_8K_MSG_SIZE)
>   		pool = rds_ibdev->mr_8k_pool;
> @@ -61,6 +61,7 @@ static struct rds_ib_mr *rds_ib_alloc_frmr(struct rds_ib_device *rds_ibdev,
>   			 pool->fmr_attr.max_pages);
>   	if (IS_ERR(frmr->mr)) {
>   		pr_warn("RDS/IB: %s failed to allocate MR", __func__);
> +		err = -ENOMEM;
>   		goto out_no_cigar;
>   	}
>   

