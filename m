From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v5 08/27] IB/Verbs: Reform IB-ulp xprtrdma
Date: Tue, 21 Apr 2015 20:06:46 -0400
Message-ID: <20150422000645.GI15893@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <5534BA63.8010004@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5534BA63.8010004@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 20, 2015 at 10:35:47AM +0200, Michael Wang wrote:
> 
> Use raw management helpers to reform IB-ulp xprtrdma.
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
>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |  3 +--
>  net/sunrpc/xprtrdma/svc_rdma_transport.c | 45 +++++++++++++-------------------
>  2 files changed, 19 insertions(+), 29 deletions(-)
> 
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> index f9f13a3..a5bed5b 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> @@ -117,8 +117,7 @@ static void rdma_build_arg_xdr(struct svc_rqst *rqstp,
>  
>  static int rdma_read_max_sge(struct svcxprt_rdma *xprt, int sge_count)
>  {
> -	if (rdma_node_get_transport(xprt->sc_cm_id->device->node_type) ==
> -	     RDMA_TRANSPORT_IWARP)
> +	if (rdma_tech_iwarp(xprt->sc_cm_id->device, xprt->sc_cm_id->port_num))
>  		return 1;
>  	else
>  		return min_t(int, sge_count, xprt->sc_max_sge);
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> index f609c1c..a09b7a1 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> @@ -851,7 +851,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
>  	struct ib_qp_init_attr qp_attr;
>  	struct ib_device_attr devattr;
>  	int uninitialized_var(dma_mr_acc);
> -	int need_dma_mr;
> +	int need_dma_mr = 0;
>  	int ret;
>  	int i;
>  
> @@ -985,35 +985,26 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
>  	/*
>  	 * Determine if a DMA MR is required and if so, what privs are required
>  	 */
> -	switch (rdma_node_get_transport(newxprt->sc_cm_id->device->node_type)) {
> -	case RDMA_TRANSPORT_IWARP:
> -		newxprt->sc_dev_caps |= SVCRDMA_DEVCAP_READ_W_INV;
> -		if (!(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG)) {
> -			need_dma_mr = 1;
> -			dma_mr_acc =
> -				(IB_ACCESS_LOCAL_WRITE |
> -				 IB_ACCESS_REMOTE_WRITE);
> -		} else if (!(devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)) {
> -			need_dma_mr = 1;
> -			dma_mr_acc = IB_ACCESS_LOCAL_WRITE;
> -		} else
> -			need_dma_mr = 0;
> -		break;
> -	case RDMA_TRANSPORT_IB:
> -		if (!(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG)) {
> -			need_dma_mr = 1;
> -			dma_mr_acc = IB_ACCESS_LOCAL_WRITE;
> -		} else if (!(devattr.device_cap_flags &
> -			     IB_DEVICE_LOCAL_DMA_LKEY)) {
> -			need_dma_mr = 1;
> -			dma_mr_acc = IB_ACCESS_LOCAL_WRITE;
> -		} else
> -			need_dma_mr = 0;
> -		break;
> -	default:
> +	if (!rdma_tech_iwarp(newxprt->sc_cm_id->device,
> +			     newxprt->sc_cm_id->port_num) &&
> +	    !rdma_ib_or_iboe(newxprt->sc_cm_id->device,
> +			     newxprt->sc_cm_id->port_num))
>  		goto errout;
> +
> +	if (!(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG) ||
> +	    !(devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)) {
> +		need_dma_mr = 1;
> +		dma_mr_acc = IB_ACCESS_LOCAL_WRITE;
> +		if (rdma_tech_iwarp(newxprt->sc_cm_id->device,
> +				    newxprt->sc_cm_id->port_num) &&
> +		    !(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG))
> +			dma_mr_acc |= IB_ACCESS_REMOTE_WRITE;
>  	}
>  
> +	if (rdma_tech_iwarp(newxprt->sc_cm_id->device,
> +			    newxprt->sc_cm_id->port_num))
> +		newxprt->sc_dev_caps |= SVCRDMA_DEVCAP_READ_W_INV;
> +
>  	/* Create the DMA MR if needed, otherwise, use the DMA LKEY */
>  	if (need_dma_mr) {
>  		/* Register all of physical memory */
> -- 
> 2.1.0
