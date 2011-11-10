From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibmad/rpc.c: On receive, add debug info for dumping
 incoming MAD address
Date: Thu, 10 Nov 2011 11:28:44 -0800
Message-ID: <20111110112844.9f470e6d.weiny2@llnl.gov>
References: <4EBBD63E.7090405@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EBBD63E.7090405-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 10 Nov 2011 05:48:46 -0800
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied,
Ira

> ---
> diff --git a/src/rpc.c b/src/rpc.c
> index 19a5a70..6312d42 100644
> --- a/src/rpc.c
> +++ b/src/rpc.c
> @@ -166,6 +166,8 @@ _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int agentid, int len,
>  				return -1;
>  			}
>  
> +			if (ibdebug > 2)
> +				umad_addr_dump(umad_get_mad_addr(rcvbuf));
>  			if (ibdebug > 1) {
>  				IBWARN("rcv buf:");
>  				xdump(stderr, "rcv buf\n", umad_get_mad(rcvbuf),


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
