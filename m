From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ibsim: fix size of slid/dlid fields in sim_request
 structure
Date: Tue, 9 Aug 2011 18:07:23 +0300
Message-ID: <20110809150723.GC2056@calypso.mtl.com>
References: <E1QpTpl-00026F-D6@rvml.edm.orcorp.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E1QpTpl-00026F-D6-nLM+XIojDeH72zTlGHhC+rDks+cytr/Z@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Rolf,

On 17:29 Fri 05 Aug     , Rolf Manderscheid wrote:
> 
> The code treats them as 16-bit fields (by using htons), make
> the structure match.  This also avoids the 32 bits of padding
> before the length field.
> 

There are more places where lids defined as integer. Why did you choose to
change only these two?

> Signed-off-by: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  include/ibsim.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/ibsim.h b/include/ibsim.h
> index 15fc37c..b6b08bd 100644
> --- a/include/ibsim.h
> +++ b/include/ibsim.h
> @@ -62,8 +62,8 @@ struct sim_port {
>  #define SIM_CTL_MAX_DATA	64
>  
>  struct sim_request {
> -	uint32_t dlid;
> -	uint32_t slid;
> +	uint16_t dlid;
> +	uint16_t slid;
>  	uint32_t dqp;
>  	uint32_t sqp;
>  	uint32_t status;
> -- 
> 1.7.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
