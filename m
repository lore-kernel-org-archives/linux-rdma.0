From: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core: replace memcpy with ether_addr_copy
Date: Thu, 24 Aug 2017 23:01:03 +0530
Message-ID: <20170824173103.GA13379@himanshu-Vostro-3559>
References: <1503589307-10457-1-git-send-email-himanshujha199640@gmail.com>
 <1503590792.12569.2.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503590792.12569.2.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 24, 2017 at 09:06:32AM -0700, Joe Perches wrote:
> On Thu, 2017-08-24 at 21:11 +0530, Himanshu Jha wrote:
> > Use ether_addr_copy to copy an ethernet address of size ETH_ALEN
> > instead of memcpy.
> []
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> []
> > @@ -798,7 +798,7 @@ int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
> >  	if (ret)
> >  		return ret;
> >  
> > -	memcpy(dmac, dev_addr.dst_dev_addr, ETH_ALEN);
> > +	ether_addr_copy(dmac, dev_addr.dst_dev_addr);
> >  	dev = dev_get_by_index(&init_net, dev_addr.bound_dev_if);
> >  	if (!dev)
> >  		return -ENODEV;
> > @@ -831,7 +831,7 @@ int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id)
> >  	if (ret)
> >  		return ret;
> >  
> > -	memcpy(smac, dev_addr.src_dev_addr, ETH_ALEN);
> > +	ether_addr_copy(smac, dev_addr.src_dev_addr);
> >  	return ret;
> >  }
> >  EXPORT_SYMBOL(rdma_addr_find_smac_by_sgid);
> 
> Both dmac and smac are function arguments.
> What guarantees these to be
> aligned properly?
>
Yes, you are correct!
The arguments should be a pointer to a six byte Ethernet address.

Apologies!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
