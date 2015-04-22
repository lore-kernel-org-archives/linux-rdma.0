From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v5 24/27] IB/Verbs: Use management helper cap_af_ib()
Date: Tue, 21 Apr 2015 20:11:38 -0400
Message-ID: <20150422001137.GX15893@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <5534BBF9.80703@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5534BBF9.80703@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 20, 2015 at 10:42:33AM +0200, Michael Wang wrote:
> 
> Introduce helper cap_af_ib() to help us check if the port of an
> IB device support Native Infiniband Address.
> 
> Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
> Cc: Steve Wise <swise@opengridcomputing.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/infiniband/core/cma.c |  2 +-
>  include/rdma/ib_verbs.h       | 15 +++++++++++++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 05d148e..9c1f5b72 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -469,7 +469,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
>  
>  	list_for_each_entry(cur_dev, &dev_list, list) {
>  		for (p = 1; p <= cur_dev->device->phys_port_cnt; ++p) {
> -			if (!rdma_ib_or_iboe(cur_dev->device, p))
> +			if (!cap_af_ib(cur_dev->device, p))
>  				continue;
>  
>  			if (ib_find_cached_pkey(cur_dev->device, p, pkey, &index))
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 074f66d..9cfab09 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1879,6 +1879,21 @@ static inline int cap_ipoib(struct ib_device *device, u8 port_num)
>  }
>  
>  /**
> + * cap_af_ib - Check if the port of device has the capability
> + * Native Infiniband Address.
> + *
> + * @device: Device to be checked
> + * @port_num: Port number of the device
> + *
> + * Return 0 when port of the device don't support
> + * Native Infiniband Address.
> + */
> +static inline int cap_af_ib(struct ib_device *device, u8 port_num)
> +{
> +	return rdma_ib_or_iboe(device, port_num);
> +}
> +
> +/**
>   * cap_read_multi_sge - Check if the port of device has the capability
>   * RDMA Read Multiple Scatter-Gather Entries.
>   *
> -- 
> 2.1.0
