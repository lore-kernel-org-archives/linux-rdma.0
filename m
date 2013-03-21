From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all
 ports of HCA are connected]
Date: Thu, 21 Mar 2013 16:58:58 -0600
Message-ID: <20130321225858.GA9924@obsidianresearch.com>
References: <20130320231923.GA32300@obsidianresearch.com>
 <514A5C07.3080308@oracle.com>
 <20130321052122.GB20882@obsidianresearch.com>
 <514B6F74.9020707@oracle.com>
 <20130321212703.GA8431@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB4AF5@CRSMSX102.amr.corp.intel.com>
 <20130321220751.GG8431@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB4B49@CRSMSX102.amr.corp.intel.com>
 <20130321225018.GA9749@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB4B7E@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510EBB4B7E-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 21, 2013 at 10:53:21PM +0000, Weiny, Ira wrote:
> > From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> > Sent: Thursday, March 21, 2013 3:50 PM
> > To: Weiny, Ira
> > Cc: brendan doyle; Boris Chiu; iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Pramod Gunjikar
> > Subject: Re: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all ports
> > of HCA are connected]
> > 
> > On Thu, Mar 21, 2013 at 10:46:06PM +0000, Weiny, Ira wrote:
> > 
> > > have to follow different idioms.  However having 2 or 3 in the same
> > > library is even worse!!!
> > 
> > Agreed, I think you made a compelling case that the new POSIX method is
> > not appropriate for this library, so standardizing on the old method is the
> > least bad option..
> > 
> 
> Wait what did I do?
> 
> You think using errno is the "right" thing to do now?

Well, I greatly prefer +ERRNO return for its enhanced safety and
consistency with other libraries but I didn't do the analysis you did
to see how inapplicable it is to the existing function
signatures.. Usually it is > 50% :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
