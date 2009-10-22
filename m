From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Thu, 22 Oct 2009 12:40:04 -0600
Message-ID: <20091022184004.GB14520@obsidianresearch.com>
References: <20091022002846.GU14520@obsidianresearch.com> <4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com> <20091022011939.GW14520@obsidianresearch.com> <60E9443821EE4FFA90448DF5CC1368A8@amr.corp.intel.com> <20091022062531.GB26003@obsidianresearch.com> <B1D32A650C2F400E92AFC4909D8880A0@amr.corp.intel.com> <20091022164717.GG26003@obsidianresearch.com> <A03920DE5BAE4309BAFC1B6471AE928C@amr.corp.intel.com> <20091022182221.GZ14520@obsidianresearch.com> <60293EE44E7243B59C41498F20D558A0@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <60293EE44E7243B59C41498F20D558A0-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 22, 2009 at 11:31:07AM -0700, Sean Hefty wrote:
> The REP does not contain a port GUID, so what exactly were you trying to say
> here?

Sorry, typo, it was too late. I ment REQ.

The point was, that you don't know what port the QP will be bound to
until you get the REQ (ie the RDMA CM user does rdma_accept()). So
early binding limits capabilities.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
