From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH TRIVIAL infiniband-diags] ibportstate.c: When not switch, port can be router port
Date: Tue, 18 Oct 2016 12:25:53 -0400
Message-ID: <20161018162551.GA16254@phlsvsds.ph.intel.com>
References: <f44f2a4f-15f7-6ae5-d1fb-7af0a77aeaee@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f44f2a4f-15f7-6ae5-d1fb-7af0a77aeaee-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 23, 2016 at 09:17:10AM -0400, Hal Rosenstock wrote:
> 
> Indicate PortInfo is on CA/RT port rather than just CA port when not
> on Switch port. RT is what's used by ibnetdiscover for router nodes.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>

Thanks applied,
Ira

> ---
> diff --git a/src/ibportstate.c b/src/ibportstate.c
> index cb47aa9..cfb8be7 100644
> --- a/src/ibportstate.c
> +++ b/src/ibportstate.c
> @@ -522,9 +522,9 @@ int main(int argc, char **argv)
>  		IBEXIT("Can't set M_Key fields on switch port != 0");
>  
>  	if (port_op != QUERY || changed)
> -		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA");
> +		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA/RT");
>  	else
> -		printf("%s PortInfo:\n", is_switch ? "Switch" : "CA");
> +		printf("%s PortInfo:\n", is_switch ? "Switch" : "CA/RT");
>  	espeed_cap = get_port_info(&portid, data, portnum, is_switch);
>  	show_port_info(&portid, data, portnum, espeed_cap, is_switch);
>  	if (is_mlnx_ext_port_info_supported(devid)) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
