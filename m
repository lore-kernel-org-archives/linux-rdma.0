From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv8 04/11] ib_core: IBoE CMA device binding
Date: Thu, 13 May 2010 11:26:13 +0300
Message-ID: <20100513082613.GC16073@mtldesk030.lab.mtl.com>
References: <20100218172403.GE12286@mtls03>
	<adawrv8ubrh.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adawrv8ubrh.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 12, 2010 at 01:05:06PM -0700, Roland Dreier wrote:
>  > +static void iboe_mcast_work_handler(struct work_struct *work)
>  > +{
>  > +	struct iboe_mcast_work *mw = container_of(work, struct iboe_mcast_work, work);
>  > +	struct cma_multicast *mc = mw->mc;
>  > +	struct ib_sa_multicast *m = mc->multicast.ib;
>  > +
>  > +	mc->multicast.ib->context = mc;
>  > +	cma_ib_mc_handler(0, m);
>  > +	kref_put(&mc->mcref, release_mc);
>  > +	kfree(mw);
>  > +}
> 
> I'm having a hard time working out why the iboe case needs to schedule
> to a work queue here since its already in process context, right?  It
> seems it would be really preferable to avoid all the extra pointer
> munging and reference counting, and just call things directly.
> 

I assume that the caller might attempt to acquire the same lock when
calling join and in the callback. Specifically, ucma_join_multicast()
calls rdma_join_multicast() with file->mut acquired and
ucma_event_handler() does the same.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
