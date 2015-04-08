From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 12/19] IB/mad: Add MAD size parameters to process_mad
Date: Wed, 8 Apr 2015 12:07:46 -0400
Message-ID: <20150408160745.GE433@phlsvsds.ph.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com> <1423092585-26692-13-git-send-email-ira.weiny@intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FBD692@ORSMSX109.amr.corp.intel.com> <20150407172303.GB433@phlsvsds.ph.intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FBE224@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBE224-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 07, 2015 at 11:53:00AM -0600, Hefty, Sean wrote:
> > > Rather than calling device->process_mad() directly, would it be better
> > to call a common function?  So we can avoid adding:
> > >
> > > > +	struct ib_mad *in_mad = (struct ib_mad *)in;
> > > > +	struct ib_mad *out_mad = (struct ib_mad *)out;
> > > > +
> > > > +	if (in_mad_size != sizeof(*in_mad) || *out_mad_size !=
> > > > sizeof(*out_mad))
> > > > +		return IB_MAD_RESULT_FAILURE;
> > >
> > > to existing drivers?
> > 
> > No.  The checks need to be done by the devices.  IB devices expect exactly
> > 256
> > bytes, OPA devices expect 2K, while some drivers don't care at all (don't
> > support MADs).
> 
> The checks are per device, but that doesn't mean that every driver has to do the same check.
> 
> ib_process_mad(...)
> {
> 	if (ib_device(...))
> 		insert check here
> 	else if (opa_device(...))
> 		insert some other check here
> 	else
> 		hit caller on nose

See this is another Oddity in the stack.  Those devices which are neither OPA
nor IB (iWarp or RoCE) have some support for MADs so we can't just "hit the
caller on the nose.

> 	dev->process_mad(...)
> }
> 
> I'm fine either way.  It's more a matter of how much trust is given to the other kernel components.

Indeed, I debated if I should add such checks at all.  In the end I have very
little trust so I did...  ;-)

However, to better reflect the nature of the error I've changed them all to
WARN_ONs.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
