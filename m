From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Add support for optimized SLtoVLMappingTable
 programming
Date: Tue, 12 Jan 2010 12:55:16 +0200
Message-ID: <20100112105516.GK26089@me>
References: <20091201194110.GA26753@comcast.net>
 <20100105111841.GO26940@me>
 <20100105112334.GP26940@me>
 <f0e08f231001070535l382f1d54t7f6290607e52b196@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f231001070535l382f1d54t7f6290607e52b196-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08:35 Thu 07 Jan     , Hal Rosenstock wrote:
> >
> > diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
> > index f54e995..6bbbfa2 100644
> > --- a/opensm/opensm/osm_qos.c
> > +++ b/opensm/opensm/osm_qos.c
> > @@ -1,5 +1,6 @@
> > =A0/*
> > =A0* Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
> > + * Copyright (c) 2009 HNR Consulting. All rights reserved.
> > =A0*
> > =A0* This software is available to you under a choice of one of two
> > =A0* licenses. =A0You may choose to be licensed under the terms of =
the GNU
> > @@ -157,14 +158,13 @@ static ib_api_status_t vlarb_update(osm_sm_t =
* sm, osm_physp_t * p,
> > =A0}
> >
> > =A0static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_phy=
sp_t * p,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 uint8_t in_port, uint8_t out_port,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 uint8_t in_port, uint32_t attr_mod,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0unsigned force_update,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0const ib_slvl_table_t * sl2vl_table)
> > =A0{
> > =A0 =A0 =A0 =A0osm_madw_context_t context;
> > =A0 =A0 =A0 =A0ib_slvl_table_t tbl, *p_tbl;
> > =A0 =A0 =A0 =A0osm_node_t *p_node =3D osm_physp_get_node_ptr(p);
> > - =A0 =A0 =A0 uint32_t attr_mod;
> > =A0 =A0 =A0 =A0ib_api_status_t status;
> > =A0 =A0 =A0 =A0unsigned vl_mask;
> > =A0 =A0 =A0 =A0uint8_t vl1, vl2;
> > @@ -189,7 +189,6 @@ static ib_api_status_t sl2vl_update_table(osm_s=
m_t * sm, osm_physp_t * p,
> > =A0 =A0 =A0 =A0context.slvl_context.node_guid =3D osm_node_get_node=
_guid(p_node);
> > =A0 =A0 =A0 =A0context.slvl_context.port_guid =3D osm_physp_get_por=
t_guid(p);
> > =A0 =A0 =A0 =A0context.slvl_context.set_method =3D TRUE;
> > - =A0 =A0 =A0 attr_mod =3D in_port << 8 | out_port;
> > =A0 =A0 =A0 =A0status =3D osm_req_set(sm, osm_physp_get_dr_path_ptr=
(p),
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (uint8_t *)=
 & tbl, sizeof(tbl),
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IB_MAD_ATTR=
_SLVL_TABLE, cl_hton32(attr_mod),
> > @@ -223,12 +222,20 @@ static int qos_extports_setup(osm_sm_t * sm, =
osm_node_t *node,
> > =A0 =A0 =A0 =A0if (!(p0->port_info.capability_mask & IB_PORT_CAP_HA=
S_SL_MAP))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ret;
> >
> > + =A0 =A0 =A0 if (ib_switch_info_get_opt_sl2vlmapping(&node->sw->sw=
itch_info) &&
> > + =A0 =A0 =A0 =A0 =A0 sm->p_subn->opt.use_optimized_slvl) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p =3D osm_node_get_physp_ptr(node, 1)=
;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 force_update =3D p->need_update || sm=
->p_subn->need_update;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return sl2vl_update_table(sm, p, 1, 0=
x30000, force_update,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 &qcfg->sl2vl);
> > + =A0 =A0 =A0 }
> > +
> > =A0 =A0 =A0 =A0for (i =3D 1; i < num_ports; i++) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0p =3D osm_node_get_physp_ptr(node, i=
);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0force_update =3D p->need_update || s=
m->p_subn->need_update;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (j =3D 0; j < num_ports; j++)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sl2vl_update_tabl=
e(sm, p, i, j, force_update,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0&qcfg->sl2vl))
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sl2vl_update_tabl=
e(sm, p, i, i << 8 | j,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0force_update, &qcfg->sl2vl))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =
=3D -1;
> > =A0 =A0 =A0 =A0}
> >
> >
> > , does it look fine for you?
>=20
> In the optimized case, doesn't this send extra SL2VL mapping table ?

I don't see how, could you elaborate?

Sasha

> Couldn''t that be eliminated by checking for this in the new endport
> routine (and skipping the remainder of that routine) ?
>=20
> -- Hal
>=20
> >
> > Sasha
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
