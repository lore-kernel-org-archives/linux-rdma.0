From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv10 02/12] ib_core: IBoE CMA device binding
Date: Sun, 29 Aug 2010 17:39:14 +0300
Message-ID: <20100829143914.GA14370@mtldesk30>
References: <20100826141723.GC8795@mtldesk30>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB26491D@orsmsx501.amr.corp.intel.com>
 <20100827054256.GA9755@mtldesk30>
 <adavd6w37lp.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adavd6w37lp.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 26, 2010 at 11:14:26PM -0700, Roland Dreier wrote:
> 
> I thought the whole point of this change:
> 
>  >  static inline void rdma_addr_get_sgid(struct rdma_dev_addr *dev_addr, union ib_gid *gid)
>  >  {
>  > -	memcpy(gid, dev_addr->src_dev_addr + rdma_addr_gid_offset(dev_addr), sizeof *gid);
>  > +	if (dev_addr->transport == RDMA_TRANSPORT_IB &&
>  > +	    dev_addr->dev_type != ARPHRD_INFINIBAND)
>  > +		iboe_addr_get_sgid(dev_addr, gid);
>  > +	else
>  > +		memcpy(gid, dev_addr->src_dev_addr +
>  > +		       rdma_addr_gid_offset(dev_addr), sizeof *gid);
>  >  }
> 
> is that rdma_addr_get_sgid() now calls iboe_addr_get_sgid for IBoE
> devices, and does the original thing in the other case.  So I don't see
> why any change to cma_acquire_dev() is needed at all?
> 

The point is it cma_acquire_dev() may get called when
dev_addr->transport has not yet been set so we can't rely on its value
to retrieve the correct GID; for example when it gets called by
rdma_bind_addr() it will only set the transport a few lines down the
function when calling cma_attach_to_dev(). That's why I may have to
look for the GID in the IBoE case.
I agree that traversing the list twice does not look so good so how
about this:

static int cma_acquire_dev(struct rdma_id_private *id_priv)
{
	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
	struct cma_device *cma_dev;
	union ib_gid gid, iboe_gid;
	int ret = -ENODEV;

	iboe_addr_get_sgid(dev_addr, &iboe_gid);
	memcpy(&gid, dev_addr->src_dev_addr +
	       rdma_addr_gid_offset(dev_addr), sizeof gid);
	list_for_each_entry(cma_dev, &dev_list, list) {
		ret = ib_find_cached_gid(cma_dev->device, &gid,
					 &id_priv->id.port_num, NULL);
		if (!ret)
			break;
		if (dev_addr->dev_type != ARPHRD_INFINIBAND) {
			ret = ib_find_cached_gid(cma_dev->device, &iboe_gid,
						 &id_priv->id.port_num, NULL);
			if (!ret)
				break;
		}
	}

	if (!ret)
		cma_attach_to_dev(id_priv, cma_dev);

	return ret;
}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
