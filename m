From: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Subject: Re: [patch 1/3] ib_srpt: fixup error handling in
 srpt_alloc_ioctx_ring()
Date: Fri, 04 Nov 2011 14:52:24 -0700
Message-ID: <1320443544.5859.168.camel@haakon2.linux-iscsi.org>
References: <20111104182701.GG5796@elgon.mountain>
Reply-To: nab@risingtidesystems.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20111104182701.GG5796@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, Bart Van Assche <bart.vanassche@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2011-11-04 at 21:27 +0300, Dan Carpenter wrote:
> We returned a freed value instead of NULL on certain error paths.
> Complicated error handling generally more error prone, so I've tried
> to simplify it a little by removing some gotos.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Looks like a reasonable cleanup.  Thanks Dan!

--nab

> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 1c29679..937b4bc 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -680,21 +680,20 @@ static struct srpt_ioctx **srpt_alloc_ioctx_ring(struct srpt_device *sdev,
>  
>  	ring = kmalloc(ring_size * sizeof(ring[0]), GFP_KERNEL);
>  	if (!ring)
> -		goto out;
> +		return NULL;
>  	for (i = 0; i < ring_size; ++i) {
>  		ring[i] = srpt_alloc_ioctx(sdev, ioctx_size, dma_size, dir);
>  		if (!ring[i])
>  			goto err;
>  		ring[i]->index = i;
>  	}
> -	goto out;
> +	return ring;
>  
>  err:
>  	while (--i >= 0)
>  		srpt_free_ioctx(sdev, ring[i], dma_size, dir);
>  	kfree(ring);
> -out:
> -	return ring;
> +	return NULL;
>  }
>  
>  /**
