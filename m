From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 02/19] IB/core: Cache device attributes for use by upper level drivers
Date: Wed, 8 Apr 2015 12:01:09 -0400
Message-ID: <20150408160108.GD433@phlsvsds.ph.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com> <1423092585-26692-3-git-send-email-ira.weiny@intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FBD574@ORSMSX109.amr.corp.intel.com> <20150406221044.GA433@phlsvsds.ph.intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FBDE3E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBDE3E-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 06, 2015 at 04:43:01PM -0600, Hefty, Sean wrote:
> > I understand your point and I originally called this "attributes" but it
> > was
> > suggested to call it cached_dev_attrs.
> > 
> > https://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg22486.html
> > 
> > I can change it back if we are all agreed.
> 
> I'll disagree with Or on this.  Unless some of these values can change dynamically, these are the attributes.

Or

Any comment?

Personally, this patch was not originally part of my series.  I had a
ib_query_device call which Or objected to "yet another caching" of a device
attribute.

With the discussions on "management helpers" I probably don't need this at all.
So, if I can remove it I will and then we can debate its merits separate from the
OPA changes.

Ira

> 
> This leads me to, is there a reason to keep the per device query_attribute() call?  (This would not be part of this series.)  Are there attributes being returned from the kernel to user space that fall outside of the defined attribute area?
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
