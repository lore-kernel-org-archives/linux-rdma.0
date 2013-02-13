From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/saquery.c: Add support for ServiceID
 in PathRecord querying
Date: Wed, 13 Feb 2013 14:23:37 -0800
Message-ID: <20130213142337.9ae926aaa3bb037eeb194443@llnl.gov>
References: <511B95BD.4020309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511B95BD.4020309-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We should update the man page for saquery to reflect this change in the same patch.

Thanks,
Ira

On Wed, 13 Feb 2013 08:31:41 -0500
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> diff --git a/src/saquery.c b/src/saquery.c
> index bdf5e9a..1994cf9 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -59,7 +59,13 @@
>  
>  #include "ibdiag_common.h"
>  
> +#ifndef IB_PR_COMPMASK_SERVICEID
> +#define IB_PR_COMPMASK_SERVICEID (IB_PR_COMPMASK_SERVICEID_MSB | \
> +				  IB_PR_COMPMASK_SERVICEID_LSB)
> +#endif
> +
>  struct query_params {
> +	uint64_t service_id;
>  	ib_gid_t sgid, dgid, gid, mgid;
>  	uint16_t slid, dlid, mlid;
>  	uint32_t flow_label;
> @@ -959,6 +965,7 @@ static int query_path_records(const struct query_cmd *q, bind_handle_t h,
>  	uint8_t reversible = 0;
>  
>  	memset(&pr, 0, sizeof(pr));
> +	CHECK_AND_SET_VAL(p->service_id, 64, 0, pr.service_id, PR, SERVICEID);
>  	CHECK_AND_SET_GID(p->sgid, pr.sgid, PR, SGID);
>  	CHECK_AND_SET_GID(p->dgid, pr.dgid, PR, DGID);
>  	CHECK_AND_SET_VAL(p->slid, 16, 0, pr.slid, PR, SLID);
> @@ -1518,6 +1525,9 @@ static int process_opt(void *context, int ch, char *optarg)
>  	case 'X':
>  		p->proxy_join = strtoul(optarg, NULL, 0);
>  		break;
> +	case 22:
> +		p->service_id = strtoull(optarg, NULL, 0);
> +		break;
>  	default:
>  		return -1;
>  	}
> @@ -1596,6 +1606,7 @@ int main(int argc, char **argv)
>  		{"hop_limit", 'H', 1, NULL,
>  		 "Hop limit (PathRecord, MCMemberRecord)"},
>  		{"scope", 21, 1, NULL, "Scope (MCMemberRecord)"},
> +		{"service_id", 22, 1, NULL, "ServiceID (PathRecord)"},
>  		{"join_state", 'J', 1, NULL, "Join state (MCMemberRecord)"},
>  		{"proxy_join", 'X', 1, NULL, "Proxy join (MCMemberRecord)"},
>  		{0}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
