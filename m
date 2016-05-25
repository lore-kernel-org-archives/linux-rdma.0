From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V6 for-next 1/4] IB/core: Introduce capabilitymask2 field
 in ClassPortInfo mad
Date: Wed, 25 May 2016 07:06:18 -0400
Message-ID: <ea04e299-ba87-ad6c-77ae-5abc46cd6ea5@dev.mellanox.co.il>
References: <1464165622-1540-1-git-send-email-erezsh@mellanox.com>
 <1464165622-1540-2-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464165622-1540-2-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/25/2016 4:40 AM, Erez Shitrit wrote:
> Change struct ib_class_port_info to conform to IB Spec 1.3
> That in order to get specific capability mask from ClassPortInfo mad.
> 
>>From the IB Spec, ClassPortInfo section:
>         "CapabilityMask2 Bits 0-26: Additional class-specific capabilities...
>          RespTimeValue the rest 5 bits"
> 
> The new struct now has one field for capabilitymask2 (previously was the
> reserved field) and the resp_time field.
> 
> And it fixes up qib and srpt, use of the field repurposed to be used as
> capabilitymask2:
> IB/qib: Change pma_get_classportinfo
> IB/srpt: Adjust the use of ib_class_port_info
> 
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/qib/qib_mad.c   |  6 ++--
>  drivers/infiniband/ulp/srpt/ib_srpt.c |  2 +-
>  include/rdma/ib_mad.h                 | 58 +++++++++++++++++++++++++++++++++--
>  3 files changed, 61 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
> index 0bd1837..d2ac298 100644
> --- a/drivers/infiniband/hw/qib/qib_mad.c
> +++ b/drivers/infiniband/hw/qib/qib_mad.c
> @@ -1172,11 +1172,13 @@ static int pma_get_classportinfo(struct ib_pma_mad *pmp,
>  	 * Set the most significant bit of CM2 to indicate support for
>  	 * congestion statistics
>  	 */
> -	p->reserved[0] = dd->psxmitwait_supported << 7;
> +	ib_set_cpi_capmask2(p,
> +			    dd->psxmitwait_supported <<
> +			    (31 - IB_CLASS_PORT_INFO_RESP_TIME_FIELD_SIZE));
>  	/*
>  	 * Expected response time is 4.096 usec. * 2^18 == 1.073741824 sec.
>  	 */
> -	p->resp_time_value = 18;
> +	ib_set_cpi_resp_time(p, 18);
>  
>  	return reply((struct ib_smp *) pmp);
>  }
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 2843f1a..887ebad 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -254,8 +254,8 @@ static void srpt_get_class_port_info(struct ib_dm_mad *mad)
>  	memset(cif, 0, sizeof(*cif));
>  	cif->base_version = 1;
>  	cif->class_version = 1;
> -	cif->resp_time_value = 20;
>  
> +	ib_set_cpi_resp_time(cif, 20);
>  	mad->mad_hdr.status = 0;
>  }
>  
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index 37dd534c..3f3ae04 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -239,12 +239,15 @@ struct ib_vendor_mad {
>  
>  #define IB_MGMT_CLASSPORTINFO_ATTR_ID	cpu_to_be16(0x0001)
>  
> +#define IB_CLASS_PORT_INFO_RESP_TIME_MASK	0x1F
> +#define IB_CLASS_PORT_INFO_RESP_TIME_FIELD_SIZE 5
> +
>  struct ib_class_port_info {
>  	u8			base_version;
>  	u8			class_version;
>  	__be16			capability_mask;
> -	u8			reserved[3];
> -	u8			resp_time_value;
> +	  /* 27 bits for cap_mask2, 5 bits for resp_time */
> +	__be32			cap_mask2_resp_time;
>  	u8			redirect_gid[16];
>  	__be32			redirect_tcslfl;
>  	__be16			redirect_lid;
> @@ -259,6 +262,57 @@ struct ib_class_port_info {
>  	__be32			trap_qkey;
>  };
>  
> +/**
> + * ib_get_cpi_resp_time - Returns the resp_time value from
> + * cap_mask2_resp_time in ib_class_port_info.
> + * @cpi: A struct ib_class_port_info mad.
> + */
> +static inline u8 ib_get_cpi_resp_time(struct ib_class_port_info *cpi)
> +{
> +	return (u8)(be32_to_cpu(cpi->cap_mask2_resp_time) &
> +		    IB_CLASS_PORT_INFO_RESP_TIME_MASK);
> +}
> +
> +/**
> + * ib_set_cpi_resptime - Sets the response time in an

ib_set_cpi_resp_time

> + * ib_class_port_info mad.
> + * @cpi: A struct ib_class_port_info.
> + * @rtime: The response time to set.
> + */
> +static inline void ib_set_cpi_resp_time(struct ib_class_port_info *cpi,
> +					u8 rtime)
> +{
> +	cpi->cap_mask2_resp_time =
> +		(cpi->cap_mask2_resp_time &
> +		 cpu_to_be32(~IB_CLASS_PORT_INFO_RESP_TIME_MASK)) |
> +		cpu_to_be32(rtime & IB_CLASS_PORT_INFO_RESP_TIME_MASK);
> +}
> +
> +/**
> + * ib_get_cpi_capmask2 - Returns the capmask2 value from
> + * cap_mask2_resp_time in ib_class_port_info.
> + * @cpi: A struct ib_class_port_info mad.
> + */
> +static inline u32 ib_get_cpi_capmask2(struct ib_class_port_info *cpi)
> +{
> +	return (be32_to_cpu(cpi->cap_mask2_resp_time) >> 5);

Why not now use IB_CLASS_PORT_INFO_RESP_TIME_FIELD_SIZE rather than 5 ?

> +}
> +
> +/**
> + * ib_set_cpi_capmask2 - Sets the capmask2 in an
> + * ib_class_port_info mad.
> + * @cpi: A struct ib_class_port_info.
> + * @capmask2: The capmask2 to set.
> + */
> +static inline void ib_set_cpi_capmask2(struct ib_class_port_info *cpi,
> +				       u32 capmask2)
> +{
> +	cpi->cap_mask2_resp_time =
> +		(cpi->cap_mask2_resp_time &
> +		 cpu_to_be32(IB_CLASS_PORT_INFO_RESP_TIME_MASK)) |
> +		cpu_to_be32(capmask2 << 5);

Same comment as above.

> +}
> +
>  struct ib_mad_notice_attr {
>  	u8 generic_type;
>  	u8 prod_type_msb;
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
