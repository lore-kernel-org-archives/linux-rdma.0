From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 19/19] IB/mad: Implement Intel Omni-Path Architecture
 MAD processing
Date: Mon, 6 Apr 2015 20:29:54 -0600
Message-ID: <20150407022954.GA7531@obsidianresearch.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
 <1423092585-26692-20-git-send-email-ira.weiny@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FBD9DE@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBD9DE-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Apr 04, 2015 at 01:44:40AM +0000, Hefty, Sean wrote:

> > +	if (opa && smp->class_version == OPA_SMP_CLASS_VERSION) {
> 
> There are several places where this sort of check is made.  IMO,
> this check should only require looking at the MAD, not the MAD + the
> device attributes that the MAD will be transferred on.  I would
> actually prefer to see this as:
> 
> 	if (smp->class_version == OPA_SMP_CLASS_VERSION)
> 
> That check is sufficient.  There is no conflict with IB MADs, and
> it's needlessly complicates the code to assume that the IBTA is
> going to someday define another 128 class versions in such a way
> that those versions will not require any other changes to the code.

Hal asked for this, and I agree. It is just lazy not to check the
underlying device type for this stuff - they are different number
spaces, administered by different bodies with no apparent
coordination.

The IBA is pretty clear what should happen to process an unsupported class
version and and adding OPA shouldn't suddenly make the IB side
non-conformant, however aesthetically unpleasing the code may be.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
