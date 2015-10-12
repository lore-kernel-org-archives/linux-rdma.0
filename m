From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH TRIVIAL infiniband-diags] ibdiag_common.c: Move static to beginning of get_build_version declaration
Date: Mon, 12 Oct 2015 19:18:14 -0400
Message-ID: <20151012231813.GA6211@phlsvsds.ph.intel.com>
References: <561BA81B.9040902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <561BA81B.9040902-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2015 at 08:31:23AM -0400, Hal Rosenstock wrote:
> 
> Eliminate compiler warning:
> src/ibdiag_common.c:85: warning: ?static? is not at beginning of declaration
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> index e09623d..5424845 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -82,7 +82,7 @@ static const char **prog_examples;
>  static struct option *long_opts = NULL;
>  static const struct ibdiag_opt *opts_map[256];
>  
> -const static char *get_build_version(void)
> +static const char *get_build_version(void)
>  {
>  	return "BUILD VERSION: " IBDIAG_VERSION " Build date: " __DATE__ " "
>  	    __TIME__;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
