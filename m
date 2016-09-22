From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] IB/mad: Eliminate redundant SM class version defines for OPA
Date: Thu, 22 Sep 2016 13:41:45 -0400
Message-ID: <20160922174144.GA30349@phlsvsds.ph.intel.com>
References: <4810d736-b0c3-bf73-70c1-975b4af850a3@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4810d736-b0c3-bf73-70c1-975b4af850a3-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 21, 2016 at 10:41:57AM -0400, Hal Rosenstock wrote:
> 
> and rename class version define to SM rather than SMP or SMI
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Seems like a good clean up.  I did some minor testing as well.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 2d49228..17ba07d 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -769,7 +769,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
>  	 * If we are at the start of the LID routed part, don't update the
>  	 * hop_ptr or hop_cnt.  See section 14.2.2, Vol 1 IB spec.
>  	 */
> -	if (opa && smp->class_version == OPA_SMP_CLASS_VERSION) {
> +	if (opa && smp->class_version == OPA_SM_CLASS_VERSION) {
>  		u32 opa_drslid;
>  
>  		if ((opa_get_smp_direction(opa_smp)
> @@ -2167,7 +2167,7 @@ handle_smi(struct ib_mad_port_private *port_priv,
>  	struct ib_mad_hdr *mad_hdr = (struct ib_mad_hdr *)recv->mad;
>  
>  	if (opa && mad_hdr->base_version == OPA_MGMT_BASE_VERSION &&
> -	    mad_hdr->class_version == OPA_SMI_CLASS_VERSION)
> +	    mad_hdr->class_version == OPA_SM_CLASS_VERSION)
>  		return handle_opa_smi(port_priv, qp_info, wc, port_num, recv,
>  				      response);
>  
> diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
> index 7ffc14f..484ed60 100644
> --- a/drivers/infiniband/hw/hfi1/mad.c
> +++ b/drivers/infiniband/hw/hfi1/mad.c
> @@ -128,7 +128,7 @@ static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned len)
>  	smp = send_buf->mad;
>  	smp->base_version = OPA_MGMT_BASE_VERSION;
>  	smp->mgmt_class = IB_MGMT_CLASS_SUBN_LID_ROUTED;
> -	smp->class_version = OPA_SMI_CLASS_VERSION;
> +	smp->class_version = OPA_SM_CLASS_VERSION;
>  	smp->method = IB_MGMT_METHOD_TRAP;
>  	ibp->rvp.tid++;
>  	smp->tid = cpu_to_be64(ibp->rvp.tid);
> @@ -343,7 +343,7 @@ static int __subn_get_opa_nodeinfo(struct opa_smp *smp, u32 am, u8 *data,
>  
>  	ni->port_guid = cpu_to_be64(dd->pport[pidx].guid);
>  	ni->base_version = OPA_MGMT_BASE_VERSION;
> -	ni->class_version = OPA_SMI_CLASS_VERSION;
> +	ni->class_version = OPA_SM_CLASS_VERSION;
>  	ni->node_type = 1;     /* channel adapter */
>  	ni->num_ports = ibdev->phys_port_cnt;
>  	/* This is already in network order */
> @@ -379,7 +379,7 @@ static int subn_get_nodeinfo(struct ib_smp *smp, struct ib_device *ibdev,
>  		nip->port_guid = cpu_to_be64(dd->pport[pidx].guid);
>  
>  	nip->base_version = OPA_MGMT_BASE_VERSION;
> -	nip->class_version = OPA_SMI_CLASS_VERSION;
> +	nip->class_version = OPA_SM_CLASS_VERSION;
>  	nip->node_type = 1;     /* channel adapter */
>  	nip->num_ports = ibdev->phys_port_cnt;
>  	/* This is already in network order */
> @@ -2309,7 +2309,7 @@ static int pma_get_opa_classportinfo(struct opa_pma_mad *pmp,
>  		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
>  
>  	p->base_version = OPA_MGMT_BASE_VERSION;
> -	p->class_version = OPA_SMI_CLASS_VERSION;
> +	p->class_version = OPA_SM_CLASS_VERSION;
>  	/*
>  	 * Expected response time is 4.096 usec. * 2^18 == 1.073741824 sec.
>  	 */
> @@ -4029,7 +4029,7 @@ static int process_subn_opa(struct ib_device *ibdev, int mad_flags,
>  
>  	am = be32_to_cpu(smp->attr_mod);
>  	attr_id = smp->attr_id;
> -	if (smp->class_version != OPA_SMI_CLASS_VERSION) {
> +	if (smp->class_version != OPA_SM_CLASS_VERSION) {
>  		smp->status |= IB_SMP_UNSUP_VERSION;
>  		ret = reply((struct ib_mad_hdr *)smp);
>  		return ret;
> @@ -4239,7 +4239,7 @@ static int process_perf_opa(struct ib_device *ibdev, u8 port,
>  
>  	*out_mad = *in_mad;
>  
> -	if (pmp->mad_hdr.class_version != OPA_SMI_CLASS_VERSION) {
> +	if (pmp->mad_hdr.class_version != OPA_SM_CLASS_VERSION) {
>  		pmp->mad_hdr.status |= IB_SMP_UNSUP_VERSION;
>  		return reply((struct ib_mad_hdr *)pmp);
>  	}
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index c8a773f..981214b 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -46,7 +46,7 @@
>  #define IB_MGMT_BASE_VERSION			1
>  #define OPA_MGMT_BASE_VERSION			0x80
>  
> -#define OPA_SMP_CLASS_VERSION			0x80
> +#define OPA_SM_CLASS_VERSION			0x80
>  
>  /* Management classes */
>  #define IB_MGMT_CLASS_SUBN_LID_ROUTED		0x01
> diff --git a/include/rdma/opa_smi.h b/include/rdma/opa_smi.h
> index 4a529ef..f789611 100644
> --- a/include/rdma/opa_smi.h
> +++ b/include/rdma/opa_smi.h
> @@ -44,8 +44,6 @@
>  #define OPA_MAX_SLS				32
>  #define OPA_MAX_SCS				32
>  
> -#define OPA_SMI_CLASS_VERSION			0x80
> -
>  #define OPA_LID_PERMISSIVE			cpu_to_be32(0xFFFFFFFF)
>  
>  struct opa_smp {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
