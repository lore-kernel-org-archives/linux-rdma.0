From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Added option for IPv4 MGID multiplexing.
Date: Thu, 05 Aug 2010 16:07:18 +0300
Message-ID: <4C5AB786.9040008@gmail.com>
References: <4C5AA299.1080901@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C5AA299.1080901-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch implements IPv4 MGID to MLID mapping in the same scheme as multicast IP to MAC mapping.
Users may choose multicast IPs to use the same MLID or not.


Slava Strebkov wrote:
> When option is enabled, same mlid may be assigned to
> multicast groups created by IPoIB IPv4.
> If there is no difference in 23 lsb bits of MGID,
> multicast group will got same mlid.
> 
> Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
>  opensm/include/opensm/osm_subnet.h     |    3 +-
>  opensm/opensm/main.c                   |    9 ++++++-
>  opensm/opensm/osm_sa_mcmember_record.c |   42 +++++++++++++++++++++++++++++++-
>  opensm/opensm/osm_subnet.c             |    9 ++++++-
>  4 files changed, 59 insertions(+), 4 deletions(-)
> 
> diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
> index 95a635c..505f8bd 100644
> --- a/opensm/include/opensm/osm_subnet.h
> +++ b/opensm/include/opensm/osm_subnet.h
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2004-2010 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
> @@ -231,6 +231,7 @@ typedef struct osm_subn_opt {
>  	char *prefix_routes_file;
>  	char *log_prefix;
>  	boolean_t consolidate_ipv6_snm_req;
> +	boolean_t consolidate_ipv4;
>  	struct osm_subn_opt *file_opts; /* used for update */
>  	uint8_t lash_start_vl;			/* starting vl to use in lash */
>  	uint8_t sm_sl;			/* which SL to use for SM/SA communication */
> diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
> index 6e6c733..b476b98 100644
> --- a/opensm/opensm/main.c
> +++ b/opensm/opensm/main.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2004-2010 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2009 HNR Consulting. All rights reserved.
> @@ -328,6 +328,9 @@ static void show_usage(void)
>  	printf("--consolidate_ipv6_snm_req\n"
>  	       "          Use shared MLID for IPv6 Solicited Node Multicast groups\n"
>  	       "          per MGID scope and P_Key.\n\n");
> +	printf("--consolidate_ipv4\n"
> +	       "          Use shared MLID for IPv4 Multicast groups\n"
> +	       "          per MGID scope and P_Key.\n\n");
>  	printf("--log_prefix <prefix text>\n"
>  	       "          Prefix to syslog messages from OpenSM.\n\n");
>  	printf("--verbose, -v\n"
> @@ -610,6 +613,7 @@ int main(int argc, char *argv[])
>  #endif
>  		{"prefix_routes_file", 1, NULL, 3},
>  		{"consolidate_ipv6_snm_req", 0, NULL, 4},
> +		{"consolidate_ipv4", 0, NULL, 11},
>  		{"do_mesh_analysis", 0, NULL, 5},
>  		{"lash_start_vl", 1, NULL, 6},
>  		{"sm_sl", 1, NULL, 7},
> @@ -974,6 +978,9 @@ int main(int argc, char *argv[])
>  		case 4:
>  			opt.consolidate_ipv6_snm_req = TRUE;
>  			break;
> +		case 11:
> +			opt.consolidate_ipv4 = TRUE;
> +			break;
>  		case 5:
>  			opt.do_mesh_analysis = TRUE;
>  			break;
> diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
> index 93c2767..1ddbe55 100644
> --- a/opensm/opensm/osm_sa_mcmember_record.c
> +++ b/opensm/opensm/osm_sa_mcmember_record.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2004-2010 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
> @@ -122,6 +122,36 @@ static void free_mlid(IN osm_sa_t * sa, IN uint16_t mlid)
>  #define PREFIX_SIGNATURE CL_HTON64(0xff10601b00000000ULL)
>  #define INT_ID_MASK CL_HTON64(0xfffffff1ff000000ULL)
>  #define INT_ID_SIGNATURE CL_HTON64(0x00000001ff000000ULL)
> +#define IPV4_PREFIX_MASK CL_HTON64(0xff10ffff00000000)
> +#define IPV4_MUX_MASK	CL_HTON32(0x007fffff)
> +#define PREFIX_SIGNATURE_IPV4 CL_HTON64(0xff10401b00000000ULL)
> +
> +static int compare_ipv4_mux_mgids(const void *m1, const void *m2)
> +{
> +	int res = memcmp(m1, m2, sizeof(ib_gid_t) - 4);
> +	if (res)
> +		return res;
> +	uint32_t cmp_m1, cmp_m2;
> +	cmp_m1 = *(uint32_t*)(&((ib_gid_t*)m1)->raw[12]);
> +	cmp_m2 = *(uint32_t*)(&((ib_gid_t*)m2)->raw[12]);
> +	cmp_m1 &= IPV4_MUX_MASK;
> +	cmp_m2 &= IPV4_MUX_MASK;
> +	return memcmp (&cmp_m1, &cmp_m2, sizeof(cmp_m1));
> +}
> +
> +static ib_net16_t find_ipv4_mux_mlid(osm_subn_t *subn, ib_gid_t *mgid)
> +{
> +	osm_mgrp_t *m = (osm_mgrp_t *)cl_fmap_match(&subn->mgrp_mgid_tbl, mgid,
> +		compare_ipv4_mux_mgids);
> +	if (m != (osm_mgrp_t *)cl_fmap_end(&subn->mgrp_mgid_tbl))
> +		return m->mlid;
> +	return 0;
> +}
> +
> +static unsigned match_ipv4_mux_mgid(ib_gid_t * mgid)
> +{
> +	return ((mgid->unicast.prefix & IPV4_PREFIX_MASK) == PREFIX_SIGNATURE_IPV4);
> +}
>  
>  static int compare_ipv6_snm_mgids(const void *m1, const void *m2)
>  {
> @@ -164,6 +194,16 @@ static ib_net16_t get_new_mlid(osm_sa_t * sa, ib_member_rec_t * mcmr)
>  		return requested_mlid;
>  	}
>  
> +	if (sa->p_subn->opt.consolidate_ipv4
> +	    && match_ipv4_mux_mgid(&mcmr->mgid)
> +	    && (requested_mlid = find_ipv4_mux_mlid(sa->p_subn, &mcmr->mgid))) {
> +		char str[INET6_ADDRSTRLEN];
> +		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
> +			"Mapping IPv4 MGID %s to mlid \n",
> +			inet_ntop(AF_INET6, mcmr->mgid.raw, str, sizeof(str)));
> +		return requested_mlid;
> +	}
> +
>  	max = p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO + 1;
>  	for (i = 0; i < max; i++)
>  		if (!sa->p_subn->mboxes[i])
> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
> index d5c5ab2..e7e063c 100644
> --- a/opensm/opensm/osm_subnet.c
> +++ b/opensm/opensm/osm_subnet.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2004-2010 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
> @@ -398,6 +398,7 @@ static const opt_rec_t opt_tbl[] = {
>  	{ "no_clients_rereg", OPT_OFFSET(no_clients_rereg), opts_parse_boolean, NULL, 1 },
>  	{ "prefix_routes_file", OPT_OFFSET(prefix_routes_file), opts_parse_charp, NULL, 0 },
>  	{ "consolidate_ipv6_snm_req", OPT_OFFSET(consolidate_ipv6_snm_req), opts_parse_boolean, NULL, 1 },
> +	{ "consolidate_ipv4", OPT_OFFSET(consolidate_ipv4), opts_parse_boolean, NULL, 1 },
>  	{ "lash_start_vl", OPT_OFFSET(lash_start_vl), opts_parse_uint8, NULL, 1 },
>  	{ "sm_sl", OPT_OFFSET(sm_sl), opts_parse_uint8, NULL, 1 },
>  	{ "log_prefix", OPT_OFFSET(log_prefix), opts_parse_charp, NULL, 1 },
> @@ -758,6 +759,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
>  	p_opt->no_clients_rereg = FALSE;
>  	p_opt->prefix_routes_file = strdup(OSM_DEFAULT_PREFIX_ROUTES_FILE);
>  	p_opt->consolidate_ipv6_snm_req = FALSE;
> +	p_opt->consolidate_ipv4 = FALSE;
>  	p_opt->lash_start_vl = 0;
>  	p_opt->sm_sl = OSM_DEFAULT_SL;
>  	p_opt->log_prefix = NULL;
> @@ -1656,6 +1658,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
>  		"consolidate_ipv6_snm_req %s\n\n",
>  		p_opts->consolidate_ipv6_snm_req ? "TRUE" : "FALSE");
>  
> +	fprintf(out,
> +		"#\n# Consolidate IPv4 Multicast gids Options\n#\n"
> +		"consolidate_ipv4 %s\n\n",
> +		p_opts->consolidate_ipv4 ? "TRUE" : "FALSE");
> +
>  	fprintf(out, "# Log prefix\nlog_prefix %s\n\n", p_opts->log_prefix);
>  
>  	/* optional string attributes ... */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
