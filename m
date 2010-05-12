From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 04/11] ib_core: IBoE CMA device binding
Date: Wed, 12 May 2010 13:05:06 -0700
Message-ID: <adawrv8ubrh.fsf@roland-alpha.cisco.com>
References: <20100218172403.GE12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100218172403.GE12286@mtls03> (Eli Cohen's message of "Thu, 18
	Feb 2010 19:24:03 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > +static void iboe_mcast_work_handler(struct work_struct *work)
 > +{
 > +	struct iboe_mcast_work *mw = container_of(work, struct iboe_mcast_work, work);
 > +	struct cma_multicast *mc = mw->mc;
 > +	struct ib_sa_multicast *m = mc->multicast.ib;
 > +
 > +	mc->multicast.ib->context = mc;
 > +	cma_ib_mc_handler(0, m);
 > +	kref_put(&mc->mcref, release_mc);
 > +	kfree(mw);
 > +}

I'm having a hard time working out why the iboe case needs to schedule
to a work queue here since its already in process context, right?  It
seems it would be really preferable to avoid all the extra pointer
munging and reference counting, and just call things directly.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
