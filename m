From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 1/2] infiniband-diags: libibnetdisc add find node by lid
Date: Sun, 3 Feb 2013 14:45:11 -0800
Message-ID: <20130203144511.1545db69c5c2fd33061413f3@llnl.gov>
References: <20130202163628.5f4693217bc8008ccfd18308@llnl.gov>
	<510E83F3.80104@dev.mellanox.co.il>
	<20130203132025.d5f197394ae711d048d28bd5@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130203132025.d5f197394ae711d048d28bd5-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 3 Feb 2013 13:20:25 -0800
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

> On Sun, 03 Feb 2013 10:36:19 -0500
> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
> > On 2/2/2013 7:36 PM, Ira Weiny wrote:
> > > 
> > > 

[snip]

> > > +
> > > +	/* We add the port for all "lmc" lids
> > > +	 * so it is easier to find for any "random" lid specified */
> > > +	for (lid = base_lid; lid <= (base_lid + lid_mask); lid++) {
> > > +		uint16_t *lidp = calloc(1, sizeof(*lidp));
> > > +		*lidp = lid;
> > > +		g_hash_table_insert(htable, lidp, port);
> > 
> > calloc error should be handled
> 
> Yes and I should have specified "free" in g_hash_table_new_full for the key object.

There is a better way to do this by storing the lid as the pointer:

http://developer.gnome.org/glib/2.31/glib-Hash-Tables.html#g-direct-equal

Ira

> 
> Thanks,
> Ira
> 
> > 
> > -- Hal
> > 
> > > +	}
> > > +}
> > > +
> > >  void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
> > >  {
> > >  	switch (node->type) {
> > > @@ -664,6 +695,12 @@ static int set_config(struct ibnd_config *config, struct ibnd_config *cfg)
> > >  	return (0);
> > >  }
> > >  
> > > +static ibnd_fabric_t *allocate_fabric(void)
> > > +{
> > > +	f_internal_t *f = calloc(1, sizeof(*f));
> > > +	return ((ibnd_fabric_t *)f);
> > > +}
> > > +
> > >  ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
> > >  				    ib_portid_t * from,
> > >  				    struct ibnd_config *cfg)
> > > @@ -685,7 +722,7 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
> > >  		return NULL;
> > >  	}
> > >  
> > > -	fabric = calloc(1, sizeof(*fabric));
> > > +	fabric = allocate_fabric();
> > >  	if (!fabric) {
> > >  		IBND_ERROR("OOM: failed to calloc ibnd_fabric_t\n");
> > >  		return NULL;
> > > @@ -715,6 +752,8 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
> > >  
> > >  	IBND_DEBUG("from %s\n", portid2str(from));
> > >  
> > > +	create_lid2guid(fabric);
> > > +
> > >  	if (!query_node_info(&engine, from, NULL))
> > >  		if (process_mads(&engine) != 0)
> > >  			goto error;
> > > @@ -768,6 +807,7 @@ void ibnd_destroy_fabric(ibnd_fabric_t * fabric)
> > >  		destroy_node(node);
> > >  		node = next;
> > >  	}
> > > +	destroy_lid2guid(fabric);
> > >  	free(fabric);
> > >  }
> > >  
> > > @@ -825,6 +865,17 @@ void ibnd_iter_nodes_type(ibnd_fabric_t * fabric, ibnd_iter_node_func_t func,
> > >  		func(cur, user_data);
> > >  }
> > >  
> > > +ibnd_port_t *ibnd_find_port_lid(ibnd_fabric_t * fabric,
> > > +				uint16_t lid)
> > > +{
> > > +	ibnd_port_t *port;
> > > +	f_internal_t *f = (f_internal_t *)fabric;
> > > +
> > > +	port = (ibnd_port_t *)g_hash_table_lookup(f->lid2guid, &lid);
> > > +
> > > +	return port;
> > > +}
> > > +
> > >  ibnd_port_t *ibnd_find_port_guid(ibnd_fabric_t * fabric, uint64_t guid)
> > >  {
> > >  	int hash = HASHGUID(guid) % HTSZ;
> > > diff --git a/libibnetdisc/src/internal.h b/libibnetdisc/src/internal.h
> > > index 80918c4..b7e18e8 100644
> > > --- a/libibnetdisc/src/internal.h
> > > +++ b/libibnetdisc/src/internal.h
> > > @@ -40,6 +40,7 @@
> > >  
> > >  #include <infiniband/ibnetdisc.h>
> > >  #include <complib/cl_qmap.h>
> > > +#include <glib.h>
> > >  
> > >  #define	IBND_DEBUG(fmt, ...) \
> > >  	if (ibdebug) { \
> > > @@ -57,6 +58,11 @@
> > >  #define DEFAULT_TIMEOUT 1000
> > >  #define DEFAULT_RETRIES 3
> > >  
> > > +typedef struct f_internal {
> > > +	ibnd_fabric_t fabric;
> > > +	GHashTable *lid2guid;
> > > +} f_internal_t;
> > > +
> > >  typedef struct ibnd_scan {
> > >  	ib_portid_t selfportid;
> > >  	ibnd_fabric_t *fabric;
> > > @@ -100,6 +106,7 @@ void smp_engine_destroy(smp_engine_t * engine);
> > >  void add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[]);
> > >  
> > >  void add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[]);
> > > +void add_to_portlid_hash(ibnd_port_t * port, GHashTable *htable);
> > >  
> > >  void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric);
> > >  
> > > diff --git a/libibnetdisc/src/libibnetdisc.map b/libibnetdisc/src/libibnetdisc.map
> > > index 1c42e7b..f1b7229 100644
> > > --- a/libibnetdisc/src/libibnetdisc.map
> > > +++ b/libibnetdisc/src/libibnetdisc.map
> > > @@ -16,6 +16,7 @@ IBNETDISC_1.0 {
> > >  		ibnd_iter_nodes_type;
> > >  		ibnd_find_port_guid;
> > >  		ibnd_find_port_dr;
> > > +		ibnd_find_port_lid;
> > >  		ibnd_iter_ports;
> > >  	local: *;
> > >  };
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -- 
> Ira Weiny
> Member of Technical Staff
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
