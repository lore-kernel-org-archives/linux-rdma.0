From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 02/12] ib_core: IBoE CMA device binding
Date: Thu, 26 Aug 2010 23:14:26 -0700
Message-ID: <adavd6w37lp.fsf@cisco.com>
References: <20100826141723.GC8795@mtldesk30>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25AB26491D@orsmsx501.amr.corp.intel.com>
	<20100827054256.GA9755@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100827054256.GA9755@mtldesk30> (Eli Cohen's message of "Fri,
	27 Aug 2010 08:42:56 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > 	if (dev_addr->dev_type != ARPHRD_INFINIBAND) {
 > 		iboe_addr_get_sgid(dev_addr, &gid);
 > 		list_for_each_entry(cma_dev, &dev_list, list) {
 > 			ret = ib_find_cached_gid(cma_dev->device, &gid,
 > 						 &id_priv->id.port_num, NULL);
 > 			if (!ret)
 > 				goto out;
 > 		}
 > 	}
 > 
 > 	memcpy(&gid, dev_addr->src_dev_addr +
 > 	       rdma_addr_gid_offset(dev_addr), sizeof gid);
 > 	list_for_each_entry(cma_dev, &dev_list, list) {
 > 		ret = ib_find_cached_gid(cma_dev->device, &gid,
 > 					 &id_priv->id.port_num, NULL);
 > 		if (!ret)
 > 			break;
 > 	}
 > 
 > out:

This duplication of the code in the loop ends up looking pretty bad, and
indeed the change to the function doesn't make much sense to me:

 > @@ -330,15 +348,29 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
 >  	union ib_gid gid;
 >  	int ret = -ENODEV;
 >  
 > -	rdma_addr_get_sgid(dev_addr, &gid);
 > +	if (dev_addr->dev_type != ARPHRD_INFINIBAND) {
 > +		iboe_addr_get_sgid(dev_addr, &gid);
 > +		list_for_each_entry(cma_dev, &dev_list, list) {
 > +			ret = ib_find_cached_gid(cma_dev->device, &gid,
 > +						 &id_priv->id.port_num, NULL);
 > +			if (!ret)
 > +				goto out;
 > +		}
 > +	}
 > +
 > +	memcpy(&gid, dev_addr->src_dev_addr +
 > +	       rdma_addr_gid_offset(dev_addr), sizeof gid);

I thought the whole point of this change:

 >  static inline void rdma_addr_get_sgid(struct rdma_dev_addr *dev_addr, union ib_gid *gid)
 >  {
 > -	memcpy(gid, dev_addr->src_dev_addr + rdma_addr_gid_offset(dev_addr), sizeof *gid);
 > +	if (dev_addr->transport == RDMA_TRANSPORT_IB &&
 > +	    dev_addr->dev_type != ARPHRD_INFINIBAND)
 > +		iboe_addr_get_sgid(dev_addr, gid);
 > +	else
 > +		memcpy(gid, dev_addr->src_dev_addr +
 > +		       rdma_addr_gid_offset(dev_addr), sizeof *gid);
 >  }

is that rdma_addr_get_sgid() now calls iboe_addr_get_sgid for IBoE
devices, and does the original thing in the other case.  So I don't see
why any change to cma_acquire_dev() is needed at all?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
