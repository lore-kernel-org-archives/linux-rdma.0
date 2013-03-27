From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: Add missing newline to end of log message
Date: Wed, 27 Mar 2013 08:43:24 -0400
Message-ID: <5152E96C.6090002@dev.mellanox.co.il>
References: <1364321798.878.19.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364321798.878.19.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/26/2013 2:16 PM, Albert Chu wrote:
> Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---
>  opensm/osm_helper.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
> index 219554a..95462a7 100644
> --- a/opensm/osm_helper.c
> +++ b/opensm/osm_helper.c
> @@ -2848,6 +2848,7 @@ static void osm_dump_smp_dr_path_to_buf(IN const ib_smp_t * p_smp,
>  		n += snprintf(buf + n, buf_size - n, ", Return path  = ");
>  		n += sprint_uint8_arr(buf + n, buf_size - n,
>  				      p_smp->return_path, p_smp->hop_count + 1);
> +		n += sprintf(buf + n, "\n");

I'm missing why that's needed. Isn't it currently taken care of by the
callers to this routine ?

-- Hal

>  	}
>  }
>  

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
