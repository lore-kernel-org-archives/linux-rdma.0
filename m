From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/6] IB/SA: Add OPA path record type
Date: Wed, 19 Apr 2017 10:50:18 -0400
Message-ID: <632589f6-b39b-f8e0-34b5-680170b5c44a@dev.mellanox.co.il>
References: <1492462590-64866-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1492462590-64866-6-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492462590-64866-6-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/17/2017 4:56 PM, Dasaratharaman Chandramouli wrote:
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 7d6c199..38df02f 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1846,6 +1846,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
>  	struct srp_login_rej *rej;
>  	struct ib_cm_rep_param *rep_param;
>  	struct srpt_rdma_ch *ch, *tmp_ch;
> +	union ib_gid *sgid = &param->primary_path->sgid;
>  	__be16 *guid;
>  	u32 it_iu_len;
>  	int i, ret = 0;
> @@ -1992,7 +1993,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
>  		goto destroy_ib;
>  	}
>  
> -	guid = (__be16 *)&param->primary_path->sgid.global.interface_id;
> +	guid = (__be16 *)&sgid->global.interface_id;

Nit: This seems like an unrelated change.

-- Hal

>  	snprintf(ch->ini_guid, sizeof(ch->ini_guid), "%04x:%04x:%04x:%04x",
>  		 be16_to_cpu(guid[0]), be16_to_cpu(guid[1]),
>  		 be16_to_cpu(guid[2]), be16_to_cpu(guid[3]));
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
