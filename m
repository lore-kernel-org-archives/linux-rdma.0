From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [PATCH v3 01/28] IB/Verbs: Implement new callback query_transport()
Date: Wed, 15 Apr 2015 14:36:13 -0400
Message-ID: <552EAF9D.8050400@dev.mellanox.co.il>
References: <552BB470.4090407@profitbricks.com> <552BB4FA.5000109@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <552BB4FA.5000109@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On 4/13/2015 8:22 AM, Michael Wang wrote:
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 65994a1..d54f91e 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -75,10 +75,13 @@ enum rdma_node_type {
>  };
>  
>  enum rdma_transport_type {
> +	/* legacy for users */
>  	RDMA_TRANSPORT_IB,
>  	RDMA_TRANSPORT_IWARP,
>  	RDMA_TRANSPORT_USNIC,
> -	RDMA_TRANSPORT_USNIC_UDP
> +	RDMA_TRANSPORT_USNIC_UDP,
> +	/* new transport */
> +	RDMA_TRANSPORT_IBOE,
>  };
>  
>  __attribute_const__ enum rdma_transport_type
> @@ -1501,6 +1504,8 @@ struct ib_device {
>  	int		           (*query_port)(struct ib_device *device,
>  						 u8 port_num,
>  						 struct ib_port_attr *port_attr);
> +	enum rdma_transport_type   (*query_transport)(struct ib_device *device,
> +						      u8 port_num);
>  	enum rdma_link_layer	   (*get_link_layer)(struct ib_device *device,
>  						     u8 port_num);
>  	int		           (*query_gid)(struct ib_device *device,

libibverbs also exposes transport at the device level. Isn't a change to
make transport per port rather than per device needed there as well to
be consistent with these proposed kernel changes ? If so, would the
additional IBoE transport be exposed ? We also need to worry about
backward compatibility for existing applications.

-- Hal
