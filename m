From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH v3 1/2] libibnetdisc: Convert to a multi-smp algorithm
Date: Tue, 13 Apr 2010 10:07:08 -0700
Message-ID: <20100413100708.2e1ce146.weiny2@llnl.gov>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
	<20100413104658.GA10830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100413104658.GA10830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 13 Apr 2010 13:46:58 +0300
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> On 12:49 Thu 18 Feb     , Ira Weiny wrote:
> > 
> > From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > Date: Fri, 22 Jan 2010 17:33:30 -0800
> > Subject: [PATCH] libibnetdisc: Convert to a multi-smp algorithm
> > 
> > v3: change DEFAULT_MAX_SMP_ON_WIRE to 2
> > 
> > 	Allow for multiple SMP's to be on the wire at a single time.  This
> > 	algorithm splits the processing of SMP's to a small smp engine which
> > 	may be useful to split out in the future.
> > 
> > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> 
> Applied. Thanks.
> 
> However see some comments and questions below.
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

Looking at the code I think you are right...  In practice, this does not happen...

I am still trying to figure out exactly why.

> 
> > +
> > +		ib_portid_t path = smp->path;
> > +		if (extend_dpath(engine, &path, port_num) != -1)
> > +			query_node_info(engine, &path, node);
> > +	}
> > +
> > +	return 0;
> > +}
> 
> [snip]
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
> 
> This one.
> 
> > +
> > +	return 0;
> > +}
> 
> [snip]
> 
> > diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
> > index 348bd0f..61b644d 100644
> > --- a/infiniband-diags/libibnetdisc/src/internal.h
> > +++ b/infiniband-diags/libibnetdisc/src/internal.h
> > @@ -39,6 +39,7 @@
> >  #define _INTERNAL_H_
> >  
> >  #include <infiniband/ibnetdisc.h>
> > +#include <complib/cl_qmap.h>
> 
> I'm not really happy with complib dependency introduction - we had an
> issues with it in the past.

I don't recall.  infiniband-diags is already dependant on opensm-libs.  We have, at least, the node name map dependency from complib already, so I did not think it was that big of a deal.

> 
> Also I think that we can implement simpler transaction tracker (likely
> even more efficient) by storing sent MADs in cyclic array and encoding
> its index as part of TRID.

I just thought code reuse was the way to go here.

> 
> >  
> >  #define	IBND_DEBUG(fmt, ...) \
> >  	if (ibdebug) { \
> > @@ -52,16 +53,44 @@
> >  
> >  #define MAXHOPS         63
> >  
> > -typedef struct ibnd_node_scan {
> > -	ibnd_node_t *node;
> > -	struct ibnd_node_scan *dnext;	/* nodesdist next */
> > -} ibnd_node_scan_t;
> > +#define DEFAULT_MAX_SMP_ON_WIRE 2
> >  
> >  typedef struct ibnd_scan {
> > -	ibnd_node_scan_t *nodesdist[MAXHOPS + 1];
> >  	ib_portid_t selfportid;
> > +	ibnd_fabric_t *fabric;
> >  } ibnd_scan_t;
> >  
> > +
> > +typedef struct ibnd_smp ibnd_smp_t;
> > +typedef struct smp_engine smp_engine_t;
> > +typedef int (*smp_comp_cb_t)(smp_engine_t *engine, ibnd_smp_t * smp,
> > +			     uint8_t *mad_resp, void *cb_data);
> > +struct ibnd_smp {
> > +	cl_map_item_t on_wire;
> > +	struct ibnd_smp * qnext;
> > +	smp_comp_cb_t cb;
> > +	void * cb_data;
> > +	ib_portid_t path;
> > +	ib_rpc_t rpc;
> > +};
> > +struct smp_engine {
> > +	struct ibmad_port *ibmad_port;
> > +	ibnd_smp_t *smp_queue_head;
> > +	ibnd_smp_t *smp_queue_tail;
> > +	void * user_data;
> > +	cl_qmap_t smps_on_wire;
> > +	int num_smps_outstanding;
> > +	int max_smps_on_wire;
> > +};
> > +
> > +void smp_engine_init(smp_engine_t * engine, struct ibmad_port *ibmad_port,
> > +		     void * user_data, int max_smps_on_wire);
> > +int issue_smp(smp_engine_t *engine, ib_portid_t * portid,
> > +	      unsigned attrid, unsigned mod,
> > +	      smp_comp_cb_t cb, void * cb_data);
> > +int process_mads(smp_engine_t *engine);
> > +void smp_engine_destroy(smp_engine_t *engine);
> > +
> >  void add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[]);
> >  
> >  void add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[]);
> > diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
> > new file mode 100644
> > index 0000000..5571314
> > --- /dev/null
> > +++ b/infiniband-diags/libibnetdisc/src/query_smp.c
> > @@ -0,0 +1,249 @@
> > +/*
> > + * Copyright (c) 2010 Lawrence Livermore National Laboratory
> > + *
> > + * This software is available to you under a choice of one of two
> > + * licenses.  You may choose to be licensed under the terms of the GNU
> > + * General Public License (GPL) Version 2, available from the file
> > + * COPYING in the main directory of this source tree, or the
> > + * OpenIB.org BSD license below:
> > + *
> > + *     Redistribution and use in source and binary forms, with or
> > + *     without modification, are permitted provided that the following
> > + *     conditions are met:
> > + *
> > + *      - Redistributions of source code must retain the above
> > + *        copyright notice, this list of conditions and the following
> > + *        disclaimer.
> > + *
> > + *      - Redistributions in binary form must reproduce the above
> > + *        copyright notice, this list of conditions and the following
> > + *        disclaimer in the documentation and/or other materials
> > + *        provided with the distribution.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> > + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> > + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> > + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> > + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> > + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> > + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> > + * SOFTWARE.
> > + *
> > + */
> > +
> > +#include <errno.h>
> > +#include <infiniband/ibnetdisc.h>
> > +#include <infiniband/umad.h>
> > +#include "internal.h"
> > +
> > +void
> > +queue_smp(smp_engine_t *engine, ibnd_smp_t *smp)
> > +{
> > +	smp->qnext = NULL;
> > +	if (!engine->smp_queue_head) {
> > +		engine->smp_queue_head = smp;
> > +		engine->smp_queue_tail = smp;
> > +	} else {
> > +		engine->smp_queue_tail->qnext = smp;
> > +		engine->smp_queue_tail = smp;
> > +	}
> > +}
> > +
> > +ibnd_smp_t *
> > +get_smp(smp_engine_t *engine)
> > +{
> > +	ibnd_smp_t *head = engine->smp_queue_head;
> > +	ibnd_smp_t *tail = engine->smp_queue_tail;
> > +	ibnd_smp_t *rc = head;
> > +	if (head) {
> > +		if (tail == head)
> > +			engine->smp_queue_tail = NULL;
> > +		engine->smp_queue_head = head->qnext;
> > +	}
> > +	return rc;
> > +}
> > +
> > +int send_smp(ibnd_smp_t * smp, struct ibmad_port *srcport)
> > +{
> > +	int rc = 0;
> > +	uint8_t umad[1024];
> > +	ib_rpc_t *rpc = &smp->rpc;
> > +
> > +	memset(umad, 0, umad_size() + IB_MAD_SIZE);
> > +
> > +	if ((rc = mad_build_pkt(umad, &smp->rpc, &smp->path, NULL, NULL))
> > +	    < 0) {
> > +		IBND_ERROR("mad_build_pkt failed; %d", rc);
> > +		return rc;
> > +	}
> > +
> > +	if ((rc = umad_send(mad_rpc_portid(srcport),
> > +			    mad_rpc_class_agent(srcport, rpc->mgtclass),
> > +			    umad, IB_MAD_SIZE,
> > +			    mad_get_timeout(srcport, rpc->timeout),
> > +			    mad_get_retries(srcport))) < 0) {
> > +		IBND_ERROR("send failed; %d", rc);
> > +		return rc;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int process_smp_queue(smp_engine_t *engine)
> > +{
> > +	int rc = 0;
> > +	ibnd_smp_t *smp;
> > +	while (cl_qmap_count(&engine->smps_on_wire) < engine->max_smps_on_wire) {
> > +		smp = get_smp(engine);
> > +		if (!smp)
> > +			return 0;
> > +
> > +		cl_qmap_insert(&engine->smps_on_wire, (uint32_t)smp->rpc.trid,
> > +			       (cl_map_item_t *)smp);
> > +		if ((rc = send_smp(smp, engine->ibmad_port)) != 0)
> > +			return rc;
> > +	}
> > +	return 0;
> > +}
> > +
> > +int issue_smp(smp_engine_t *engine, ib_portid_t * portid,
> > +	      unsigned attrid, unsigned mod,
> > +	      smp_comp_cb_t cb, void * cb_data)
> > +{
> > +	ibnd_smp_t *smp = calloc(1, sizeof *smp);
> > +	if (!smp) {
> > +		IBND_ERROR("OOM");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	smp->cb = cb;
> > +	smp->cb_data = cb_data;
> > +	smp->path = *portid;
> > +	smp->rpc.method = IB_MAD_METHOD_GET;
> > +	smp->rpc.attr.id = attrid;
> > +	smp->rpc.attr.mod = mod;
> > +	smp->rpc.timeout = mad_get_timeout(engine->ibmad_port, 0);
> > +	smp->rpc.datasz = IB_SMP_DATA_SIZE;
> > +	smp->rpc.dataoffs = IB_SMP_DATA_OFFS;
> > +	smp->rpc.trid = mad_trid();
> 
> BTW, by reviewing mad_trid() code in libibmad:
> 
> uint64_t mad_trid(void)
> {
> 	static uint64_t base;
> 	static uint64_t trid;
> 	uint64_t next;
> 
> 	if (!base) {
> 		srandom((int)time(0) * getpid());
> 		base = random();
> 		trid = random();
> 	}
> 	next = ++trid | (base << 32);
> 	return next;
> }
> 
> For me it doesn't look as thread safe function.

It's not!  The whole of libibmad is not thread safe!  (Ok perhaps just the parts I was using before.)  But we are not using threads here, right?

> 
> > +
> > +	if ((portid->lid <= 0) ||
> > +	    (portid->drpath.drslid == 0xffff) ||
> > +	    (portid->drpath.drdlid == 0xffff))
> > +		smp->rpc.mgtclass = IB_SMI_DIRECT_CLASS; /* direct SMI */
> > +	else
> > +		smp->rpc.mgtclass = IB_SMI_CLASS; /* Lid routed SMI */
> > +
> > +	portid->sl = 0;
> > +	portid->qp = 0;
> > +
> > +	engine->num_smps_outstanding++;
> > +	queue_smp(engine, smp);
> > +	return (process_smp_queue(engine));
> > +}
> > +
> > +int process_one_recv(smp_engine_t *engine)
> > +{
> > +	int rc = 0;
> > +	int status = 0;
> > +	ibnd_smp_t *smp;
> > +	uint8_t *mad;
> > +	uint32_t trid;
> > +	uint8_t umad[umad_size() + IB_MAD_SIZE];
> > +	int length = umad_size() + IB_MAD_SIZE;
> > +
> > +	memset(umad, 0, sizeof(umad));
> > +
> > +	/* wait for the next message */
> > +	if ((rc = umad_recv(mad_rpc_portid(engine->ibmad_port), umad, &length,
> > +			    0)) < 0) {
> > +		if (rc == -EWOULDBLOCK)
> > +			return 0;
> > +		IBND_ERROR("umad_recv failed: %d\n", rc);
> > +		return -1;
> > +	}
> > +
> > +	rc = process_smp_queue(engine);
> > +
> > +	mad = umad_get_mad(umad);
> > +	trid = (uint32_t)mad_get_field64(mad, 0, IB_MAD_TRID_F);
> > +
> > +	smp = (ibnd_smp_t *)cl_qmap_remove(&engine->smps_on_wire, trid);
> > +	if ((cl_map_item_t *)smp == cl_qmap_end(&engine->smps_on_wire)) {
> > +		IBND_ERROR("Failed to find matching smp for trid (%x)\n",
> > +			   trid);
> > +		return -1;
> > +	}
> > +
> > +	if (rc)
> > +		goto error;
> > +
> > +	if ((status = umad_status(umad))) {
> > +		IBND_ERROR("umad (%s Attr 0x%x:%u) bad status %d; %s\n",
> > +			portid2str(&smp->path),
> > +			smp->rpc.attr.id, smp->rpc.attr.mod,
> > +			status, strerror(status));
> > +	} else if ((status = mad_get_field(mad, 0, IB_DRSMP_STATUS_F))) {
> > +			IBND_ERROR("mad (%s Attr 0x%x:%u) bad status 0x%x\n",
> > +				   portid2str(&smp->path),
> > +				   smp->rpc.attr.id, smp->rpc.attr.mod,
> > +				   status);
> > +	} else
> > +		rc = smp->cb(engine, smp, mad, smp->cb_data);
> > +
> > +error:
> > +	free(smp);
> > +	engine->num_smps_outstanding--;
> > +	return (rc);
> > +}
> > +
> > +void smp_engine_init(smp_engine_t * engine, struct ibmad_port *ibmad_port,
> > +		     void * user_data, int max_smps_on_wire)
> > +{
> > +	memset(engine, '\0', sizeof(*engine));
> > +	engine->ibmad_port = ibmad_port;
> > +	engine->user_data = user_data;
> > +	cl_qmap_init(&engine->smps_on_wire);
> > +	engine->num_smps_outstanding = 0;
> > +	engine->max_smps_on_wire = max_smps_on_wire;
> > +}
> > +
> > +void smp_engine_destroy(smp_engine_t *engine)
> > +{
> > +	cl_map_item_t *item;
> > +	ibnd_smp_t *smp;
> > +
> > +	/* remove queued smps */
> > +	smp = get_smp(engine);
> > +	if (smp)
> > +		IBND_ERROR("outstanding SMP's\n");
> > +	for (/* */; smp; smp = get_smp(engine)) {
> > +		free(smp);
> > +	}
> > +
> > +	/* remove smps from the wire queue */
> > +	item = cl_qmap_head(&engine->smps_on_wire);
> > +	if (item != cl_qmap_end(&engine->smps_on_wire))
> > +		IBND_ERROR("outstanding SMP's on wire\n");
> > +	for (/* */; item != cl_qmap_end(&engine->smps_on_wire);
> > +	     item = cl_qmap_head(&engine->smps_on_wire)) {
> > +		cl_qmap_remove_item(&engine->smps_on_wire, item);
> > +		free(item);
> > +	}
> > +
> > +	engine->num_smps_outstanding = 0;
> > +}
> > +
> > +int process_mads(smp_engine_t *engine)
> > +{
> > +	int rc = 0;
> > +	while (engine->num_smps_outstanding > 0) {
> > +		if ((rc = process_smp_queue(engine)) != 0)
> > +			return rc;
> 
> Is it really needed to run process_smp_queue() here (assuming that it is
> already executed in issue_smp() and process_one_recv())? Or this is just
> for handling process_one_recv() error case? If so wouldn't it better to
> run it there?

Yes I was looking at that yesterday.  Since we are not threaded I just wanted to make sure that there were some messages on the wire before we went into the processing loop.  I will send a patch after I have tested everything out.

Ira

> 
> Sasha
> 
> > +		while (!cl_is_qmap_empty(&engine->smps_on_wire))
> > +			if ((rc = process_one_recv(engine)) != 0)
> > +				return rc;
> > +	}
> > +	return 0;
> > +}
> > +
> > -- 
> > 1.5.4.5
> > 


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
