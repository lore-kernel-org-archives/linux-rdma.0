From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 18/19] IB/mad: Implement Intel Omni-Path Architecture
 SMP processing
Date: Fri, 3 Apr 2015 23:47:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FBD742@ORSMSX109.amr.corp.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
 <1423092585-26692-19-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423092585-26692-19-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -236,6 +252,24 @@ enum smi_action smi_handle_dr_smp_recv(struct ib_smp
> *smp, u8 node_type,
>  					smp->dr_slid == IB_LID_PERMISSIVE);
>  }
> 
> +/*
> + * Adjust information for a received SMP
> + * Return 0 if the SMP should be dropped

The function returns an enum.  The comment of returning 0 is misleading.  The entire comment seems unnecessary. 

> + */
> +enum smi_action opa_smi_handle_dr_smp_recv(struct opa_smp *smp, u8
> node_type,
> +					   int port_num, int phys_port_cnt)
> +{
> +	return __smi_handle_dr_smp_recv(node_type, port_num, phys_port_cnt,
> +					&smp->hop_ptr, smp->hop_cnt,
> +					smp->route.dr.initial_path,
> +					smp->route.dr.return_path,
> +					opa_get_smp_direction(smp),
> +					smp->route.dr.dr_dlid ==
> +					OPA_LID_PERMISSIVE,
> +					smp->route.dr.dr_slid ==
> +					OPA_LID_PERMISSIVE);
> +}
> +
>  static inline
>  enum smi_forward_action __smi_check_forward_dr_smp(u8 hop_ptr, u8
> hop_cnt,
>  						   u8 direction,
> @@ -277,6 +311,16 @@ enum smi_forward_action
> smi_check_forward_dr_smp(struct ib_smp *smp)
>  					  smp->dr_slid != IB_LID_PERMISSIVE);
>  }
> 
> +enum smi_forward_action opa_smi_check_forward_dr_smp(struct opa_smp *smp)
> +{
> +	return __smi_check_forward_dr_smp(smp->hop_ptr, smp->hop_cnt,
> +					  opa_get_smp_direction(smp),
> +					  smp->route.dr.dr_dlid ==
> +					  OPA_LID_PERMISSIVE,
> +					  smp->route.dr.dr_slid ==
> +					  OPA_LID_PERMISSIVE);
> +}
> +
>  /*
>   * Return the forwarding port number from initial_path for outgoing SMP
> and
>   * from return_path for returning SMP
> @@ -286,3 +330,13 @@ int smi_get_fwd_port(struct ib_smp *smp)
>  	return (!ib_get_smp_direction(smp) ? smp->initial_path[smp-
> >hop_ptr+1] :
>  		smp->return_path[smp->hop_ptr-1]);
>  }
> +
> +/*
> + * Return the forwarding port number from initial_path for outgoing SMP
> and
> + * from return_path for returning SMP
> + */
> +int opa_smi_get_fwd_port(struct opa_smp *smp)
> +{
> +	return !opa_get_smp_direction(smp) ? smp->route.dr.initial_path[smp-
> >hop_ptr+1] :
> +		smp->route.dr.return_path[smp->hop_ptr-1];
> +}
> diff --git a/drivers/infiniband/core/smi.h b/drivers/infiniband/core/smi.h
> index aff96ba..e95c537 100644
> --- a/drivers/infiniband/core/smi.h
> +++ b/drivers/infiniband/core/smi.h
> @@ -62,6 +62,9 @@ extern enum smi_action smi_handle_dr_smp_send(struct
> ib_smp *smp,
>   * Return IB_SMI_HANDLE if the SMP should be handled by the local SMA/SM
>   * via process_mad
>   */
> +/* NOTE: This is called on opa_smp's don't check fields which are not
> common
> + * between ib_smp and opa_smp
> + */

This comment suggests that the function is not correct for OPA.  ?

>  static inline enum smi_action smi_check_local_smp(struct ib_smp *smp,
>  						  struct ib_device *device)
>  {
> @@ -77,6 +80,9 @@ static inline enum smi_action smi_check_local_smp(struct
> ib_smp *smp,
>   * Return IB_SMI_HANDLE if the SMP should be handled by the local SMA/SM
>   * via process_mad
>   */
> +/* NOTE: This is called on opa_smp's don't check fields which are not
> common
> + * between ib_smp and opa_smp
> + */

Same comment

>  static inline enum smi_action smi_check_local_returning_smp(struct ib_smp
> *smp,
>  						   struct ib_device *device)
>  {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
