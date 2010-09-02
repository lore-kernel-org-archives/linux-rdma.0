From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 02/12] ib_core: IBoE CMA device binding
Date: Thu, 02 Sep 2010 10:46:10 -0700
Message-ID: <adaeidcnin1.fsf@cisco.com>
References: <20100826141723.GC8795@mtldesk30>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25AB26491D@orsmsx501.amr.corp.intel.com>
	<20100827054256.GA9755@mtldesk30> <adavd6w37lp.fsf@cisco.com>
	<20100829143914.GA14370@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100829143914.GA14370@mtldesk30> (Eli Cohen's message of "Sun,
	29 Aug 2010 17:39:14 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > The point is it cma_acquire_dev() may get called when
 > dev_addr->transport has not yet been set so we can't rely on its value
 > to retrieve the correct GID; for example when it gets called by
 > rdma_bind_addr() it will only set the transport a few lines down the
 > function when calling cma_attach_to_dev(). That's why I may have to
 > look for the GID in the IBoE case.

I see.  We just have the address but the RDMA CM API doesn't give us the
type exactly (we just know the ARPHRD type).

 > I agree that traversing the list twice does not look so good so how
 > about this:

 > static int cma_acquire_dev(struct rdma_id_private *id_priv)
 > {
 > 	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
 > 	struct cma_device *cma_dev;
 > 	union ib_gid gid, iboe_gid;
 > 	int ret = -ENODEV;
 > 
 > 	iboe_addr_get_sgid(dev_addr, &iboe_gid);
 > 	memcpy(&gid, dev_addr->src_dev_addr +
 > 	       rdma_addr_gid_offset(dev_addr), sizeof gid);

I wish there were a cleaner way to write all this...

 > 	list_for_each_entry(cma_dev, &dev_list, list) {
 > 		ret = ib_find_cached_gid(cma_dev->device, &gid,
 > 					 &id_priv->id.port_num, NULL);
 > 		if (!ret)
 > 			break;
 > 		if (dev_addr->dev_type != ARPHRD_INFINIBAND) {
 > 			ret = ib_find_cached_gid(cma_dev->device, &iboe_gid,
 > 						 &id_priv->id.port_num, NULL);
 > 			if (!ret)
 > 				break;
 > 		}

looks better but since we know everything about the device we're
comparing to, can't we do something like:

		if (addr and dev ARPHRD agree)
			if (dev is IBoE)
				ret = ib_find_gid(iboe_gid);
			else
				ret = ib_find_gid(gid);

		if (!ret)
			break;

(by the way, it seems we can use ib_find_gid() here since we are in a
sleepable context -- no need to rely on the cached_gid stuff, which I
would like to phase out someday)

 > 	}
 > 
 > 	if (!ret)
 > 		cma_attach_to_dev(id_priv, cma_dev);
 > 
 > 	return ret;
 > }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
