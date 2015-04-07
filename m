From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 19/19] IB/mad: Implement Intel Omni-Path Architecture
 MAD processing
Date: Tue, 7 Apr 2015 12:06:10 -0600
Message-ID: <20150407180610.GA15958@obsidianresearch.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
 <1423092585-26692-20-git-send-email-ira.weiny@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FBD9DE@ORSMSX109.amr.corp.intel.com>
 <20150407022954.GA7531@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FBE150@ORSMSX109.amr.corp.intel.com>
 <20150407171659.GA15634@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FBE1EB@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBE1EB-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 07, 2015 at 05:41:34PM +0000, Hefty, Sean wrote:
> > > > The IBA is pretty clear what should happen to process an unsupported
> > class
> > > > version and and adding OPA shouldn't suddenly make the IB side
> > > > non-conformant, however aesthetically unpleasing the code may be.
> > >
> > > Are there checks to ensure that MADs not supported by RoCE aren't
> > > processed on RoCE ports?
> > 
> > RoCE isn't different, it uses the same numbering space and rules as
> > IB.
> 
> I was agreeing with the point made about non-compliance.  RoCE only
> supports a subset of IB management, and AFAIK, there are no checks
> to validate MADs received over a RoCE port.  Those should be added.

RoCE follows the base IB spec pretty well, except that there is no QP0
(or SMPs, or SMI, etc). There is already code that avoids creating QP0
MAD stuff and the SMI for RoCE. A RoCE driver should never deliver a
QP0 packet to the mad layer.

There are already various checks that tie SMP's to QP0, on tx and also
in validate_mad. Eg validate_mad already refuses every SMP on RoCE
since qp_num can never be 0.

So I think we are good already. Every difference not caught by the
missing QP0 is handled by not registering certain agents for RoCE,
which looks OK already since I think most GSI's are supported.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
