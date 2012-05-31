From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH V3.1 8/8] infiniband-diags: Add sa_smkey option to
 config file
Date: Thu, 31 May 2012 15:23:53 -0700
Message-ID: <20120531152353.d0c0fe3b.weiny2@llnl.gov>
References: <1338398497-12444-8-git-send-email-foraker1@llnl.gov>
	<1338416114-14068-1-git-send-email-foraker1@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338416114-14068-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 30 May 2012 15:15:14 -0700
Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org> wrote:

> Defines a default for the smkey used in SA requests
> 
> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>

Thanks, applied.
Ira

> ---
>  etc/ibdiag.conf     |    3 +++
>  src/ibdiag_common.c |    3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/etc/ibdiag.conf b/etc/ibdiag.conf
> index 2a2334f..9686d14 100644
> --- a/etc/ibdiag.conf
> +++ b/etc/ibdiag.conf
> @@ -17,3 +17,6 @@
>  
>  # define a default m_key
>  #m_key=0x00
> +
> +# default smkey to be used for SA requests
> +#sa_key=0x00
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> index eaf504f..ba0ce0b 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -160,6 +160,9 @@ void read_ibdiag_config(const char *file)
>  			}
>  		} else if (strncmp(name, "m_key", strlen("m_key")) == 0) {
>  			ibd_mkey = strtoull(val_str, 0, 0);
> +		} else if (strncmp(name, "sa_key",
> +				   strlen("sa_key")) == 0) {
> +			ibd_sakey = strtoull(val_str, 0, 0);
>  		}
>  	}
>  
> -- 
> 1.7.9.2
> 


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
