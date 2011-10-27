From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: Add the precreation of multicast groups
Date: Thu, 27 Oct 2011 15:41:53 -0400
Message-ID: <4EA9B401.5030101@dev.mellanox.co.il>
References: <20111006171326.3b143b03.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111006171326.3b143b03.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/6/2011 8:13 PM, Ira Weiny wrote:
> 
> Allow for the pre-creation of these groups on a partition by partition basis.

This looks good to me and has been needed for some time now; Thanks for
doing this!

Just some minor comments below from scanning through the patch. I
haven't tried it yet...

> P_Key is taken from the partition specification.  Q_Key, TClass, rate, and mtu
> can be specified.

If TClass is added, should FlowLabel also be added ?

> For IP groups, rate and mtu are verified to match the broadcast groups
> parameters.  P_Key can be specified in the mgid itself and is verified to match
> the P_Key of the partition if != 0x0000.  If pkey == 0x0000 then the P_Key is
> taken from the partition specification.

Do you mean the pkey in the IPoIB MGID here by "partition specification" ?

> The syntax extends the existing syntax by allowing MC groups to be specified
> one per line, intermixed with the port specifications.
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
>  include/opensm/osm_base.h      |    5 +
>  include/opensm/osm_partition.h |   12 +-
>  man/opensm.8.in                |  121 +++++++++++------

Similar changes should be made to doc/partition-config.txt which is
where this part of the man page came from originally.

>  opensm/osm_prtn.c              |  111 ++++++++++++----
>  opensm/osm_prtn_config.c       |  278 ++++++++++++++++++++++++++++++++++++----
>  opensm/osm_qos_policy.c        |   48 ++++----
>  opensm/osm_subnet.c            |    2 +-
>  7 files changed, 454 insertions(+), 123 deletions(-)
> 
> diff --git a/include/opensm/osm_base.h b/include/opensm/osm_base.h
> index e558c55..869ba9c 100644
> --- a/include/opensm/osm_base.h
> +++ b/include/opensm/osm_base.h
> @@ -53,6 +53,7 @@
>  #endif
>  
>  #include <complib/cl_types.h>
> +#include <iba/ib_types.h>
>  
>  #ifdef __cplusplus
>  #  define BEGIN_C_DECLS extern "C" {
> @@ -954,6 +955,10 @@ typedef enum _osm_sm_signal {
>  #define OSM_VENDOR_ID_HP4           0x00237D
>  #define OSM_VENDOR_ID_OPENIB        0x001405
>  
> +/* IPoIB Broadcast Defaults */
> +#define OSM_IPOIB_BROADCAST_MGRP_QKEY 0x0b1b
> +extern const ib_gid_t osm_ipoib_broadcast_mgid;
> +
>  /**********/
>  
>  END_C_DECLS
> diff --git a/include/opensm/osm_partition.h b/include/opensm/osm_partition.h
> index fdb34b9..7277eac 100644
> --- a/include/opensm/osm_partition.h
> +++ b/include/opensm/osm_partition.h
> @@ -94,10 +94,11 @@ typedef struct osm_prtn {
>  	cl_map_item_t map_item;
>  	ib_net16_t pkey;
>  	uint8_t sl;
> -	osm_mgrp_t *mgrp;
>  	cl_map_t full_guid_tbl;
>  	cl_map_t part_guid_tbl;
>  	char name[32];
> +	osm_mgrp_t **mgrps;
> +	int nmgrps;
>  } osm_prtn_t;
>  /*
>  * FIELDS
> @@ -110,9 +111,10 @@ typedef struct osm_prtn {
>  *	sl
>  *		The Service Level (SL) associated with this Partiton.
>  *
> -*	mgrp
> -*		The pointer to the well known Multicast Group
> -*		that was created for this partition (when configured).
> +*       mgrps
> +*		List of well known Multicast Groups
> +*		that were created for this partition (when configured).
> +*		This includes the IPoIB broadcast group.
>  *
>  *	full_guid_tbl
>  *		Container of pointers to all Port objects in the Partition
> @@ -139,7 +141,7 @@ typedef struct osm_prtn {
>  *
>  * SYNOPSIS
>  */
> -void osm_prtn_delete(IN OUT osm_prtn_t ** pp_prtn);
> +void osm_prtn_delete(IN OUT osm_prtn_t ** pp_prtn, osm_subn_t * p_subn);

IN osm_subn_t * p_subn

Also, reverse the parameters to be consistent with the coding convention.

>  /*
>  * PARAMETERS
>  *	pp_prtn
> diff --git a/man/opensm.8.in b/man/opensm.8.in
> index 042bee3..da0c247 100644
> --- a/man/opensm.8.in
> +++ b/man/opensm.8.in
> @@ -523,45 +523,76 @@ parser.
>  
>  General file format:
>  
> -<Partition Definition>:<PortGUIDs list> ;
> -
> -Partition Definition:
> -
> -[PartitionName][=PKey][,flag[=value]][,defmember=full|limited]
> -
> - PartitionName - string, will be used with logging. When omitted
> -                 empty string will be used.
> - PKey          - P_Key value for this partition. Only low 15 bits will
> -                 be used. When omitted will be autogenerated.
> - flag          - used to indicate IPoIB capability of this partition.
> - defmember=full|limited - specifies default membership for port guid
> -                 list. Default is limited.
> -
> -Currently recognized flags are:
> -
> - ipoib       - indicates that this partition may be used for IPoIB, as
> -               result IPoIB capable MC group will be created.
> - rate=<val>  - specifies rate for this IPoIB MC group
> -               (default is 3 (10GBps))
> - mtu=<val>   - specifies MTU for this IPoIB MC group
> -               (default is 4 (2048))
> - sl=<val>    - specifies SL for this IPoIB MC group
> -               (default is 0)
> - scope=<val> - specifies scope for this IPoIB MC group
> -               (default is 2 (link local)).  Multiple scope settings
> -               are permitted for a partition.
> -
> -Note that values for rate, mtu, and scope should be specified as
> -defined in the IBTA specification (for example, mtu=4 for 2048).
> -
> -PortGUIDs list:
> -
> - PortGUID         - GUID of partition member EndPort. Hexadecimal
> -                    numbers should start from 0x, decimal numbers
> -                    are accepted too.
> - full or limited  - indicates full or limited membership for this
> -                    port.  When omitted (or unrecognized) limited
> -                    membership is assumed.
> +<Partition Definition>:[<newline>]<Partition Properties>;
> +
> +     Partition Definition:
> +       [PartitionName][=PKey][,part_flag[=value]][,defmember=full|limited]
> +
> +        PartitionName - string, will be used with logging. When omitted
> +                        empty string will be used.
> +        PKey          - P_Key value for this partition. Only low 15 bits will
> +                        be used. When omitted will be autogenerated.
> +        part_flags    - used to indicate/specify IPoIB capability of this partition.
> +        defmember=full|limited - specifies default membership for port guid
> +                        list. Default is limited.
> +
> +     part_flag:
> +        ipoib       - indicates that this partition may be used for IPoIB, as
> +                      result IPoIB capable MC group will be created.
> +        rate=<val>  - specifies rate for this IPoIB MC group
> +                      (default is 3 (10GBps))
> +        mtu=<val>   - specifies MTU for this IPoIB MC group
> +                      (default is 4 (2048))
> +        sl=<val>    - specifies SL for this IPoIB MC group
> +                      (default is 0)
> +        scope=<val> - specifies scope for this IPoIB MC group
> +                      (default is 2 (link local)).  Multiple scope settings
> +                      are permitted for a partition.
> +
> +     Partition Properties:
> +       [<Port list>|<MCast Group>]* | <Port list>
> +
> +     Port list:
> +        <Port Specifier>[,<Port Specifier>]
> +
> +     Port Specifier:
> +        <PortGUID>[=[full|limited]]
> +
> +        PortGUID         - GUID of partition member EndPort. Hexadecimal
> +                           numbers should start from 0x, decimal numbers
> +                           are accepted too.
> +        full or limited  - indicates full or limited membership for this
> +                           port.  When omitted (or unrecognized) limited
> +                           membership is assumed.
> +
> +     MCast Group:
> +        mgid=gid[,mgroup_flag=val]*<newline>
> +
> +     mgroup_flag:
> +        rate=<val>  - specifies rate for this MC group
> +                      (default is 3 (10GBps))
> +        mtu=<val>   - specifies MTU for this MC group
> +                      (default is 4 (2048))
> +        sl=<val>    - specifies SL for this MC group
> +                      (default is 0)
> +        scope=<val> - specifies scope for this MC group
> +                      (default is 2 (link local)).  Multiple scope settings
> +                      are permitted for a partition.
> +		      NOTE: This overwrites the scope nibble of the specified
> +			    mgid.  Furthermore specifying multiple scope
> +			    settings will result in multiple MC groups
> +			    being created.
> +        qkey=<val>    - specifies the Q_Key for this MC group
> +                      (default: 0x0b1b for IP groups, 0 for other groups)
> +        tclass=<val>    - specifies tclass for this MC group
> +                      (default is 0)
> +
> +     newline: '\n'
> +
> +
> +Note that values for rate, mtu, and scope, for both partitions and multicast
> +groups, should be specified as defined in the IBTA specification (for example,
> +mtu=4 for 2048).
>  
>  There are several useful keywords for PortGUID definition:
>  
> @@ -577,9 +608,6 @@ Notes:
>  
>  White space is permitted between delimiters ('=', ',',':',';').
>  
> -The line can be wrapped after ':' followed after Partition Definition and
> -between.
> -
>  PartitionName does not need to be unique, PKey does need to be unique.
>  If PKey is repeated then those partition configurations will be merged
>  and first PartitionName will be used (see also next note).
> @@ -606,6 +634,15 @@ Examples:
>   ShareIO = 0x80 , defmember=full : 0x123459, 0x12345a;
>   ShareIO = 0x80 , defmember=full : 0x12345b, 0x12345c=limited, 0x12345d;
>  
> + # multicast groups added to default
> + Default=0x7fff,ipoib:
> +        mgid=ff12:401b::0707,sl=1 # random IPv4 group
> +        mgid=ff12:601b::16    # MLDv2-capable routers
> +        mgid=ff12:401b::16    # IGMP
> +        mgid=ff12:601b::2     # All routers
> +        mgid=ff12::1,sl=1,Q_Key=0xDEADBEEF,rate=3,mtu=2 # random group
> +        ALL=full;
> +
>  
>  Note:
>  
> diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
> index 3fd4fc0..2e2837a 100644
> --- a/opensm/osm_prtn.c
> +++ b/opensm/osm_prtn.c
> @@ -53,6 +53,8 @@
>  #include <opensm/osm_node.h>
>  #include <opensm/osm_sa.h>
>  #include <opensm/osm_multicast.h>
> +#include <arpa/inet.h>
> +#include <errno.h>
>  
>  extern int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
>  				      const char *file_name);
> @@ -68,6 +70,8 @@ osm_prtn_t *osm_prtn_new(IN const char *name, IN uint16_t pkey)
>  	memset(p, 0, sizeof(*p));
>  	p->pkey = pkey;
>  	p->sl = OSM_DEFAULT_SL;
> +	p->mgrps = NULL;
> +	p->nmgrps = 0;
>  	cl_map_construct(&p->full_guid_tbl);
>  	cl_map_init(&p->full_guid_tbl, 32);
>  	cl_map_construct(&p->part_guid_tbl);
> @@ -81,14 +85,34 @@ osm_prtn_t *osm_prtn_new(IN const char *name, IN uint16_t pkey)
>  	return p;
>  }
>  
> -void osm_prtn_delete(IN OUT osm_prtn_t ** pp_prtn)
> +void osm_prtn_delete(IN OUT osm_prtn_t ** pp_prtn, osm_subn_t * p_subn)
>  {
> +	char gid_str[INET6_ADDRSTRLEN];
> +	int i = 0;
>  	osm_prtn_t *p = *pp_prtn;
>  
>  	cl_map_remove_all(&p->full_guid_tbl);
>  	cl_map_destroy(&p->full_guid_tbl);
>  	cl_map_remove_all(&p->part_guid_tbl);
>  	cl_map_destroy(&p->part_guid_tbl);
> +
> +	if (p->mgrps) {
> +		/* Clean up mgrps */
> +		for (i = 0; i < p->nmgrps; i++) {
> +			/* osm_mgrp_cleanup will not delete
> +			 * "well_known" groups */
> +			p->mgrps[i]->well_known = FALSE;
> +			osm_mgrp_cleanup(p_subn, p->mgrps[i]);
> +			OSM_LOG(&p_subn->p_osm->log, OSM_LOG_ERROR,

Should this some other log level like VERBOSE or DEBUG ?

> +			"removing mgroup %s from partition (0x%x)\n",
> +			inet_ntop(AF_INET6, p->mgrps[i]->mcmember_rec.mgid.raw,
> +					gid_str, sizeof gid_str),
> +				cl_hton16(p->pkey));
> +		}
> +
> +		free(p->mgrps);
> +	}
> +
>  	free(p);
>  	*pp_prtn = NULL;
>  }
> @@ -156,21 +180,47 @@ _err:
>  	return status;
>  }
>  
> -static const ib_gid_t osm_ipoib_mgid = {
> -	{
> -	 0xff,			/*  multicast field */
> -	 0x12,			/*  non-permanent bit, link local scope */
> -	 0x40, 0x1b,		/*  IPv4 signature */
> -	 0xff, 0xff,		/*  16 bits of P_Key (to be filled in) */
> -	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/*  48 bits of zeros */
> -	 0xff, 0xff, 0xff, 0xff,	/*  32 bit IPv4 broadcast address */
> -	 },
> -};
> +static ib_api_status_t
> +track_mgrp_w_partition(osm_log_t *p_log, osm_prtn_t *p, osm_mgrp_t *mgrp,
> +			osm_subn_t *p_subn, const ib_gid_t *mgid,
> +			ib_net16_t pkey)
> +{
> +	char gid_str[INET6_ADDRSTRLEN];
> +	osm_mgrp_t **tmp;
> +	int i = 0;
> +
> +	/* check if we are already tracking this group */
> +	for (i = 0; i< p->nmgrps; i++)
> +		if (p->mgrps[i] == mgrp)
> +			return (IB_SUCCESS);
> +
> +	/* otherwise add it to our list */
> +	tmp = realloc(p->mgrps, (p->nmgrps +1) * sizeof(*p->mgrps));
> +	if (tmp) {
> +		p->mgrps = tmp;
> +		p->mgrps[p->nmgrps] = mgrp;
> +		p->nmgrps++;
> +	} else {
> +		OSM_LOG(p_log, OSM_LOG_ERROR,
> +		        "ERR: realloc error to create MC group (%s) in "

Other similar errors in this file don't have the "ERR: " part. There are
also other instances below but I snipped the rest.

-- Hal

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
