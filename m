From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH infiniband-diags] saquery.c: Return proper status from
 query_sa_cpi on bad result status
Date: Sat, 8 Nov 2014 14:51:57 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CBA7D93@CRSMSX101.amr.corp.intel.com>
References: <545A86ED.9060803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545A86ED.9060803-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Wednesday, November 05, 2014 12:22 PM
> To: Weiny, Ira
> Cc: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org); Dan Ben-Yosef
> Subject: [PATCH infiniband-diags] saquery.c: Return proper status from
> query_sa_cpi on bad result status
> 
> 
> When result status was other than IB_SA_MAD_STATUS_SUCCESS,
> 0 was being returned rather than EIO as intended.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira


> ---
> diff --git a/src/saquery.c b/src/saquery.c index 0f39064..1af3401 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -1445,7 +1445,7 @@ static int query_sa_cpi(struct sa_handle *h, struct
> query_params *query_params)
>  	memcpy(&query_params->cpi, cpi, sizeof(query_params->cpi));
>  Exit:
>  	sa_free_result_mad(&result);
> -	return (0);
> +	return ret;
>  }
> 
>  static const struct query_cmd query_cmds[] = {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
