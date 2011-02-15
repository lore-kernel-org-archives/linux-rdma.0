From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: add support for ibnetdiscover
 grouping for Mellanox switches
Date: Mon, 14 Feb 2011 16:06:36 -0800
Message-ID: <20110214160636.117b3e1e.weiny2@llnl.gov>
References: <4D52B595.3020302@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D52B595.3020302-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tamir Ronen <tamirr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tamir,

I have this in a for-next branch.  Can someone from Mellanox verify this will work on all their switches.  I did not think they always labeled their switches this way but perhaps they do.

Can the user program node descriptors in those chassis?  I thought this was possible but I am unable to verify this today.

Ira


On Wed, 9 Feb 2011 07:41:09 -0800
Tamir Ronen <tamirr-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> 
> From f1c92f4cae5605dec338b52ac6b261ddbe6e5609 Mon Sep 17 00:00:00 2001
> From: Tamir Ronen <tamirr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> Date: Tue, 8 Feb 2011 13:01:22 +0200
> Subject: [PATCH] add support for ibnetdiscover grouping for Mellanox switches
> 
> Group Mellanox switches to the same chassis using SYSTEM_GUID
> Use the node description format:
> 'MF0;<system name>:<system type>/<system slot name>[:board type]/U<node index>'
> to identify system type, slot type Line/Spine, slotnum and anafanum.
> Map Line ports 1-18 as external ports 1-18.
> ---
>  .../libibnetdisc/include/infiniband/ibnetdisc.h    |    3 +
>  infiniband-diags/libibnetdisc/src/chassis.c        |  220 ++++++++++++++++++-
>  infiniband-diags/libibnetdisc/src/chassis.h        |    3 +
>  3 files changed, 214 insertions(+), 12 deletions(-)
> 
> diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
> index 935e427..1efd1d6 100644
> --- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
> +++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
> @@ -43,6 +43,8 @@
>  struct ibnd_chassis;		/* forward declare */
>  struct ibnd_port;		/* forward declare */
>  
> +#define CHASSIS_TYPE_SIZE 20
> +
>  /** =========================================================================
>   * Node
>   */
> @@ -80,6 +82,7 @@ typedef struct ibnd_node {
>  	struct ibnd_node *next_chassis_node;	/* next node in ibnd_chassis_t->nodes */
>  	struct ibnd_chassis *chassis;	/* if != NULL the chassis this node belongs to */
>  	unsigned char ch_type;
> +	char ch_type_str[CHASSIS_TYPE_SIZE];
>  	unsigned char ch_anafanum;
>  	unsigned char ch_slotnum;
>  	unsigned char ch_slot;
> diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
> index 6bfc45b..3d90034 100644
> --- a/infiniband-diags/libibnetdisc/src/chassis.c
> +++ b/infiniband-diags/libibnetdisc/src/chassis.c
> @@ -62,30 +62,53 @@ typedef struct chassis_scan {
>  
>  char *ibnd_get_chassis_type(ibnd_node_t * node)
>  {
> +	int chassis_type;
> +
>  	if (!node) {
>  		IBND_DEBUG("node parameter NULL\n");
>  		return NULL;
>  	}
>  
> -	/* Currently, only if Voltaire chassis */
> -	if (mad_get_field(node->info, 0, IB_NODE_VENDORID_F) != VTR_VENDOR_ID)
> -		return NULL;
>  	if (!node->chassis)
>  		return NULL;
> -	if (node->ch_type == UNRESOLVED_CT || node->ch_type > ISR4200_CT)
> -		return NULL;
> -	return ChassisTypeStr[node->ch_type];
> +
> +	chassis_type = mad_get_field(node->info, 0, IB_NODE_VENDORID_F);
> +
> +	switch (chassis_type)
> +	{
> +		case VTR_VENDOR_ID: /* Voltaire chassis */
> +		{
> +			if (node->ch_type == UNRESOLVED_CT || node->ch_type > ISR4200_CT)
> +				return NULL;
> +			return ChassisTypeStr[node->ch_type];
> +		}
> +		case MLX_VENDOR_ID:
> +		{
> +			if (node->ch_type_str[0] == '\0')
> +				return NULL;
> +			return node->ch_type_str;
> +		}
> +		default:
> +		{
> +			break;
> +		}
> +	}
> +	return NULL;
>  }
>  
>  char *ibnd_get_chassis_slot_str(ibnd_node_t * node, char *str, size_t size)
>  {
> +	int vendor_id;
> +
>  	if (!node) {
>  		IBND_DEBUG("node parameter NULL\n");
>  		return NULL;
>  	}
>  
> -	/* Currently, only if Voltaire chassis */
> -	if (mad_get_field(node->info, 0, IB_NODE_VENDORID_F) != VTR_VENDOR_ID)
> +	/* Currently, only if Voltaire or Mellanox chassis */
> +	vendor_id = mad_get_field(node->info, 0,IB_NODE_VENDORID_F);
> +
> +	if ((vendor_id != VTR_VENDOR_ID) && (vendor_id != MLX_VENDOR_ID))
>  		return NULL;
>  	if (!node->chassis)
>  		return NULL;
> @@ -574,6 +597,166 @@ static int get_slb_slot(ibnd_node_t * n, ibnd_port_t * spineport)
>  	return 0;
>  }
>  
> +
> +/*
> +	This function called for every Mellanox node in fabric
> +*/
> +static int fill_mellanox_chassis_record(ibnd_node_t * node)
> +{
> +	int p = 0;
> +	ibnd_port_t *port;
> +
> +	char node_desc[IB_SMP_DATA_SIZE];
> +	char *system_name;
> +	char *system_type;
> +	char *system_slot_name;
> +	char *node_index;
> +	char *iter;
> +	int dev_id;
> +
> +	/*
> +	The node description has the following format:
> +
> +	'MF0;<system name>:<system type>/<system slot name>[:board type]/U<node index>'
> +
> +     - System slot name in our systems can be L[01-36] , S[01-18]
> +     - Node index is always 1 (we don.t have boards with multiple IS4 chips).
> +     - System name is taken from the currently configured host name.
> +     -The board type is optional and we don.t set it currently  - A leaf or spine slot can currently hold a single type of board.
> +	 */
> +
> +	memcpy(node_desc, node->nodedesc, IB_SMP_DATA_SIZE);
> +
> +	IBND_DEBUG("fill_mellanox_chassis_record: node_desc:%s \n",node_desc);
> +
> +	if (node->ch_found)	/* somehow this node has already been passed */
> +		return 0;
> +
> +	/* All mellanox IS4 switches have the same vendor id*/
> +	dev_id = mad_get_field(node->info, 0,IB_NODE_DEVID_F);
> +	if (dev_id != MLX_DEVID_IS4)
> +		return 0;
> +
> +	if((node_desc[0] != 'M') ||
> +	   (node_desc[1] != 'F') ||
> +	   (node_desc[2] != '0') ||
> +	   (node_desc[3] != ';')) {
> +		IBND_DEBUG("fill_mellanox_chassis_record: Unsupported node description format:%s \n",node_desc);
> +		return 0;
> +	}
> +
> +	/* parse system name*/
> +	system_name = &node_desc[4];
> +	for (iter = system_name ; (*iter != ':') && (*iter != '\0') ; iter++);
> +	if(*iter == '\0'){
> +		IBND_DEBUG("fill_mellanox_chassis_record: Unsupported node description format:%s - (get system_name failed) \n",node_desc);
> +		return 0;
> +	}
> +	*iter = '\0';
> +	iter++;
> +	/* parse system type*/
> +	system_type = iter;
> +	for ( ; (*iter != '/') && (*iter != '\0') ; iter++);
> +	if(*iter == '\0'){
> +		IBND_DEBUG("fill_mellanox_chassis_record: Unsupported node description format:%s - (get system_type failed) \n",node_desc);
> +		return 0;
> +	}
> +	*iter = '\0';
> +	iter++;
> +	/* parse system slot name*/
> +	system_slot_name = iter;
> +	for ( ; (*iter != '/') && (*iter != ':') && (*iter != '\0') ; iter++);
> +	if(*iter == '\0'){
> +		IBND_DEBUG("fill_mellanox_chassis_record: Unsupported node description format:%s - (get system_slot_name failed) \n",node_desc);
> +		return 0;
> +	}
> +	if(*iter == ':'){
> +		*iter = '\0';
> +		iter++;
> +		for ( ; (*iter != '/') && (*iter != '\0') ; iter++);
> +		if(*iter == '\0'){
> +			IBND_DEBUG("fill_mellanox_chassis_record: Unsupported node description format:%s - (get board type failed) \n",node_desc);
> +			return 0;
> +		}
> +	}
> +	*iter = '\0';
> +	iter++;
> +	node_index = iter;
> +	if(node_index[0] != 'U'){
> +		IBND_DEBUG("fill_mellanox_chassis_record: Unsupported node description format:%s - (get node index) \n",node_desc);
> +		return 0;
> +	}
> +
> +	/* set Chip number (node index) */
> +	node->ch_anafanum = atoi(&node_index[1]);
> +	if(node->ch_anafanum != 1){
> +		IBND_DEBUG("Unexpected Chip number:%d \n",node->ch_anafanum);
> +	}
> +
> +
> +	/* set Line Spine numbers */
> +	if(system_slot_name[0] == 'L')
> +		node->ch_slot = LINE_CS;
> +	else if(system_slot_name[0] == 'S')
> +		node->ch_slot = SPINE_CS;
> +	else{
> +		IBND_DEBUG("fill_mellanox_chassis_record: Unsupported system_slot_name:%s \n",system_slot_name);
> +		return 0;
> +	}
> +
> +	/* The switch will be displayed under Line or Spine and not under Chassis switches */
> +	node->ch_found = 1;
> +
> +	node->ch_slotnum = atoi(&system_slot_name[1]);
> +	if((node->ch_slot == LINE_CS && (node->ch_slotnum >  (LINES_MAX_NUM + 1))) ||
> +	   (node->ch_slot == SPINE_CS && (node->ch_slotnum > (SPINES_MAX_NUM + 1)))){
> +		IBND_ERROR("fill_mellanox_chassis_record: invalid slot number:%d \n",node->ch_slotnum);
> +		node->ch_slotnum = 0;
> +		return 0;
> +	}
> +
> +	/*set ch_type_str*/
> +	strncpy(node->ch_type_str , system_type, sizeof(node->ch_type_str)-1);
> +
> +	/* Line ports 1-18 are mapped to external ports 1-18*/
> +	if(node->ch_slot == LINE_CS)
> +	{
> +		for (p = 1; p <= node->numports && p <= 18 ; p++) {
> +			port = node->ports[p];
> +			if (!port)
> +				continue;
> +			port->ext_portnum = p;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int insert_mellanox_line_and_spine(ibnd_node_t * node, ibnd_chassis_t * chassis)
> +{
> +	if (node->ch_slot == LINE_CS){
> +
> +		if (chassis->linenode[node->ch_slotnum])
> +			return 0;	/* already filled slot */
> +
> +		chassis->linenode[node->ch_slotnum] = node;
> +	}
> +	else if (node->ch_slot == SPINE_CS){
> +
> +		if (chassis->spinenode[node->ch_slotnum])
> +			return 0;	/* already filled slot */
> +
> +		chassis->spinenode[node->ch_slotnum] = node;
> +	}
> +	else
> +		return 0;
> +
> +	node->chassis = chassis;
> +
> +	return 0;
> +}
> +
> +
>  /* forward declare this */
>  static void voltaire_portmap(ibnd_port_t * port);
>  /*
> @@ -1064,15 +1247,23 @@ int group_nodes(ibnd_fabric_t * fabric)
>  	chassis_scan.current_chassis = NULL;
>  	chassis_scan.last_chassis = NULL;
>  
> +	int vendor_id;
> +
>  	/* first pass on switches and build for every Voltaire node */
>  	/* an appropriate chassis record (slotnum and position) */
>  	/* according to internal connectivity */
>  	/* not very efficient but clear code so... */
>  	for (node = fabric->switches; node; node = node->type_next) {
> -		if (mad_get_field(node->info, 0,
> -				  IB_NODE_VENDORID_F) == VTR_VENDOR_ID
> +
> +		vendor_id = mad_get_field(node->info, 0,IB_NODE_VENDORID_F);
> +
> +		if (vendor_id == VTR_VENDOR_ID
>  		    && fill_voltaire_chassis_record(node))
>  			goto cleanup;
> +		else if (vendor_id == MLX_VENDOR_ID
> +			&& fill_mellanox_chassis_record(node))
> +			goto cleanup;
> +
>  	}
>  
>  	/* separate every Voltaire chassis from each other and build linked list of them */
> @@ -1118,8 +1309,10 @@ int group_nodes(ibnd_fabric_t * fabric)
>  	/* now, make another pass to see which nodes are part of chassis */
>  	/* (defined as chassis->nodecount > 1) */
>  	for (node = fabric->nodes; node; node = node->next) {
> -		if (mad_get_field(node->info, 0,
> -				  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
> +
> +		vendor_id = mad_get_field(node->info, 0,IB_NODE_VENDORID_F);
> +
> +		if (vendor_id == VTR_VENDOR_ID)
>  			continue;
>  		if (mad_get_field64(node->info, 0, IB_NODE_SYSTEM_GUID_F)) {
>  			chassis = find_chassisguid(fabric, node);
> @@ -1130,6 +1323,9 @@ int group_nodes(ibnd_fabric_t * fabric)
>  					node->ch_found = 1;
>  					add_node_to_chassis(chassis, node);
>  				}
> +				else if (vendor_id == MLX_VENDOR_ID){
> +					insert_mellanox_line_and_spine(node, chassis);
> +				}
>  			}
>  		}
>  	}
> diff --git a/infiniband-diags/libibnetdisc/src/chassis.h b/infiniband-diags/libibnetdisc/src/chassis.h
> index 004156e..7a91be3 100644
> --- a/infiniband-diags/libibnetdisc/src/chassis.h
> +++ b/infiniband-diags/libibnetdisc/src/chassis.h
> @@ -75,8 +75,11 @@
>  #define VTR_DEVID_SFB4700X2		0x5a5d
>  #define VTR_DEVID_SFB4200		0x5a60
>  
> +#define MLX_DEVID_IS4			0xbd36
> +
>  /* Vendor IDs (for chassis based systems) */
>  #define VTR_VENDOR_ID			0x8f1	/* Voltaire */
> +#define MLX_VENDOR_ID			0x2c9	/* Mellanox */
>  #define TS_VENDOR_ID			0x5ad	/* Cisco */
>  #define SS_VENDOR_ID			0x66a	/* InfiniCon */
>  #define XS_VENDOR_ID			0x1397	/* Xsigo */
> -- 
> 1.5.5.6
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
