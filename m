From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] [PATCHv8 02/11] ib_core: IBoE support only QP1
Date: Wed, 12 May 2010 12:56:58 -0700
Message-ID: <ada632svqph.fsf@roland-alpha.cisco.com>
References: <20100218172344.GC12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100218172344.GC12286@mtls03> (Eli Cohen's message of "Thu, 18
	Feb 2010 19:23:44 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > @@ -1017,9 +1020,12 @@ static void ib_sa_add_one(struct ib_device *device)
 >  	sa_dev->end_port   = e;
 >  
 >  	for (i = 0; i <= e - s; ++i) {
 > +		spin_lock_init(&sa_dev->port[i].ah_lock);
 > +		if (rdma_port_link_layer(device, i + 1) != IB_LINK_LAYER_INFINIBAND)
 > +			continue;

Not sure I understand why you move the initialization of the spinlock up
here?  It seems we ignore everything that might have to do with spinlock
if this is an IBoE port.

But the larger issue is what if someone calls one of the ib_sa_XXX_query
functions on an IBoE port?  Seems we just crash on uninitialized
structures.  I guess we're assuming that the kernel is smart enough not
to do that?

Also I'm wondering why you did the "count" stuff to ignore IBoE-only
devices in multicast.c but not sa_query.c?

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
