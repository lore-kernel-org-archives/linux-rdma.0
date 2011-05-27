From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/saquery.c: Fix SA_ERR_UNKNOWN define
Date: Fri, 27 May 2011 16:10:20 -0700
Message-ID: <20110527161020.6763e021.weiny2@llnl.gov>
References: <4DDFE4C5.6070004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DDFE4C5.6070004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 27 May 2011 10:52:05 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/saquery.c b/src/saquery.c
> index 515df52..7933fec 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -123,9 +123,9 @@ int requested_lid_flag = 0;
>  uint64_t requested_guid = 0;
>  int requested_guid_flag = 0;
>  
> -#define SA_ERR_UNKNOWN IB_SA_MAD_STATUS_PRIO_SUGGESTED
> +#define ARR_SIZE(a) (sizeof(a)/sizeof((a)[0]))
>  
> -const char *ib_sa_error_str[] = {
> +static const char *ib_sa_error_str[] = {
>  	"SA_NO_ERROR",
>  	"SA_ERR_NO_RESOURCES",
>  	"SA_ERR_REQ_INVALID",
> @@ -138,6 +138,8 @@ const char *ib_sa_error_str[] = {
>  	"SA_ERR_UNKNOWN"
>  };
>  
> +#define SA_ERR_UNKNOWN (ARR_SIZE(ib_sa_error_str) - 1)
> +
>  static inline const char *ib_sa_err_str(IN uint8_t status)
>  {
>  	if (status > SA_ERR_UNKNOWN)


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
