From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 1/2] libibnetdisc: Convert to a multi-smp algorithm
Date: Tue, 13 Apr 2010 20:18:24 +0300
Message-ID: <20100413171824.GP10830@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413104658.GA10830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100413104658.GA10830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:46 Tue 13 Apr     , Sasha Khapyorsky wrote:
> 
> > +static int recv_node_info(smp_engine_t *engine, ibnd_smp_t * smp,
> > +			  uint8_t *mad, void *cb_data)
> > +{
> > +	ibnd_fabric_t *fabric = ((ibnd_scan_t *)engine->user_data)->fabric;
> > +	int i = 0;
> > +	uint8_t *node_info = mad + IB_SMP_DATA_OFFS;
> > +	ibnd_node_t * rem_node = (ibnd_node_t *)cb_data;
> >  	ibnd_node_t *node;
> > +	int node_is_new = 0;
> > +	uint64_t node_guid = mad_get_field64(node_info, 0, IB_NODE_GUID_F);
> > +	uint64_t port_guid = mad_get_field64(node_info, 0, IB_NODE_PORT_GUID_F);
> > +	int port_num = mad_get_field(node_info, 0, IB_NODE_LOCAL_PORT_F);
> > +	ibnd_port_t *port = NULL;
> >  
> > -	for (node = fabric->nodestbl[hash]; node; node = node->htnext)
> > -		if (node->guid == new->guid)
> > -			return node;
> > +	node = ibnd_find_node_guid(fabric, node_guid);
> > +	if (!node) {
> > +		node = create_node(engine, &smp->path, node_info);
> > +		if (!node)
> > +			return -1;
> > +		node_is_new = 1;
> > +	}
> > +	IBND_DEBUG("Found %s node GUID %lx (%s)\n",
> > +		   (node_is_new) ? "new": "old", node->guid,
> > +		   portid2str(&smp->path));
> >  
> > -	return NULL;
> > +	port = node->ports[port_num];
> > +	if (!port) {
> > +		/* If we have not see this port before create a shell for it */
> > +		port = node->ports[port_num] = calloc(1, sizeof(*port));
> > +		port->node = node;
> > +		port->portnum = port_num;
> > +	}
> > +	port->guid = port_guid;
> > +
> > +	if (rem_node == NULL) /* this is the start node */
> > +		fabric->from_node = node;
> > +	else {
> > +		/* link ports... */
> > +		int rem_port_num = get_last_port(&smp->path);
> > +
> > +		if (!rem_node->ports[rem_port_num]) {
> > +			IBND_ERROR("Internal Error; "
> > +				   "Node(%p) %lx Port %d no port created!?!?!?\n\n",
> > +				   rem_node, rem_node->guid, rem_port_num);
> > +			return (-1);
> > +		}
> > +
> > +		link_ports(node, port, rem_node, rem_node->ports[rem_port_num]);
> > +	}
> > +
> > +	if (!node_is_new)
> > +		return 0;
> > +
> > +	query_node_desc(engine, &smp->path, node);
> > +
> > +	if (node->type == IB_NODE_SWITCH)
> > +		query_switch_info(engine, &smp->path, node);
> > +
> > +	/* process all the ports on this node */
> > +	for (i = (node->type == IB_NODE_SWITCH) ? 0 : 1;
> > +		i <= node->numports; i++) {
> > +			query_port_info(engine, &smp->path, node, i);
> > +	}

Actually it seems possible to save some MADs by not querying CA/Router
ports which is not connected to our fabric. Something like this:

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 2ce15b7..1c7d6f2 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -339,19 +339,16 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 		link_ports(node, port, rem_node, rem_node->ports[rem_port_num]);
 	}
 
-	if (!node_is_new)
-		return 0;
-
-	query_node_desc(engine, &smp->path, node);
-
-	if (node->type == IB_NODE_SWITCH)
-		query_switch_info(engine, &smp->path, node);
+	if (node_is_new) {
+		query_node_desc(engine, &smp->path, node);
 
-	/* process all the ports on this node */
-	for (i = (node->type == IB_NODE_SWITCH) ? 0 : 1;
-	     i <= node->numports; i++) {
-		query_port_info(engine, &smp->path, node, i);
-	}
+		if (node->type == IB_NODE_SWITCH) {
+			query_switch_info(engine, &smp->path, node);
+			for (i = 0; i <= node->numports; i++)
+				query_port_info(engine, &smp->path, node, i);
+		}
+	} else if (node->type != IB_NODE_SWITCH)
+		query_port_info(engine, &smp->path, node, port_num);
 
 	return 0;
 }


What do you think?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
