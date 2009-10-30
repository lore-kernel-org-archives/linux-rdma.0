From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add initial support for optimized
	SLtoVLMappingTable programming
Date: Fri, 30 Oct 2009 11:40:20 -0400
Message-ID: <f0e08f230910300840t2902ea50ye20420694fd7ef7@mail.gmail.com>
References: <20090804131836.GA15226@comcast.net> <20091030022324.GT20136@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091030022324.GT20136@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 29, 2009 at 10:23 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
> On 09:18 Tue 04 Aug =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>
> Implementation description would be very useful.

> What does "initial support" mean?

It means there's more to come in terms of using
OptimizedSLtoVLMappingProgramming. This is the simplest
use/introduction of this optional feature.

>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/ope=
nsm/osm_subnet.h
>> index 6c20de8..8443763 100644
>> --- a/opensm/include/opensm/osm_subnet.h
>> +++ b/opensm/include/opensm/osm_subnet.h
>> @@ -4,6 +4,7 @@
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 * Copyright (c) 2008 Xsigo Systems Inc. =C2=A0All rights rese=
rved.
>> =C2=A0 * Copyright (c) 2009 System Fabric Works, Inc. All rights res=
erved.
>> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -204,6 +205,7 @@ typedef struct osm_subn_opt {
>> =C2=A0 =C2=A0 =C2=A0 boolean_t daemon;
>> =C2=A0 =C2=A0 =C2=A0 boolean_t sm_inactive;
>> =C2=A0 =C2=A0 =C2=A0 boolean_t babbling_port_policy;
>> + =C2=A0 =C2=A0 boolean_t use_optimized_slvl;
>> =C2=A0 =C2=A0 =C2=A0 osm_qos_options_t qos_options;
>> =C2=A0 =C2=A0 =C2=A0 osm_qos_options_t qos_ca_options;
>> =C2=A0 =C2=A0 =C2=A0 osm_qos_options_t qos_sw0_options;
>> @@ -428,6 +430,10 @@ typedef struct osm_subn_opt {
>> =C2=A0* =C2=A0 =C2=A0babbling_port_policy
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0OpenSM will enforce=
 its "babbling" port policy.
>> =C2=A0*
>> +* =C2=A0 =C2=A0use_optimized_slvl
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Use optimized SLtoVLMapp=
ingTable programming if
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0device indicates it supp=
orts this.
>> +*
>> =C2=A0* =C2=A0 =C2=A0perfmgr
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Enable or disable t=
he performance manager
>> =C2=A0*
>> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
>> index e3dfb58..592e082 100644
>> --- a/opensm/opensm/osm_qos.c
>> +++ b/opensm/opensm/osm_qos.c
>> @@ -1,5 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2006-2008 Voltaire, Inc. All rights reserved.
>> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -150,7 +151,7 @@ static ib_api_status_t vlarb_update(osm_sm_t * s=
m, osm_physp_t * p,
>>
>> =C2=A0static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_p=
hysp_t * p,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
uint8_t in_port, uint8_t out_port,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsi=
gned force_update,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsi=
gned optimize, unsigned force_update,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
const ib_slvl_table_t * sl2vl_table)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 osm_madw_context_t context;
>> @@ -177,10 +178,18 @@ static ib_api_status_t sl2vl_update_table(osm_=
sm_t * sm, osm_physp_t * p,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !memcmp(p_tbl, &tbl, sizeof(tbl))=
)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IB_SUCCESS;
>>
>> + =C2=A0 =C2=A0 /* both input port and output port wildcarded */
>> + =C2=A0 =C2=A0 if (optimize && (in_port !=3D 1 || out_port !=3D 1))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IB_SUCCESS;
>> +
>
> This function (sl2vl_update_table()) is called for each in and out po=
rts
> combination. I think that instead of calling it N * N times and
> filtering out the case 'in =3D=3D out =3D=3D 1' you just need it once=
 somewhere
> at higher layer.

I was trying to minimize the changes to the current code flow. It can
be done the way you propose but that will cause larger changes. Are
you sure about this direction ?

>> =C2=A0 =C2=A0 =C2=A0 context.slvl_context.node_guid =3D osm_node_get=
_node_guid(p_node);
>> =C2=A0 =C2=A0 =C2=A0 context.slvl_context.port_guid =3D osm_physp_ge=
t_port_guid(p);
>> =C2=A0 =C2=A0 =C2=A0 context.slvl_context.set_method =3D TRUE;
>> - =C2=A0 =C2=A0 attr_mod =3D in_port << 8 | out_port;
>> + =C2=A0 =C2=A0 if (optimize)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* both input port and o=
utput port wildcarded */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 attr_mod =3D 0x30000;
>> + =C2=A0 =C2=A0 else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 attr_mod =3D in_port << =
8 | out_port;
>> =C2=A0 =C2=A0 =C2=A0 return osm_req_set(sm, osm_physp_get_dr_path_pt=
r(p),
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0(uint8_t *) & tbl, sizeof(tbl),
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0IB_MAD_ATTR_SLVL_TABLE, cl_hton32(attr_mod),
>> @@ -189,14 +198,17 @@ static ib_api_status_t sl2vl_update_table(osm_=
sm_t * sm, osm_physp_t * p,
>>
>> =C2=A0static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t =
* p_port,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_physp_t * p, uint=
8_t port_num,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned force_update,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned optimize, unsign=
ed force_update,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct qos_conf=
ig *qcfg)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status;
>> =C2=A0 =C2=A0 =C2=A0 uint8_t i, num_ports;
>> =C2=A0 =C2=A0 =C2=A0 osm_physp_t *p_physp;
>> + =C2=A0 =C2=A0 osm_node_t *p_node;
>> + =C2=A0 =C2=A0 unsigned optimizesl2vl =3D 0;
>>
>> - =C2=A0 =C2=A0 if (osm_node_get_type(osm_physp_get_node_ptr(p)) =3D=
=3D IB_NODE_TYPE_SWITCH) {
>> + =C2=A0 =C2=A0 p_node =3D osm_physp_get_node_ptr(p);
>> + =C2=A0 =C2=A0 if (osm_node_get_type(p_node) =3D=3D IB_NODE_TYPE_SW=
ITCH) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ib_port_info_ge=
t_vl_cap(&p->port_info) =3D=3D 1) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 /* Check port 0's capability mask */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_physp =3D p_port->p_physp;
>> @@ -205,7 +217,8 @@ static ib_api_status_t sl2vl_update(osm_sm_t * s=
m, osm_port_t * p_port,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0capability_mask & IB_PORT_CAP_HAS_SL_MAP))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IB_SUCCESS;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 num_ports =3D osm_node_g=
et_num_physp(osm_physp_get_node_ptr(p));
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 num_ports =3D osm_node_g=
et_num_physp(p_node);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 optimizesl2vl =3D ib_swi=
tch_info_get_opt_sl2vlmapping(&p_node->sw->switch_info) & optimize;
>
> It should be once per switch, not for each switch port.

Sure; if (still) needed here (might depend on the approach) is a
tradeoff of a simple local operation v. an additional passed in
parameter.

>> =C2=A0 =C2=A0 =C2=A0 } else {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!(p->port_info.=
capability_mask & IB_PORT_CAP_HAS_SL_MAP))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return IB_SUCCESS;
>> @@ -213,8 +226,8 @@ static ib_api_status_t sl2vl_update(osm_sm_t * s=
m, osm_port_t * p_port,
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < num_ports; i++) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D sl2vl_update_=
table(sm, p, i, port_num, force_update,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 &qcfg->sl2vl);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D sl2vl_update_=
table(sm, p, i, port_num, optimizesl2vl,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 force_update, &qcfg->sl2vl);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_=
SUCCESS)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return status;
>> =C2=A0 =C2=A0 =C2=A0 }
>> @@ -224,7 +237,8 @@ static ib_api_status_t sl2vl_update(osm_sm_t * s=
m, osm_port_t * p_port,
>>
>> =C2=A0static int qos_physp_setup(osm_log_t * p_log, osm_sm_t * sm,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0osm_port_t * p_port, osm_physp_t * p,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0uint8_t port_num, unsigned force_update,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0uint8_t port_num, unsigned optimize,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0unsigned force_update,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0const struct qos_config *qcfg)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status;
>> @@ -245,7 +259,8 @@ static int qos_physp_setup(osm_log_t * p_log, os=
m_sm_t * sm,
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 /* setup SL2VL tables */
>> - =C2=A0 =C2=A0 status =3D sl2vl_update(sm, p_port, p, port_num, for=
ce_update, qcfg);
>> + =C2=A0 =C2=A0 status =3D sl2vl_update(sm, p_port, p, port_num, opt=
imize, force_update,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 qcfg);
>> =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_SUCCESS) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_ERROR, "ERR 6203 : "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "failed to update SL2VLMapping tables "
>> @@ -307,6 +322,7 @@ int osm_qos_setup(osm_opensm_t * p_osm)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_osm->subn.need_upda=
te;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (qos_physp_setup(&p_osm->log, &p=
_osm->sm,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_port, p_physp, i,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_osm->subn.opt.use_optimized_slvl,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 force_update, &swe_config))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D=
 -1;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 }
>> @@ -327,7 +343,7 @@ int osm_qos_setup(osm_opensm_t * p_osm)
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 force_update =3D p_=
physp->need_update || p_osm->subn.need_update;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (qos_physp_setup=
(&p_osm->log, &p_osm->sm, p_port, p_physp,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0, force_update, cfg))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0, 0, force_update, cfg))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ret =3D -1;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> diff --git a/opensm/opensm/osm_slvl_map_rcv.c b/opensm/opensm/osm_sl=
vl_map_rcv.c
>> index 9c37442..67c71bd 100644
>> --- a/opensm/opensm/osm_slvl_map_rcv.c
>> +++ b/opensm/opensm/osm_slvl_map_rcv.c
>> @@ -2,6 +2,7 @@
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> =C2=A0 * Copyright (c) 2002-2005 Mellanox Technologies LTD. All righ=
ts reserved.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -72,7 +73,9 @@ void osm_slvl_rcv_process(IN void *context, IN voi=
d *p_data)
>> =C2=A0 =C2=A0 =C2=A0 osm_slvl_context_t *p_context;
>> =C2=A0 =C2=A0 =C2=A0 ib_net64_t port_guid;
>> =C2=A0 =C2=A0 =C2=A0 ib_net64_t node_guid;
>> - =C2=A0 =C2=A0 uint8_t out_port_num, in_port_num;
>> + =C2=A0 =C2=A0 uint32_t attr_mod;
>> + =C2=A0 =C2=A0 uint8_t out_port_num, in_port_num, startinport, star=
toutport,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 endinport, endoutport;
>>
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(sm);
>>
>> @@ -111,6 +114,9 @@ void osm_slvl_rcv_process(IN void *context, IN v=
oid *p_data)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint=
8_t) cl_ntoh32(p_smp->attr_mod & 0xFF000000);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in_port_num =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint=
8_t) cl_ntoh32((p_smp->attr_mod & 0x00FF0000) << 8);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 attr_mod =3D cl_ntoh32(p=
_smp->attr_mod);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (attr_mod & 0x30000)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto opt_sl2vl;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_physp =3D osm_nod=
e_get_physp_ptr(p_node, out_port_num);
>> =C2=A0 =C2=A0 =C2=A0 } else {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_physp =3D p_port-=
>p_physp;
>> @@ -123,7 +129,7 @@ void osm_slvl_rcv_process(IN void *context, IN v=
oid *p_data)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0all we want is to update the subne=
t.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Got SLtoVL get response=
 in_port_num %u out_port_num %u with "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Received SLtoVL GetResp=
 in_port_num %u out_port_num %u with "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "GUID 0x%" PRIx64 "=
 for parent node GUID 0x%" PRIx64 ", TID 0x%"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 PRIx64 "\n", in_por=
t_num, out_port_num, cl_ntoh64(port_guid),
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh64(node_guid=
), cl_ntoh64(p_smp->trans_id));
>> @@ -142,6 +148,39 @@ void osm_slvl_rcv_process(IN void *context, IN =
void *p_data)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 out_port_num, p_slvl_tbl, OSM_LOG_D=
EBUG);
>>
>> =C2=A0 =C2=A0 =C2=A0 osm_physp_set_slvl_tbl(p_physp, p_slvl_tbl, in_=
port_num);
>> + =C2=A0 =C2=A0 goto Exit;
>> +
>> +opt_sl2vl:
>
> I think that you need to use functions here.

Where is here ? To what are you referring ?

>> + =C2=A0 =C2=A0 OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Got optimized SLtoVL ge=
t response in_port_num %u out_port_num "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "%u with GUID 0x%" PRIx6=
4 " for parent node GUID 0x%" PRIx64
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ", TID 0x%" PRIx64 "\n",=
 in_port_num, out_port_num,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh64(port_guid), cl=
_ntoh64(node_guid),
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh64(p_smp->trans_i=
d));
>> +
>> + =C2=A0 =C2=A0 osm_dump_slvl_map_table(sm->p_log, port_guid, in_por=
t_num,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 out_port_num, p_slvl_tbl, OSM_LOG_DEBUG=
);
>> +
>> + =C2=A0 =C2=A0 if (attr_mod & 0x10000) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 startoutport =3D ib_swit=
ch_info_is_enhanced_port0(&p_node->sw->switch_info) ? 0 : 1;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 endoutport =3D osm_node_=
get_num_physp(p_node);
>> + =C2=A0 =C2=A0 } else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 endoutport =3D startoutp=
ort =3D out_port_num;
>> + =C2=A0 =C2=A0 if (attr_mod & 0x20000) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 startinport =3D ib_switc=
h_info_is_enhanced_port0(&p_node->sw->switch_info) ? 0 : 1;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 endinport =3D osm_node_g=
et_num_physp(p_node);
>> + =C2=A0 =C2=A0 } else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 endinport =3D startinpor=
t =3D in_port_num;
>> +
>> + =C2=A0 =C2=A0 for (out_port_num =3D startoutport; out_port_num < e=
ndoutport;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0out_port_num++) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_physp =3D osm_node_get=
_physp_ptr(p_node, out_port_num);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!p_physp)
>
> When could this be NULL?

It was just defensive. Should it be removed ?

-- Hal

> Sasha
>
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 continue;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (in_port_num =3D sta=
rtinport; in_port_num < endinport;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0in_p=
ort_num++)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 osm_physp_set_slvl_tbl(p_physp, p_slvl_tbl, in_port_num);
>> + =C2=A0 =C2=A0 }
>>
>> =C2=A0Exit:
>> =C2=A0 =C2=A0 =C2=A0 cl_plock_release(sm->p_lock);
>> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
>> index 0d11811..540165a 100644
>> --- a/opensm/opensm/osm_subnet.c
>> +++ b/opensm/opensm/osm_subnet.c
>> @@ -4,6 +4,7 @@
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 * Copyright (c) 2008 Xsigo Systems Inc. =C2=A0All rights rese=
rved.
>> =C2=A0 * Copyright (c) 2009 System Fabric Works, Inc. All rights res=
erved.
>> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -352,6 +353,7 @@ static const opt_rec_t opt_tbl[] =3D {
>> =C2=A0 =C2=A0 =C2=A0 { "daemon", OPT_OFFSET(daemon), opts_parse_bool=
ean, NULL, 0 },
>> =C2=A0 =C2=A0 =C2=A0 { "sm_inactive", OPT_OFFSET(sm_inactive), opts_=
parse_boolean, NULL, 1 },
>> =C2=A0 =C2=A0 =C2=A0 { "babbling_port_policy", OPT_OFFSET(babbling_p=
ort_policy), opts_parse_boolean, NULL, 1 },
>> + =C2=A0 =C2=A0 {"use_optimized_slvl", OPT_OFFSET(use_optimized_slvl=
), opts_parse_boolean, NULL, 1 },
>> =C2=A0#ifdef ENABLE_OSM_PERF_MGR
>> =C2=A0 =C2=A0 =C2=A0 { "perfmgr", OPT_OFFSET(perfmgr), opts_parse_bo=
olean, NULL, 0 },
>> =C2=A0 =C2=A0 =C2=A0 { "perfmgr_redir", OPT_OFFSET(perfmgr_redir), o=
pts_parse_boolean, NULL, 0 },
>> @@ -715,6 +717,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t =
* const p_opt)
>> =C2=A0 =C2=A0 =C2=A0 p_opt->daemon =3D FALSE;
>> =C2=A0 =C2=A0 =C2=A0 p_opt->sm_inactive =3D FALSE;
>> =C2=A0 =C2=A0 =C2=A0 p_opt->babbling_port_policy =3D FALSE;
>> + =C2=A0 =C2=A0 p_opt->use_optimized_slvl =3D FALSE;
>> =C2=A0#ifdef ENABLE_OSM_PERF_MGR
>> =C2=A0 =C2=A0 =C2=A0 p_opt->perfmgr =3D FALSE;
>> =C2=A0 =C2=A0 =C2=A0 p_opt->perfmgr_redir =3D TRUE;
>> @@ -1501,10 +1504,13 @@ int osm_subn_output_conf(FILE *out, IN osm_s=
ubn_opt_t *const p_opts)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# SM Inactive\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "sm_inactive %s\n\n=
"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# Babbling Port Po=
licy\n"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "babbling_port_policy %s=
\n\n",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "babbling_port_policy %s=
\n\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# Use Optimized SLtoVLM=
apping programming if supported by device\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "use_optimized_slvl %s\n=
\n",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->daemon ? "T=
RUE" : "FALSE",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->sm_inactive=
 ? "TRUE" : "FALSE",
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->babbling_port_po=
licy ? "TRUE" : "FALSE");
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->babbling_port_po=
licy ? "TRUE" : "FALSE",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->use_optimized_sl=
vl ? "TRUE" : "FALSE");
>>
>> =C2=A0#ifdef ENABLE_OSM_PERF_MGR
>> =C2=A0 =C2=A0 =C2=A0 fprintf(out,
>>
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
