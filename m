From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 1/2] infiniband-diags/libibnetdisc: clean up PortInfo
 queries
Date: Tue, 10 Nov 2009 14:03:03 -0800
Message-ID: <20091110140303.a1d95293.weiny2@llnl.gov>
References: <20091110140137.0c66e84f.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091110140137.0c66e84f.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry, I clicked "send" on patch 2/2 first so they came out of order...

I think you will get the idea...  ;-)

Ira

On Tue, 10 Nov 2009 14:01:37 -0800
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

> Sasha,
> 
> This and the subsequent patch clean up the port info query code to be more
> straight forward.
> 
> First off I got rid of the "decode_port_info" function as it does very little
> and combined the smp_query_via call into a "query_port_info"
> 
> The second patch removes the "get_port_info" function as it became nearly
> redundant with query_port_info.
> 
> Ira
> 
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Tue, 10 Nov 2009 11:22:03 -0800
> Subject: [PATCH] infiniband-diags/libibnetdisc: clean up PortInfo queries
> 
> 	remove old "decode_port_info" and replace with new "query_port_info"
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
>  infiniband-diags/libibnetdisc/src/ibnetdisc.c |   32 +++++++++++++-----------
>  1 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> index 62dff93..3f62f3f 100644
> --- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> +++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> @@ -57,16 +57,24 @@
>  static int show_progress = 0;
>  int ibdebug;
>  
> -void decode_port_info(ibnd_port_t * port)
> +int query_port_info(struct ibmad_port *ibmad_port, ib_portid_t * portid,
> +		    int portnum, ibnd_port_t * port)
>  {
> +	if (!smp_query_via(port->info, portid, IB_ATTR_PORT_INFO,
> +			   portnum, 0, ibmad_port))
> +		return -1;
> +
>  	port->base_lid = (uint16_t) mad_get_field(port->info, 0, IB_PORT_LID_F);
>  	port->lmc = (uint8_t) mad_get_field(port->info, 0, IB_PORT_LMC_F);
> +
> +	return 0;
>  }
>  
>  static int get_port_info(struct ibmad_port *ibmad_port,
>  			 ibnd_fabric_t * fabric, ibnd_port_t * port,
>  			 int portnum, ib_portid_t * portid)
>  {
> +	int rc = 0;
>  	char width[64], speed[64];
>  	int iwidth;
>  	int ispeed;
> @@ -75,11 +83,8 @@ static int get_port_info(struct ibmad_port *ibmad_port,
>  	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
>  	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
>  
> -	if (!smp_query_via(port->info, portid, IB_ATTR_PORT_INFO,
> -			   portnum, 0, ibmad_port))
> -		return -1;
> -
> -	decode_port_info(port);
> +	if ((rc = query_port_info(ibmad_port, portid, portnum, port)) != 0)
> +		return rc;
>  
>  	IBND_DEBUG
>  	    ("portid %s portnum %d: base lid %d state %d physstate %d %s %s\n",
> @@ -123,10 +128,8 @@ static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
>  	if (!smp_query_via(nd, portid, IB_ATTR_NODE_DESC, 0, 0, ibmad_port))
>  		return -1;
>  
> -	if (!smp_query_via(port->info, portid, IB_ATTR_PORT_INFO, 0, 0,
> -			   ibmad_port))
> -		return -1;
> -	decode_port_info(port);
> +	if ((rc = query_port_info(ibmad_port, portid, 0, port)) != 0)
> +		return rc;
>  
>  	if (node->type != IB_NODE_SWITCH)
>  		return 0;
> @@ -134,11 +137,10 @@ static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
>  	node->smalid = port->base_lid;
>  	node->smalmc = port->lmc;
>  
> -	/* after we have the sma information find out the real PortInfo for this port */
> -	if (!smp_query_via(port->info, portid, IB_ATTR_PORT_INFO,
> -			   port->portnum, 0, ibmad_port))
> -		return -1;
> -	decode_port_info(port);
> +	/* after we have the sma information find out the "real" PortInfo for
> +	 * the external port */
> +	if ((rc = query_port_info(ibmad_port, portid, port->portnum, port)) != 0)
> +		return rc;
>  
>  	port->base_lid = (uint16_t) node->smalid;	/* LID is still defined by port 0 */
>  	port->lmc = (uint8_t) node->smalmc;
> -- 
> 1.5.4.5
> 


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
