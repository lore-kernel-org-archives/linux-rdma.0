From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] opensm: Added option for IPv4 MGID multiplexing.
Date: Mon, 23 Aug 2010 10:26:17 -0400
Message-ID: <AANLkTi=FW_Xr8QCWmSjQ0vthKggMjvkMMb-myqerQ1+3@mail.gmail.com>
References: <4C5AA299.1080901@Voltaire.COM>
	<4C628671.103@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C628671.103-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elid-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 11, 2010 at 7:16 AM, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org> w=
rote:
> When option is enabled, same mlid may be assigned to
> multicast groups created by IPoIB IPv4.
> 32-bit mask can be defined in configuration file
> using option mcast_ipv4_mux_mask.
> If there is no difference in 32 lsb bits of MGID,
> multicast group will got same mlid.
>
> Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
> =C2=A0opensm/include/opensm/osm_subnet.h =C2=A0 =C2=A0 | =C2=A0 =C2=A0=
3 +-
> =C2=A0opensm/opensm/main.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A09 +++++-
> =C2=A0opensm/opensm/osm_sa_mcmember_record.c | =C2=A0 50 ++++++++++++=
+++++++++++++++++++-
> =C2=A0opensm/opensm/osm_subnet.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | =C2=A0 =C2=A09 +++++-
> =C2=A04 files changed, 67 insertions(+), 4 deletions(-)
>
> diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/open=
sm/osm_subnet.h
> index 95a635c..03df112 100644
> --- a/opensm/include/opensm/osm_subnet.h
> +++ b/opensm/include/opensm/osm_subnet.h
> @@ -1,5 +1,5 @@
> =C2=A0/*
> - * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2004-2010 Voltaire, Inc. All rights reserved.
> =C2=A0* Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights=
 reserved.
> =C2=A0* Copyright (c) 1996-2003 Intel Corporation. All rights reserve=
d.
> =C2=A0* Copyright (c) 2008 Xsigo Systems Inc. =C2=A0All rights reserv=
ed.
> @@ -231,6 +231,7 @@ typedef struct osm_subn_opt {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0char *prefix_routes_file;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0char *log_prefix;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0boolean_t consolidate_ipv6_snm_req;
> + =C2=A0 =C2=A0 =C2=A0 uint32_t =C2=A0mcast_ipv4_mux_mask;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct osm_subn_opt *file_opts; /* used fo=
r update */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0uint8_t lash_start_vl; =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* starting vl to use in lash=
 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0uint8_t sm_sl; =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* which SL to use for SM/SA communi=
cation */
> diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
> index 6e6c733..bf5557f 100644
> --- a/opensm/opensm/main.c
> +++ b/opensm/opensm/main.c
> @@ -1,5 +1,5 @@
> =C2=A0/*
> - * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2004-2010 Voltaire, Inc. All rights reserved.
> =C2=A0* Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights=
 reserved.
> =C2=A0* Copyright (c) 1996-2003 Intel Corporation. All rights reserve=
d.
> =C2=A0* Copyright (c) 2009 HNR Consulting. All rights reserved.
> @@ -328,6 +328,9 @@ static void show_usage(void)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("--consolidate_ipv6_snm_req\n"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Use shared MLID for IPv6 Solicited Node Multicast groups\=
n"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0per MGID scope and P_Key.\n\n");
> + =C2=A0 =C2=A0 =C2=A0 printf("--mcast_ipv4_mux_mask\n"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0Use =C2=A0mask =C2=A0for multiplexing IPv4 multicast g=
roups\n"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0per MGID scope and P_Key.\n\n");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("--log_prefix <prefix text>\n"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Prefix to syslog messages from OpenSM.\n\n");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("--verbose, -v\n"
> @@ -610,6 +613,7 @@ int main(int argc, char *argv[])
> =C2=A0#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{"prefix_route=
s_file", 1, NULL, 3},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{"consolidate_=
ipv6_snm_req", 0, NULL, 4},
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 {"mcast_ipv4_mux_m=
ask", 0, NULL, 11},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{"do_mesh_anal=
ysis", 0, NULL, 5},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{"lash_start_v=
l", 1, NULL, 6},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{"sm_sl", 1, N=
ULL, 7},
> @@ -974,6 +978,9 @@ int main(int argc, char *argv[])
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 4:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0opt.consolidate_ipv6_snm_req =3D TRUE;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 11:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 opt.mcast_ipv4_mux_mask =3D 0xffffffff;

Shouldn't this be set based on the command line parameter for this opti=
on ?

-- Hal

> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 5:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0opt.do_mesh_analysis =3D TRUE;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/o=
sm_sa_mcmember_record.c
> index 93c2767..90aebf6 100644
> --- a/opensm/opensm/osm_sa_mcmember_record.c
> +++ b/opensm/opensm/osm_sa_mcmember_record.c
> @@ -1,5 +1,5 @@
> =C2=A0/*
> - * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2004-2010 Voltaire, Inc. All rights reserved.
> =C2=A0* Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights=
 reserved.
> =C2=A0* Copyright (c) 1996-2003 Intel Corporation. All rights reserve=
d.
> =C2=A0* Copyright (c) 2008 Xsigo Systems Inc. =C2=A0All rights reserv=
ed.
> @@ -122,6 +122,44 @@ static void free_mlid(IN osm_sa_t * sa, IN uint1=
6_t mlid)
> =C2=A0#define PREFIX_SIGNATURE CL_HTON64(0xff10601b00000000ULL)
> =C2=A0#define INT_ID_MASK CL_HTON64(0xfffffff1ff000000ULL)
> =C2=A0#define INT_ID_SIGNATURE CL_HTON64(0x00000001ff000000ULL)
> +#define IPV4_PREFIX_MASK CL_HTON64(0xff10ffff00000000)
> +#define PREFIX_SIGNATURE_IPV4 CL_HTON64(0xff10401b00000000ULL)
> +
> +struct mgid_mask_ipv4 {
> + =C2=A0 =C2=A0 =C2=A0 ib_gid_t *mgid;
> + =C2=A0 =C2=A0 =C2=A0 uint32_t mux_mask;
> +};
> +
> +static int compare_ipv4_mux_mgids(const void *m1, const void *m2)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct mgid_mask_ipv4 *p_mgid_mask =3D (struct=
 mgid_mask *)m1;
> + =C2=A0 =C2=A0 =C2=A0 int res =3D memcmp(p_mgid_mask->mgid, m2, size=
of(ib_gid_t) - 4);
> + =C2=A0 =C2=A0 =C2=A0 if (res)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return res;
> + =C2=A0 =C2=A0 =C2=A0 uint32_t cmp_m1, cmp_m2;
> + =C2=A0 =C2=A0 =C2=A0 cmp_m1 =3D *(uint32_t*)(&p_mgid_mask->mgid->ra=
w[12]);
> + =C2=A0 =C2=A0 =C2=A0 cmp_m2 =3D *(uint32_t*)(&((ib_gid_t*)m2)->raw[=
12]);
> + =C2=A0 =C2=A0 =C2=A0 cmp_m1 &=3D CL_HTON32(p_mgid_mask->mux_mask);
> + =C2=A0 =C2=A0 =C2=A0 cmp_m2 &=3D CL_HTON32(p_mgid_mask->mux_mask);
> + =C2=A0 =C2=A0 =C2=A0 return memcmp (&cmp_m1, &cmp_m2, sizeof(cmp_m1=
));
> +}
> +
> +static ib_net16_t find_ipv4_mux_mlid(osm_subn_t *subn, ib_gid_t *mgi=
d)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct mgid_mask_ipv4 mgid_mask;
> + =C2=A0 =C2=A0 =C2=A0 mgid_mask.mgid =3D mgid;
> + =C2=A0 =C2=A0 =C2=A0 mgid_mask.mux_mask =3D subn->opt.mcast_ipv4_mu=
x_mask;
> + =C2=A0 =C2=A0 =C2=A0 osm_mgrp_t *m =3D (osm_mgrp_t *)cl_fmap_match(=
&subn->mgrp_mgid_tbl, &mgid_mask,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 compare_ipv4_mux_m=
gids);
> + =C2=A0 =C2=A0 =C2=A0 if (m !=3D (osm_mgrp_t *)cl_fmap_end(&subn->mg=
rp_mgid_tbl))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return m->mlid;
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +static unsigned match_ipv4_mux_mgid(ib_gid_t * mgid)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return ((mgid->unicast.prefix & IPV4_PREFIX_MA=
SK) =3D=3D PREFIX_SIGNATURE_IPV4);
> +}
>
> =C2=A0static int compare_ipv6_snm_mgids(const void *m1, const void *m=
2)
> =C2=A0{
> @@ -164,6 +202,16 @@ static ib_net16_t get_new_mlid(osm_sa_t * sa, ib=
_member_rec_t * mcmr)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return request=
ed_mlid;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> + =C2=A0 =C2=A0 =C2=A0 if (sa->p_subn->opt.mcast_ipv4_mux_mask !=3D 0=
xffffffff
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 && match_ipv4_mux_mgid(&mcmr->mg=
id)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 && (requested_mlid =3D find_ipv4=
_mux_mlid(sa->p_subn, &mcmr->mgid))) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 char str[INET6_ADD=
RSTRLEN];
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(sa->p_log,=
 OSM_LOG_DEBUG,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "Mapping IPv4 MGID %s to mlid \n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 inet_ntop(AF_INET6, mcmr->mgid.raw, str, sizeof(str)));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return requested_m=
lid;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0max =3D p_subn->max_mcast_lid_ho - IB_LID_=
MCAST_START_HO + 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i < max; i++)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!sa->p_sub=
n->mboxes[i])
> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
> index d5c5ab2..97b84b4 100644
> --- a/opensm/opensm/osm_subnet.c
> +++ b/opensm/opensm/osm_subnet.c
> @@ -1,5 +1,5 @@
> =C2=A0/*
> - * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2004-2010 Voltaire, Inc. All rights reserved.
> =C2=A0* Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights=
 reserved.
> =C2=A0* Copyright (c) 1996-2003 Intel Corporation. All rights reserve=
d.
> =C2=A0* Copyright (c) 2008 Xsigo Systems Inc. =C2=A0All rights reserv=
ed.
> @@ -398,6 +398,7 @@ static const opt_rec_t opt_tbl[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "no_clients_rereg", OPT_OFFSET(no_client=
s_rereg), opts_parse_boolean, NULL, 1 },
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "prefix_routes_file", OPT_OFFSET(prefix_=
routes_file), opts_parse_charp, NULL, 0 },
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "consolidate_ipv6_snm_req", OPT_OFFSET(c=
onsolidate_ipv6_snm_req), opts_parse_boolean, NULL, 1 },
> + =C2=A0 =C2=A0 =C2=A0 { "mcast_ipv4_mux_mask", OPT_OFFSET(mcast_ipv4=
_mux_mask), opts_parse_uint32, NULL, 1 },
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "lash_start_vl", OPT_OFFSET(lash_start_v=
l), opts_parse_uint8, NULL, 1 },
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "sm_sl", OPT_OFFSET(sm_sl), opts_parse_u=
int8, NULL, 1 },
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "log_prefix", OPT_OFFSET(log_prefix), op=
ts_parse_charp, NULL, 1 },
> @@ -758,6 +759,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t *=
 p_opt)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_opt->no_clients_rereg =3D FALSE;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_opt->prefix_routes_file =3D strdup(OSM_D=
EFAULT_PREFIX_ROUTES_FILE);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_opt->consolidate_ipv6_snm_req =3D FALSE;
> + =C2=A0 =C2=A0 =C2=A0 p_opt->mcast_ipv4_mux_mask =3D 0xffffffff;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_opt->lash_start_vl =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_opt->sm_sl =3D OSM_DEFAULT_SL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_opt->log_prefix =3D NULL;
> @@ -1656,6 +1658,11 @@ int osm_subn_output_conf(FILE *out, IN osm_sub=
n_opt_t * p_opts)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"consolidate_i=
pv6_snm_req %s\n\n",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_opts->consol=
idate_ipv6_snm_req ? "TRUE" : "FALSE");
>
> + =C2=A0 =C2=A0 =C2=A0 fprintf(out,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "#\n# Multicast IP=
v4 Mux mask\n#\n"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "mcast_ipv4_mux_ma=
sk 0x%08X\n\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->mcast_ipv4=
_mux_mask);
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(out, "# Log prefix\nlog_prefix %s\=
n\n", p_opts->log_prefix);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* optional string attributes ... */
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
