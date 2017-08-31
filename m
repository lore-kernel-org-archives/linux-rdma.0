From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [Pv-drivers] [PATCH rdma-core] vmw_pvrdma: Explicitly check for
 IP_BASED_GIDS port flag
Date: Thu, 31 Aug 2017 10:42:14 -0700
Message-ID: <bdd5a150-ebae-ad43-fa02-7d85ddaf651b@vmware.com>
References: <1504136041-3070-1-git-send-email-aditr@vmware.com>
 <20170831100438.4e90516f@vypre.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170831100438.4e90516f-pVyPKaU+gKZOHLTnHDQRgA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 31, 2017 at 10:06:02AM -0400, Steven Rostedt wrote:
> On Wed, 30 Aug 2017 16:34:01 -0700
> Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org> wrote:
> 
> 
> >  struct ibv_ah *pvrdma_create_ah(struct ibv_pd *pd,
> > @@ -218,15 +222,17 @@ struct ibv_ah *pvrdma_create_ah(struct ibv_pd *pd,
> >  				   attr->grh.flow_label;
> >  	memcpy(av->dgid, attr->grh.dgid.raw, 16);
> >  
> > -	if (ibv_resolve_eth_l2_from_gid(pd->context, attr,
> > -					av->dmac, &vlan_id)) {
> > -		free(ah);
> > -		return NULL;
> > +	if (port_attr.port_cap_flags & IBV_PORT_IP_BASED_GIDS) {
> > +		if (!ibv_resolve_eth_l2_from_gid(pd->context, attr,
> > +						 av->dmac, &vlan_id))
> > +			return &ah->ibv_ah;
> >  	} else {
> > -		set_mac_from_gid(&attr->grh.dgid, av->dmac);
> > +		if (!set_mac_from_gid(&attr->grh.dgid, av->dmac))
> 
> Could this have been simplified to:
> 
> 	} else if (!set_mac_from_gid(...)) {
> 
> > +		return &ah->ibv_ah;

Thanks, Steve. We can probably look at doing that in a future cleanup
patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
