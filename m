From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Add support for optimized SLtoVLMappingTable
	programming
Date: Thu, 7 Jan 2010 08:35:28 -0500
Message-ID: <f0e08f231001070535l382f1d54t7f6290607e52b196@mail.gmail.com>
References: <20091201194110.GA26753@comcast.net> <20100105111841.GO26940@me>
	 <20100105112334.GP26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100105112334.GP26940@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 5, 2010 at 6:23 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> On 13:18 Tue 05 Jan =C2=A0 =C2=A0 , Sasha Khapyorsky wrote:
>> >
>> > Optimized SLtoVLMappingTable programming reduces the number of MAD=
s
>> > needed from O(n**2) to O(n). See IBA 1.2.1 vol 1 p. 843 14.2.5.8
>> > SLtoVLMappingTable.
>> >
>> > Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > ---
>>
>> [snip]
>>
>> > diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
>> > index 08f9a60..617a86e 100644
>> > --- a/opensm/opensm/osm_qos.c
>> > +++ b/opensm/opensm/osm_qos.c
>>
>
> After rebasing this part over recently posted patches it becomes:
>
> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
> index f54e995..6bbbfa2 100644
> --- a/opensm/opensm/osm_qos.c
> +++ b/opensm/opensm/osm_qos.c
> @@ -1,5 +1,6 @@
> =C2=A0/*
> =C2=A0* Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
> =C2=A0*
> =C2=A0* This software is available to you under a choice of one of tw=
o
> =C2=A0* licenses. =C2=A0You may choose to be licensed under the terms=
 of the GNU
> @@ -157,14 +158,13 @@ static ib_api_status_t vlarb_update(osm_sm_t * =
sm, osm_physp_t * p,
> =C2=A0}
>
> =C2=A0static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_ph=
ysp_t * p,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
uint8_t in_port, uint8_t out_port,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
uint8_t in_port, uint32_t attr_mod,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0unsigned force_update,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0const ib_slvl_table_t * sl2vl_table)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_madw_context_t context;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ib_slvl_table_t tbl, *p_tbl;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_node_t *p_node =3D osm_physp_get_node_=
ptr(p);
> - =C2=A0 =C2=A0 =C2=A0 uint32_t attr_mod;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ib_api_status_t status;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned vl_mask;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0uint8_t vl1, vl2;
> @@ -189,7 +189,6 @@ static ib_api_status_t sl2vl_update_table(osm_sm_=
t * sm, osm_physp_t * p,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0context.slvl_context.node_guid =3D osm_nod=
e_get_node_guid(p_node);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0context.slvl_context.port_guid =3D osm_phy=
sp_get_port_guid(p);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0context.slvl_context.set_method =3D TRUE;
> - =C2=A0 =C2=A0 =C2=A0 attr_mod =3D in_port << 8 | out_port;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D osm_req_set(sm, osm_physp_get_d=
r_path_ptr(p),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t *) & tbl, sizeof(tbl),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_MAD_ATTR_SLVL_TABLE, cl_hton32(attr_mod=
),
> @@ -223,12 +222,20 @@ static int qos_extports_setup(osm_sm_t * sm, os=
m_node_t *node,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(p0->port_info.capability_mask & IB_P=
ORT_CAP_HAS_SL_MAP))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
>
> + =C2=A0 =C2=A0 =C2=A0 if (ib_switch_info_get_opt_sl2vlmapping(&node-=
>sw->switch_info) &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sm->p_subn->opt.use_optimized_sl=
vl) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p =3D osm_node_get=
_physp_ptr(node, 1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 force_update =3D p=
->need_update || sm->p_subn->need_update;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return sl2vl_updat=
e_table(sm, p, 1, 0x30000, force_update,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
&qcfg->sl2vl);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 1; i < num_ports; i++) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D osm_node=
_get_physp_ptr(node, i);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_update =3D=
 p->need_update || sm->p_subn->need_update;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (j =3D 0; =
j < num_ports; j++)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (sl2vl_update_table(sm, p, i, j, force_update,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0&qcfg->sl2vl))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (sl2vl_update_table(sm, p, i, i << 8 | j,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0force_update, &qcfg->sl2vl))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
>
> , does it look fine for you?

In the optimized case, doesn't this send extra SL2VL mapping table ?
Couldn''t that be eliminated by checking for this in the new endport
routine (and skipping the remainder of that routine) ?

-- Hal

>
> Sasha
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
