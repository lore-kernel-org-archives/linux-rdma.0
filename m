From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Thu, 22 Oct 2009 12:22:21 -0600
Message-ID: <20091022182221.GZ14520@obsidianresearch.com>
References: <20091021233639.GS14520@obsidianresearch.com> <BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com> <20091022002846.GU14520@obsidianresearch.com> <4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com> <20091022011939.GW14520@obsidianresearch.com> <60E9443821EE4FFA90448DF5CC1368A8@amr.corp.intel.com> <20091022062531.GB26003@obsidianresearch.com> <B1D32A650C2F400E92AFC4909D8880A0@amr.corp.intel.com> <20091022164717.GG26003@obsidianresearch.com> <A03920DE5BAE4309BAFC1B6471AE928C@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <A03920DE5BAE4309BAFC1B6471AE928C-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 22, 2009 at 10:59:37AM -0700, Sean Hefty wrote:
> >> You can redirect (REJ) a REQ to a different port, but you can't accept (REP)
> >a
> >> connection on a different port.
> >
> >Do you have a compliance statment for that? :)
> 
> The REP doesn't carry port (i.e. GID) information.

Why would it need to? The REQ contains all the port information
necessary, the active side doesn't get to pick the port, it just gets
to approve it.

> Under reject reasons:
> 
> 12 Primary Remote Port GID rejected
> The recipient of the REQ message could not (or would not) accept the Primary
> Remote Port GID
> GID of acceptable port.
> 
> 13 Primary Remote Port LID rejected
> The recipient of the REQ message could not (or would not) accept the Primary
> Remote Port LID
> LID of acceptable port.
> 
> I interpret this as the REQ carries the proposal.  If the passive side aggress
> with the proposal, it accepts the connection, otherwise it rejects.

I agree.

But the proposal contains a complete description of the data carrying
port (GUID, GID, LID) and there is *nothing* in the spec that says
that description must match the port the GMP is received on.

Don't get confused by GMP redirection, that is yet again something
else :)

So, IBA allows the active side to propose a data connection with
primary path on Port 1, alternate path on Port 2 and send the GMP on
Port 2.

The passive CM then looks at this and decides if it is within local
policy constraints, if not it returns 12 or 13.

Thus, you cannot know what port the data QP will be bound to until you
process the REQ - just like IP.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
