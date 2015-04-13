From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v3 07/28] IB/Verbs: Reform IB-ulp ipoib
Date: Mon, 13 Apr 2015 13:27:01 -0600
Message-ID: <20150413192701.GA19112@obsidianresearch.com>
References: <552BB470.4090407@profitbricks.com>
 <552BB5AC.6050101@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <552BB5AC.6050101@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 13, 2015 at 02:25:16PM +0200, Michael Wang wrote:
>  	dev_list = kmalloc(sizeof *dev_list, GFP_KERNEL);
>  	if (!dev_list)
> @@ -1673,13 +1671,19 @@ static void ipoib_add_one(struct ib_device *device)
>  	}
>  
>  	for (p = s; p <= e; ++p) {
> -		if (rdma_port_get_link_layer(device, p) != IB_LINK_LAYER_INFINIBAND)
> +		if (!rdma_tech_ib(device, p))
>  			continue;
>  		dev = ipoib_add_port("ib%d", device, p);
>  		if (!IS_ERR(dev)) {
>  			priv = netdev_priv(dev);
>  			list_add_tail(&priv->list, dev_list);
>  		}
> +		count++;
> +	}
> +
> +	if (!count) {
> +		kfree(dev_list);
> +		return;
>  	}

This doesn't quite look right, it should be 'goto error1'

But then I read 'goto error1' and it doesn't look like it can handle
cm_dev->port being NULL, so more fixing is needed.

Ditto for cm_remove_one

Should audit all uses of cm_dev->port[] to make sure they can all
handle NULL.

Jason
