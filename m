From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibportstate.c: Changes for extended
 link speeds
Date: Thu, 18 Aug 2011 11:22:57 -0700
Message-ID: <20110818112257.ecf94e04.weiny2@llnl.gov>
References: <4E4A34FF.2010400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E4A34FF.2010400-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 16 Aug 2011 02:14:39 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/ibportstate.c b/src/ibportstate.c
> index 1f0f42e..f7ad37f 100644
> --- a/src/ibportstate.c
> +++ b/src/ibportstate.c
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
> - * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
> + * Copyright (c) 2010,2011 Mellanox Technologies LTD.  All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -53,6 +53,7 @@ enum port_ops {
>  	RESET,
>  	DISABLE,
>  	SPEED,
> +	ESPEED,
>  	WIDTH,
>  	DOWN,
>  	ARM,
> @@ -66,6 +67,7 @@ enum port_ops {
>  
>  struct ibmad_port *srcport;
>  int speed = 0; /* no state change */
> +int espeed = 0; /* no state change */
>  int width = 0; /* no state change */
>  int lid;
>  int smlid;
> @@ -83,6 +85,7 @@ struct {
>  	{"reset", NULL, 0},	/* RESET */
>  	{"disable", NULL, 0},	/* DISABLE */
>  	{"speed", &speed, 0},	/* SPEED */
> +	{"espeed", &espeed, 0},	/* EXTENDED SPEED */
>  	{"width", &width, 0},	/* WIDTH */
>  	{"down", NULL, 0},	/* DOWN */
>  	{"arm", NULL, 0},	/* ARM */
> @@ -99,7 +102,7 @@ struct {
>  /*******************************************/
>  
>  /*
> - * Return 1 if port is a switch, else zero.
> + * Return 1 if node is a switch, else zero.
>   */
>  static int get_node_info(ib_portid_t * dest, uint8_t * data)
>  {
> @@ -115,15 +118,30 @@ static int get_node_info(ib_portid_t * dest, uint8_t * data)
>  		return 0;
>  }
>  
> -static void get_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
> +static int get_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
> +			 int is_switch)
>  {
> +	uint8_t smp[IB_SMP_DATA_SIZE];
> +	uint8_t *info;
> +	int cap_mask;
> +
> +	if (is_switch) {
> +		if (!smp_query_via(smp, dest, IB_ATTR_PORT_INFO, 0, 0, srcport))
> +			IBERROR("smp query port 0 portinfo failed");
> +		info = smp;
> +	} else
> +		info = data;
> +
>  	if (!smp_query_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
>  		IBERROR("smp query portinfo failed");
> +	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
> +	return (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
>  }
>  
> -static void show_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
> +static void show_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
> +			   int espeed_cap)
>  {
> -	char buf[2048];
> +	char buf[2300];
>  	char val[64];
>  
>  	mad_dump_portstates(buf, sizeof buf, data, sizeof *data);
> @@ -163,17 +181,35 @@ static void show_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
>  	mad_dump_field(IB_PORT_LINK_SPEED_ACTIVE_F, buf + strlen(buf),
>  		       sizeof buf - strlen(buf), val);
>  	sprintf(buf + strlen(buf), "%s", "\n");
> +	if (espeed_cap) {
> +		mad_decode_field(data, IB_PORT_LINK_SPEED_EXT_SUPPORTED_F, val);
> +		mad_dump_field(IB_PORT_LINK_SPEED_EXT_SUPPORTED_F,
> +			       buf + strlen(buf), sizeof buf - strlen(buf),
> +			       val);
> +		sprintf(buf + strlen(buf), "%s", "\n");
> +		mad_decode_field(data, IB_PORT_LINK_SPEED_EXT_ENABLED_F, val);
> +		mad_dump_field(IB_PORT_LINK_SPEED_EXT_ENABLED_F,
> +			       buf + strlen(buf), sizeof buf - strlen(buf),
> +			       val);
> +		sprintf(buf + strlen(buf), "%s", "\n");
> +		mad_decode_field(data, IB_PORT_LINK_SPEED_EXT_ACTIVE_F, val);
> +		mad_dump_field(IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
> +			       buf + strlen(buf), sizeof buf - strlen(buf),
> +			       val);
> +		sprintf(buf + strlen(buf), "%s", "\n");
> +	}
>  
>  	printf("# Port info: %s port %d\n%s", portid2str(dest), portnum, buf);
>  }
>  
> -static void set_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
> +static void set_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
> +			  int espeed_cap)
>  {
>  	if (!smp_set_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
>  		IBERROR("smp set portinfo failed");
>  
>  	printf("\nAfter PortInfo set:\n");
> -	show_port_info(dest, data, portnum);
> +	show_port_info(dest, data, portnum, espeed_cap);
>  }
>  
>  static int get_link_width(int lwe, int lws)
> @@ -192,6 +228,14 @@ static int get_link_speed(int lse, int lss)
>  		return lse;
>  }
>  
> +static int get_link_speed_ext(int lsee, int lses)
> +{
> +	if (lsee == 31)
> +		return lses;
> +	else
> +		return lsee;
> +}
> +
>  static void validate_width(int width, int peerwidth, int lwa)
>  {
>  	if ((width & peerwidth & 0x8)) {
> @@ -222,7 +266,7 @@ static void validate_speed(int speed, int peerspeed, int lsa)
>  	if ((speed & peerspeed & 0x4)) {
>  		if (lsa != 4)
>  			IBWARN
> -			    ("Peer ports operating at active speed %d rather than  4 (10.0 Gbps)",
> +			    ("Peer ports operating at active speed %d rather than 4 (10.0 Gbps)",
>  			     lsa);
>  	} else if ((speed & peerspeed & 0x2)) {
>  		if (lsa != 2)
> @@ -237,17 +281,32 @@ static void validate_speed(int speed, int peerspeed, int lsa)
>  	}
>  }
>  
> +static void validate_extended_speed(int espeed, int peerespeed, int lsea)
> +{
> +	if ((espeed & peerespeed & 0x2)) {
> +		if (lsea != 2)
> +			IBWARN
> +			    ("Peer ports operating at active extended speed %d rather than 2 (25.78125 Gbps)",
> +			     lsea);
> +	} else if ((espeed & peerespeed & 0x1)) {
> +		if (lsea != 1)
> +			IBWARN
> +			    ("Peer ports operating at active extended speed %d rather than 1 (14.0625 Gbps)",
> +			     lsea);
> +	}
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	int mgmt_classes[3] =
>  	    { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS };
>  	ib_portid_t portid = { 0 };
>  	int port_op = -1;
> -	int is_switch;
> -	int state, physstate, lwe, lws, lwa, lse, lss, lsa;
> +	int is_switch, is_peer_switch, espeed_cap, peer_espeed_cap;
> +	int state, physstate, lwe, lws, lwa, lse, lss, lsa, lsee, lses, lsea;
>  	int peerlocalportnum, peerlwe, peerlws, peerlwa, peerlse, peerlss,
> -	    peerlsa;
> -	int peerwidth, peerspeed;
> +	    peerlsa, peerlsee, peerlses, peerlsea;
> +	int peerwidth, peerspeed, peerespeed;
>  	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
>  	ib_portid_t peerportid = { 0 };
>  	int portnum = 0;
> @@ -316,6 +375,10 @@ int main(int argc, char **argv)
>  				if (val < 0 || val > 15)
>  					IBERROR("invalid speed value %ld", val);
>  				break;
> +			case ESPEED:
> +				if (val < 0 || val > 31)
> +					IBERROR("invalid extended speed value %ld", val);
> +				break;
>  			case WIDTH:
>  				if (val < 0 || (val > 15 && val != 255))
>  					IBERROR("invalid width value %ld", val);
> @@ -357,9 +420,8 @@ int main(int argc, char **argv)
>  		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA");
>  	else
>  		printf("%s PortInfo:\n", is_switch ? "Switch" : "CA");
> -	memset(data, 0, sizeof(data));
> -	get_port_info(&portid, data, portnum);
> -	show_port_info(&portid, data, portnum);
> +	espeed_cap = get_port_info(&portid, data, portnum, is_switch);
> +	show_port_info(&portid, data, portnum, espeed_cap);
>  
>  	if (port_op != QUERY || changed) {
>  		/*
> @@ -397,8 +459,9 @@ int main(int argc, char **argv)
>  			break;
>  		}
>  
> -		/* always set enabled speed/width - defaults to NOP */
> +		/* always set enabled speeds/width - defaults to NOP */
>  		mad_set_field(data, 0, IB_PORT_LINK_SPEED_ENABLED_F, speed);
> +		mad_set_field(data, 0, IB_PORT_LINK_SPEED_EXT_ENABLED_F, espeed);
>  		mad_set_field(data, 0, IB_PORT_LINK_WIDTH_ENABLED_F, width);
>  
>  		if (port_args[VLS].set)
> @@ -412,7 +475,7 @@ int main(int argc, char **argv)
>  		if (port_args[LMC].set)
>  			mad_set_field(data, 0, IB_PORT_LMC_F, lmc);
>  
> -		set_port_info(&portid, data, portnum);
> +		set_port_info(&portid, data, portnum, is_switch);
>  
>  	} else if (is_switch && portnum) {
>  		/* Now, make sure PortState is Active */
> @@ -432,6 +495,17 @@ int main(int argc, char **argv)
>  					 &lsa);
>  			mad_decode_field(data, IB_PORT_LINK_SPEED_ENABLED_F,
>  					 &lse);
> +			if (espeed_cap) {
> +				mad_decode_field(data,
> +						 IB_PORT_LINK_SPEED_EXT_SUPPORTED_F,
> +						 &lses);
> +				mad_decode_field(data,
> +						 IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
> +						 &lsea);
> +				mad_decode_field(data,
> +						 IB_PORT_LINK_SPEED_EXT_ENABLED_F,
> +						 &lsee);
> +			}
>  
>  			/* Setup portid for peer port */
>  			memcpy(&peerportid, &portid, sizeof(peerportid));
> @@ -446,15 +520,18 @@ int main(int argc, char **argv)
>  			peerportid.drpath.drdlid = 0xffff;
>  
>  			/* Get peer port NodeInfo to obtain peer port number */
> -			get_node_info(&peerportid, data);
> +			is_peer_switch = get_node_info(&peerportid, data);
>  
>  			mad_decode_field(data, IB_NODE_LOCAL_PORT_F,
>  					 &peerlocalportnum);
>  
>  			printf("Peer PortInfo:\n");
>  			/* Get peer port characteristics */
> -			get_port_info(&peerportid, data, peerlocalportnum);
> -			show_port_info(&peerportid, data, peerlocalportnum);
> +			peer_espeed_cap = get_port_info(&peerportid, data,
> +							peerlocalportnum,
> +							is_peer_switch);
> +			show_port_info(&peerportid, data, peerlocalportnum,
> +				       peer_espeed_cap);
>  
>  			mad_decode_field(data, IB_PORT_LINK_WIDTH_ENABLED_F,
>  					 &peerlwe);
> @@ -468,6 +545,17 @@ int main(int argc, char **argv)
>  					 &peerlsa);
>  			mad_decode_field(data, IB_PORT_LINK_SPEED_ENABLED_F,
>  					 &peerlse);
> +			if (peer_espeed_cap) {
> +				mad_decode_field(data,
> +						 IB_PORT_LINK_SPEED_EXT_SUPPORTED_F,
> +						 &peerlses);
> +				mad_decode_field(data,
> +						 IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
> +						 &peerlsea);
> +				mad_decode_field(data,
> +						 IB_PORT_LINK_SPEED_EXT_ENABLED_F,
> +						 &peerlsee);
> +			}
>  
>  			/* Now validate peer port characteristics */
>  			/* Examine Link Width */
> @@ -475,10 +563,18 @@ int main(int argc, char **argv)
>  			peerwidth = get_link_width(peerlwe, peerlws);
>  			validate_width(width, peerwidth, lwa);
>  
> -			/* Examine Link Speed */
> +			/* Examine Link Speeds */
>  			speed = get_link_speed(lse, lss);
>  			peerspeed = get_link_speed(peerlse, peerlss);
>  			validate_speed(speed, peerspeed, lsa);
> +
> +			if (espeed_cap && peer_espeed_cap) {
> +				espeed = get_link_speed_ext(lsee, lses);
> +				peerespeed = get_link_speed_ext(peerlsee,
> +								peerlses);
> +				validate_extended_speed(espeed, peerespeed,
> +							lsea);
> +			}
>  		}
>  	}
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
