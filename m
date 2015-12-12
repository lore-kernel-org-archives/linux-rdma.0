From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] ibsendtrap.c: Eliminate unused parameter from send_trap
Date: Sat, 12 Dec 2015 11:34:47 -0500
Message-ID: <20151212163447.GL7855@phlsvsds.ph.intel.com>
References: <5641D3BB.4090003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5641D3BB.4090003-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 01:23:39PM +0200, Hal Rosenstock wrote:
> 
> src/ibsendtrap.c: In function ?send_trap?:
> src/ibsendtrap.c:124: warning: unused parameter ?name?
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/ibsendtrap.c b/src/ibsendtrap.c
> index 46fd6e7..659f2d2 100644
> --- a/src/ibsendtrap.c
> +++ b/src/ibsendtrap.c
> @@ -121,8 +121,7 @@ static void build_trap129(ib_mad_notice_attr_t * n, ib_portid_t * port)
>  	n->data_details.ntc_129_131.port_num = (uint8_t) error_port;
>  }
>  
> -static int send_trap(const char *name,
> -		     void (*build) (ib_mad_notice_attr_t *, ib_portid_t *))
> +static int send_trap(void (*build) (ib_mad_notice_attr_t *, ib_portid_t *))
>  {
>  	ib_portid_t sm_port;
>  	ib_portid_t selfportid;
> @@ -169,7 +168,7 @@ int process_send_trap(char *trap_name)
>  
>  	for (i = 0; traps[i].trap_name; i++)
>  		if (strcmp(traps[i].trap_name, trap_name) == 0)
> -			return send_trap(trap_name, traps[i].build_func);
> +			return send_trap(traps[i].build_func);
>  	ibdiag_show_usage();
>  	return 1;
>  }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
