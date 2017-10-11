From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 17/47] IB/hfi1: Remove set-but-not-used variables
Date: Wed, 11 Oct 2017 09:45:47 -0400
Message-ID: <9444fa36-3433-9d71-a54e-699c21e82586@intel.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-18-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-18-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/6/2017 5:33 PM, Bart Van Assche wrote:
> diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
> index f57d893df3e0..29da75d89a7c 100644
> --- a/drivers/infiniband/hw/hfi1/mad.c
> +++ b/drivers/infiniband/hw/hfi1/mad.c
> @@ -2889,7 +2889,6 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
>   	struct _vls_dctrs *vlinfo;
>   	size_t response_data_size;
>   	u32 num_ports;
> -	u8 num_pslm;
>   	u8 lq, num_vls;
>   	u8 res_lli, res_ler;
>   	u64 port_mask;
> @@ -2899,7 +2898,6 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
>   	int vfi;
>   
>   	num_ports = be32_to_cpu(pmp->mad_hdr.attr_mod) >> 24;
> -	num_pslm = hweight64(be64_to_cpu(req->port_select_mask[3]));

I need to figure out why we don't check num_pslm here like we do in 
every other instance. This may be a bug. I'm fine removing this for now, 
since it clearly doesn't hurt, and we will add it back later with the 
check if needed.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
