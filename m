From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH -next] IB/qib: Add missing err handle for
 qib_user_sdma_rb_insert
Date: Fri, 4 Jan 2019 18:39:50 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC70C11891@fmsmsx120.amr.corp.intel.com>
References: <20181221021938.13784-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181221021938.13784-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c
> b/drivers/infiniband/hw/qib/qib_user_sdma.c
> index 31c523b..e87c0a7 100644
> --- a/drivers/infiniband/hw/qib/qib_user_sdma.c
> +++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
> @@ -237,6 +237,8 @@ qib_user_sdma_queue_create(struct device *dev,
> int unit, int ctxt, int sctxt)
> 
>  		ret = qib_user_sdma_rb_insert(&qib_user_sdma_rb_root,
>  					sdma_rb_node);
> +		if (ret == 0)
> +			goto err_rb;
>  	}
>  	pq->sdma_rb_node = sdma_rb_node;
> 
> --
> 2.7.0
> 

Thanks!

This patch is ok.

The NULL returned from this routine will result in an error return up to PSM which will fail.

The bail branch will do the necessary cleanup, including freeing the node that couldn't be added.

Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
