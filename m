From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 04/12] IB/core: add a helper to check for READ WITH
 INVALIDATE support
Date: Mon, 18 Apr 2016 23:15:07 -0400
Message-ID: <20160419031506.GC27515@rhel.amr.corp.intel.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460410360-13104-5-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dledford@redhat.com, bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 11, 2016 at 02:32:32PM -0700, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Steve Wise <swise@opengridcomputing.com>
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  include/rdma/ib_verbs.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 24d0d82..9e8616a 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -2318,6 +2318,18 @@ static inline bool rdma_cap_roce_gid_table(const struct ib_device *device,
>  		device->add_gid && device->del_gid;
>  }
>  
> +/*
> + * Check if the device supports READ W/ INVALIDATE.
> + */
> +static inline bool rdma_cap_read_inv(struct ib_device *dev, u32 port_num)
> +{
> +	/*
> +	 * iWarp drivers must support READ W/ INVALIDATE.  No other protocol
> +	 * has support for it yet.
> +	 */
> +	return rdma_protocol_iwarp(dev, port_num);
> +}
> +
>  int ib_query_gid(struct ib_device *device,
>  		 u8 port_num, int index, union ib_gid *gid,
>  		 struct ib_gid_attr *attr);
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
