From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH -next] IB/qib: Add missing err handle for
 qib_user_sdma_rb_insert
Date: Wed, 2 Jan 2019 10:12:24 -0700
Message-ID: <20190102171224.GA26765@ziepe.ca>
References: <20181221021938.13784-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181221021938.13784-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, dledford@redhat.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 21, 2018 at 10:19:38AM +0800, YueHaibing wrote:
> It should goto err handle if qib_user_sdma_rb_insert fails,
> other than success return.
> 
> Fixes: 67810e8c3c01 ("RDMA/qib: Remove all occurrences of BUG_ON()")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/infiniband/hw/qib/qib_user_sdma.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
> index 31c523b..e87c0a7 100644
> --- a/drivers/infiniband/hw/qib/qib_user_sdma.c
> +++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
> @@ -237,6 +237,8 @@ qib_user_sdma_queue_create(struct device *dev, int unit, int ctxt, int sctxt)
>  
>  		ret = qib_user_sdma_rb_insert(&qib_user_sdma_rb_root,
>  					sdma_rb_node);
> +		if (ret == 0)
> +			goto err_rb;
>  	}

This doesn't look right, what about undoing the kmalloc directly
above?

Jason
