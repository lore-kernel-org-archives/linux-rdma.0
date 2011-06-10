From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/libibnetdisc/ibnetdisc_cache.c: Fix a
 couple of memory leaks
Date: Fri, 10 Jun 2011 11:43:24 -0700
Message-ID: <20110610114324.8f52da73.weiny2@llnl.gov>
References: <4DEF6F66.9070507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DEF6F66.9070507-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 8 Jun 2011 05:47:34 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/libibnetdisc/src/ibnetdisc_cache.c b/libibnetdisc/src/ibnetdisc_cache.c
> index 199bf33..2690373 100644
> --- a/libibnetdisc/src/ibnetdisc_cache.c
> +++ b/libibnetdisc/src/ibnetdisc_cache.c
> @@ -326,6 +326,7 @@ static int _load_node(int fd, ibnd_fabric_cache_t * fabric_cache)
>  	node = (ibnd_node_t *) malloc(sizeof(ibnd_node_t));
>  	if (!node) {
>  		IBND_DEBUG("OOM: node\n");
> +		free(node_cache);
>  		return -1;
>  	}
>  	memset(node, '\0', sizeof(ibnd_node_t));
> @@ -426,6 +427,7 @@ static int _load_port(int fd, ibnd_fabric_cache_t * fabric_cache)
>  	port = (ibnd_port_t *) malloc(sizeof(ibnd_port_t));
>  	if (!port) {
>  		IBND_DEBUG("OOM: port\n");
> +		free(port_cache);
>  		return -1;
>  	}
>  	memset(port, '\0', sizeof(ibnd_port_t));


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
