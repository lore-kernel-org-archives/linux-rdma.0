From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH]opensm: QOS options for switch leaf (edge) ports.
Date: Thu, 28 Jan 2010 10:29:45 -0500
Message-ID: <f0e08f231001280729o69c94631nba2093960e0d80f@mail.gmail.com>
References: <4B5D96B0.8030903@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B5D96B0.8030903-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 25, 2010 at 8:03 AM, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org> w=
rote:
> New QOS option for edge ports allows to set
> different sl 2 vl mapping for switch ports
> connected to HCAs.

Should be CAs as this includes TCAs too, right ?

Should router peer ports also be included here ?

> Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
> =C2=A0opensm/include/opensm/osm_subnet.h | =C2=A0 =C2=A01 +
> =C2=A0opensm/opensm/osm_qos.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
| =C2=A0 21 ++++++++++++++++++---
> =C2=A0opensm/opensm/osm_subnet.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0=
 14 ++++++++++++++

IMO QoS docs and opensm man page should also be updated to go along wit=
h this.

> =C2=A03 files changed, 33 insertions(+), 3 deletions(-)
>
> diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/open=
sm/osm_subnet.h
> index 65f687a..31681aa 100644
> --- a/opensm/include/opensm/osm_subnet.h
> +++ b/opensm/include/opensm/osm_subnet.h
> @@ -212,6 +212,7 @@ typedef struct osm_subn_opt {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_qos_options_t qos_ca_options;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_qos_options_t qos_sw0_options;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_qos_options_t qos_swe_options;
> + =C2=A0 =C2=A0 =C2=A0 osm_qos_options_t qos_sw_edge_options;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_qos_options_t qos_rtr_options;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0boolean_t enable_quirks;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0boolean_t no_clients_rereg;
> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
> index 6bbbfa2..51f0aed 100644
> --- a/opensm/opensm/osm_qos.c
> +++ b/opensm/opensm/osm_qos.c
> @@ -202,15 +202,21 @@ static ib_api_status_t sl2vl_update_table(osm_s=
m_t * sm, osm_physp_t * p,
> =C2=A0}
>
> =C2=A0static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct qos_config *qcfg)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct qos_config *qcfg, boolean_t e=
dge_ports_only)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_physp_t *p0, *p;
> + =C2=A0 =C2=A0 =C2=A0 osm_node_t *p_remote_node;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned force_update;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned num_ports =3D osm_node_get_num_ph=
ysp(node);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned i, j;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 1; i < num_ports; i++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (edge_ports_onl=
y) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_remote_node =3D osm_node_get_remote_node(node, i, NULL);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (p_remote_node && (osm_node_get_type(p_remote_node) !=3D IB_=
NODE_TYPE_CA))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D osm_node=
_get_physp_ptr(node, i);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_update =3D=
 p->need_update || sm->p_subn->need_update;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p->vl_high_lim=
it =3D qcfg->vl_high_limit;
> @@ -231,6 +237,11 @@ static int qos_extports_setup(osm_sm_t * sm, osm=
_node_t *node,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 1; i < num_ports; i++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (edge_ports_onl=
y ) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_remote_node =3D osm_node_get_remote_node(node, i, NULL);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (p_remote_node && (osm_node_get_type(p_remote_node) !=3D IB_=
NODE_TYPE_CA))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D osm_node=
_get_physp_ptr(node, i);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_update =3D=
 p->need_update || sm->p_subn->need_update;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (j =3D 0; =
j < num_ports; j++)

How does this work when optimized SL to VL programming is enabled and
supported on the device ? Doesn't some handling need to be added for
this ?

> @@ -262,7 +273,7 @@ static int qos_endport_setup(osm_sm_t * sm, osm_p=
hysp_t * p,
>
> =C2=A0int osm_qos_setup(osm_opensm_t * p_osm)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct qos_config ca_config, sw0_config, swe_c=
onfig, rtr_config;
> + =C2=A0 =C2=A0 =C2=A0 struct qos_config ca_config, sw0_config, swe_c=
onfig, sw_edge_config, rtr_config;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct qos_config *cfg;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_qmap_t *p_tbl;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_map_item_t *p_next;
> @@ -281,6 +292,8 @@ int osm_qos_setup(osm_opensm_t * p_osm)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 &p_osm->subn.opt.qos_options);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0qos_build_config(&swe_config, &p_osm->subn=
=2Eopt.qos_swe_options,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 &p_osm->subn.opt.qos_options);
> + =C2=A0 =C2=A0 =C2=A0 qos_build_config(&sw_edge_config, &p_osm->subn=
=2Eopt.qos_sw_edge_options,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0&p_osm->subn.opt.qos_options);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0qos_build_config(&rtr_config, &p_osm->subn=
=2Eopt.qos_rtr_options,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 &p_osm->subn.opt.qos_options);
>
> @@ -297,9 +310,11 @@ int osm_qos_setup(osm_opensm_t * p_osm)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_node =3D p_p=
ort->p_node;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (p_node->sw=
) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (qos_extports_setup(&p_osm->sm, p_node, &swe_config))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (qos_extports_setup(&p_osm->sm, p_node, &swe_config, FALSE))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -1;
>
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (qos_extports_setup(&p_osm->sm, p_node, &sw_edge_config, TRU=
E))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* skip base port 0 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (!ib_switch_info_is_enhanced_port0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0(&p_node->sw->switch_info))
> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
> index edbffe8..aa82f32 100644
> --- a/opensm/opensm/osm_subnet.c
> +++ b/opensm/opensm/osm_subnet.c
> @@ -385,6 +385,11 @@ static const opt_rec_t opt_tbl[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "qos_swe_vlarb_high", OPT_OFFSET(qos_swe=
_options.vlarb_high), opts_parse_charp, NULL, 1 },
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "qos_swe_vlarb_low", OPT_OFFSET(qos_swe_=
options.vlarb_low), opts_parse_charp, NULL, 1 },
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "qos_swe_sl2vl", OPT_OFFSET(qos_swe_opti=
ons.sl2vl), opts_parse_charp, NULL, 1 },
> + =C2=A0 =C2=A0 =C2=A0 { "qos_edge_max_vls", OPT_OFFSET(qos_sw_edge_o=
ptions.max_vls), opts_parse_uint32, NULL, 1 },
> + =C2=A0 =C2=A0 =C2=A0 { "qos_edge_high_limit", OPT_OFFSET(qos_sw_edg=
e_options.high_limit), opts_parse_int32, NULL, 1 },
> + =C2=A0 =C2=A0 =C2=A0 { "qos_edge_vlarb_high", OPT_OFFSET(qos_sw_edg=
e_options.vlarb_high), opts_parse_charp, NULL, 1 },
> + =C2=A0 =C2=A0 =C2=A0 { "qos_edge_vlarb_low", OPT_OFFSET(qos_sw_edge=
_options.vlarb_low), opts_parse_charp, NULL, 1 },
> + =C2=A0 =C2=A0 =C2=A0 { "qos_edge_sl2vl", OPT_OFFSET(qos_sw_edge_opt=
ions.sl2vl), opts_parse_charp, NULL, 1 },

Are edge ports the same as leaf ports ? If so, it would be better to
use that terminology if it is the same as it is already used and
exposed in OpenSM. Maybe the difference is that edge ports currently
appear to only have CA ports as peers whereas leaf ports have CA or
router ports as peers.

-- Hal

> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "qos_rtr_max_vls", OPT_OFFSET(qos_rtr_op=
tions.max_vls), opts_parse_uint32, NULL, 1 },
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "qos_rtr_high_limit", OPT_OFFSET(qos_rtr=
_options.high_limit), opts_parse_int32, NULL, 1 },
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "qos_rtr_vlarb_high", OPT_OFFSET(qos_rtr=
_options.vlarb_high), opts_parse_charp, NULL, 1 },
> @@ -768,6 +773,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t *=
 p_opt)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0subn_init_qos_options(&p_opt->qos_ca_optio=
ns, NULL);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0subn_init_qos_options(&p_opt->qos_sw0_opti=
ons, NULL);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0subn_init_qos_options(&p_opt->qos_swe_opti=
ons, NULL);
> + =C2=A0 =C2=A0 =C2=A0 subn_init_qos_options(&p_opt->qos_sw_edge_opti=
ons, NULL);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0subn_init_qos_options(&p_opt->qos_rtr_opti=
ons, NULL);
> =C2=A0}
>
> @@ -1112,6 +1118,8 @@ int osm_subn_verify_config(IN osm_subn_opt_t * =
p_opts)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&p_opts->qos_op=
tions);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0subn_verify_qo=
s_set(&p_opts->qos_swe_options, "qos_swe",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&p_opts->qos_op=
tions);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 subn_verify_qos_se=
t(&p_opts->qos_sw_edge_options, "qos_edge",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &p_opts->qos_options)=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0subn_verify_qo=
s_set(&p_opts->qos_rtr_options, "qos_rtr",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&p_opts->qos_op=
tions);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> @@ -1220,6 +1228,8 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * =
p_subn)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&p_opts->file_opts->qos_sw0_options)=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0subn_init_qos_options(&p_opts->qos_swe_opt=
ions,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&p_opts->file_opts->qos_swe_options)=
;
> + =C2=A0 =C2=A0 =C2=A0 subn_init_qos_options(&p_opts->qos_sw_edge_opt=
ions,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &p_opts->file_opts->qos_sw_edge_options);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0subn_init_qos_options(&p_opts->qos_rtr_opt=
ions,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&p_opts->file_opts->qos_rtr_options)=
;
>
> @@ -1620,6 +1630,10 @@ int osm_subn_output_conf(FILE *out, IN osm_sub=
n_opt_t * p_opts)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&p_opts->qos_swe_options);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(out, "\n");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0subn_dump_qos_options(out,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "QoS Edge ports options", "qos_edge",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &p_opts->qos_sw_edge_options);
> + =C2=A0 =C2=A0 =C2=A0 fprintf(out, "\n");
> + =C2=A0 =C2=A0 =C2=A0 subn_dump_qos_options(out,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"QoS Router ports options", "qos_rtr=
",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&p_opts->qos_rtr_options);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(out, "\n");
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
