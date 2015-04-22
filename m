From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v5 22/27] IB/Verbs: Use management helper cap_ipoib()
Date: Tue, 21 Apr 2015 20:11:10 -0400
Message-ID: <20150422001109.GV15893@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <5534BBC2.4010902@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5534BBC2.4010902@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 20, 2015 at 10:41:38AM +0200, Michael Wang wrote:
> 
> Introduce helper cap_ipoib() to help us check if the port of an
> IB device support IP over Infiniband.
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
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |  2 +-
>  include/rdma/ib_verbs.h                   | 15 +++++++++++++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 60b379d..a9812df 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1671,7 +1671,7 @@ static void ipoib_add_one(struct ib_device *device)
>  	}
>  
>  	for (p = s; p <= e; ++p) {
> -		if (!rdma_tech_ib(device, p))
> +		if (!cap_ipoib(device, p))
>  			continue;
>  		dev = ipoib_add_port("ib%d", device, p);
>  		if (!IS_ERR(dev)) {
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 6e354df..d0ae08e 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1863,6 +1863,21 @@ static inline int cap_ib_mcast(struct ib_device *device, u8 port_num)
>  	return cap_ib_sa(device, port_num);
>  }
>  
> +/**
> + * cap_ipoib - Check if the port of device has the capability
> + * IP over Infiniband.
> + *
> + * @device: Device to be checked
> + * @port_num: Port number of the device
> + *
> + * Return 0 when port of the device don't support
> + * IP over Infiniband.
> + */
> +static inline int cap_ipoib(struct ib_device *device, u8 port_num)
> +{
> +	return rdma_tech_ib(device, port_num);
> +}
> +
>  int ib_query_gid(struct ib_device *device,
>  		 u8 port_num, int index, union ib_gid *gid);
>  
> -- 
> 2.1.0
