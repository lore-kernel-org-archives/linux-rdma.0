From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] infiniband-diags: libibnetdisc add find node by lid
Date: Sun, 03 Feb 2013 10:36:19 -0500
Message-ID: <510E83F3.80104@dev.mellanox.co.il>
References: <20130202163628.5f4693217bc8008ccfd18308@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130202163628.5f4693217bc8008ccfd18308-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/2/2013 7:36 PM, Ira Weiny wrote:
> 
> 
> NOTE: this change adds a glib requirement to the package.

Would you elaborate on the direction here ? Do you intend on removing
any complib dependencies in libibnetdisc ?

> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
>  configure.in                                |    7 ++++
>  infiniband-diags.spec.in                    |    4 +-
>  libibnetdisc/Makefile.am                    |    4 +-
>  libibnetdisc/include/infiniband/ibnetdisc.h |    3 ++
>  libibnetdisc/libibnetdisc.ver               |    2 +-
>  libibnetdisc/src/ibnetdisc.c                |   53 ++++++++++++++++++++++++++-
>  libibnetdisc/src/internal.h                 |    7 ++++
>  libibnetdisc/src/libibnetdisc.map           |    1 +
>  8 files changed, 75 insertions(+), 6 deletions(-)
> 
> diff --git a/configure.in b/configure.in
> index 2dc60a0..ca62d5b 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -161,6 +161,13 @@ IBSCRIPTPATH_TMP2="`echo $IBSCRIPTPATH_TMP1 | sed 's/^NONE/$ac_default_prefix/'`
>  IBSCRIPTPATH="${with_ibpath_override:-`eval echo $IBSCRIPTPATH_TMP2`}"
>  AC_SUBST(IBSCRIPTPATH)
>  
> +dnl check for glib
> +PKG_CHECK_MODULES([GLIB], [glib-2.0], ac_glib=yes, ac_glib=no)
> +AM_CONDITIONAL([HAVE_GLIB], test "$ac_glib" = "yes")
> +if test "$ac_glib" = "yes"; then
> +   AC_DEFINE([HAVE_GLIB], 1, [Define to 1 to indicate GLIB support])
> +fi
> +
>  dnl Begin libibnetdisc stuff
>  ibnetdisc_api_version=`grep LIBVERSION $srcdir/libibnetdisc/libibnetdisc.ver | sed 's/LIBVERSION=//'`
>  if test -z $ibnetdisc_api_version; then
> diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
> index d3fcd13..9cd195b 100644
> --- a/infiniband-diags.spec.in
> +++ b/infiniband-diags.spec.in
> @@ -11,8 +11,8 @@ Group: System Environment/Libraries
>  BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
>  Source: http://www.openfabrics.org/downloads/management/@TARBALL@
>  Url: http://openfabrics.org/
> -BuildRequires: libibmad-devel, opensm-devel, libibumad-devel
> -Requires: libibmad, opensm-libs, libibumad
> +BuildRequires: libibmad-devel, opensm-devel, libibumad-devel, glib-devel
> +Requires: libibmad, opensm-libs, libibumad, glib
>  Provides: perl(IBswcountlimits)
>  Obsoletes: openib-diags
>  
> diff --git a/libibnetdisc/Makefile.am b/libibnetdisc/Makefile.am
> index fbf0e60..d05604f 100644
> --- a/libibnetdisc/Makefile.am
> +++ b/libibnetdisc/Makefile.am
> @@ -24,10 +24,10 @@ endif
>  
>  libibnetdisc_la_SOURCES = src/ibnetdisc.c src/ibnetdisc_cache.c src/chassis.c \
>  			  src/chassis.h src/internal.h src/query_smp.c
> -libibnetdisc_la_CFLAGS = -Wall $(DBGFLAGS)
> +libibnetdisc_la_CFLAGS = -Wall $(DBGFLAGS) $(GLIB_CFLAGS)
>  libibnetdisc_la_LDFLAGS = -version-info $(ibnetdisc_api_version) \
>  	-export-dynamic $(libibnetdisc_version_script) \
> -	-libmad
> +	-libmad $(GLIB_LIBS)
>  libibnetdisc_la_DEPENDENCIES = $(srcdir)/src/libibnetdisc.map
>  
>  libibnetdiscincludedir = $(includedir)/infiniband
> diff --git a/libibnetdisc/include/infiniband/ibnetdisc.h b/libibnetdisc/include/infiniband/ibnetdisc.h
> index 335ad83..1efca3c 100644
> --- a/libibnetdisc/include/infiniband/ibnetdisc.h
> +++ b/libibnetdisc/include/infiniband/ibnetdisc.h
> @@ -229,6 +229,9 @@ IBND_EXPORT ibnd_port_t *ibnd_find_port_guid(ibnd_fabric_t * fabric,
>  					uint64_t guid);
>  IBND_EXPORT ibnd_port_t *ibnd_find_port_dr(ibnd_fabric_t * fabric,
>  					char *dr_str);
> +IBND_EXPORT ibnd_port_t *ibnd_find_port_lid(ibnd_fabric_t * fabric,
> +					    uint16_t lid);
> +
>  typedef void (*ibnd_iter_port_func_t) (ibnd_port_t * port, void *user_data);
>  IBND_EXPORT void ibnd_iter_ports(ibnd_fabric_t * fabric,
>  				ibnd_iter_port_func_t func, void *user_data);
> diff --git a/libibnetdisc/libibnetdisc.ver b/libibnetdisc/libibnetdisc.ver
> index c513f2a..59fca19 100644
> --- a/libibnetdisc/libibnetdisc.ver
> +++ b/libibnetdisc/libibnetdisc.ver
> @@ -6,4 +6,4 @@
>  # API_REV - advance on any added API
>  # RUNNING_REV - advance any change to the vendor files
>  # AGE - number of backward versions the API still supports
> -LIBVERSION=7:0:2
> +LIBVERSION=8:0:3
> diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
> index 3a7dd8f..5f15194 100644
> --- a/libibnetdisc/src/ibnetdisc.c
> +++ b/libibnetdisc/src/ibnetdisc.c
> @@ -360,6 +360,7 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
>  	}
>  
>  	add_to_portguid_hash(port, fabric->portstbl);
> +	add_to_portlid_hash(port, ((f_internal_t *)fabric)->lid2guid);
>  
>  	if ((scan->cfg->flags & IBND_CONFIG_MLX_EPI)
>  	    && is_mlnx_ext_port_info_supported(port)) {
> @@ -628,6 +629,36 @@ void add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[])
>  	hash[hash_idx] = port;
>  }
>  
> +static void create_lid2guid(ibnd_fabric_t *fabric)
> +{
> +	f_internal_t *f = (f_internal_t *)fabric;
> +	f->lid2guid = g_hash_table_new_full(g_int_hash, g_int_equal,
> +				NULL, NULL);
> +}
> +
> +static void destroy_lid2guid(ibnd_fabric_t *fabric)
> +{
> +	f_internal_t *f = (f_internal_t *)fabric;
> +	if (f->lid2guid) {
> +		g_hash_table_destroy((GHashTable *)f->lid2guid);

Nit: Is the cast needed here ?

> +	}
> +}
> +
> +void add_to_portlid_hash(ibnd_port_t * port, GHashTable *htable)
> +{
> +	uint16_t base_lid = port->base_lid;
> +	uint16_t lid_mask = ((1 << port->lmc) -1);
> +	uint16_t lid = 0;
> +
> +	/* We add the port for all "lmc" lids
> +	 * so it is easier to find for any "random" lid specified */
> +	for (lid = base_lid; lid <= (base_lid + lid_mask); lid++) {
> +		uint16_t *lidp = calloc(1, sizeof(*lidp));
> +		*lidp = lid;
> +		g_hash_table_insert(htable, lidp, port);

calloc error should be handled

-- Hal

> +	}
> +}
> +
>  void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
>  {
>  	switch (node->type) {
> @@ -664,6 +695,12 @@ static int set_config(struct ibnd_config *config, struct ibnd_config *cfg)
>  	return (0);
>  }
>  
> +static ibnd_fabric_t *allocate_fabric(void)
> +{
> +	f_internal_t *f = calloc(1, sizeof(*f));
> +	return ((ibnd_fabric_t *)f);
> +}
> +
>  ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
>  				    ib_portid_t * from,
>  				    struct ibnd_config *cfg)
> @@ -685,7 +722,7 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
>  		return NULL;
>  	}
>  
> -	fabric = calloc(1, sizeof(*fabric));
> +	fabric = allocate_fabric();
>  	if (!fabric) {
>  		IBND_ERROR("OOM: failed to calloc ibnd_fabric_t\n");
>  		return NULL;
> @@ -715,6 +752,8 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
>  
>  	IBND_DEBUG("from %s\n", portid2str(from));
>  
> +	create_lid2guid(fabric);
> +
>  	if (!query_node_info(&engine, from, NULL))
>  		if (process_mads(&engine) != 0)
>  			goto error;
> @@ -768,6 +807,7 @@ void ibnd_destroy_fabric(ibnd_fabric_t * fabric)
>  		destroy_node(node);
>  		node = next;
>  	}
> +	destroy_lid2guid(fabric);
>  	free(fabric);
>  }
>  
> @@ -825,6 +865,17 @@ void ibnd_iter_nodes_type(ibnd_fabric_t * fabric, ibnd_iter_node_func_t func,
>  		func(cur, user_data);
>  }
>  
> +ibnd_port_t *ibnd_find_port_lid(ibnd_fabric_t * fabric,
> +				uint16_t lid)
> +{
> +	ibnd_port_t *port;
> +	f_internal_t *f = (f_internal_t *)fabric;
> +
> +	port = (ibnd_port_t *)g_hash_table_lookup(f->lid2guid, &lid);
> +
> +	return port;
> +}
> +
>  ibnd_port_t *ibnd_find_port_guid(ibnd_fabric_t * fabric, uint64_t guid)
>  {
>  	int hash = HASHGUID(guid) % HTSZ;
> diff --git a/libibnetdisc/src/internal.h b/libibnetdisc/src/internal.h
> index 80918c4..b7e18e8 100644
> --- a/libibnetdisc/src/internal.h
> +++ b/libibnetdisc/src/internal.h
> @@ -40,6 +40,7 @@
>  
>  #include <infiniband/ibnetdisc.h>
>  #include <complib/cl_qmap.h>
> +#include <glib.h>
>  
>  #define	IBND_DEBUG(fmt, ...) \
>  	if (ibdebug) { \
> @@ -57,6 +58,11 @@
>  #define DEFAULT_TIMEOUT 1000
>  #define DEFAULT_RETRIES 3
>  
> +typedef struct f_internal {
> +	ibnd_fabric_t fabric;
> +	GHashTable *lid2guid;
> +} f_internal_t;
> +
>  typedef struct ibnd_scan {
>  	ib_portid_t selfportid;
>  	ibnd_fabric_t *fabric;
> @@ -100,6 +106,7 @@ void smp_engine_destroy(smp_engine_t * engine);
>  void add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[]);
>  
>  void add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[]);
> +void add_to_portlid_hash(ibnd_port_t * port, GHashTable *htable);
>  
>  void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric);
>  
> diff --git a/libibnetdisc/src/libibnetdisc.map b/libibnetdisc/src/libibnetdisc.map
> index 1c42e7b..f1b7229 100644
> --- a/libibnetdisc/src/libibnetdisc.map
> +++ b/libibnetdisc/src/libibnetdisc.map
> @@ -16,6 +16,7 @@ IBNETDISC_1.0 {
>  		ibnd_iter_nodes_type;
>  		ibnd_find_port_guid;
>  		ibnd_find_port_dr;
> +		ibnd_find_port_lid;
>  		ibnd_iter_ports;
>  	local: *;
>  };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
