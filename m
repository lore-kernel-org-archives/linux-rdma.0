From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH TRIVIAL infiniband-diags] ibdiag_common.c: Fix cosmetic formatting issue
Date: Thu, 27 Apr 2017 17:27:06 -0400
Message-ID: <20170427212705.GA31202@phlsvsds.ph.intel.com>
References: <5c06ade8-c86d-b59c-0ee5-c8309af69676@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5c06ade8-c86d-b59c-0ee5-c8309af69676-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 27, 2017 at 12:56:47PM -0400, Hal Rosenstock wrote:
> 
> Change leading spaces into a tab
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
>  src/ibdiag_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> index cbade5b..1f91269 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -850,7 +850,7 @@ int vsnprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
>  	int len, i, ret;
>  
>  	len = strlen(mad_field_name(f));
> -        if (len + 2 > n || spacing + 1 > n)
> +	if (len + 2 > n || spacing + 1 > n)
>  		return 0;
>  
>  	strncpy(buf, mad_field_name(f), n);
> -- 
> 2.8.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
