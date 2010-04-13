From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 1/2] libibnetdisc: Convert to a multi-smp algorithm
Date: Tue, 13 Apr 2010 19:53:25 +0300
Message-ID: <20100413165325.GN10830@me>
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
> > +static int recv_port_info(smp_engine_t *engine, ibnd_smp_t * smp,
> > +			  uint8_t *mad, void *cb_data)
> > +{
> > +	ibnd_fabric_t *fabric = ((ibnd_scan_t *)engine->user_data)->fabric;
> > +	ibnd_node_t *node = (ibnd_node_t *)cb_data;
> > +	ibnd_port_t *port;
> > +	uint8_t *port_info = mad + IB_SMP_DATA_OFFS;
> > +	uint8_t port_num, local_port;
> > +
> > +	port_num = mad_get_field(mad, 0, IB_MAD_ATTRMOD_F);
> > +	local_port = mad_get_field(port_info, 0, IB_PORT_LOCAL_PORT_F);
> > +
> > +	/* this may have been created before */
> > +	port = node->ports[port_num];
> > +	if (!port) {
> > +		port = node->ports[port_num] = calloc(1, sizeof(*port));
> > +		if (!port) {
> > +			IBND_ERROR("Failed to allocate port\n");
> > +			return -1;
> > +		}
> > +	}
> > +
> > +	memcpy(port->info, port_info, sizeof(port->info));
> > +	port->node = node;
> > +	port->portnum = port_num;
> > +	port->ext_portnum = 0;
> > +	port->base_lid = (uint16_t) mad_get_field(port->info, 0, IB_PORT_LID_F);
> > +	port->lmc = (uint8_t) mad_get_field(port->info, 0, IB_PORT_LMC_F);
> > +
> > +	if (port_num == 0) {
> > +		node->smalid = port->base_lid;
> > +		node->smalmc = port->lmc;
> > +	} else if (node->type == IB_NODE_SWITCH) {
> > +		port->base_lid = node->smalid;
> > +		port->lmc = node->smalmc;
> > +	}
> > +
> > +	add_to_portguid_hash(port, fabric->portstbl);
> > +
> > +	debug_port(&smp->path, port);
> >  
> > -	mad_dump_node_type(type, 64, &node->type, sizeof(int));
> > -	printf("%s -> %s %s {%016" PRIx64 "} portnum %d base lid %d-%d\"%s\"\n",
> > -	       portid2str(path), prompt, type, node->guid,
> > -	       node->type == IB_NODE_SWITCH ? 0 : port->portnum,
> > -	       port->base_lid,
> > -	       port->base_lid + (1 << port->lmc) - 1, node->nodedesc);
> > +	if (port_num &&
> > +	    (mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
> > +	    == IB_PORT_PHYS_STATE_LINKUP)
> > +		&&
> > +	    (node->type == IB_NODE_SWITCH || node == fabric->from_node)) {
> 
> What will happen when ibnetdiscover runs from host connected by two
> ports to different subnets? Wouldn't it run over both fabrics (following
> PortInfo querying loop in recv_node_info() below)?

I tested with two connected ports. This doesn't work - it tries to cross
another fabric from another port of local node, but failed to send (CA
doesn't route MADs). So this case should be fixed as:

	if (port_num && port_state == IB_PORT_PHYS_STATE_LINKUP &&
	    ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
	     (node == fabric->from_node && port_num == local_port)))

Sasha

> 
> > +
> > +		ib_portid_t path = smp->path;
> > +		if (extend_dpath(engine, &path, port_num) != -1)
> > +			query_node_info(engine, &path, node);
> > +	}
> > +
> > +	return 0;
> > +}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
