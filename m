From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibmad/[register rpc].c: Fix some bounds checks
Date: Wed, 1 Jun 2011 14:54:29 -0700
Message-ID: <20110601145429.3a6172ee.weiny2@llnl.gov>
References: <4DE64295.6040908@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DE64295.6040908-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 1 Jun 2011 06:45:57 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied,
Ira

> ---
> diff --git a/src/register.c b/src/register.c
> index 0ff8006..1fdb64a 100644
> --- a/src/register.c
> +++ b/src/register.c
> @@ -77,7 +77,7 @@ static int mgmt_class_vers(int mgmt_class)
>  
>  int mad_class_agent(int mgmt)
>  {
> -	if (mgmt < 1 || mgmt > MAX_CLASS)
> +	if (mgmt < 1 || mgmt >= MAX_CLASS)
>  		return -1;
>  	return ibmp->class_agents[mgmt];
>  }
> diff --git a/src/rpc.c b/src/rpc.c
> index 88e43e7..d20c321 100644
> --- a/src/rpc.c
> +++ b/src/rpc.c
> @@ -120,7 +120,7 @@ int mad_rpc_portid(struct ibmad_port *srcport)
>  
>  int mad_rpc_class_agent(struct ibmad_port *port, int class)
>  {
> -	if (class < 1 || class > MAX_CLASS)
> +	if (class < 1 || class >= MAX_CLASS)
>  		return -1;
>  	return port->class_agents[class];
>  }


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
