From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCHv2 3/6] infiniband-diags/iblinkinfo.c: Add support for
 FDR10
Date: Wed, 31 Aug 2011 17:20:12 -0700
Message-ID: <20110831172012.0b705080.weiny2@llnl.gov>
References: <4E5E52AA.5020606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E5E52AA.5020606-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 31 Aug 2011 08:26:34 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Changes since v1:
> Rebased to latest master
> 
>  libibnetdisc/include/infiniband/ibnetdisc.h |    1 +
>  src/ibdiag_common.c                         |   19 ++++++++++++++++---
>  src/iblinkinfo.c                            |   23 +++++++++++++++--------
>  3 files changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/libibnetdisc/include/infiniband/ibnetdisc.h b/libibnetdisc/include/infiniband/ibnetdisc.h
> index 300094e..0cad93f 100644
> --- a/libibnetdisc/include/infiniband/ibnetdisc.h
> +++ b/libibnetdisc/include/infiniband/ibnetdisc.h
> @@ -109,6 +109,7 @@ typedef struct ibnd_port {
>  	uint8_t lmc;
>  	/* use libibmad decoder functions for info */
>  	uint8_t info[IB_SMP_DATA_SIZE];
> +	uint8_t ext_info[IB_SMP_DATA_SIZE];

This breaks ABI for libibnetdisc if the user has ignored the comments and used the internal htnext parameter.  :-(  I am going to rev the so version while saying it is backwards compatible since the user should not be using htnext in the structure as it is documented to be internal only.  But this could have been better designed...  (I know it is my code...  ;-)

Also I think this hunk should be moved around to be included in the library update where you actually query this data.  I have applied the following series which is the same code but with the patches reorganized and the addition of a so name bump.

commit 1e62d09ae5d7e4d43089deea07ceb94f8dfd49a0
Author: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Wed Aug 31 15:26:42 2011 +0000

    infiniband-diags/ibqueryerrors.c: Add support for FDR10

    Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

commit 95a84b7cc30aae53e4212e6138b95b515287b151
Author: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date:   Wed Aug 31 17:08:50 2011 -0700

    infiniband-diags/iblinkinfo.c: Add support for FDR10

        Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
        Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

commit ce6c56fa2165078e9f653428e26368f5393dd081
Author: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date:   Wed Aug 31 17:07:29 2011 -0700

    infiniband-diags: Add support for FDR10 to ibnetdiscover

        Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
        Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

commit c8542da6a0c00ab463f8b7a066219baa1afcb43c
Author: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date:   Wed Aug 31 17:06:43 2011 -0700

    infiniband-diags: Add FDR10 support to libibnetdisc

        Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
        Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Let me know if it breaks something, I can't test as I don't have this hardware.  :-(

So applied with caveats,  ;-)

Ira

>  
>  	/* internal use only */
>  	struct ibnd_port *htnext;
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> index 74960e1..e6587af 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -594,7 +594,7 @@ void get_max_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * p
>  {
>  	char buf[64];
>  	uint32_t max_speed = 0;
> -	uint32_t cap_mask, rem_cap_mask;
> +	uint32_t cap_mask, rem_cap_mask, fdr10;
>  	uint8_t *info;
>  
>  	uint32_t max_width = get_max(mad_get_field(port->info, 0,
> @@ -623,7 +623,14 @@ void get_max_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * p
>  	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS &&
>  	    rem_cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
>  		goto check_ext_speed;
> -check_speed_supp:
> +check_fdr10_supp:
> +	fdr10 = (mad_get_field(port->ext_info, 0,
> +			       IB_MLNX_EXT_PORT_LINK_SPEED_SUPPORTED_F) & FDR10)
> +		&& (mad_get_field(port->remoteport->ext_info, 0,
> +				  IB_MLNX_EXT_PORT_LINK_SPEED_SUPPORTED_F) & FDR10);
> +	if (fdr10)
> +		goto check_fdr10_active;
> +
>  	max_speed = get_max(mad_get_field(port->info, 0,
>  					  IB_PORT_LINK_SPEED_SUPPORTED_F)
>  			    & mad_get_field(port->remoteport->info, 0,
> @@ -642,7 +649,7 @@ check_ext_speed:
>  			  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F) == 0 ||
>  	    mad_get_field(port->remoteport->info, 0,
>  			  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F) == 0)
> -		goto check_speed_supp;
> +		goto check_fdr10_supp;
>  	max_speed = get_max(mad_get_field(port->info, 0,
>  					  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F)
>  			    & mad_get_field(port->remoteport->info, 0,
> @@ -654,4 +661,10 @@ check_ext_speed:
>  		snprintf(speed_msg, msg_size, "Could be %s",
>  			 mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
>  				      buf, 64, &max_speed));
> +	return;
> +
> +check_fdr10_active:
> +	if ((mad_get_field(port->ext_info, 0,
> +			   IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F) & FDR10) == 0)
> +		snprintf(speed_msg, msg_size, "Could be FDR10");
>  }
> diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
> index bbdb51d..673ed95 100644
> --- a/src/iblinkinfo.c
> +++ b/src/iblinkinfo.c
> @@ -78,7 +78,6 @@ static int down_links_only = 0;
>  static int line_mode = 0;
>  static int add_sw_settings = 0;
>  
> -
>  int filterdownport_check(ibnd_node_t * node, ibnd_port_t * port)
>  {
>  	ibnd_node_t *fsw;
> @@ -112,7 +111,7 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
>  	char width_msg[256];
>  	char speed_msg[256];
>  	char ext_port_str[256];
> -	int iwidth, ispeed, espeed, istate, iphystate, cap_mask;
> +	int iwidth, ispeed, fdr10, espeed, istate, iphystate, cap_mask;
>  	int n = 0;
>  	uint8_t *info;
>  
> @@ -121,6 +120,8 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
>  
>  	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
>  	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
> +	fdr10 = mad_get_field(port->ext_info, 0,
> +			      IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F) & FDR10;
>  
>  	if (port->node->type == IB_NODE_SWITCH)
>  		info = (uint8_t *)&port->node->ports[0]->info;
> @@ -150,15 +151,21 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
>  	/* C14-24.2.1 states that a down port allows for invalid data to be
>  	 * returned for all PortInfo components except PortState and
>  	 * PortPhysicalState */
> +	if (!espeed) {
> +		if (fdr10)
> +			sprintf(speed, "10.0 Gbps (FDR10)");
> +		else
> +			mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed,
> +				     64, &ispeed);
> +	} else
> +		mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed,
> +			     64, &espeed);
> +
>  	if (istate != IB_LINK_DOWN) {
> -		n = snprintf(link_str, 256, "(%3s %9s %6s/%8s)",
> +		n = snprintf(link_str, 256, "(%3s %18s %6s/%8s)",
>  		     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64,
>  				  &iwidth),
> -		     (ispeed != 4 || !espeed) ?
> -			mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64,
> -				     &ispeed) :
> -			mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed, 64,
> -				     &espeed),
> +		     speed,
>  		     mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
>  		     mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64,
>  				  &iphystate));
> -- 
> 1.5.3
> 
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
