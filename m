From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: add rdma-ndd daemon
Date: Tue, 11 Nov 2014 10:11:04 -0500
Message-ID: <54622708.50405@dev.mellanox.co.il>
References: <1414713270-12710-1-git-send-email-ira.weiny@intel.com> <1414713270-12710-2-git-send-email-ira.weiny@intel.com> <20141108004029.GB12120@obsidianresearch.com> <2807E5FD2F6FDA4886F6618EAC48510E0CBA8FCD@CRSMSX101.amr.corp.intel.com> <20141110051155.GD31256@obsidianresearch.com> <2807E5FD2F6FDA4886F6618EAC48510E0CBB39E8@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CBB39E8-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/10/2014 1:32 PM, Weiny, Ira wrote:
> I think changing the default is a worthwhile change.  In addition, alternate admin policies are aided by the 
> general use of the %h specifier.
> 
> 	1) SM's which periodically scan the Node Description always get up to date hostname info.
> 	2) Up to date hostname info is provided even if a user space daemons fails.
> 		Note: OpenSM has an update node description feature for this condition.
> 	3) Low level diag tools always get up to date hostname info

There is a node description local changes trap which should cause an SM
to reread the updated NodeDescription. This is assuming the "SMA" is
compliant and issues such trap when ND changes and this occurs after LinkUp.

ALso, there is a new optional (SMA) feature (@ 1.3) to set the
NodeDescription. Not sure if this helps for this.

> Do you believe that "<hostname> <device>" is an unreasonable default?
> 
> Roland, Hal, do you have any input?

I was concerned with having the format be self identifying so that it
can be easily distinguishable from other known formats being used in the
field.

As you wrote, given that RedHat is already using this format, we are
already "living" with this.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
