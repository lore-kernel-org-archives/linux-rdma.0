From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] ibstat.c: If port is 1x SDR, rate is 2.5 rather than 2 Gbps
Date: Wed, 8 Feb 2017 15:25:06 -0500
Message-ID: <20170208202505.GA26726@phlsvsds.ph.intel.com>
References: <7230ef46-74ff-76cd-4123-f34a75a6d436@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7230ef46-74ff-76cd-4123-f34a75a6d436-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 06, 2017 at 08:03:12AM -0500, Hal Rosenstock wrote:
> From: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Signed-off-by: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Shouldn't this be fixed at a lower level?

I think the problem is that libibumad is masking the information.  AFAICT the
kernel reports "2.5" in sysfs.

I'm concerned that there are probably lots of other places in the software
stack which have this bug because libibumad is masking the rate.

If the value of "2" was at least documented to be special and meant "2.5" I
think this could be an ok patch...

Something like 

else if (port->rate == UMAD_2_5_RATE)
	printf("%sRate: 2.5\n", pre);
else
	printf("%sRate: %d\n", pre, port->rate);

Ira

> ---
> diff --git a/src/ibstat.c b/src/ibstat.c
> index 37f2361..2d980c4 100644
> --- a/src/ibstat.c
> +++ b/src/ibstat.c
> @@ -182,8 +182,10 @@ static int port_dump(umad_port_t * port, int alone)
>  	       7 ? port_phy_state_str[port->phys_state] : "???");
>  	if (is_fdr10(port))
>  		printf("%sRate: %d (FDR10)\n", pre, port->rate);
> -	else
> +	else if (port->rate != 2)	/* 1x SDR */
>  		printf("%sRate: %d\n", pre, port->rate);
> +	else
> +		printf("%sRate: 2.5\n", pre);
>  	printf("%sBase lid: %d\n", pre, port->base_lid);
>  	printf("%sLMC: %d\n", pre, port->lmc);
>  	printf("%sSM lid: %d\n", pre, port->sm_lid);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
