From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Add support for optimized SLtoVLMappingTable
 programming
Date: Sat, 16 Jan 2010 22:33:04 +0200
Message-ID: <20100116203304.GB574@me>
References: <20091201194110.GA26753@comcast.net>
 <20100105111841.GO26940@me>
 <20100105112334.GP26940@me>
 <f0e08f231001070535l382f1d54t7f6290607e52b196@mail.gmail.com>
 <20100112105516.GK26089@me>
 <f0e08f231001131214w790b1f34s46cbbda8b6454ac3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f231001131214w790b1f34s46cbbda8b6454ac3-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 15:14 Wed 13 Jan     , Hal Rosenstock wrote:
> >> > @@ -223,12 +222,20 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
> >> >        if (!(p0->port_info.capability_mask & IB_PORT_CAP_HAS_SL_MAP))
> >> >                return ret;
> >> >
> >> > +       if (ib_switch_info_get_opt_sl2vlmapping(&node->sw->switch_info) &&
> >> > +           sm->p_subn->opt.use_optimized_slvl) {
> >> > +               p = osm_node_get_physp_ptr(node, 1);
> >> > +               force_update = p->need_update || sm->p_subn->need_update;
> >> > +               return sl2vl_update_table(sm, p, 1, 0x30000, force_update,
> >> > +                                         &qcfg->sl2vl);
> >> > +       }
> >> > +
> >> >        for (i = 1; i < num_ports; i++) {
> >> >                p = osm_node_get_physp_ptr(node, i);
> >> >                force_update = p->need_update || sm->p_subn->need_update;
> >> >                for (j = 0; j < num_ports; j++)
> >> > -                       if (sl2vl_update_table(sm, p, i, j, force_update,
> >> > -                                              &qcfg->sl2vl))
> >> > +                       if (sl2vl_update_table(sm, p, i, i << 8 | j,
> >> > +                                              force_update, &qcfg->sl2vl))
> >> >                                ret = -1;
> >> >        }
> >> >
> >> >
> >> > , does it look fine for you?
> >>
> >> In the optimized case, doesn't this send extra SL2VL mapping table ?
> >
> > I don't see how, could you elaborate?
> 
> Doesn't this send a table for the endport even when optimized ?

Yes, and how is this different from the original patch?

Remember, that there is a different configuration for switch's port 0
(needed or not - this is another question), so we must to take it into
account.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
