From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] ibacm: check for special handling of loopback
 requests
Date: Tue, 16 Nov 2010 16:31:13 -0800
Message-ID: <1289953873.2365.179.camel@chromite.mv.qlogic.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168B9@orsmsx501.amr.corp.intel.com>
	 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168CE@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168CE-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-11-16 at 16:15 -0800, Hefty, Sean wrote:
...
> @@ -2620,6 +2663,12 @@ static void acm_set_options(void)
>  	}
>  
>  	fclose(f);
> +
> +	if (!(f = fopen("/sys/module/mlx4_core/parameters/block_loopback", "r")))
> +		return;
> +
> +	fscanf(f, "%d", &loopback_prot);
> +	fclose(f);
>  }
>  
>  static void acm_log_options(void)

This seems to introduce an HCA specific dependency.
Isn't ibacm supposed to work with different HCAs?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
