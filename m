From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv10 02/12] ib_core: IBoE CMA device binding
Date: Thu, 2 Sep 2010 22:27:46 +0300
Message-ID: <20100902192745.GA22039@mtldesk30>
References: <20100826141723.GC8795@mtldesk30>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB26491D@orsmsx501.amr.corp.intel.com>
 <20100827054256.GA9755@mtldesk30>
 <adavd6w37lp.fsf@cisco.com>
 <20100829143914.GA14370@mtldesk30>
 <adaeidcnin1.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaeidcnin1.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 02, 2010 at 10:46:10AM -0700, Roland Dreier wrote:
> 
> looks better but since we know everything about the device we're
> comparing to, can't we do something like:
> 
> 		if (addr and dev ARPHRD agree)
> 			if (dev is IBoE)
> 				ret = ib_find_gid(iboe_gid);
> 			else
> 				ret = ib_find_gid(gid);
> 
> 		if (!ret)
> 			break;

This looks even better with no duplicate checks.

> 
> (by the way, it seems we can use ib_find_gid() here since we are in a
> sleepable context -- no need to rely on the cached_gid stuff, which I
> would like to phase out someday)
> 

Sure, I can change that too.
Please let me know if you'd like me to send a new series or just send
this patch again.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
