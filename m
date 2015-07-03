From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4 infiniband-diags] ibqueryerrors: code improvement
Date: Fri, 3 Jul 2015 11:22:30 -0400
Message-ID: <20150703152230.GD15224@phlsvsds.ph.intel.com>
References: <553D3DA9.1080507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <553D3DA9.1080507-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 26, 2015 at 03:34:01PM -0400, Hal Rosenstock wrote:
> From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Sun, 26 Apr 2015 18:29:31 +0300
> 
> goto is performed after IBEXIT call
> 
> Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks I applied this earlier in the series because I wanted to fix up the goto
labels in your other patch.

Ira

> ---
>  src/ibqueryerrors.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index 398e2a7..bdae156 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -1011,7 +1011,6 @@ int main(int argc, char **argv)
>  	if (resolve_self(ibd_ca, ibd_ca_port, &self_portid, &port, &self_gid.raw) < 0) {
>  		mad_rpc_close_port(ibmad_port);
>  		IBEXIT("can't resolve self port %s", argv[0]);
> -		goto close_port;
>  	}
>  
>  	node_name_map = open_node_name_map(node_name_map_file);
> -- 
> 1.7.8.2
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
