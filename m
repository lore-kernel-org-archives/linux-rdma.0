From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 19/19] IB/mad: Implement Intel Omni-Path Architecture
 MAD processing
Date: Tue, 7 Apr 2015 17:15:07 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FBE17D@ORSMSX109.amr.corp.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
 <1423092585-26692-20-git-send-email-ira.weiny@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FBD9DE@ORSMSX109.amr.corp.intel.com>
 <20150407022954.GA7531@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > The IBA is pretty clear what should happen to process an unsupported
> class
> > version and and adding OPA shouldn't suddenly make the IB side
> > non-conformant, however aesthetically unpleasing the code may be.
> 
> Are there checks to ensure that MADs not supported by RoCE aren't
> processed on RoCE ports?

For the receive side, we need to enhance the validate_mad().  A similar check could be added to the send side, if we don't trust the senders.

Mgmt_class checks are everywhere in the code.  Pairing each with device checks for IB, RoCE, or OPA would be unwieldy.

IMO, a MAD should be self-identifying.  E.g. update the mad private structure to indicate what sort of MAD it is -- is_smp(), is_gmp(), is_rmpp(), is_opa(), is_ib(), much like the device checks are being updated.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
