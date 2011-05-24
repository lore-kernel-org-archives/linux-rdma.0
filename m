From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/libibnetdisc/ibnetdisc.c: Better error
 message
Date: Tue, 24 May 2011 13:46:48 -0700
Message-ID: <20110524134648.219e35fb.weiny2@llnl.gov>
References: <4DDBF859.7000503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DDBF859.7000503-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 24 May 2011 11:26:33 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> include node GUID and port number
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied,
Ira

> ---
> diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
> index e4487c1..7ba87fd 100644
> --- a/libibnetdisc/src/ibnetdisc.c
> +++ b/libibnetdisc/src/ibnetdisc.c
> @@ -171,7 +171,8 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
>  	if (!port) {
>  		port = node->ports[port_num] = calloc(1, sizeof(*port));
>  		if (!port) {
> -			IBND_ERROR("Failed to allocate port\n");
> +			IBND_ERROR("Failed to allocate 0x%" PRIx64 " port %u\n",
> +				    node->guid, port_num);
>  			return -1;
>  		}
>  		port->guid =
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


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
