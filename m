From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all
 ports of HCA are connected]
Date: Thu, 21 Mar 2013 15:48:32 -0600
Message-ID: <20130321214832.GE8431@obsidianresearch.com>
References: <514A0156.2070009@oracle.com>
 <20130320190208.GA23478@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB4214@CRSMSX102.amr.corp.intel.com>
 <514A3169.7000501@oracle.com>
 <20130320222422.GA30100@obsidianresearch.com>
 <514A3BDF.2090105@oracle.com>
 <20130320231923.GA32300@obsidianresearch.com>
 <514A5C07.3080308@oracle.com>
 <20130321052122.GB20882@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB4ACB@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510EBB4ACB-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 21, 2013 at 09:37:41PM +0000, Weiny, Ira wrote:
> > From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]

> > I looked at all of these, they are OK because the functions do not
> > return int, they are returning pointers.
> > 
> > The 'new' POSIX convention is:
> >  - int function returns are 0 on success, -1 on 'not-an-errno' and
> >    +ERRNO to indicate error.
> >  - 'fd in an int' function returns are -1 on failure with errno set,
> >    everything else is a valid fd. (Code that checks for fd's < 0 is
> >    pedantically wrong)
> >  - pointer function returns are NULL on failure with errno set.
> >  - void returns can never fail
> > 
> 
> Do you have a link to this?  I have been searching all through this
> discussion and have not found a good reference.

I've never seen it spelled out like this before, it is the convention
they switched to for pthreads and many new things follow it now. Look
at the pthread man pages for instance.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
