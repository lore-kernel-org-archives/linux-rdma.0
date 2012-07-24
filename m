From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add initial congestion control configuration
 support
Date: Tue, 24 Jul 2012 19:58:25 +0300
Message-ID: <20120724165825.GC2413@calypso>
References: <1335302382.5973.132.camel@auk59.llnl.gov>
 <20120717153345.GA28239@calypso>
 <1342630767.18615.22.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1342630767.18615.22.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Albert

 
> > > +
> > > +     p_tbl = &p_osm->subn.port_guid_tbl;
> > > +     p_next = cl_qmap_head(p_tbl);
> > > +     while (p_next != cl_qmap_end(p_tbl)) {
> > > +             osm_port_t *p_port = (osm_port_t *) p_next;
> > > +             osm_node_t *p_node = p_port->p_node;
> > > +             ib_api_status_t status;
> > > +
> > > +             p_next = cl_qmap_next(p_next);
> > > +
> > > +             if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH) {
> > > +                     status = cc_send_sw_cong_setting(&p_osm->sm, p_node);
> > > +                     if (status != IB_SUCCESS)
> > > +                             ret = -1;
> > > +             } else if (osm_node_get_type(p_node) == IB_NODE_TYPE_CA) {
> > > +                     status = cc_send_ca_cong_setting(&p_osm->sm,
> > > +                                                      p_node,
> > > +                                                      p_port->p_physp);
> > > +                     if (status != IB_SUCCESS)
> > > +                             ret = -1;
> > > +
> > > +                     status = cc_send_cct(&p_osm->sm,
> > > +                                          p_node,
> > > +                                          p_port->p_physp);
> > 
> > SetCongestionControlTable may also apply to enhanced port 0 of the switch.
> 
> [AL] Got it.

This one can be postponed to a later patch. I'm not sure how much switches
support this mode.

> > > +     p_opt->cc_cct.entries_len = 0;
> > > +     p_opt->cc_cct.input_str = NULL;
> > 
> > What about setting other CC defaults? It won't be enough for a user to just turn "congestion_control = TRUE" flag
> > for CC to work. Running with defaults won't be perfect, but CC will start to work.
> 
> [AL] I initially didn't add it, as we were still trying to figure out
> optimal values for our situation w/ Lustre.
> 
> How about we hold off on CC default values for another patch and
> discussion.  It can be a very big discussion by itself.  I think getting
> the core configuration support is more important presently.
>

Agreed.
 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
