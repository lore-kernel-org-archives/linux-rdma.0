From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCHv10 02/12] ib_core: IBoE CMA device binding
Date: Thu, 2 Sep 2010 13:30:11 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB44BA6F@orsmsx501.amr.corp.intel.com>
References: <20100826141723.GC8795@mtldesk30>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB26491D@orsmsx501.amr.corp.intel.com>
 <20100827054256.GA9755@mtldesk30> <adavd6w37lp.fsf@cisco.com>
 <20100829143914.GA14370@mtldesk30> <adaeidcnin1.fsf@cisco.com>
 <20100902192745.GA22039@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100902192745.GA22039@mtldesk30>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > looks better but since we know everything about the device we're
> > comparing to, can't we do something like:
> >
> > 		if (addr and dev ARPHRD agree)
> > 			if (dev is IBoE)
> > 				ret = ib_find_gid(iboe_gid);
> > 			else
> > 				ret = ib_find_gid(gid);
> >
> > 		if (!ret)
> > 			break;
> 
> This looks even better with no duplicate checks.

In cma_acquire_dev, we try to match up a portion of the dev_addr with a GID.  The current code does this by checking the dev_type to determine if the GID would start at offset 0 or 4 in the dev_addr.  With IBoE, this check is no longer possible, so we select the offset based on the rdma device that we're trying to compare against, rather than using data stored with the net_device.

Maybe it's just so unlikely that we don't care, but can this lead to a false match?  (and maybe the current code can have a false match..)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
