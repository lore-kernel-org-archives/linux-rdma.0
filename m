From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: add rdma-ndd daemon
Date: Sun, 9 Nov 2014 22:11:55 -0700
Message-ID: <20141110051155.GD31256@obsidianresearch.com>
References: <1414713270-12710-1-git-send-email-ira.weiny@intel.com>
 <1414713270-12710-2-git-send-email-ira.weiny@intel.com>
 <20141108004029.GB12120@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CBA8FCD@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CBA8FCD-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 10, 2014 at 12:28:27AM +0000, Weiny, Ira wrote:
> > 
> > Sadly, I think the proper way to address this is the same way netdev addresses
> > it - do not activate the interface on module load, wait for an explicit
> > enablement so userspace can configure before it tries to link up.
> > 
> > (Not to say that is even possible considering RDMA's history, but still..)
> 
> I don't think this is really possible.  When would you consider the
> "interface" to be "up"?  Even before the port goes active the SM and
> other diags can query this value.  This is why I propose that the
> default of the drivers, without user space involvement, should
> change.  The user space daemon is only trying to react to other user
> space activity.

Same as net dev, after the module load the physical layer is
disabled. Nothing can see the NodeDescription because the link is kept
down.

The everything gets configured, then the physical layer is allowed to
come up.

I don't know if this is practical, but it is the only race free way to
properly address all of this.

> > TBH, I'd rather see just this daemon and drop the kernel side... If the daemon is
> > started before the modules are loaded then it might be able to set the
> > description while the port is still down.
> 
> The problem is this sequence.
> 
> 1) rdma-ndd daemon started (hostname == localhost, no rdma devices set)
> 2) dhcp started (or other hostname change, rdma-ndd triggered but no rdma devices set; not loaded yet)
> 3) rdma devices loaded, default node_desc

4) daemon detects new rdma device instantly and programs the admin
   desired node name in the 100ms before the physical link reaches
   up. Since the link is down when the change occurs no traps are scheduled.
   Or in the 10% case where the race is lost you get a trap. Oh well.

> What I have proposed will work no matter what order things are
> started/loaded.  

Well, not really - it works in the sense that the kernel default node
name works properly, but it doesn't allow the admin to set a custom
name without hitting all these same issues (well, except perhaps by
module parameter..).

> Finally, I contemplated the alternative of having the rdma-ndd
> daemon detect new rdma devices.

Well, without that all it does is link two parts of the kernel
together through user space with no way toset policy in userspace
(policy in this case is the node description string). Seems very
strange.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
