From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all
 ports of HCA are connected]
Date: Thu, 21 Mar 2013 15:47:25 -0600
Message-ID: <20130321214725.GD8431@obsidianresearch.com>
References: <20130320190208.GA23478@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB4214@CRSMSX102.amr.corp.intel.com>
 <514A3169.7000501@oracle.com>
 <20130320222422.GA30100@obsidianresearch.com>
 <514A3BDF.2090105@oracle.com>
 <20130320231923.GA32300@obsidianresearch.com>
 <514A5C07.3080308@oracle.com>
 <20130321052122.GB20882@obsidianresearch.com>
 <514B6F74.9020707@oracle.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB4AB2@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510EBB4AB2-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 21, 2013 at 09:30:07PM +0000, Weiny, Ira wrote:

> > Well Linux is not my bag, but I couldn't see where in the code
> > this was the case.
> 
> I'm a bit confused by what you guys are debating here.  FWIW
> umad_status does not return MAD.status (IBTA 1.2.1 section 13.4.7)
> but rather ib_user_mad.status.
> 
> ib_user_mad is the umad meta data to communicate with the kernel and
> ib_user_mad.status _is_ an errno value.  I don't know what solaris
> does.

Yes, I think we all agree on this..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
