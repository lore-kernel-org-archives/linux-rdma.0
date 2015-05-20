From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 06/14] IB/mad: Add helper function for
 smi_check_forward_dr_smp
Date: Wed, 20 May 2015 17:32:01 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FDDAA6@ORSMSX109.amr.corp.intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
 <1432109615-19564-7-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-7-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/smi.c b/drivers/infiniband/core/smi.c
> index b09fa1dec865..4969ce3338fb 100644
> --- a/drivers/infiniband/core/smi.c
> +++ b/drivers/infiniband/core/smi.c
> @@ -236,21 +236,20 @@ enum smi_action smi_handle_dr_smp_recv(struct ib_smp
> *smp, u8 node_type,
>  					smp->dr_slid == IB_LID_PERMISSIVE);
>  }
> 
> -enum smi_forward_action smi_check_forward_dr_smp(struct ib_smp *smp)
> +static inline
> +enum smi_forward_action __smi_check_forward_dr_smp(u8 hop_ptr, u8
> hop_cnt,
> +						   u8 direction,
> +						   int dr_dlid_is_permissive,
> +						   int dr_slid_is_permissive)

snip

> +enum smi_forward_action smi_check_forward_dr_smp(struct ib_smp *smp)
> +{
> +	return __smi_check_forward_dr_smp(smp->hop_ptr, smp->hop_cnt,
> +					  ib_get_smp_direction(smp),
> +					  smp->dr_dlid == IB_LID_PERMISSIVE,
> +					  smp->dr_slid != IB_LID_PERMISSIVE);

The dr_slid check looks backwards.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
