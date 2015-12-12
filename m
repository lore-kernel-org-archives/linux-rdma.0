From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] ibportstate.c: Fix unsigned comparison warnings
Date: Sat, 12 Dec 2015 11:34:32 -0500
Message-ID: <20151212163432.GK7855@phlsvsds.ph.intel.com>
References: <5641D395.9050208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5641D395.9050208-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 01:23:01PM +0200, Hal Rosenstock wrote:
> 
> src/ibportstate.c:450: warning: comparison of unsigned expression < 0 is always false
> src/ibportstate.c:454: warning: comparison of unsigned expression < 0 is always false
> src/ibportstate.c:458: warning: comparison of unsigned expression < 0 is always false
> src/ibportstate.c:462: warning: comparison of unsigned expression < 0 is always false
> src/ibportstate.c:483: warning: comparison of unsigned expression < 0 is always false
> src/ibportstate.c:500: warning: comparison of unsigned expression < 0 is always false
> src/ibportstate.c:504: warning: comparison of unsigned expression < 0 is always false
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/ibportstate.c b/src/ibportstate.c
> index 47e9133..cb47aa9 100644
> --- a/src/ibportstate.c
> +++ b/src/ibportstate.c
> @@ -447,40 +447,40 @@ int main(int argc, char **argv)
>  			val = strtoull(argv[i], 0, 0);
>  			switch (j) {
>  			case SPEED:
> -				if (val < 0 || val > 15)
> +				if (val > 15)
>  					IBEXIT("invalid speed value %ld", val);
>  				break;
>  			case ESPEED:
> -				if (val < 0 || val > 31)
> +				if (val > 31)
>  					IBEXIT("invalid extended speed value %ld", val);
>  				break;
>  			case FDR10SPEED:
> -				if (val < 0 || val > 1)
> +				if (val > 1)
>  					IBEXIT("invalid fdr10 speed value %ld", val);
>  				break;
>  			case WIDTH:
> -				if (val < 0 || (val > 15 && val != 255))
> +				if ((val > 15 && val != 255))
>  					IBEXIT("invalid width value %ld", val);
>  				break;
>  			case VLS:
> -				if (val <= 0 || val > 5)
> +				if (val == 0 || val > 5)
>  					IBEXIT("invalid vls value %ld", val);
>  				break;
>  			case MTU:
> -				if (val <= 0 || val > 5)
> +				if (val == 0 || val > 5)
>  					IBEXIT("invalid mtu value %ld", val);
>  				break;
>  			case LID:
> -				if (val <= 0 || val >= 0xC000)
> +				if (val == 0 || val >= 0xC000)
>  					IBEXIT("invalid lid value 0x%lx", val);
>  				break;
>  			case SMLID:
> -				if (val <= 0 || val >= 0xC000)
> +				if (val == 0 || val >= 0xC000)
>  					IBEXIT("invalid smlid value 0x%lx",
>  						val);
>  				break;
>  			case LMC:
> -				if (val < 0 || val > 7)
> +				if (val > 7)
>  					IBEXIT("invalid lmc value %ld", val);
>  				break;
>  			case MKEY:
> @@ -497,11 +497,11 @@ int main(int argc, char **argv)
>  				/* All 64-bit values are legal */
>  				break;
>  			case MKEYLEASE:
> -				if (val < 0 || val > 0xFFFF)
> +				if (val > 0xFFFF)
>  					IBEXIT("invalid mkey lease time %ld", val);
>  				break;
>  			case MKEYPROT:
> -				if (val < 0 || val > 3)
> +				if (val > 3)
>  					IBEXIT("invalid mkey protection bit setting %ld", val);
>  			}
>  			*port_args[j].val = val;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
