From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_qos.c: split switch external and end ports
	setup
Date: Wed, 13 Jan 2010 15:15:23 -0500
Message-ID: <f0e08f231001131215l73a9624amb4e0e3fb4170d1b5@mail.gmail.com>
References: <20091201194110.GA26753@comcast.net> <20100104170141.GK26940@me>
	 <20100105111032.GN26940@me>
	 <f0e08f231001070540y26b69cb3v82dddc1d7b7134b9@mail.gmail.com>
	 <20100112104358.GJ26089@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100112104358.GJ26089@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 12, 2010 at 5:43 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> On 08:40 Thu 07 Jan     , Hal Rosenstock wrote:
>> On Tue, Jan 5, 2010 at 6:10 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
>> >
>> > This splits QoS related port parameters setup over switch external ports
>> > and end ports. Such separation leaves us with simpler code and saves
>> > some repeated flows in case of switch external ports (actually required
>> > per switch and not per port).
>>
>> Not sure what you mean by required in this statement. What are you
>> referring to as required per switch rather than per port ?
>
> Duplicated per switch external port setup detection of common (per
> switch) data - such as: number of ports, Sl2VL mapping capability
> p0->port_info.capability_mask.

It was your use of the word 'required' which was confusing to me. It's
clear now what you mean.

-- Hal

>
>>
>> > Another advantages: Optimized Sl2VL Mapping procedure can be implemented
>> > easier using this model. A low level port QoS related parameters setup
>> > infrastructure is ready for supporting per port QoS related configuration
>> > (which hopefully will be implemented some days).
>> >
>> > Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>> > ---
>> >  opensm/opensm/osm_qos.c |  137 +++++++++++++++++++++--------------------------
>> >  1 files changed, 61 insertions(+), 76 deletions(-)
>> >
>> > diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
>> > index afeaa11..f54e995 100644
>> > --- a/opensm/opensm/osm_qos.c
>> > +++ b/opensm/opensm/osm_qos.c
>> > @@ -77,6 +77,7 @@ static ib_api_status_t vlarb_update_table_block(osm_sm_t * sm,
>> >        osm_madw_context_t context;
>> >        uint32_t attr_mod;
>> >        unsigned vl_mask, i;
>> > +       ib_api_status_t status;
>> >
>> >        vl_mask = (1 << (ib_port_info_get_op_vls(&p->port_info) - 1)) - 1;
>> >
>> > @@ -96,10 +97,17 @@ static ib_api_status_t vlarb_update_table_block(osm_sm_t * sm,
>> >        context.vla_context.set_method = TRUE;
>> >        attr_mod = ((block_num + 1) << 16) | port_num;
>> >
>> > -       return osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
>> > -                          (uint8_t *) & block, sizeof(block),
>> > -                          IB_MAD_ATTR_VL_ARBITRATION, cl_hton32(attr_mod),
>> > -                          CL_DISP_MSGID_NONE, &context);
>> > +       status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
>> > +                            (uint8_t *) & block, sizeof(block),
>> > +                            IB_MAD_ATTR_VL_ARBITRATION, cl_hton32(attr_mod),
>> > +                            CL_DISP_MSGID_NONE, &context);
>> > +       if (status != IB_SUCCESS)
>> > +               OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 6202 : "
>> > +                       "failed to update VLArbitration tables "
>> > +                       "for port %" PRIx64 " block %u\n",
>> > +                       cl_ntoh64(p->port_guid), block_num);
>> > +
>> > +       return status;
>> >  }
>> >
>> >  static ib_api_status_t vlarb_update(osm_sm_t * sm, osm_physp_t * p,
>> > @@ -157,6 +165,7 @@ static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
>> >        ib_slvl_table_t tbl, *p_tbl;
>> >        osm_node_t *p_node = osm_physp_get_node_ptr(p);
>> >        uint32_t attr_mod;
>> > +       ib_api_status_t status;
>> >        unsigned vl_mask;
>> >        uint8_t vl1, vl2;
>> >        int i;
>> > @@ -181,70 +190,65 @@ static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
>> >        context.slvl_context.port_guid = osm_physp_get_port_guid(p);
>> >        context.slvl_context.set_method = TRUE;
>> >        attr_mod = in_port << 8 | out_port;
>> > -       return osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
>> > -                          (uint8_t *) & tbl, sizeof(tbl),
>> > -                          IB_MAD_ATTR_SLVL_TABLE, cl_hton32(attr_mod),
>> > -                          CL_DISP_MSGID_NONE, &context);
>> > +       status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
>> > +                            (uint8_t *) & tbl, sizeof(tbl),
>> > +                            IB_MAD_ATTR_SLVL_TABLE, cl_hton32(attr_mod),
>> > +                            CL_DISP_MSGID_NONE, &context);
>> > +       if (status != IB_SUCCESS)
>> > +               OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 6203 : "
>> > +                       "failed to update SL2VLMapping tables "
>> > +                       "for port %" PRIx64 "i, attr_mod 0x%x\n",
>> > +                       cl_ntoh64(p->port_guid), attr_mod);
>> > +       return status;
>> >  }
>> >
>> > -static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_port,
>> > -                                   osm_physp_t * p, uint8_t port_num,
>> > -                                   unsigned force_update,
>> > -                                   const struct qos_config *qcfg)
>> > +static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
>> > +                             const struct qos_config *qcfg)
>> >  {
>> > -       ib_api_status_t status;
>> > -       uint8_t i, num_ports;
>> > -       ib_port_info_t *pi = &p_port->p_physp->port_info;
>> > -
>> > -       if (!(pi->capability_mask & IB_PORT_CAP_HAS_SL_MAP))
>> > -               return IB_SUCCESS;
>> > +       osm_physp_t *p0, *p;
>> > +       unsigned force_update;
>> > +       unsigned num_ports = osm_node_get_num_physp(node);
>> > +       int ret = 0;
>> > +       unsigned i, j;
>> >
>> > -       if (osm_node_get_type(osm_physp_get_node_ptr(p)) == IB_NODE_TYPE_SWITCH)
>> > -               num_ports = osm_node_get_num_physp(osm_physp_get_node_ptr(p));
>> > -       else
>> > -               num_ports = 1;
>> > +       for (i = 1; i < num_ports; i++) {
>> > +               p = osm_node_get_physp_ptr(node, i);
>> > +               force_update = p->need_update || sm->p_subn->need_update;
>> > +               p->vl_high_limit = qcfg->vl_high_limit;
>> > +               if (vlarb_update(sm, p, p->port_num, force_update, qcfg))
>> > +                       ret = -1;
>> > +       }
>> >
>> > -       for (i = 0; i < num_ports; i++) {
>> > -               status = sl2vl_update_table(sm, p, i, port_num, force_update,
>> > -                                           &qcfg->sl2vl);
>> > -               if (status != IB_SUCCESS)
>> > -                       return status;
>> > +       p0 = osm_node_get_physp_ptr(node, 0);
>> > +       if (!(p0->port_info.capability_mask & IB_PORT_CAP_HAS_SL_MAP))
>> > +               return ret;
>>
>> Same comment on this as previous osm_qos patch comment on merging the
>> SL2VL mapping capability check.
>
> I answered there.
>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
