From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Add support for optimized SLtoVLMappingTable
	programming
Date: Wed, 13 Jan 2010 15:14:23 -0500
Message-ID: <f0e08f231001131214w790b1f34s46cbbda8b6454ac3@mail.gmail.com>
References: <20091201194110.GA26753@comcast.net> <20100105111841.GO26940@me>
	 <20100105112334.GP26940@me>
	 <f0e08f231001070535l382f1d54t7f6290607e52b196@mail.gmail.com>
	 <20100112105516.GK26089@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100112105516.GK26089@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 12, 2010 at 5:55 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> On 08:35 Thu 07 Jan     , Hal Rosenstock wrote:
>> >
>> > diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
>> > index f54e995..6bbbfa2 100644
>> > --- a/opensm/opensm/osm_qos.c
>> > +++ b/opensm/opensm/osm_qos.c
>> > @@ -1,5 +1,6 @@
>> >  /*
>> >  * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
>> > + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> >  *
>> >  * This software is available to you under a choice of one of two
>> >  * licenses.  You may choose to be licensed under the terms of the GNU
>> > @@ -157,14 +158,13 @@ static ib_api_status_t vlarb_update(osm_sm_t * sm, osm_physp_t * p,
>> >  }
>> >
>> >  static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
>> > -                                         uint8_t in_port, uint8_t out_port,
>> > +                                         uint8_t in_port, uint32_t attr_mod,
>> >                                          unsigned force_update,
>> >                                          const ib_slvl_table_t * sl2vl_table)
>> >  {
>> >        osm_madw_context_t context;
>> >        ib_slvl_table_t tbl, *p_tbl;
>> >        osm_node_t *p_node = osm_physp_get_node_ptr(p);
>> > -       uint32_t attr_mod;
>> >        ib_api_status_t status;
>> >        unsigned vl_mask;
>> >        uint8_t vl1, vl2;
>> > @@ -189,7 +189,6 @@ static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
>> >        context.slvl_context.node_guid = osm_node_get_node_guid(p_node);
>> >        context.slvl_context.port_guid = osm_physp_get_port_guid(p);
>> >        context.slvl_context.set_method = TRUE;
>> > -       attr_mod = in_port << 8 | out_port;
>> >        status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
>> >                             (uint8_t *) & tbl, sizeof(tbl),
>> >                             IB_MAD_ATTR_SLVL_TABLE, cl_hton32(attr_mod),
>> > @@ -223,12 +222,20 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
>> >        if (!(p0->port_info.capability_mask & IB_PORT_CAP_HAS_SL_MAP))
>> >                return ret;
>> >
>> > +       if (ib_switch_info_get_opt_sl2vlmapping(&node->sw->switch_info) &&
>> > +           sm->p_subn->opt.use_optimized_slvl) {
>> > +               p = osm_node_get_physp_ptr(node, 1);
>> > +               force_update = p->need_update || sm->p_subn->need_update;
>> > +               return sl2vl_update_table(sm, p, 1, 0x30000, force_update,
>> > +                                         &qcfg->sl2vl);
>> > +       }
>> > +
>> >        for (i = 1; i < num_ports; i++) {
>> >                p = osm_node_get_physp_ptr(node, i);
>> >                force_update = p->need_update || sm->p_subn->need_update;
>> >                for (j = 0; j < num_ports; j++)
>> > -                       if (sl2vl_update_table(sm, p, i, j, force_update,
>> > -                                              &qcfg->sl2vl))
>> > +                       if (sl2vl_update_table(sm, p, i, i << 8 | j,
>> > +                                              force_update, &qcfg->sl2vl))
>> >                                ret = -1;
>> >        }
>> >
>> >
>> > , does it look fine for you?
>>
>> In the optimized case, doesn't this send extra SL2VL mapping table ?
>
> I don't see how, could you elaborate?

Doesn't this send a table for the endport even when optimized ?

-- Hal

>
> Sasha
>
>> Couldn''t that be eliminated by checking for this in the new endport
>> routine (and skipping the remainder of that routine) ?
>>
>> -- Hal
>>
>> >
>> > Sasha
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
