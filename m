From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v2 06/17] RDMA/counter: Add "auto"
 configuration mode support
Date: Wed, 22 May 2019 14:11:48 -0300
Message-ID: <20190522171148.GB15023@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190429083453.16654-7-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 11:34:42AM +0300, Leon Romanovsky wrote:

>  void rdma_counter_init(struct ib_device *dev)
>  {
>  	struct rdma_port_counter *port_counter;
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 9204b4251fc8..dfaa57de871f 100644
> +++ b/drivers/infiniband/core/device.c
> @@ -2349,6 +2349,8 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
>  	SET_DEVICE_OP(dev_ops, set_vf_guid);
>  	SET_DEVICE_OP(dev_ops, set_vf_link_state);
>  	SET_DEVICE_OP(dev_ops, unmap_fmr);
> +	SET_DEVICE_OP(dev_ops, counter_bind_qp);
> +	SET_DEVICE_OP(dev_ops, counter_unbind_qp);

Keep sorted

Jason
