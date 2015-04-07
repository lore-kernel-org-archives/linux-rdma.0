From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 12/19] IB/mad: Add MAD size parameters to process_mad
Date: Tue, 7 Apr 2015 17:53:00 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FBE224@ORSMSX109.amr.corp.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
 <1423092585-26692-13-git-send-email-ira.weiny@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FBD692@ORSMSX109.amr.corp.intel.com>
 <20150407172303.GB433@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150407172303.GB433-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Rather than calling device->process_mad() directly, would it be better
> to call a common function?  So we can avoid adding:
> >
> > > +	struct ib_mad *in_mad = (struct ib_mad *)in;
> > > +	struct ib_mad *out_mad = (struct ib_mad *)out;
> > > +
> > > +	if (in_mad_size != sizeof(*in_mad) || *out_mad_size !=
> > > sizeof(*out_mad))
> > > +		return IB_MAD_RESULT_FAILURE;
> >
> > to existing drivers?
> 
> No.  The checks need to be done by the devices.  IB devices expect exactly
> 256
> bytes, OPA devices expect 2K, while some drivers don't care at all (don't
> support MADs).

The checks are per device, but that doesn't mean that every driver has to do the same check.

ib_process_mad(...)
{
	if (ib_device(...))
		insert check here
	else if (opa_device(...))
		insert some other check here
	else
		hit caller on nose
	dev->process_mad(...)
}

I'm fine either way.  It's more a matter of how much trust is given to the other kernel components.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
