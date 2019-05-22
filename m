From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v2 13/17] RDMA/core: Get sum value of all
 counters when perform a sysfs stat read
Date: Wed, 22 May 2019 14:26:36 -0300
Message-ID: <20190522172636.GF15023@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-14-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190429083453.16654-14-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 11:34:49AM +0300, Leon Romanovsky wrote:
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index c56ffc61ab1e..8ae4906a60e7 100644
> +++ b/drivers/infiniband/core/device.c
> @@ -1255,7 +1255,11 @@ int ib_register_device(struct ib_device *device, const char *name)
>  		goto dev_cleanup;
>  	}
>  
> -	rdma_counter_init(device);
> +	ret = rdma_counter_init(device);
> +	if (ret) {
> +		dev_warn(&device->dev, "Couldn't initialize counter\n");
> +		goto sysfs_cleanup;
> +	}

Don't put this things randomly, if there is some reason it should be
after sysfs it needs a comment, otherwise if it is just allocating
memory it belongs earlier, and the unwind should be done in release.

I also think it is very strange/wrong that both sysfs and counters are
allocating the same alloc_hw_stats object

Why can't they share?

Jason
