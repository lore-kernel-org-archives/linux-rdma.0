From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibportstate: allow changes to CA
 portinfo parameters
Date: Tue, 1 Dec 2009 05:17:22 +0200
Message-ID: <20091201031722.GI16607@me>
References: <1257451016.992.173.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1257451016.992.173.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ralph,

On 11:56 Thu 05 Nov     , Ralph Campbell wrote:
> This patch adds new commands to ibportstate to support initializing
> the link for CAs connected back-to-back. It also allows more than
> one field to be changed at the same time such as "lid 23 arm" or
> "width 1 speed 3 enable".

As far as I can see this changes a functionality of ibportstate
dramatically. Actually it makes it more like to 'ibportset' than just
'ibportstate', correct?

If so, wouldn't it be better to introduce a new tool - let's say
'ibportset' (or like this)?

(Or even wider 'smpset' - however such 'smpset' can be done later
following a real needs by extending ibportset or so).

Don't understand me wrong I'm not disagree at all, just trying to find
the best way to add such functionality to infiniband-diags.

Sasha

> 
> Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
> ---
> 
> diff --git a/infiniband-diags/src/ibportstate.c b/infiniband-diags/src/ibportstate.c
> index e631bfd..192b14e 100644
> --- a/infiniband-diags/src/ibportstate.c
> +++ b/infiniband-diags/src/ibportstate.c
> @@ -46,93 +46,133 @@
>  
>  #include "ibdiag_common.h"
>  
> +enum port_ops {
> +	QUERY,
> +	ENABLE,
> +	RESET,
> +	DISABLE,
> +	SPEED,
> +	WIDTH,
> +	DOWN,
> +	ARM,
> +	ACTIVE,
> +	VLS,
> +	MTU,
> +	LID,
> +	SMLID,
> +	LMC,
> +};
> +
>  struct ibmad_port *srcport;
> +int speed = 15;
> +int width = 255;
> +int lid;
> +int smlid;
> +int lmc;
> +int mtu;
> +int vls;
> +
> +struct {
> +	const char *name;
> +	int *val;
> +	int set;
> +} port_args[] = {
> +	{ "query", NULL, 0 },	/* QUERY */
> +	{ "enable", NULL, 0 },	/* ENABLE */
> +	{ "reset", NULL, 0 },	/* RESET */
> +	{ "disable", NULL, 0 },	/* DISABLE */
> +	{ "speed", &speed, 0 },	/* SPEED */
> +	{ "width", &width, 0 },	/* WIDTH */
> +	{ "down", NULL, 0 },	/* DOWN */
> +	{ "arm", NULL, 0 },	/* ARM */
> +	{ "active", NULL, 0 },	/* ACTIVE */
> +	{ "vls", &vls, 0 },	/* VLS */
> +	{ "mtu", &mtu, 0 },	/* MTU */
> +	{ "lid", &lid, 0 },	/* LID */
> +	{ "smlid", &smlid, 0 },	/* SMLID */
> +	{ "lmc", &lmc, 0 },	/* LMC */
> +};
> +
> +#define NPORT_ARGS (sizeof(port_args) / sizeof(port_args[0]))
>  
>  /*******************************************/
>  
> +/*
> + * Return 1 if port is a switch, else zero.
> + */
>  static int get_node_info(ib_portid_t * dest, uint8_t * data)
>  {
>  	int node_type;
>  
>  	if (!smp_query_via(data, dest, IB_ATTR_NODE_INFO, 0, 0, srcport))
> -		return -1;
> +		IBERROR("smp query nodeinfo failed");
>  
>  	node_type = mad_get_field(data, 0, IB_NODE_TYPE_F);
>  	if (node_type == IB_NODE_SWITCH)	/* Switch NodeType ? */
> -		return 0;
> -	else
>  		return 1;
> +	else
> +		return 0;
>  }
>  
> -static int get_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
> -			 int port_op)
> +static void get_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
> +{
> +	if (!smp_query_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
> +		IBERROR("smp query portinfo failed");
> +}
> +
> +static void show_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
>  {
>  	char buf[2048];
>  	char val[64];
>  
> -	if (!smp_query_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
> -		return -1;
> -
> -	if (port_op != 4) {
> -		mad_dump_portstates(buf, sizeof buf, data, sizeof data);
> -		mad_decode_field(data, IB_PORT_LINK_WIDTH_SUPPORTED_F, val);
> -		mad_dump_field(IB_PORT_LINK_WIDTH_SUPPORTED_F,
> -			       buf + strlen(buf), sizeof buf - strlen(buf),
> -			       val);
> -		sprintf(buf + strlen(buf), "%s", "\n");
> -		mad_decode_field(data, IB_PORT_LINK_WIDTH_ENABLED_F, val);
> -		mad_dump_field(IB_PORT_LINK_WIDTH_ENABLED_F, buf + strlen(buf),
> -			       sizeof buf - strlen(buf), val);
> -		sprintf(buf + strlen(buf), "%s", "\n");
> -		mad_decode_field(data, IB_PORT_LINK_WIDTH_ACTIVE_F, val);
> -		mad_dump_field(IB_PORT_LINK_WIDTH_ACTIVE_F, buf + strlen(buf),
> -			       sizeof buf - strlen(buf), val);
> -		sprintf(buf + strlen(buf), "%s", "\n");
> -		mad_decode_field(data, IB_PORT_LINK_SPEED_SUPPORTED_F, val);
> -		mad_dump_field(IB_PORT_LINK_SPEED_SUPPORTED_F,
> -			       buf + strlen(buf), sizeof buf - strlen(buf),
> -			       val);
> -		sprintf(buf + strlen(buf), "%s", "\n");
> -		mad_decode_field(data, IB_PORT_LINK_SPEED_ENABLED_F, val);
> -		mad_dump_field(IB_PORT_LINK_SPEED_ENABLED_F, buf + strlen(buf),
> -			       sizeof buf - strlen(buf), val);
> -		sprintf(buf + strlen(buf), "%s", "\n");
> -		mad_decode_field(data, IB_PORT_LINK_SPEED_ACTIVE_F, val);
> -		mad_dump_field(IB_PORT_LINK_SPEED_ACTIVE_F, buf + strlen(buf),
> -			       sizeof buf - strlen(buf), val);
> -		sprintf(buf + strlen(buf), "%s", "\n");
> -	} else {
> -		mad_decode_field(data, IB_PORT_LINK_SPEED_ENABLED_F, val);
> -		mad_dump_field(IB_PORT_LINK_SPEED_ENABLED_F, buf, sizeof buf,
> -			       val);
> -		sprintf(buf + strlen(buf), "%s", "\n");
> -	}
> +	mad_dump_portstates(buf, sizeof buf, data, sizeof data);
> +	mad_decode_field(data, IB_PORT_LID_F, val);
> +	mad_dump_field(IB_PORT_LID_F, buf + strlen(buf),
> +		       sizeof buf - strlen(buf), val);
> +	sprintf(buf + strlen(buf), "%s", "\n");
> +	mad_decode_field(data, IB_PORT_SMLID_F, val);
> +	mad_dump_field(IB_PORT_SMLID_F, buf + strlen(buf),
> +		       sizeof buf - strlen(buf), val);
> +	sprintf(buf + strlen(buf), "%s", "\n");
> +	mad_decode_field(data, IB_PORT_LMC_F, val);
> +	mad_dump_field(IB_PORT_LMC_F, buf + strlen(buf),
> +		       sizeof buf - strlen(buf), val);
> +	sprintf(buf + strlen(buf), "%s", "\n");
> +	mad_decode_field(data, IB_PORT_LINK_WIDTH_SUPPORTED_F, val);
> +	mad_dump_field(IB_PORT_LINK_WIDTH_SUPPORTED_F, buf + strlen(buf),
> +		       sizeof buf - strlen(buf), val);
> +	sprintf(buf + strlen(buf), "%s", "\n");
> +	mad_decode_field(data, IB_PORT_LINK_WIDTH_ENABLED_F, val);
> +	mad_dump_field(IB_PORT_LINK_WIDTH_ENABLED_F, buf + strlen(buf),
> +		       sizeof buf - strlen(buf), val);
> +	sprintf(buf + strlen(buf), "%s", "\n");
> +	mad_decode_field(data, IB_PORT_LINK_WIDTH_ACTIVE_F, val);
> +	mad_dump_field(IB_PORT_LINK_WIDTH_ACTIVE_F, buf + strlen(buf),
> +		       sizeof buf - strlen(buf), val);
> +	sprintf(buf + strlen(buf), "%s", "\n");
> +	mad_decode_field(data, IB_PORT_LINK_SPEED_SUPPORTED_F, val);
> +	mad_dump_field(IB_PORT_LINK_SPEED_SUPPORTED_F, buf + strlen(buf),
> +		       sizeof buf - strlen(buf), val);
> +	sprintf(buf + strlen(buf), "%s", "\n");
> +	mad_decode_field(data, IB_PORT_LINK_SPEED_ENABLED_F, val);
> +	mad_dump_field(IB_PORT_LINK_SPEED_ENABLED_F, buf + strlen(buf),
> +		       sizeof buf - strlen(buf), val);
> +	sprintf(buf + strlen(buf), "%s", "\n");
> +	mad_decode_field(data, IB_PORT_LINK_SPEED_ACTIVE_F, val);
> +	mad_dump_field(IB_PORT_LINK_SPEED_ACTIVE_F, buf + strlen(buf),
> +		       sizeof buf - strlen(buf), val);
> +	sprintf(buf + strlen(buf), "%s", "\n");
>  
>  	printf("# Port info: %s port %d\n%s", portid2str(dest), portnum, buf);
> -	return 0;
>  }
>  
> -static int set_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
> -			 int port_op)
> +static void set_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
>  {
> -	char buf[2048];
> -	char val[64];
> -
>  	if (!smp_set_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
> -		return -1;
> -
> -	if (port_op != 4)
> -		mad_dump_portstates(buf, sizeof buf, data, sizeof data);
> -	else {
> -		mad_decode_field(data, IB_PORT_LINK_SPEED_ENABLED_F, val);
> -		mad_dump_field(IB_PORT_LINK_SPEED_ENABLED_F, buf, sizeof buf,
> -			       val);
> -		sprintf(buf + strlen(buf), "%s", "\n");
> -	}
> +		IBERROR("smp set portinfo failed");
>  
>  	printf("\nAfter PortInfo set:\n");
> -	printf("# Port info: %s port %d\n%s", portid2str(dest), portnum, buf);
> -	return 0;
> +	show_port_info(dest, data, portnum);
>  }
>  
>  static int get_link_width(int lwe, int lws)
> @@ -201,22 +241,23 @@ int main(int argc, char **argv)
>  	int mgmt_classes[3] =
>  	    { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS };
>  	ib_portid_t portid = { 0 };
> -	int err;
> -	int port_op = 0;	/* default to query */
> -	int speed = 15;
> -	int is_switch = 1;
> +	int port_op = -1;
> +	int is_switch;
>  	int state, physstate, lwe, lws, lwa, lse, lss, lsa;
>  	int peerlocalportnum, peerlwe, peerlws, peerlwa, peerlse, peerlss,
>  	    peerlsa;
> -	int width = 255, peerwidth, peerspeed;
> +	int peerwidth, peerspeed;
>  	uint8_t data[IB_SMP_DATA_SIZE];
>  	ib_portid_t peerportid = { 0 };
>  	int portnum = 0;
>  	ib_portid_t selfportid = { 0 };
>  	int selfport = 0;
> -
> +	int changed = 0;
> +	int i;
> +	long val;
>  	char usage_args[] = "<dest dr_path|lid|guid> <portnum> [<op>]\n"
> -	    "\nSupported ops: enable, disable, reset, speed, width, query";
> +	    "\nSupported ops: enable, disable, reset, speed, width, query,\n"
> +	    "\tdown, arm, active, vls, mtu, lid, smlid, lmc\n";
>  	const char *usage_examples[] = {
>  		"3 1 disable\t\t\t# by lid",
>  		"-G 0x2C9000100D051 1 enable\t# by guid",
> @@ -224,6 +265,7 @@ int main(int argc, char **argv)
>  		"3 1 reset\t\t\t# by lid",
>  		"3 1 speed 1\t\t\t# by lid",
>  		"3 1 width 1\t\t\t# by lid",
> +		"-D 0 1 lid 0x1234 arm\t\t# by direct route",
>  		NULL
>  	};
>  
> @@ -247,78 +289,130 @@ int main(int argc, char **argv)
>  	if (argc > 1)
>  		portnum = strtol(argv[1], 0, 0);
>  
> -	/* First, make sure it is a switch port if it is a "set" */
> -	if (argc >= 3) {
> -		if (!strcmp(argv[2], "enable"))
> -			port_op = 1;
> -		else if (!strcmp(argv[2], "disable"))
> -			port_op = 2;
> -		else if (!strcmp(argv[2], "reset"))
> -			port_op = 3;
> -		else if (!strcmp(argv[2], "speed")) {
> -			if (argc < 4)
> -				IBERROR
> -				    ("speed requires an additional parameter");
> -			port_op = 4;
> -			/* Parse speed value */
> -			speed = strtoul(argv[3], 0, 0);
> -			if (speed > 15)
> -				IBERROR("invalid speed value %d", speed);
> -		} else if (!strcmp(argv[2], "width")) {
> -			if (argc < 4)
> -				IBERROR
> -				    ("width requires an additional parameter");
> -			port_op = 5;
> -			/* Parse width value */
> -			width = strtoul(argv[3], 0, 0);
> -			if (width > 15 && width != 255)
> -				IBERROR("invalid width value %d", width);
> +	for (i = 2; i < argc; i++) {
> +		int j;
> +
> +		for (j = 0; j < NPORT_ARGS; j++) {
> +			if (strcmp(argv[i], port_args[j].name))
> +				continue;
> +			port_args[j].set = 1;
> +			if (!port_args[j].val) {
> +				if (port_op >= 0)
> +					IBERROR("%s only one of: ",
> +						"query, enable, disable, "
> +						"reset, down, arm, active, "
> +						"can be specified",
> +						port_args[j].name);
> +				port_op = j;
> +				break;
> +			}
> +			if (++i >= argc)
> +				IBERROR("%s requires an additional parameter",
> +					port_args[j].name);
> +			val = strtol(argv[i], 0, 0);
> +			switch (j) {
> +			case SPEED:
> +				if (val < 0 || val > 15)
> +					IBERROR("invalid speed value %ld", val);
> +				break;
> +			case WIDTH:
> +				if (val < 0 || (val > 15 && val != 255))
> +					IBERROR("invalid width value %ld", val);
> +				break;
> +			case VLS:
> +				if (val <= 0 || val > 5)
> +					IBERROR("invalid vls value %ld", val);
> +				break;
> +			case MTU:
> +				if (val <= 0 || val > 5)
> +					IBERROR("invalid mtu value %ld", val);
> +				break;
> +			case LID:
> +				if (val <= 0 || val >= 0xC000)
> +					IBERROR("invalid lid value 0x%lx", val);
> +				break;
> +			case SMLID:
> +				if (val <= 0 || val >= 0xC000)
> +					IBERROR("invalid smlid value 0x%lx",
> +						val);
> +				break;
> +			case LMC:
> +				if (val < 0 || val > 7)
> +					IBERROR("invalid lmc value %ld", val);
> +			}
> +			*port_args[j].val = (int) val;
> +			changed = 1;
> +			break;
>  		}
> +		if (j == NPORT_ARGS)
> +			IBERROR("invalid operation: %s", argv[i]);
>  	}
> +	if (port_op < 0)
> +		port_op = QUERY;
>  
> -	err = get_node_info(&portid, data);
> -	if (err < 0)
> -		IBERROR("smp query nodeinfo failed");
> -	if (err) {		/* not switch */
> -		if (port_op == 0)	/* query op */
> -			is_switch = 0;
> -		else if (port_op == 2)	/* disable */
> -			IBERROR("Node type not switch - disable not allowed");
> -	}
> +	is_switch = get_node_info(&portid, data);
>  
> -	if (port_op)
> -		printf("Initial PortInfo:\n");
> +	if (port_op != QUERY || changed)
> +		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA");
>  	else
> -		printf("PortInfo:\n");
> -	err = get_port_info(&portid, data, portnum, port_op);
> -	if (err < 0)
> -		IBERROR("smp query portinfo failed");
> -
> -	/* Only if one of the "set" options is chosen */
> -	if (port_op) {
> -		if ((port_op == 1) || (port_op == 3)) {	/* Enable or Reset port */
> -			mad_set_field(data, 0, IB_PORT_PHYS_STATE_F, 2);	/* Polling */
> -			mad_set_field(data, 0, IB_PORT_STATE_F, 0);	/* No Change */
> -		} else if (port_op == 2) {	/* Disable port */
> +		printf("%s PortInfo:\n", is_switch ? "Switch" : "CA");
> +	get_port_info(&portid, data, portnum);
> +	show_port_info(&portid, data, portnum);
> +
> +	if (port_op != QUERY || changed) {
> +		/*
> +		 * If we aren't setting the LID and the LID is the default,
> +		 * the SMA command will fail due to an invalid LID.
> +		 * Set it to something unlikely but valid.
> +		 */
> +		val = mad_get_field(data, 0, IB_PORT_LID_F);
> +		if (!port_args[LID].set && (!val || val == 0xFFFF))
> +			mad_set_field(data, 0, IB_PORT_LID_F, 0x1234);
> +		val = mad_get_field(data, 0, IB_PORT_SMLID_F);
> +		if (!port_args[SMLID].set && (!val || val == 0xFFFF))
> +			mad_set_field(data, 0, IB_PORT_SMLID_F, 0x1234);
> +		mad_set_field(data, 0, IB_PORT_STATE_F, 0);       /* NOP */
> +		mad_set_field(data, 0, IB_PORT_PHYS_STATE_F, 0);  /* NOP */
> +
> +		switch (port_op) {
> +		case ENABLE:
> +		case RESET:
> +			/* Polling */
> +			mad_set_field(data, 0, IB_PORT_PHYS_STATE_F, 2);
> +			break;
> +		case DISABLE:
>  			printf("Disable may be irreversible\n");
> -			mad_set_field(data, 0, IB_PORT_STATE_F, 1);	/* Down */
> -			mad_set_field(data, 0, IB_PORT_PHYS_STATE_F, 3);	/* Disabled */
> -		} else if (port_op == 4) {	/* Set speed */
> +			mad_set_field(data, 0, IB_PORT_PHYS_STATE_F, 3);
> +			break;
> +		case DOWN:
> +			mad_set_field(data, 0, IB_PORT_STATE_F, 1);
> +			break;
> +		case ARM:
> +			mad_set_field(data, 0, IB_PORT_STATE_F, 3);
> +			break;
> +		case ACTIVE:
> +			mad_set_field(data, 0, IB_PORT_STATE_F, 4);
> +			break;
> +		}
> +		if (port_args[SPEED].set)
>  			mad_set_field(data, 0, IB_PORT_LINK_SPEED_ENABLED_F,
>  				      speed);
> -			mad_set_field(data, 0, IB_PORT_STATE_F, 0);
> -			mad_set_field(data, 0, IB_PORT_PHYS_STATE_F, 0);
> -		} else if (port_op == 5) {	/* Set width */
> +		if (port_args[WIDTH].set)
>  			mad_set_field(data, 0, IB_PORT_LINK_WIDTH_ENABLED_F,
>  				      width);
> -			mad_set_field(data, 0, IB_PORT_STATE_F, 0);
> -			mad_set_field(data, 0, IB_PORT_PHYS_STATE_F, 0);
> -		}
> +		if (port_args[VLS].set)
> +			mad_set_field(data, 0, IB_PORT_OPER_VLS_F, vls);
> +		if (port_args[MTU].set)
> +			mad_set_field(data, 0, IB_PORT_NEIGHBOR_MTU_F, mtu);
> +		if (port_args[LID].set)
> +			mad_set_field(data, 0, IB_PORT_LID_F, lid);
> +		if (port_args[SMLID].set)
> +			mad_set_field(data, 0, IB_PORT_SMLID_F, smlid);
> +		if (port_args[LMC].set)
> +			mad_set_field(data, 0, IB_PORT_LMC_F, lmc);
> +
> +		set_port_info(&portid, data, portnum);
>  
> -		err = set_port_info(&portid, data, portnum, port_op);
> -		if (err < 0)
> -			IBERROR("smp set portinfo failed");
> -		/* query op - only compare peer port if switch port, exclude SP0 */
>  	} else if (is_switch && portnum) {
>  		/* Now, make sure PortState is Active */
>  		/* Or is PortPhysicalState LinkUp sufficient ? */
> @@ -351,20 +445,15 @@ int main(int argc, char **argv)
>  			peerportid.drpath.drdlid = 0xffff;
>  
>  			/* Get peer port NodeInfo to obtain peer port number */
> -			err = get_node_info(&peerportid, data);
> -			if (err < 0)
> -				IBERROR("smp query nodeinfo failed");
> +			get_node_info(&peerportid, data);
>  
>  			mad_decode_field(data, IB_NODE_LOCAL_PORT_F,
>  					 &peerlocalportnum);
>  
>  			printf("Peer PortInfo:\n");
>  			/* Get peer port characteristics */
> -			err =
> -			    get_port_info(&peerportid, data, peerlocalportnum,
> -					  port_op);
> -			if (err < 0)
> -				IBERROR("smp query peer portinfo failed");
> +			get_port_info(&peerportid, data, peerlocalportnum);
> +			show_port_info(&peerportid, data, peerlocalportnum);
>  
>  			mad_decode_field(data, IB_PORT_LINK_WIDTH_ENABLED_F,
>  					 &peerlwe);
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
