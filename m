From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv10 02/12] ib_core: IBoE CMA device binding
Date: Fri, 27 Aug 2010 08:42:56 +0300
Message-ID: <20100827054256.GA9755@mtldesk30>
References: <20100826141723.GC8795@mtldesk30>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB26491D@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB26491D-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 26, 2010 at 01:11:56PM -0700, Hefty, Sean wrote:
> > @@ -330,15 +348,29 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
> >  	union ib_gid gid;
> >  	int ret = -ENODEV;
> > 
> > -	rdma_addr_get_sgid(dev_addr, &gid);
> > +	if (dev_addr->dev_type != ARPHRD_INFINIBAND) {
> > +		iboe_addr_get_sgid(dev_addr, &gid);
> 
> How does this work with iwarp?
> 

Referring to the entire function:
 
static int cma_acquire_dev(struct rdma_id_private *id_priv)
{
	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
	struct cma_device *cma_dev;
	union ib_gid gid;
	int ret = -ENODEV;

	if (dev_addr->dev_type != ARPHRD_INFINIBAND) {
		iboe_addr_get_sgid(dev_addr, &gid);
		list_for_each_entry(cma_dev, &dev_list, list) {
			ret = ib_find_cached_gid(cma_dev->device, &gid,
						 &id_priv->id.port_num, NULL);
			if (!ret)
				goto out;
		}
	}

	memcpy(&gid, dev_addr->src_dev_addr +
	       rdma_addr_gid_offset(dev_addr), sizeof gid);
	list_for_each_entry(cma_dev, &dev_list, list) {
		ret = ib_find_cached_gid(cma_dev->device, &gid,
					 &id_priv->id.port_num, NULL);
		if (!ret)
			break;
	}

out:
	if (!ret)
		cma_attach_to_dev(id_priv, cma_dev);

	return ret;
}

The idea is that if it is not infiniband then it is either iwarp or iboe.
So we first build a gid assuming it is the iboe case and search it the
devices' gid tables. If it was not found then we proceed with the
regular flow.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
