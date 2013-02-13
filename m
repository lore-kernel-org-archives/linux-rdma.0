From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH][TRIVIAL] infiniband-diags/saquery.c: Display NodeRecord
 LID in decimal
Date: Wed, 13 Feb 2013 14:26:21 -0800
Message-ID: <20130213142621.831efea895d1f368bf374a16@llnl.gov>
References: <50F06917.3080706@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50F06917.3080706-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 11 Jan 2013 14:33:43 -0500
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> rather than hex
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied,
Ira

> ---
> diff --git a/src/saquery.c b/src/saquery.c
> index bdf5e9a..2c5b465 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -146,7 +146,7 @@ static void dump_node_record(void *data)
>  	ib_node_info_t *ni = &nr->node_info;
>  
>  	printf("NodeRecord dump:\n"
> -	       "\t\tlid.....................0x%X\n"
> +	       "\t\tlid.....................%u\n"
>  	       "\t\treserved................0x%X\n"
>  	       "\t\tbase_version............0x%X\n"
>  	       "\t\tclass_version...........0x%X\n"
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
