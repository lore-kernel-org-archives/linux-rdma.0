From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: add rdma-ndd daemon
Date: Mon, 10 Nov 2014 12:05:43 -0700
Message-ID: <20141110190543.GD5296@obsidianresearch.com>
References: <1414713270-12710-1-git-send-email-ira.weiny@intel.com>
 <1414713270-12710-2-git-send-email-ira.weiny@intel.com>
 <20141108004029.GB12120@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CBA8FCD@CRSMSX101.amr.corp.intel.com>
 <20141110051155.GD31256@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CBB39E8@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CBB39E8-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 10, 2014 at 06:32:18PM +0000, Weiny, Ira wrote:

> > I don't know if this is practical, but it is the only race free way to properly
> > address all of this.
> 
> I don't think it is practical at all.
> 
> Assuming that we can hold the link from transitioning to Init how

PortInfo writes can do that

> does any userspace software know if the current hostname is "valid"?
> If, at the time of module load, the hostname is "localhost" you end
> up with the same "problem" as the proposed kernel patches.

Deciding when to turn on the IB interface in the boot sequence is a
policy issue for userspace. Some setups will require this to be done
in the initrd (ie boot over IB), others will want to do this after
management networking comes up (and the host name is set).

Once rdma-ndd starts running the hostname will track just the same as
if there was kernel %h support, and having your init sequence the IB
interface up after you have the hostname ensures it isn't local host.

This sequencing creates the opportunity for the admin to actually set
the host name to something that is not the kernel default.

> I'm not against adding this to rdma-ndd but I would like it to be
> optional.  With the kernel patches rdma-ndd itself is optional.

Not really, without rdma-ndd the node description is able to change on
its own and no traps are generated. That seems pretty broken. So you
need to run rdma-ndd to have IBA compliance.

> I think changing the default is a worthwhile change.  In addition,
> alternate admin policies are aided by the general use of the %h
> specifier.

I think you need to resolve this split responsibility somehow.

The kernel needs to work correctly without the daemon. To me that
either means it never changes the node desc on its own (what we have
today), or it always generates a trap when it changes.

> Do you believe that "<hostname> <device>" is an unreasonable default?

No, but what if I want it to say "OSD <hostname> <device>" on some
systems - then what? How do I set that and avoid generating traps at
boot?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
