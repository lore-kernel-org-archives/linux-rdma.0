From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 19/19] IB/mad: Implement Intel Omni-Path Architecture MAD processing
Date: Wed, 8 Apr 2015 17:24:40 -0400
Message-ID: <20150408212439.GF433@phlsvsds.ph.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com> <1423092585-26692-20-git-send-email-ira.weiny@intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FBD9DE@ORSMSX109.amr.corp.intel.com> <20150407022954.GA7531@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FBE17D@ORSMSX109.amr.corp.intel.com> <20150407171920.GB15634@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150407171920.GB15634-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 07, 2015 at 11:19:20AM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 07, 2015 at 05:15:07PM +0000, Hefty, Sean wrote:
> 
> > IMO, a MAD should be self-identifying.

A "MAD" is self-identifying (contains versions and classes).

IBoE CM MADs are a sub-set of the IB MADs.  As are the PMA MADs which those
devices support.  So the MAD stack need not perform any checks on those MADs.

Additionally, the MAD stack simply checks if QP0 is supported and fails any
post to it, regardless of MAD content.  And by definition the MAD stack will
never get anything from QP0.

> > E.g. update the mad private
> > structure to indicate what sort of MAD it is -- is_smp(), is_gmp(),
> > is_rmpp(), is_opa(), is_ib(), much like the device checks are being
> > updated.
> 
> decording into the mad private structure during initial validation
> seems like a good idea.

I think what you mean is that the MAD needs to self-identify the "MAD space"
(OPA vs IB) in which it resides.  I agree this would be nice.

However, I need to work through the full implications of this.

Ira

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
