From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 8/8] IB/mad: Ensure DR MADs are correctly
 specified when using OPA devices
Date: Mon, 5 Jun 2017 14:06:23 -0600
Message-ID: <20170605200623.GB21236@obsidianresearch.com>
References: <1496686791-51297-1-git-send-email-don.hiatt@intel.com>
 <1496686791-51297-9-git-send-email-don.hiatt@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496686791-51297-9-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 05, 2017 at 02:19:51PM -0400, Don Hiatt wrote:
> Pure DR MADs do not need OPA GIDs to be specified in the GRH since
> they do not rely on LID information.
> 
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>  drivers/infiniband/core/mad.c | 107 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 95 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 192ee3da..3fffd3f8 100644
> +++ b/drivers/infiniband/core/mad.c
> @@ -41,6 +41,7 @@
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <rdma/ib_cache.h>
> +#include <rdma/opa_addr.h>
>  
>  #include "mad_priv.h"
>  #include "mad_rmpp.h"
> @@ -732,6 +733,83 @@ static size_t mad_priv_dma_size(const struct ib_mad_private *mp)
>  	return sizeof(struct ib_grh) + mp->mad_size;
>  }
>  
> +static int verify_mad_ah(struct ib_mad_agent_private *mad_agent_priv,
> +			 struct ib_mad_send_wr_private *mad_send_wr)
> +{
> +	struct ib_device *ib_dev = mad_agent_priv->qp_info->port_priv->device;
> +	u8 port = mad_agent_priv->qp_info->port_priv->port_num;
> +	struct ib_smp *smp = mad_send_wr->send_buf.mad;
> +	struct opa_smp *opa_smp = (struct opa_smp *)smp;
> +	struct rdma_ah_attr attr;
> +	struct ib_global_route *grh;
> +	u32 opa_drslid = be32_to_cpu(opa_smp->route.dr.dr_slid);
> +	u32 opa_drdlid = be32_to_cpu(opa_smp->route.dr.dr_dlid);
> +
> +	bool dr_slid_is_permissive = (OPA_LID_PERMISSIVE ==
> +				      opa_smp->route.dr.dr_slid) ? true : false;
> +	bool dr_dlid_is_permissive = (OPA_LID_PERMISSIVE ==
> +				      opa_smp->route.dr.dr_dlid) ? true : false;
> +	bool drslid_is_ib_ucast = (opa_drslid <
> +				   be16_to_cpu(IB_MULTICAST_LID_BASE)) ?
> +					true : false;
> +	bool drdlid_is_ib_ucast = (opa_drdlid <
> +				   be16_to_cpu(IB_MULTICAST_LID_BASE)) ?
> +					true : false;
> +	bool drslid_is_ext = !drslid_is_ib_ucast && !dr_slid_is_permissive;
> +	bool drdlid_is_ext = !drdlid_is_ib_ucast && !dr_dlid_is_permissive;
> +	bool grh_present = false;
> +	union ib_gid sgid;
> +	int ret = 0;
> +
> +	ret = rdma_query_ah(mad_send_wr->send_buf.ah, &attr);
> +	if (ret)
> +		return ret;
> +	grh_present = (rdma_ah_get_ah_flags(&attr) & IB_AH_GRH) ?
> +			true : false;
> +	if (grh_present) {
> +		grh = rdma_ah_retrieve_grh(&attr);
> +		ret = ib_query_gid(ib_dev, port, grh->sgid_index,
> +				   &sgid, NULL);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (smp->class_version == OPA_SM_CLASS_VERSION) {

Why check for class_version here if this entire function is only ever
called for OPA?

> +		 * Conditions when GRH info should not be specified
> +		 * 1. both dr_slid and dr_dlid are permissve (Pure DR)
> +		 * 2. both dr_slid and dr_dlid are less than 0xc000.
> +		 *
> +		 * Conditions when GRH info should be specified
> +		 * 1. dr_dlid is not permissive and above 0xbfff
> +		 * OR
> +		 * 2. dr_slid is not permissive and above 0xbfff
> +		 */

Shouldn't this sort of stuff be in the lower layer that forms the
wire headers from the AH? The entire point of making the 32 bit lids
explicit everywhere was to take this sort of stuff out of the common
code.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
