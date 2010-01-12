From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_qos.c: split switch external and end ports
 setup
Date: Tue, 12 Jan 2010 12:43:58 +0200
Message-ID: <20100112104358.GJ26089@me>
References: <20091201194110.GA26753@comcast.net>
 <20100104170141.GK26940@me>
 <20100105111032.GN26940@me>
 <f0e08f231001070540y26b69cb3v82dddc1d7b7134b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f231001070540y26b69cb3v82dddc1d7b7134b9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08:40 Thu 07 Jan     , Hal Rosenstock wrote:
> On Tue, Jan 5, 2010 at 6:10 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
> >
> > This splits QoS related port parameters setup over switch external =
ports
> > and end ports. Such separation leaves us with simpler code and save=
s
> > some repeated flows in case of switch external ports (actually requ=
ired
> > per switch and not per port).
>=20
> Not sure what you mean by required in this statement. What are you
> referring to as required per switch rather than per port ?

Duplicated per switch external port setup detection of common (per
switch) data - such as: number of ports, Sl2VL mapping capability
p0->port_info.capability_mask.

>=20
> > Another advantages: Optimized Sl2VL Mapping procedure can be implem=
ented
> > easier using this model. A low level port QoS related parameters se=
tup
> > infrastructure is ready for supporting per port QoS related configu=
ration
> > (which hopefully will be implemented some days).
> >
> > Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> > ---
> > =A0opensm/opensm/osm_qos.c | =A0137 +++++++++++++++++++++----------=
----------------
> > =A01 files changed, 61 insertions(+), 76 deletions(-)
> >
> > diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
> > index afeaa11..f54e995 100644
> > --- a/opensm/opensm/osm_qos.c
> > +++ b/opensm/opensm/osm_qos.c
> > @@ -77,6 +77,7 @@ static ib_api_status_t vlarb_update_table_block(o=
sm_sm_t * sm,
> > =A0 =A0 =A0 =A0osm_madw_context_t context;
> > =A0 =A0 =A0 =A0uint32_t attr_mod;
> > =A0 =A0 =A0 =A0unsigned vl_mask, i;
> > + =A0 =A0 =A0 ib_api_status_t status;
> >
> > =A0 =A0 =A0 =A0vl_mask =3D (1 << (ib_port_info_get_op_vls(&p->port_=
info) - 1)) - 1;
> >
> > @@ -96,10 +97,17 @@ static ib_api_status_t vlarb_update_table_block=
(osm_sm_t * sm,
> > =A0 =A0 =A0 =A0context.vla_context.set_method =3D TRUE;
> > =A0 =A0 =A0 =A0attr_mod =3D ((block_num + 1) << 16) | port_num;
> >
> > - =A0 =A0 =A0 return osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(uint8_t *) & =
block, sizeof(block),
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IB_MAD_ATTR_VL=
_ARBITRATION, cl_hton32(attr_mod),
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CL_DISP_MSGID_=
NONE, &context);
> > + =A0 =A0 =A0 status =3D osm_req_set(sm, osm_physp_get_dr_path_ptr(=
p),
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(uint8_t *=
) & block, sizeof(block),
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IB_MAD_ATT=
R_VL_ARBITRATION, cl_hton32(attr_mod),
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CL_DISP_MS=
GID_NONE, &context);
> > + =A0 =A0 =A0 if (status !=3D IB_SUCCESS)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ER=
R 6202 : "
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "failed to update VLA=
rbitration tables "
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "for port %" PRIx64 "=
 block %u\n",
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cl_ntoh64(p->port_gui=
d), block_num);
> > +
> > + =A0 =A0 =A0 return status;
> > =A0}
> >
> > =A0static ib_api_status_t vlarb_update(osm_sm_t * sm, osm_physp_t *=
 p,
> > @@ -157,6 +165,7 @@ static ib_api_status_t sl2vl_update_table(osm_s=
m_t * sm, osm_physp_t * p,
> > =A0 =A0 =A0 =A0ib_slvl_table_t tbl, *p_tbl;
> > =A0 =A0 =A0 =A0osm_node_t *p_node =3D osm_physp_get_node_ptr(p);
> > =A0 =A0 =A0 =A0uint32_t attr_mod;
> > + =A0 =A0 =A0 ib_api_status_t status;
> > =A0 =A0 =A0 =A0unsigned vl_mask;
> > =A0 =A0 =A0 =A0uint8_t vl1, vl2;
> > =A0 =A0 =A0 =A0int i;
> > @@ -181,70 +190,65 @@ static ib_api_status_t sl2vl_update_table(osm=
_sm_t * sm, osm_physp_t * p,
> > =A0 =A0 =A0 =A0context.slvl_context.port_guid =3D osm_physp_get_por=
t_guid(p);
> > =A0 =A0 =A0 =A0context.slvl_context.set_method =3D TRUE;
> > =A0 =A0 =A0 =A0attr_mod =3D in_port << 8 | out_port;
> > - =A0 =A0 =A0 return osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(uint8_t *) & =
tbl, sizeof(tbl),
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IB_MAD_ATTR_SL=
VL_TABLE, cl_hton32(attr_mod),
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CL_DISP_MSGID_=
NONE, &context);
> > + =A0 =A0 =A0 status =3D osm_req_set(sm, osm_physp_get_dr_path_ptr(=
p),
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(uint8_t *=
) & tbl, sizeof(tbl),
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IB_MAD_ATT=
R_SLVL_TABLE, cl_hton32(attr_mod),
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CL_DISP_MS=
GID_NONE, &context);
> > + =A0 =A0 =A0 if (status !=3D IB_SUCCESS)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ER=
R 6203 : "
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "failed to update SL2=
VLMapping tables "
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "for port %" PRIx64 "=
i, attr_mod 0x%x\n",
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cl_ntoh64(p->port_gui=
d), attr_mod);
> > + =A0 =A0 =A0 return status;
> > =A0}
> >
> > -static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_=
port,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 osm_physp_t * p, uint8_t port_num,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 unsigned force_update,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 const struct qos_config *qcfg)
> > +static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const str=
uct qos_config *qcfg)
> > =A0{
> > - =A0 =A0 =A0 ib_api_status_t status;
> > - =A0 =A0 =A0 uint8_t i, num_ports;
> > - =A0 =A0 =A0 ib_port_info_t *pi =3D &p_port->p_physp->port_info;
> > -
> > - =A0 =A0 =A0 if (!(pi->capability_mask & IB_PORT_CAP_HAS_SL_MAP))
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return IB_SUCCESS;
> > + =A0 =A0 =A0 osm_physp_t *p0, *p;
> > + =A0 =A0 =A0 unsigned force_update;
> > + =A0 =A0 =A0 unsigned num_ports =3D osm_node_get_num_physp(node);
> > + =A0 =A0 =A0 int ret =3D 0;
> > + =A0 =A0 =A0 unsigned i, j;
> >
> > - =A0 =A0 =A0 if (osm_node_get_type(osm_physp_get_node_ptr(p)) =3D=3D=
 IB_NODE_TYPE_SWITCH)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_ports =3D osm_node_get_num_physp(=
osm_physp_get_node_ptr(p));
> > - =A0 =A0 =A0 else
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_ports =3D 1;
> > + =A0 =A0 =A0 for (i =3D 1; i < num_ports; i++) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p =3D osm_node_get_physp_ptr(node, i)=
;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 force_update =3D p->need_update || sm=
->p_subn->need_update;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p->vl_high_limit =3D qcfg->vl_high_li=
mit;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (vlarb_update(sm, p, p->port_num, =
force_update, qcfg))
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -1;
> > + =A0 =A0 =A0 }
> >
> > - =A0 =A0 =A0 for (i =3D 0; i < num_ports; i++) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 status =3D sl2vl_update_table(sm, p, =
i, port_num, force_update,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 &qcfg->sl2vl);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (status !=3D IB_SUCCESS)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return status;
> > + =A0 =A0 =A0 p0 =3D osm_node_get_physp_ptr(node, 0);
> > + =A0 =A0 =A0 if (!(p0->port_info.capability_mask & IB_PORT_CAP_HAS=
_SL_MAP))
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>=20
> Same comment on this as previous osm_qos patch comment on merging the
> SL2VL mapping capability check.

I answered there.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
