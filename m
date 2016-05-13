From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/4] IB/core: Add support for get
 ClassPortInfo from the SA
Date: Thu, 12 May 2016 20:00:18 -0400
Message-ID: <20160513000018.GB16168@rhel.sc.intel.com>
References: <1462194141-8902-1-git-send-email-erezsh@mellanox.com>
 <1462194141-8902-2-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462194141-8902-2-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 02, 2016 at 04:02:18PM +0300, Erez Shitrit wrote:
> 
> Change struct ib_class_port_info to conform to IB Spec 1.3
> That in order to get specific capability mask from ClassPortInfo mad.
> 
> From the IB Spec, ClassPortInfo section:
>         "CapabilityMask2 Bits 0-26: Additional class-specific capabilities...
>          RespTimeValue the rest 5 bits"
> 
> The new struct now has one field that contains both of cap_mask2 (which was
> reserved and resp_time which now is 27 bits for cap_mask2 and 5 bits for
> resp_time in the new field)
> 
> More changes to adjust the new structure:
> IB/qib: Change pma_get_classportinfo
> 
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/qib/qib_mad.c | 4 +++-
>  include/rdma/ib_mad.h               | 2 +-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
> index 0bd1837..c5f6248 100644
> --- a/drivers/infiniband/hw/qib/qib_mad.c
> +++ b/drivers/infiniband/hw/qib/qib_mad.c
> @@ -1158,6 +1158,7 @@ static int pma_get_classportinfo(struct ib_pma_mad *pmp,
>  	struct ib_class_port_info *p =
>  		(struct ib_class_port_info *)pmp->data;
>  	struct qib_devdata *dd = dd_from_ibdev(ibdev);
> +	char *p_cap_mask2;
>  
>  	memset(pmp->data, 0, sizeof(pmp->data));
>  
> @@ -1172,7 +1173,8 @@ static int pma_get_classportinfo(struct ib_pma_mad *pmp,
>  	 * Set the most significant bit of CM2 to indicate support for
>  	 * congestion statistics
>  	 */
> -	p->reserved[0] = dd->psxmitwait_supported << 7;
> +	p_cap_mask2 = (char *)&p->capability_mask2;
> +	p_cap_mask2[0] = dd->psxmitwait_supported << 7;

Why did this change from p_cap_mask2[3] to p_cap_mask2[0]?

I think this supports my concerns that endianess is not correct here.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
